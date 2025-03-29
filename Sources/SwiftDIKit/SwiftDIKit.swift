// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A private structure that acts as a facade for dependency injection management.
fileprivate struct SwiftDIKit {
    /// The internal dependency injector instance used to manage dependencies.
    nonisolated(unsafe) private static let dependencyInjector = DependencyInjector()
    
    /// Private initializer to prevent instantiation of the struct.
    private init() {}
    
    /// Registers multiple modules to the dependency injector.
    /// - Parameter modules: An array of `Module` instances to be registered.
    fileprivate static func registerModules(modules: [Module]) {
        self.dependencyInjector.registerModules(modules: modules)
    }
    
    /// Resets all registered dependencies, clearing both singletons and factories.
    fileprivate static func resetSWiftDIKit() {
        self.dependencyInjector.resetDependencies()
    }
    
    /// Resolves an instance of the requested type.
    /// - Returns: An instance of the requested type.
    fileprivate static func resolve<T>() -> T {
        let instance: T = dependencyInjector.get()
        return instance
    }
    
    fileprivate static func resolveOptional<T>(_ type: T.Type = T.self) -> T? {
        return dependencyInjector.getOptional()
    }
}

/// Creates a dependency injection module with the specified dependencies.
/// - Parameter dependencies: A closure that receives a `DependencyInjector` for registering dependencies.
/// - Returns: A `Module` containing the registered dependencies.
public func swiftDIKitModule(dependencies: @escaping (DependencyInjector) -> Void) -> Module {
    return DIModule(dependencies: dependencies)
}

/// Starts the dependency injection framework by registering the provided modules.
/// - Parameter modules: An array of `Module` instances to be registered.
public func startSwiftDIKit(modules: [Module]) {
    SwiftDIKit.registerModules(modules: modules)
}

/// Resolves an instance of the requested type.
/// - Returns: An instance of the requested type.
public func resolve<T>(type: T.Type = T.self) -> T {
    SwiftDIKit.resolve()
}

/// Resolves an optional instance of the requested type.
/// - Returns: An optional instance of the requested type.
func resolveOptional<T>(type: T.Type = T.self) -> T? {
    SwiftDIKit.resolveOptional()
}

/// Resets all registered dependencies, clearing both singletons and factories.
public func restartSwiftDIKit() {
    SwiftDIKit.resetSWiftDIKit()
}
