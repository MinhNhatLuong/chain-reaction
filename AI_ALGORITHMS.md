# Chain Reaction AI Algorithms

This document explains every computer difficulty mode in the project, from
`Easy` to `Oracle`, including the decision pipeline, formulas, and the exact
strategic meaning of each score.

The current mapping lives in:

- `lib/features/game/domain/entities/player.dart`
- `lib/features/game/domain/ai/ai_service.dart`
- `lib/features/home/presentation/providers/home_provider.dart`

Current difficulty mapping:

```text
Easy    -> RandomStrategy
Medium  -> GreedyStrategy
Hard    -> StrategicStrategy
Extreme -> ExtremeStrategy
God     -> GodStrategy
Oracle   -> OracleStrategy
```

## 1. Core Game Model

### 1.1 Board State

The board is a rectangular grid:

```text
G = rows x cols
```

Each cell has:

```text
cell.x          column index
cell.y          row index
cell.capacity   max stable atom count
cell.atomCount  current atom count
cell.ownerId    null, or the id of the owning player
```

The active player is:

```text
P = state.currentPlayer
```

An AI strategy receives:

```text
state  current GameState
player AI player
random deterministic Random(seed)
```

and returns:

```text
Point<int>(x, y)
```

### 1.2 Cell Capacity

Capacity is calculated by board position:

```text
corner cell -> capacity = 1
edge cell   -> capacity = 2
center cell -> capacity = 3
```

Important distinction:

```text
stable max count   = capacity
explosion condition = atomCount > capacity
```

So:

```text
corner explodes at 2 atoms
edge explodes at 3 atoms
center explodes at 4 atoms
```

### 1.3 Valid Move Set

All strategies inherit `getValidMoves` from `AIStrategy`.

A move is valid if the target cell is empty or owned by the same player:

```text
V(P, S) = {
  (x, y) |
  S.grid[y][x].ownerId == null
  or
  S.grid[y][x].ownerId == P.id
}
```

Where:

```text
V(P, S) = valid moves for player P in state S
```

If `V` is empty, the strategy throws `AIException`.

### 1.4 Explosion Logic

When a player places an atom:

```text
cell.atomCount = cell.atomCount + 1
cell.ownerId = player.id
```

If:

```text
cell.atomCount > cell.capacity
```

the cell explodes.

For an exploding cell `c`, let:

```text
N(c) = orthogonal neighbors of c
```

Then:

```text
c.atomCount = c.atomCount - |N(c)|
```

Each neighbor receives one atom:

```text
neighbor.atomCount = neighbor.atomCount + 1
neighbor.ownerId = explodingPlayer.id
```

If a neighbor becomes over capacity, it is queued for a chain reaction:

```text
neighbor.atomCount > neighbor.capacity
```

The real game uses `GameRules.processExplosion`.

The stronger AIs simulate future states by applying this same explosion model
without UI animation.

## 2. Common Evaluation Terms

The stronger algorithms repeatedly evaluate a simulated board state. These are
the common measurements.

For AI player `A`:

```text
myAtoms    = total atoms owned by A
enemyAtoms = total atoms owned by all non-A players

myCells    = number of cells owned by A
enemyCells = number of cells owned by all non-A players
```

Atom difference:

```text
atomsDiff = myAtoms - enemyAtoms
```

Cell difference:

```text
cellsDiff = myCells - enemyCells
```

Primed cell:

```text
cell.atomCount >= cell.capacity
```

This means the cell is at its stable maximum or beyond. One more atom from its
owner usually triggers an explosion.

Vulnerable AI cell:

```text
An AI-owned cell is vulnerable if it is adjacent to an enemy cell where:

enemyCell.atomCount >= enemyCell.capacity
```

This matters because the enemy can likely explode next turn and capture the AI
cell.

Win state:

```text
isWin(S, A) =
  S.activeOwnerIds.length == 1
  and
  S.activeOwnerIds.first == A.id
```

## 3. Easy: RandomStrategy

File:

```text
lib/features/game/domain/ai/strategies/random_strategy.dart
```

### 3.1 Idea

`Easy` does not evaluate the board. It simply chooses any legal move uniformly
at random.

This mode is intentionally weak.

### 3.2 Algorithm

```text
validMoves = V(player, state)
return random element from validMoves
```

### 3.3 Formula

For every legal move `m`:

```text
P(select m) = 1 / |V|
```

Where:

```text
|V| = number of valid moves
```

No score exists:

```text
score(m) = undefined
```

because this strategy does not rank moves.

### 3.4 Strengths

- Very fast.
- Useful for beginner mode.
- Creates unpredictable play.

### 3.5 Weaknesses

- Does not see immediate wins.
- Does not avoid obvious traps.
- Does not understand chain reactions.
- Does not defend against critical enemy cells.

## 4. Medium: GreedyStrategy

File:

```text
lib/features/game/domain/ai/strategies/greedy_strategy.dart
```

### 4.1 Idea

`Medium` is a rule-based greedy AI. It does not simulate full future boards.
Instead, it applies a fixed priority list.

It answers:

```text
Can I explode now?
If not, can I avoid obvious danger?
If possible, can I reinforce my own cells?
```

### 4.2 Priority Pipeline

Let:

```text
V = valid moves
```

#### Step 1: Immediate Explosion

The AI first finds cells where placing one atom will cause an explosion.

In code:

```text
cell.atomCount == cell.capacity
```

Because after placing one atom:

```text
cell.atomCount + 1 > cell.capacity
```

Explosion move set:

```text
E = { m in V | cell(m).atomCount == cell(m).capacity }
```

If:

```text
E is not empty
```

then:

```text
return random(E)
```

#### Step 2: Avoid Critical Enemy Neighbors

If there is no immediate explosion, the AI filters safe moves.

A move is unsafe if the target cell is adjacent to an enemy cell that is ready
to explode:

```text
unsafe(m) =
  exists n in N(m):
    owner(n) != null
    and owner(n) != player.id
    and atomCount(n) >= capacity(n)
```

Safe move set:

```text
S = { m in V | not unsafe(m) }
```

If `S` is empty, the AI falls back to all valid moves:

```text
C = S if |S| > 0 else V
```

#### Step 3: Reinforce Own Cells

From the candidate set `C`, the AI prefers cells it already owns:

```text
R = { m in C | owner(m) == player.id }
```

If:

```text
R is not empty
```

then:

```text
return random(R)
```

#### Step 4: Random Candidate

If no reinforcement move exists:

```text
return random(C)
```

### 4.3 Decision Formula

The priority can be written as:

```text
choose(m) =
  random(E), if |E| > 0
  random(R), if |E| = 0 and |R| > 0
  random(C), otherwise
```

Where:

```text
E = immediate explosion moves
S = safe moves
C = S if S is not empty, else V
R = own-cell moves inside C
```

### 4.4 Strengths

- Sees one-step explosions.
- Avoids some obvious enemy explosion traps.
- Builds toward future explosions by reinforcing own cells.

### 4.5 Weaknesses

- Does not simulate the result of a chain reaction.
- Does not check whether exploding now is actually bad.
- Does not consider the opponent's next move.
- Can miss forced defense.

## 5. Hard: StrategicStrategy

File:

```text
lib/features/game/domain/ai/strategies/strategic_strategy.dart
```

### 5.1 Idea

`Hard` is a one-ply heuristic strategy.

It simulates each legal move, evaluates the resulting board, and chooses the
highest-scoring move.

However, it intentionally makes mistakes:

```text
75% chance: choose best evaluated move
25% chance: choose random valid move
```

This is controlled by:

```text
_difficultyFactor = 0.75
```

### 5.2 Random Error Formula

Let:

```text
u = random number in [0, 1)
```

Then:

```text
if u > 0.75:
  return random(V)
```

So:

```text
P(random mistake) = 0.25
P(strategic play) = 0.75
```

### 5.3 Move Simulation

For each candidate move `m`, Hard computes:

```text
S' = simulate(S, m, player)
```

Then:

```text
score(m) = evaluate(S', m, player)
```

### 5.4 Evaluation Formula

If the simulated state is an immediate win:

```text
score(m) = 10000
```

Otherwise:

```text
score(m) =
  1.5 * (myAtoms - enemyAtoms)
  + 1.0 * (myCells - enemyCells)
  + 5.0 * capturedCells
  - 5.0 * vulnerableAdjacencyCount
  + positionBonus(m)
```

Where:

```text
capturedCells = myCellsAfter - myCellsBefore
```

Vulnerability penalty:

```text
vulnerableAdjacencyCount =
  number of AI-owned cells adjacent to enemy primed cells
```

Enemy primed cell:

```text
enemyCell.atomCount >= enemyCell.capacity
```

Position bonus:

```text
positionBonus(m) =
  2.0 if m is corner
  1.0 if m is edge but not corner
  0.0 otherwise
```

The strategy also adds a tiny random tie-breaker:

```text
jitter = randomDouble * 2.0
```

Final comparison value:

```text
comparisonScore(m) = score(m) + jitter
```

The selected move is:

```text
bestMove = argmax_m comparisonScore(m)
```

### 5.5 What The Formula Means

#### Atom Difference

```text
1.5 * (myAtoms - enemyAtoms)
```

This rewards raw material advantage. More atoms usually means more future
explosion potential.

#### Cell Difference

```text
1.0 * (myCells - enemyCells)
```

This rewards territory control.

#### Captured Cells

```text
5.0 * capturedCells
```

This strongly rewards chain reactions that convert enemy cells.

#### Vulnerability

```text
-5.0 * vulnerableAdjacencyCount
```

This discourages leaving AI cells next to enemy cells that are ready to explode.

#### Corner/Edge Bonus

```text
corner +2.0
edge   +1.0
```

Corners and edges are easier to overload because they have lower capacity.

### 5.6 Strengths

- Can see the result of its own move.
- Understands material, territory, captures, and some danger.
- Usually much stronger than Medium.

### 5.7 Weaknesses

- Only searches one AI move.
- Does not model the opponent's response.
- Has 25% intentional randomness.
- Uses its own local simulation instead of `GameRules.processExplosion`, while
  `Extreme`, `God`, and `Oracle` use the shared rules engine.

## 6. Extreme: ExtremeStrategy

File:

```text
lib/features/game/domain/ai/strategies/extreme_strategy.dart
```

### 6.1 Idea

`Extreme` is a two-ply minimax AI.

It considers:

```text
AI move -> opponent best response
```

Hard asks:

```text
How good is the board after my move?
```

Extreme asks:

```text
How good is the board after my move,
assuming the opponent replies with the most damaging move?
```

### 6.2 Search Structure

For every AI move:

```text
S1 = simulate(S, aiMove, AI)
```

If `S1` is a win:

```text
return aiMove
```

Otherwise find next opponent:

```text
O = nextPlayer(S1)
```

For every opponent response:

```text
S2 = simulate(S1, oppMove, O)
```

If `S2` is a win for opponent:

```text
score(aiMove) = -infinity
```

Otherwise:

```text
score(aiMove) = min over opponent moves evaluate(S2, AI)
```

Then:

```text
bestMove = argmax_aiMove score(aiMove)
```

### 6.3 Minimax Formula

Let:

```text
M = valid AI moves
R(m) = valid opponent replies after AI move m
```

Then:

```text
ExtremeScore(m) =
  min_{r in R(m)} Eval(simulate(simulate(S, m, AI), r, opponent), AI)
```

Selected move:

```text
bestMove = argmax_{m in M} ExtremeScore(m)
```

### 6.4 Evaluation Formula

If AI wins:

```text
Eval(S, AI) = 10000
```

If AI has no cells:

```text
Eval(S, AI) = -infinity
```

Otherwise:

```text
Eval(S, AI) =
  2.0 * (myAtoms - enemyAtoms)
  + 5.0 * (myCells - enemyCells)
  + 1.0 * myThreats
```

Where:

```text
myThreats = number of AI cells where atomCount == capacity
```

### 6.5 Alpha-Beta Pruning

Extreme uses a simple alpha value at the root.

During opponent minimization:

```text
if minOpponentScore <= alpha:
  stop checking more opponent replies
```

Meaning:

```text
The opponent already found a reply bad enough that this AI move cannot beat
the best move found so far.
```

### 6.6 Strengths

- Can avoid obvious opponent counterattacks.
- Takes immediate wins.
- Much stronger than one-ply Hard.

### 6.7 Weaknesses

- Only sees one opponent response.
- Evaluation is still relatively simple.
- Does not do full recursive search beyond two plies.

## 7. God: GodStrategy

File:

```text
lib/features/game/domain/ai/strategies/god_strategy.dart
```

### 7.1 Idea

`God` is a recursive depth-limited minimax AI with alpha-beta pruning and move
ordering.

It searches multiple future turns:

```text
AI -> opponent -> AI -> opponent ...
```

up to an adaptive depth.

### 7.2 Adaptive Depth

God chooses depth based on the number of valid moves:

```text
if moveCount <= 10: depth = 3
if moveCount <= 20: depth = 3
else:               depth = 2
```

Current practical formula:

```text
depth = 3 when moveCount <= 20
depth = 2 when moveCount > 20
```

This keeps the AI strong while avoiding extremely slow turns on open boards.

### 7.3 Recursive Search

At each node:

```text
activePlayer = player whose turn is being simulated
aiPlayer     = original AI player
```

If:

```text
activePlayer.id == aiPlayer.id
```

the node is maximizing:

```text
value = max(child scores)
```

Otherwise it is minimizing:

```text
value = min(child scores)
```

### 7.4 Terminal Conditions

If depth is exhausted:

```text
return Eval(S, AI)
```

If AI wins:

```text
return winScore + depth
```

If AI has no cells:

```text
return -winScore - depth
```

God uses:

```text
winScore = 100000
```

The `+ depth` detail means winning sooner is slightly better than winning
later.

The `- depth` detail means losing sooner is slightly worse than losing later.

### 7.5 Evaluation Formula

God calculates:

```text
myAtoms
enemyAtoms
myCells
enemyCells
myPrimed
enemyPrimed
vulnerableCells
```

Then:

```text
Eval(S, AI) =
  8.0 * (myCells - enemyCells)
  + 2.0 * (myAtoms - enemyAtoms)
  + 3.0 * (myPrimed - enemyPrimed)
  - 5.0 * vulnerableCells
```

Where:

```text
myPrimed = number of AI cells where atomCount >= capacity
enemyPrimed = number of enemy cells where atomCount >= capacity
```

### 7.6 Move Ordering

Before searching children, God simulates each candidate once and evaluates it.

For maximizing nodes:

```text
sort descending by tactical score
```

For minimizing nodes:

```text
sort ascending by tactical score
```

This helps alpha-beta pruning because good moves are considered earlier.

### 7.7 Alpha-Beta Formula

Alpha:

```text
alpha = best score already guaranteed for maximizer
```

Beta:

```text
beta = best score already guaranteed for minimizer
```

At maximizing node:

```text
alpha = max(alpha, value)
if alpha >= beta:
  prune
```

At minimizing node:

```text
beta = min(beta, value)
if alpha >= beta:
  prune
```

### 7.8 Strengths

- Searches multiple future turns.
- Avoids more traps than Extreme.
- Uses better heuristic than Extreme.
- Uses move ordering and alpha-beta pruning.

### 7.9 Weaknesses

- Fixed depth cap means it can still miss long forced chains.
- Large valid move counts reduce depth.
- No transposition table.
- No tactical extension for especially explosive lines.

## 8. Oracle: OracleStrategy

File:

```text
lib/features/game/domain/ai/strategies/oracle_strategy.dart
```

### 8.1 Idea

`Oracle` is the strongest mode.

It is built as an upgraded version of `God`, with:

```text
iterative deepening
alpha-beta pruning
transposition cache
tactical extensions
stronger heuristic evaluation
time-bounded search
```

God searches to a chosen fixed depth.

Oracle searches like this:

```text
depth 1
depth 2
depth 3
...
depth 6
```

and stops when it runs out of time.

The best fully completed depth is kept.

### 8.2 Time Budget

Oracle has a natural thinking delay:

```text
thinkingTime = 300ms + random(0..250ms)
```

Then it starts the search clock:

```text
timeBudget = 1500ms
```

So the total perceived AI turn can be roughly:

```text
300ms to 550ms thinking delay + up to 1500ms search
```

Approximate total:

```text
1800ms to 2050ms
```

### 8.3 Iterative Deepening

Maximum configured search depth:

```text
maxDepth = 6
```

Algorithm:

```text
bestMove = best move from shallow ordering

for depth in 1..6:
  result = searchRoot(depth)
  if result timed out:
    break
  bestMove = result.move

return bestMove
```

The important property:

```text
Oracle always has a usable move, even if deeper search times out.
```

### 8.4 Root Search

At root:

```text
orderedMoves = order valid AI moves
alpha = -infinity
beta = infinity
bestScore = -infinity
```

For each candidate:

```text
S1 = simulate(S, candidate, AI)
```

If immediate win:

```text
return candidate with score = winScore + depth
```

Otherwise:

```text
nextPlayer = getNextPlayer(S1)
score = recursiveSearch(S1, nextPlayer, depthAfterMove)
```

Then:

```text
if score > bestScore:
  bestScore = score
  bestMove = candidate
  alpha = max(alpha, bestScore)
```

### 8.5 Oracle Win Score

Oracle uses a larger win score than God:

```text
winScore = 1000000
```

Immediate win:

```text
score = winScore + depth
```

AI eliminated:

```text
score = -winScore - depth
```

This makes forced wins/losses dominate all heuristic material scores.

### 8.6 Tactical Extensions

Normal minimax reduces depth after each move:

```text
nextDepth = depth - 1
```

Oracle extends tactical moves.

A candidate is tactical if:

```text
isTactical =
  move causes explosion
  or move captures at least 2 cells
  or move wins immediately
```

In code:

```text
explodes = source.atomCount + 1 > source.capacity
captures = max(0, afterCellCount - beforeCellCount)

isTactical = explodes || captures >= 2 || isWin(nextState, mover)
```

Extension limit:

```text
extensionLimit = 2
```

Depth rule:

```text
if isTactical and extensionsRemaining > 0:
  nextDepth = depth
  extensionsRemaining = extensionsRemaining - 1
else:
  nextDepth = depth - 1
```

This means Oracle searches deeper in volatile positions without searching every
quiet move too deeply.

### 8.7 Transposition Cache

Oracle caches evaluated states:

```text
cacheKey -> { depth, score }
```

A cached value is reused when:

```text
cached.depth >= requestedDepth
```

The cache key includes:

```text
activePlayer.id
aiPlayer.id
depth
turnCount
grid owners
grid atom counts
```

Conceptually:

```text
CacheKey(S, active, AI, depth, turn) =
  active.id
  + AI.id
  + depth
  + turn
  + boardEncoding(S)
```

Board encoding:

```text
for every cell:
  ownerId or "-"
  atomCount
```

This avoids recalculating identical search states reached through different
move orders.

### 8.8 Oracle Move Ordering

For each move:

```text
nextState = simulate(state, move, mover)
captures = max(0, cellCountAfter(mover) - cellCountBefore(mover))
explodes = source.atomCount + 1 > source.capacity
```

Move ordering score:

```text
orderingScore(move) =
  Eval(nextState, AI)
  + 18.0 * explosionFlag
  + 12.0 * captures
```

Where:

```text
explosionFlag = 1 if move explodes, else 0
```

For maximizing nodes:

```text
sort descending by orderingScore
```

For minimizing nodes:

```text
sort ascending by orderingScore
```

Tie-breaker:

```text
lower y first, then lower x first
```

### 8.9 Oracle Evaluation Formula

Oracle calculates:

```text
myAtoms
enemyAtoms
myCells
enemyCells
safePrimed
enemyPrimed
vulnerableCells
mobility
enemyMobility
chainPotential
```

Then:

```text
Eval(S, AI) =
  10.0 * (myCells - enemyCells)
  + 2.5 * (myAtoms - enemyAtoms)
  + 6.0 * (safePrimed - enemyPrimed)
  + 1.25 * (mobility - enemyMobility)
  + 4.0 * chainPotential
  - 12.0 * vulnerableCells
```

### 8.10 Oracle Evaluation Terms

#### Cell Difference

```text
10.0 * (myCells - enemyCells)
```

This is the most important non-terminal heuristic. In Chain Reaction, cell
ownership matters more than raw atom count because it represents territory and
survival.

#### Atom Difference

```text
2.5 * (myAtoms - enemyAtoms)
```

This rewards material advantage and future explosion pressure.

#### Safe Primed Difference

```text
6.0 * (safePrimed - enemyPrimed)
```

An AI cell is safe primed if:

```text
cell.ownerId == AI.id
cell.atomCount >= cell.capacity
not vulnerableToEnemy(cell)
```

This means the cell can likely explode on a future AI turn without being easily
captured first.

Enemy primed:

```text
enemyCell.atomCount >= enemyCell.capacity
```

The formula rewards AI explosion threats and penalizes enemy explosion threats.

#### Mobility Difference

```text
1.25 * (mobility - enemyMobility)
```

Current implementation approximates mobility:

```text
AI mobility:
  +1 for each AI-owned cell
  +1 for each empty cell

Enemy mobility:
  +1 for each enemy-owned cell
  +1 for each empty cell
```

Because empty cells are playable by both sides, they contribute to both.

#### Chain Potential

For each AI-owned cell:

```text
if cell.atomCount < cell.capacity:
  contribution = 0
```

Otherwise inspect neighbors:

```text
for each neighbor:
  if neighbor is not AI-owned and neighbor.atomCount + 1 > neighbor.capacity:
    contribution += 2
  else if neighbor is not AI-owned:
    contribution += 1
```

So:

```text
chainPotential = sum of these contributions over AI-owned cells
```

This rewards positions where an AI explosion can spread into enemy or empty
territory, especially if it can trigger further explosions.

#### Vulnerable Cells

```text
-12.0 * vulnerableCells
```

An AI cell is vulnerable if adjacent to an enemy primed cell:

```text
exists enemy neighbor n:
  n.atomCount >= n.capacity
```

This is a large penalty because losing cells to a nearby enemy explosion is one
of the most common tactical failures.

### 8.11 Oracle Recursive Search Formula

Let:

```text
Search(S, activePlayer, depth, alpha, beta)
```

If terminal:

```text
return terminalScore
```

If:

```text
activePlayer == AI
```

then:

```text
Search = max over legal moves:
  Search(simulate(S, move, activePlayer), nextPlayer, nextDepth, alpha, beta)
```

If:

```text
activePlayer != AI
```

then:

```text
Search = min over legal moves:
  Search(simulate(S, move, activePlayer), nextPlayer, nextDepth, alpha, beta)
```

With alpha-beta:

```text
max node:
  value = max(value, childScore)
  alpha = max(alpha, value)
  prune if alpha >= beta

min node:
  value = min(value, childScore)
  beta = min(beta, value)
  prune if alpha >= beta
```

### 8.12 Why Oracle Is Stronger Than God

God:

```text
fixed adaptive depth 2-3
no cache
no tactical extension
simpler evaluation
```

Oracle:

```text
iterative depth 1..6
time-bounded
transposition cache
tactical extension for explosive lines
stronger evaluation formula
stronger win/loss score
better chain-potential awareness
```

## 9. Mode Comparison

| Mode | Strategy | Search Depth | Simulation | Opponent Modeling | Main Formula |
|---|---|---:|---|---|---|
| Easy | RandomStrategy | 0 | No | No | uniform random |
| Medium | GreedyStrategy | 0 | No full board simulation | No | priority rules |
| Hard | StrategicStrategy | 1 ply | Yes | No | heuristic score after own move |
| Extreme | ExtremeStrategy | 2 ply | Yes | Yes, one response | minimax over opponent reply |
| God | GodStrategy | 2-3 | Yes | Yes, recursive | minimax + alpha-beta |
| Oracle | OracleStrategy | 1-6 with time cap | Yes | Yes, recursive | iterative minimax + cache + tactical extension |

## 10. Practical Difficulty Curve

Expected strength:

```text
Easy < Medium < Hard < Extreme < God < Oracle
```

Behavior summary:

```text
Easy:
  random legal play

Medium:
  greedy explosion and simple safety

Hard:
  one-move board evaluation with intentional mistakes

Extreme:
  assumes opponent will punish the AI's move immediately

God:
  searches multiple turns with alpha-beta pruning

Oracle:
  searches as deeply as time allows, extends explosive lines, caches states,
  and uses a richer tactical evaluation
```

## 11. Important Implementation Notes

### 11.1 Difficulty Enum

```dart
enum AIDifficulty { easy, medium, hard, extreme, god, oracle }
```

### 11.2 Strategy Mapping

```dart
switch (params.player.difficulty) {
  case AIDifficulty.easy:
    strategy = RandomStrategy();
  case AIDifficulty.medium:
    strategy = GreedyStrategy();
  case AIDifficulty.hard:
    strategy = StrategicStrategy();
  case AIDifficulty.extreme:
    strategy = ExtremeStrategy(params.rules);
  case AIDifficulty.god:
    strategy = GodStrategy(params.rules);
  case AIDifficulty.oracle:
    strategy = OracleStrategy(params.rules);
  case null:
    strategy = GreedyStrategy();
}
```

### 11.3 UI Label Mapping

```dart
case AIDifficulty.oracle:
  return 'Oracle';
```

### 11.4 JSON Value

```dart
AIDifficulty.oracle: 'oracle'
```

This value is used when serializing saved game data.

## 12. Recommended Future Improvements

### 12.1 Make Hard More Honest

Current Hard has:

```text
25% random mistake rate
```

To make it harder:

```text
difficultyFactor = 0.90
```

or:

```text
difficultyFactor = 1.00
```

### 12.2 Use Shared GameRules In Hard

Hard currently has a local simulation function. It can be made more consistent
with real gameplay by using:

```text
GameRules.processExplosion
```

like `Extreme`, `God`, and `Oracle`.

### 12.3 Tune Oracle Time Budget

Current:

```text
1500ms search budget
```

Possible mobile-friendly values:

```text
1000ms -> faster
1500ms -> balanced
2500ms -> stronger but slower
```

### 12.4 Add Opening Book

The early game has repeated patterns. Oracle could use simple opening rules:

```text
prefer corners
avoid placing next to early enemy corner pressure
build separated threats
```

This would reduce search cost in the opening.

### 12.5 Improve Cache Hashing

Current cache key uses string encoding. A faster future version could use
Zobrist hashing:

```text
hash = xor randomTable[cellIndex][owner][atomCount]
```

This would reduce cache-key allocation cost during deep search.
