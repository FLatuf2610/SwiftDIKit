import XCTest
@testable import SwiftDIKit

final class SwiftDIKitTests: XCTestCase {
    override func setUpWithError() throws {
            let module = swiftDIKitModule { di in
                di.factory(type: PrintsSomething.self) { B() }
                di.singleton { A() }
                di.singleton { C(a: di.getOptional(), b: di.getOptional()) }
            }
            
            startSwiftDIKit(modules: [module])
        }
        
        override func tearDownWithError() throws {
            restartSwiftDIKit()
        }
        
        func testRegisterDependencies() throws {
            let c: C? = resolveOptional()
            XCTAssertNotNil(c)
            XCTAssertNotNil(c?.a)
            XCTAssertNotNil(c?.b)
        }
        
        func testSingleton() throws {
            let a: A? = resolveOptional()
            let a2: A? = resolveOptional()
            XCTAssertNotNil(a)
            XCTAssertNotNil(a2)
            XCTAssert(a === a2)
        }
        
        func testFactory() throws {
            let b: PrintsSomething? = resolveOptional()
            let b2: PrintsSomething? = resolveOptional()
            XCTAssertNotNil(b as? B)
            XCTAssertNotNil(b2 as? B)
            XCTAssertFalse(b as? B === b2 as? B)
        }
        
        func testResolve() throws {
            let b: PrintsSomething = resolve()
            b.printSomething()
            let a: A = resolve()
            a.doSomething()
            XCTAssert(b as? B != nil)
        }
        
        func testReset() throws {
            restartSwiftDIKit()
            let a: A? = resolveOptional()
            XCTAssertNil(a)
        }
    
    func testDependencyResolutionInMultipleThreads() throws {
        let expectation = XCTestExpectation(description: "All tasks completed")

        // Launch 10 threads to test concurrency
        let group = DispatchGroup()

        for _ in 0..<10 {
            DispatchQueue.global(qos: .userInitiated).async(group: group) {
                // Resolve dependencies on different threads
                let b: PrintsSomething = resolve() // Resolve a dependency of type PrintsSomething
                b.printSomething() // Call method on the resolved object

                let a: A = resolve() // Resolve another dependency of type A
                a.doSomething() // Call method on the resolved object

                // Verify that the instance is of the expected type
                XCTAssertTrue(b is B)
            }
        }

        // Wait for all threads to finish
        group.notify(queue: .main) {
            expectation.fulfill()
        }

        // Wait until the expectation is fulfilled, with a timeout of 5 seconds
        wait(for: [expectation], timeout: 5.0)
    }

}

class A {
    func doSomething() {
        print("Doing something")
    }
}

class B: PrintsSomething {
    func printSomething() {
        print("Something")
    }
}

class C {
    let a: A?
    let b: PrintsSomething?
    
    init(a: A?, b: PrintsSomething?) {
        self.a = a
        self.b = b
    }
}

protocol PrintsSomething {
    func printSomething()
}
