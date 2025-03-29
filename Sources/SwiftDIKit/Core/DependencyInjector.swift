//
//  DependencyInjectpr.swift
//  SwiftDIKit
//
//  Created by Franco Latuf on 29/03/2025.
//

import Foundation

/// Manages dependency injection by handling singleton and factory registrations.
public class DependencyInjector {
    /// Stores singleton instances by type identifier.
    private var singletones: [ObjectIdentifier:Any] = [:]
    /// Stores factory closures by type identifier.
    private var factories: [ObjectIdentifier:Any] = [:]
    
    internal init() {}
    
    /// Registers a singleton instance of the specified type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - factory: A closure that returns an instance of the specified type.
    public func singleton<T>(type: T.Type = T.self, factory: @escaping () -> T) {
        let key = ObjectIdentifier(type)
        if self.singletones[key] == nil {
            self.singletones[key] = factory()
        }
    }
    
    /// Registers a factory function for the specified type.
    /// - Parameters:
    ///   - type: The type to register.
    ///   - factory: A closure that returns a new instance of the specified type.
    public func factory<T>(type: T.Type = T.self, factory: @escaping () -> T) {
        let key = ObjectIdentifier(type)
        self.factories[key] = factory
        
    }
    
    /// Resolves an instance of the specified type.
    /// - Returns: An instance of the requested type.
    /// - Throws: A runtime error if the dependency cannot be resolved.
    public func get<T>() -> T {
        let key = ObjectIdentifier(T.self)
        if let instance = self.singletones[key] as? T {
            return instance
        }
        if let factory = self.factories[key] as? () -> T {
            return factory()
        }
        fatalError("Dependency: \(T.self) could not be resolved")
    }
    
    /// Resolves an optional instance of the specified type.
    /// - Returns: An optional instance of the requested type.
    internal func getOptional<T>() -> T? {
        let key = ObjectIdentifier(T.self)
        if let instance = self.singletones[key] as? T {
            return instance
        }
        if let factory = self.factories[key] as? () -> T {
            return factory()
        }
        return nil
    }
    
    /// Registers multiple modules into the dependency injector.
    /// - Parameter modules: An array of `Module` instances to be registered.
    internal func registerModules(modules: [Module]) {
        for module in modules {
            module.load(dependencyInjector: self)
        }
    }
    
    /// Resets all registered dependencies, clearing both singletons and factories.
    internal func resetDependencies() {
        self.singletones.removeAll()
        self.factories.removeAll()
    }
}
