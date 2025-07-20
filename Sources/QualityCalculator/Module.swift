//
//  Module.swift
//  QualityCalculator
//
//  Created by Vaida on 2025-07-21.
//


/// Container structure for all modules.
public enum Module {
    
    /// Legendary quality 3 module.
    ///
    /// - Parameter count: Number of modules.
    @inlinable
    public static func quality(count: Int) -> Double {
        0.062 * Double(count)
    }
    
    /// Legendary productivity 3 module.
    ///
    /// - Parameter count: Number of modules.
    @inlinable
    public static func productivity(count: Int) -> Double {
        1 + 0.25 * Double(count)
    }
    
}
