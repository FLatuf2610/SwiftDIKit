//
//  DIModule.swift
//  SwiftDIKit
//
//  Created by Franco Latuf on 29/03/2025.
//

/// Represents a module that can be loaded into the dependency injector.
public class DIModule: Module {
    /// Closure that defines dependencies to be registered.
    private let dependencies: (DependencyInjector) -> Void
    
    /// Initializes a module with the specified dependency registration closure.
    /// - Parameter dependencies: A closure that receives a `DependencyInjector` for registering dependencies.
    internal init(dependencies: @escaping (DependencyInjector) -> Void) {
        self.dependencies = dependencies
    }
    
    /// Loads the module into the given dependency injector.
    /// - Parameter dependencyInjector: The `DependencyInjector` instance where dependencies should be registered.
    public func load(dependencyInjector: DependencyInjector) {
        dependencies(dependencyInjector)
    }
}
