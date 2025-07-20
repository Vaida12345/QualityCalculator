import Testing
@testable import QualityCalculator

@Test func foundation() {
    #expect(Yield.common.produce(quality: Module.quality(count: 4)).description == "(75.2%, 22.32%, 2.232%, 0.2232%, 0.0248%)")
    #expect(Yield.common.produce(quality: 0, productivity: Module.productivity(count: 2)).description == "(150%, 0%, 0%, 0%, 0%)")
    #expect(Yield.iterateSingle(x: 1, level: 0, rate: 0.248).description == "(75.2%, 22.32%, 2.232%, 0.2232%, 0.0248%)")
    #expect(Yield(contents: [0, 1, 0, 0, 0, 0, 0, 0]).produce(quality: 0.248).description == "(0%, 75.2%, 22.32%, 2.232%, 0.248%)")
    #expect(Yield(contents: [1, 1, 0, 0, 0, 0, 0, 0]).produce(quality: 0.248).description == "(75.2%, 97.52%, 24.552%, 2.4552%, 0.2728%)")
}

@Test func nestedProduction() {
    var quality = Yield.common
    while !(0..<4).allSatisfy({ quality[$0] < 1e-12 }) {
        quality = quality.produce(productivity: Module.productivity(count: 8)) // Cryogenic plant
        quality = quality.produce(quality: Module.quality(count: 4), productivity: 0.25) // recycler
    }
    #expect(quality[.legendary] - 0.04835199 < 1e-6) // see https://wiki.factorio.com/Tutorial:Quality_upcycling_math
}
