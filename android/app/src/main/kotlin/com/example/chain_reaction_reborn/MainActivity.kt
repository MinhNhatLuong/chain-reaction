package com.example.chain_reaction_reborn

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInstaller
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.widget.Toast
import androidx.core.content.FileProvider
import java.io.File
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val installStatusAction = "com.example.chain_reaction_reborn.INSTALL_STATUS"
    private val updateChannel = "chain_reaction/update_installer"
    private var installStatusReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        registerInstallStatusReceiver()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            updateChannel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSupportedAbis" -> result.success(Build.SUPPORTED_ABIS.toList())
                "canRequestPackageInstalls" -> {
                    result.success(canRequestPackageInstalls())
                }
                "openInstallPermissionSettings" -> {
                    openInstallPermissionSettings()
                    result.success(null)
                }
                "installApk" -> {
                    val apkPath = call.argument<String>("apkPath")
                    if (apkPath.isNullOrBlank()) {
                        result.error("invalid_apk_path", "APK path is required.", null)
                        return@setMethodCallHandler
                    }

                    try {
                        installApk(apkPath)
                        result.success(null)
                    } catch (error: Exception) {
                        result.error(
                            "install_failed",
                            error.message ?: "Could not start APK install.",
                            null,
                        )
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        installStatusReceiver?.let(::unregisterReceiver)
        installStatusReceiver = null
        super.onDestroy()
    }

    private fun canRequestPackageInstalls(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.O ||
            packageManager.canRequestPackageInstalls()
    }

    private fun openInstallPermissionSettings() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent(
                Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                Uri.parse("package:$packageName"),
            )
        } else {
            Intent(Settings.ACTION_SECURITY_SETTINGS)
        }
        startActivity(intent)
    }

    private fun installApk(apkPath: String) {
        val apkFile = File(apkPath)
        require(apkFile.exists()) { "Downloaded APK was not found." }

        try {
            installWithPackageInstaller(apkFile)
        } catch (error: Exception) {
            installWithActionInstallPackage(apkFile)
        }
    }

    private fun installWithPackageInstaller(apkFile: File) {
        val packageInstaller = packageManager.packageInstaller
        val params = PackageInstaller.SessionParams(
            PackageInstaller.SessionParams.MODE_FULL_INSTALL,
        ).apply {
            setAppPackageName(packageName)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                setRequireUserAction(
                    PackageInstaller.SessionParams.USER_ACTION_NOT_REQUIRED,
                )
            }
        }

        val sessionId = packageInstaller.createSession(params)
        try {
            packageInstaller.openSession(sessionId).use { session ->
                apkFile.inputStream().use { input ->
                    session.openWrite(apkFile.name, 0, apkFile.length()).use { output ->
                        input.copyTo(output)
                        session.fsync(output)
                    }
                }

                val callbackIntent = Intent(installStatusAction).setPackage(packageName)
                val flags = PendingIntent.FLAG_UPDATE_CURRENT or
                    (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        PendingIntent.FLAG_MUTABLE
                    } else {
                        0
                    })
                val pendingIntent = PendingIntent.getBroadcast(
                    this,
                    sessionId,
                    callbackIntent,
                    flags,
                )
                session.commit(pendingIntent.intentSender)
            }
        } catch (error: Exception) {
            packageInstaller.abandonSession(sessionId)
            throw error
        }
    }

    private fun installWithActionInstallPackage(apkFile: File) {
        val apkUri = FileProvider.getUriForFile(
            this,
            "$packageName.fileprovider",
            apkFile,
        )
        val intent = Intent(Intent.ACTION_INSTALL_PACKAGE).apply {
            setDataAndType(apkUri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            putExtra(Intent.EXTRA_RETURN_RESULT, true)
            putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
        }
        startActivity(intent)
    }

    private fun registerInstallStatusReceiver() {
        if (installStatusReceiver != null) return

        installStatusReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val status = intent.getIntExtra(
                    PackageInstaller.EXTRA_STATUS,
                    PackageInstaller.STATUS_FAILURE,
                )

                when (status) {
                    PackageInstaller.STATUS_PENDING_USER_ACTION -> {
                        confirmationIntent(intent)?.let { pendingIntent ->
                            pendingIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(pendingIntent)
                        }
                    }
                    PackageInstaller.STATUS_SUCCESS -> {
                        Toast.makeText(
                            context,
                            "Update installed.",
                            Toast.LENGTH_SHORT,
                        ).show()
                    }
                    else -> {
                        val message = intent.getStringExtra(
                            PackageInstaller.EXTRA_STATUS_MESSAGE,
                        ) ?: "APK install failed."
                        Toast.makeText(context, message, Toast.LENGTH_LONG).show()
                    }
                }
            }
        }

        val filter = IntentFilter(installStatusAction)
        val receiver = installStatusReceiver ?: return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(receiver, filter, RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(receiver, filter)
        }
    }

    private fun confirmationIntent(intent: Intent): Intent? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_INTENT, Intent::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_INTENT)
        }
    }
}
