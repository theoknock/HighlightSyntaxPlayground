//
//  HighlightSyntaxPlaygroundApp.swift
//  HighlightSyntaxPlayground
//
//  Created by Xcode Developer on 6/14/25.
//

import SwiftUI
import SwiftData
import HighlightSwift

private struct HighlightKey: EnvironmentKey {
    static let defaultValue = Highlight()
}

extension EnvironmentValues {
    var highlight: Highlight {
        get { self[HighlightKey.self] }
        set { self[HighlightKey.self] = newValue }
    }
}

@main
struct HighlightSyntaxPlaygroundApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var attributedString = AttributedString("print(\"Hello World!\")")

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
