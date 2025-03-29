//
//  Module.swift
//  SwiftDIKit
//
//  Created by Franco Latuf on 29/03/2025.
//

/// A protocol that represents a dependency injection module.
/// A module is responsible for registering dependencies using a `DependencyInjector`.
public protocol Module {
    /// Loads and registers dependencies into the given `DependencyInjector`.
    ///
    /// - Parameter dependencyInjector: The `DependencyInjector` instance where dependencies will be registered.
    func load(dependencyInjector: DependencyInjector)
}
