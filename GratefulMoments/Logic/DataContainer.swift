//
//  DataContainer.swift
//  GratefulMoments
//
//  Created by Venkatesh Munaga on 31/05/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
class DataContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(includeSampleMoments: Bool = false) {
        let schema = Schema([
            Moment.self,
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: includeSampleMoments
        )
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            if includeSampleMoments {
                loadSampleMoments()
            }
            try context.save()
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }
    
    private func loadSampleMoments() {
        for moment in Moment.sampleData {
            context.insert(moment)
        }
    }
}


private let sampleContainer: DataContainer = .init(includeSampleMoments: true)

extension View {
    func sampleDataContainer() -> some View {
        self
            .environment(sampleContainer)
            .modelContainer(sampleContainer.modelContainer)
    }
}
