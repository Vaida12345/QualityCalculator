# Calculator

Factorio Quality Calculator

# Discussion

You can use an iterative approach to simulate production.
```swift
import QualityCalculator

var yield = Yield.common
while !(0..<4).allSatisfy({ quality[$0] < 1e-12 }) {
    yield = quality.produce(productivity: Module.productivity(count: 8)) // Cryogenic plant
    yield = quality.produce(quality: Module.quality(count: 4), productivity: 0.25) // recycler
}
print(yield) // (0%, 0%, 0%, 0%, 4.835199%)
```
After the iteration, `yield` contains the results of a production process that loops between Cryogenic plant and recycler to obtain legendary items.
The last value (4.8%) indicates the efficiency of legendary production.
## Parameters
You can set the `quality` augment to indicate the quality of the production process  (defaults to `0`).
```swift
Yield.common.produce(quality: Module.quality(count: 4))
// (75.2%, 22.32%, 2.232%, 0.2232%, 0.0248%)
```
The resulting vector is a combination of all qualities, as indicated by ``contents``

You can also set the `productivity` augment to set the productivity bonus (defaults to `1`).
```swift
Yield.common.produce(quality: 0, productivity: Module.productivity(count: 2))
// (150%, 0%, 0%, 0%, 0%)
```
