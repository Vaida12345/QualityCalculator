//
//  Yield.swift
//  QualityCalculator
//
//  Created by Vaida on 2025-07-21.
//

import Foundation


/// A vector for items of all qualities.
///
/// You use ``produce()`` to run simulations.
public struct Yield: CustomStringConvertible, Equatable {
    
    /// The contents of the wrapper.
    ///
    /// The vector is formatted as
    /// ```
    /// [common, uncommon, rare, epic, legendary, 0, 0, 0]
    /// ```
    public let contents: SIMD8<Double>
    
    @inlinable
    public var description: String {
        if #available(macOS 12, iOS 15, *) {
            "(" + (0..<5).map({ self.contents[$0].formatted(.percent) }).joined(separator: ", ") + ")"
        } else {
            "(" + (0..<5).map({ self.contents[$0].description }).joined(separator: ", ") + ")"
        }
    }
    
    /// The common yield.
    @inlinable
    public static var common: Yield {
        Yield(contents: [1, 0, 0, 0, 0, 0, 0, 0])
    }
    
    @inlinable
    static func iterateSingle(x: Double, level: Int, rate: Double) -> Yield {
        assert(level < 4 && level >= 0)
        assert(rate <= 1 && rate >= 0)
        
        let multipliers: [SIMD8<Double>] = [
            [1, 0.9, 0.09, 0.009, 0.001, 0, 0, 0],
            [0, 1, 0.9, 0.09, 0.01, 0, 0, 0],
            [0, 0, 1, 0.9, 0.1, 0, 0, 0],
            [0, 0, 0, 1, 1, 0, 0, 0]
        ]
        let multiplier = multipliers[level]
        
        let rates: [SIMD8<Double>] = [
            [1-rate, rate, rate, rate, rate, 0, 0, 0],
            [0, 1 - rate, rate, rate, rate, 0, 0, 0],
            [0, 0, 1 - rate, rate, rate, 0, 0, 0],
            [0, 0, 0, 1 - rate, rate, 0, 0, 0],
        ]
        
        return Yield(contents: multiplier) * Yield(contents: rates[level]) * x
    }
    
    /// Runs a production.
    ///
    /// You can use an iterative approach to simulate production.
    ///
    /// ```swift
    /// var yield = Yield.common
    /// while !(0..<4).allSatisfy({ quality[$0] < 1e-12 }) {
    ///     yield = quality.produce(productivity: Module.productivity(count: 8)) // Cryogenic plant
    ///     yield = quality.produce(quality: Module.quality(count: 4), productivity: 0.25) // recycler
    /// }
    /// print(yield) // (0%, 0%, 0%, 0%, 4.835199%)
    /// ```
    /// After the iteration, `yield` contains the results of a production process that loops between Cryogenic plant and recycler to obtain legendary items.
    ///
    /// The last value (4.8%) indicates the efficiency of legendary production.
    ///
    /// ## Parameters
    ///
    /// You can set the `quality` augment to indicate the quality of the production process  (defaults to `0`).
    /// ```swift
    /// Yield.common.produce(quality: Module.quality(count: 4))
    /// ```
    ///
    /// The resulting vector is a combination of all qualities, as indicated by ``contents``.
    /// ```swift
    /// (75.2%, 22.32%, 2.232%, 0.2232%, 0.0248%)
    /// ```
    ///
    /// You can also set the `productivity` augment to set the productivity bonus (defaults to `1`).
    /// ```swift
    /// Yield.common.produce(quality: 0, productivity: Module.productivity(count: 2))
    /// // (150%, 0%, 0%, 0%, 0%)
    /// ```
    ///
    /// - Parameters:
    ///   - quality: The quality of the production process. Defaults to `0`, indicating no bonus.
    ///   - productivity: The productivity bonus of the production process. Defaults to `1`, indicating no bonus.
    ///
    /// - Note: Both parameters are ignored for the legendary lane.
    @inlinable
    public func produce(
        quality: Double = 0,
        productivity: Double = 1
    ) -> Yield {
        stride(from: 3, through: 0, by: -1).reduce(Yield(contents: .zero)) { partialResult, l in
            partialResult + Yield.iterateSingle(x: self[l], level: l, rate: quality)
        } * productivity + Yield(contents: [0, 0, 0, 0, self[4], 0, 0, 0])
    }
    
    
    /// Element-wise addition.
    @inlinable
    public static func + (lhs: Yield, rhs: Yield) -> Yield {
        Yield(contents: lhs.contents + rhs.contents)
    }
    
    /// Element-wise addition.
    @inlinable
    public static func += (lhs: inout Yield, rhs: Yield) {
        lhs = lhs + rhs
    }
    
    /// Element-wise multiplication.
    @inlinable
    public static func * (lhs: Yield, rhs: Yield) -> Yield {
        Yield(contents: lhs.contents * rhs.contents)
    }
    
    /// Vector-scalar multiplication.
    @inlinable
    public static func * (lhs: Yield, rhs: Double) -> Yield {
        Yield(contents: lhs.contents * SIMD8<Double>(repeating: rhs))
    }
    
    /// Returns the value at a given index.
    @inlinable
    public subscript(_ index: Int) -> Double {
        contents[index]
    }
    
    /// Returns the value at a given quality.
    @inlinable
    public subscript(_ quality: Quality) -> Double {
        self[quality.rawValue]
    }
    
    /// Creates a new instance.
    ///
    /// See ``contents`` for layout.
    @inlinable
    public init(contents: SIMD8<Double>) {
        self.contents = contents
    }
    
}
