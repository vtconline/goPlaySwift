//
//  Untitled.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 17/4/25.
//

import Combine

// Generic ViewModel with a @Published property
class GoPlayViewModel<T>: ObservableObject {
    @Published var data: T

    init(data: T) {
        self.data = data
    }
    
    // Method required to conform to Hashable
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(data) // Combine the data property into the hash function
//        }
//
//        // Required equality check method for Hashable
//        static func == (lhs: GoPlayViewModel<T>, rhs: GoPlayViewModel<T>) -> Bool {
//            return lhs.data == rhs.data // Compare the data property for equality
//        }
       
    
}


// Using the generic ViewModel with a String
//let stringViewModel = MyViewModel(data: "Hello, World!") data can be struct, class,...
//let stringObserver = GenericObserver(viewModel: stringViewModel)
//
//stringViewModel.data = "New String!" // This triggers the observer
