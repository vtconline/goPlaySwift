//
//  GenericObserver.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 17/4/25.
//

import Combine
import Foundation

// Conforming to Sendable if needed (for concurrency)
@MainActor
class GenericObserver{
    private var cancellables: [ObjectIdentifier: AnyCancellable] = [:]  // Dictionary to track subscriptions
    private let lock = DispatchQueue(label: "com.yourapp.GenericObserver")


    // Singleton instance
     static let shared = GenericObserver()

    // Private initializer to enforce Singleton usage
    private init() {}

    // Function to observe changes to the entire data of a GoPlayViewModel
    func observe<T>(viewModel: GoPlayViewModel<T>, onChange: @escaping (T) async-> Void) {
        
        let cancellable = viewModel.$data
//            .sink(receiveValue: onChange)
            .sink { value in
                            // Since it's async, call it with await inside a Task
                            Task {
                                await onChange(value)
                            }
                        }


//        let id = ObjectIdentifier(viewModel)
//        cancellables[id] = cancellable
        // Synchronize access to cancellables dictionary
//        lock.sync {
//            let id = ObjectIdentifier(viewModel)
//            cancellables[id] = cancellable
//        }
        
    }
    
    func observeProperty<T, U>(
        viewModel: GoPlayViewModel<T>,
        keyPath: KeyPath<T, U>,
        onChange: @escaping (U) -> Void
    ) {
        let cancellable = viewModel.$data
            .map { $0[keyPath: keyPath] }
            .sink(receiveValue: onChange)

        let id = ObjectIdentifier(viewModel)
        cancellables[id] = cancellable
//        lock.sync {
//            let id = ObjectIdentifier(viewModel)
//            cancellables[id] = cancellable
//        }
        
    }


    // Function to observe a specific property of GoPlayViewModel using KeyPath
//    func observeProperty<T, U>(viewModel: GoPlayViewModel<T>, keyPath: KeyPath<T, U>, onChange: @escaping (U) -> Void) {
//        let cancellable = viewModel.publisher(for: keyPath)
//            .sink(receiveValue: onChange)
//
//        let id = ObjectIdentifier(viewModel)
//        cancellables[id] = cancellable
//    }

    // Function to cancel subscription for a specific ViewModel
    func cancelSubscription<T>(for viewModel: GoPlayViewModel<T>?) {
        if(viewModel == nil) {return}
        let id = ObjectIdentifier(viewModel!)
        cancellables[id]?.cancel()  // Cancel the subscription for the specific ViewModel
        cancellables.removeValue(forKey: id)  // Remove the cancellable from the dictionary
        print("Subscription canceled for \(viewModel!)")
//        lock.sync {
//            cancellables[id]?.cancel()  // Cancel the subscription for the specific ViewModel
//            cancellables.removeValue(forKey: id)  // Remove the cancellable from the dictionary
//            print("Subscription canceled for \(viewModel)")
//        }
        
    }

    // Function to cancel all subscriptions
    func cancelAll() {
        cancellables.forEach { $0.value.cancel() }  // Cancel all subscriptions
        cancellables.removeAll()  // Remove all entries from the dictionary
        print("All subscriptions canceled.")
//        lock.sync {
//            cancellables.forEach { $0.value.cancel() }  // Cancel all subscriptions
//            cancellables.removeAll()  // Remove all entries from the dictionary
//            print("All subscriptions canceled.")
//        }
        
    }
}



/* USAGE: example
 struct Person {
     var name: String
     var age: Int
 }
 let person = Person(name: "John", age: 30)
 let viewModel = GoPlayViewModel(data: person)
 // Access the singleton GenericObserver
 GenericObserver.shared.observe(viewModel: viewModel) { updatedPerson in
     print("Person object updated: \(updatedPerson)")
 }

 // Observe a specific property (name) of the Person object
 GenericObserver.shared.observeProperty(viewModel: viewModel, keyPath: \Person.name) { newName in
     print("Person's name changed to: \(newName)")
 }

 // Update the entire object and individual property
 viewModel.data = Person(name: "Jane", age: 25)  // Triggers both observers
 viewModel.data.name = "Alice"  // Triggers only the property observer

 // Output:
 // Person object updated: Person(name: "Jane", age: 25)
 // Person's name changed to: Alice

 */



