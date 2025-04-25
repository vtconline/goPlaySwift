//
//  ContentView.swift
//  SwiftSample
//
//  Created by Ngô Đồng on 23/4/25.
//

import SwiftUI
import SwiftData
import goplaysdk
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            MainView()
//            GoIdAuthenView()
            Spacer()
        }

    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
