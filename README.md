
# SwiftDIKit

**SwiftDIKit** is a lightweight Dependency Injection framework for Swift. It provides an easy way to manage dependencies in your Swift projects with minimal boilerplate code. The framework supports both singleton and factory registration, and allows you to resolve dependencies with ease.

# Features

- **Singleton Support**: Register dependencies as singletons to ensure only one instance is created and shared.
- **Factory Support**: Register dependencies as factories to create a new instance each time it is resolved.
- **Modular System**: Easily define modules to group and register dependencies.

# Installation

You can install **SwiftDIKit** via [Swift Package Manager](https://swift.org/package-manager/).

## Using Swift Package Manager (SPM)

1. Open your project in Xcode.
2. Navigate to **File > Swift Packages > Add Package Dependency**.
3. Enter the repository URL: `https://github.com/FLatuf2610/SwiftDIKit`
4. Choose the version or branch you'd like to integrate.

# Usage

## Initial Setup

To get started with **SwiftDIKit**, you first need to define your modules and register them. Modules are containers for your dependency definitions.

### Define protocols and classes

```swift
// Define a protocol
protocol PrintsSomething {
    func printSomething()
}

// Define a class that conforms to the protocol
class PrintsSomethingImpl: PrintsSomething {
    func printSomething() {
        print("Something")
    }
}

// If your dependency contains more dependencies declare them in init()
class MyDependency {
    private let printSomething: PrintSomething
    
    init(p: PrintSomething) {
        self.printSomething = p
    }
}

```

### Create a module and declare dependencies

```swift
// Create a module and declare dependencies
let networkModule = swiftDIKitModule { di in
    // Use protocol type for classes that implement a protocol
    di.singleton(type: PrintSomething.self) { PrintSomethingImpl() }
    
    // Use di.get() to resolve dependencies
    di.factory { MyDependency(p: di.get()) }
}

//You can use di.getOptional() if you want to provide an optional instance
```


### Start the framework using the preoviously created modules

iOS: 
```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startSwiftDIKit(modules: [networkModule, anotherModule])
        return true
    }
}
```

macOS:
```swift
@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        startSwiftDIKit(modules: [networkModule, anotherModule])
    }
}
```

### Important: Declare your dependencies in the correct order. If not, the DependencyInjector may fail to resolve certain dependencies and throw a fatal error. You should register local dependencies first, followed by network services, repositories, use cases, and finally ViewModels/ViewControllers.

## Resolving Dependencies

Once you have your dependencies registered, you can resolve them anywhere in your code:

```swift
// Resolve the dependency
let printsSomething: PrintsSomething = resolve()
```

## Factory and Singleton Registration

You can register dependencies either as **singletons** (a single shared instance) or as **factories** (new instances created each time they are resolved).

#### Singleton Example

```swift
// Inside a module
di.singleton(type: SomeService.self) {
    SomeServiceImplementation()
}
```

#### Factory Example

```swift
// Inside a module
di.factory(type: SomeService.self) {
    SomeServiceImplementation()
}
```

## Resetting Dependencies

If you need to reset the dependencies (for example, in unit tests or during development), you can do so by calling:

```swift
restartSwiftDIKit()
```

## Optional Resolution

You can also resolve dependencies optionally, which will return `nil` if the dependency is not found:

```swift
let optionalDependency: SomeService? = resolveOptional()
```

# API Reference

## `SwiftDIKit`

- `static func startSwiftDIKit(modules: [Module])`: Starts the dependency injection framework by registering the provided modules.
- `static func resolve<T>() -> T`: Resolves and returns a dependency of the specified type.
- `static func resolveOptional<T>() -> T?`: Resolves and returns an optional dependency of the specified type.
- `static func restartSwiftDIKit()`: Resets all registered dependencies.
- `static func swiftDIKitModule(dependencies: @escaping (DependencyInjector) -> Void) -> Module`: Defines a module and registers its dependencies.

## `DependencyInjector`

- `public func singleton<T>(type: T.Type = T.self, factory: @escaping () -> T)`: Registers a singleton dependency.
- `public func singletonInstance<T>(type: T.Type = T.self, instance: T)`: Registers a singleton dependency.
- `public func factory<T>(type: T.Type = T.self, factory: @escaping () -> T)`: Registers a factory dependency.
- `public func get<T>() -> T`: Resolves and returns a dependency of the specified type.
- `public func getOptional<T>() -> T?` Resolves and returns an optional dependency of the specified type.
- `internal func registerModules(modules: [Module])`: Registers multiple modules at once.
- `internal func resetDependencies()`: Resets all registered dependencies.

## `Module`

- `public func load(dependencyInjector: DependencyInjector)`: Loads the dependencies in the module into the `DependencyInjector`.

# Tests

To run the tests for **SwiftDIKit**, clone the repository and run the tests using Xcode:

```bash
git clone https://github.com/FLatuf2610/SwiftDIKit.git
cd SwiftDIKit
open SwiftDIKit.xcodeproj
```

Then run the tests in Xcode.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


