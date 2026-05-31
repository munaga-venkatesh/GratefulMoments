//
//  MomentEntryView.swift
//  GratefulMoments
//
//  Created by Venkatesh Munaga on 31/05/26.
//

import SwiftUI
import PhotosUI
import SwiftData

struct MomentEntryView: View {
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var imageData: Data?
    @State private var newPhoto: PhotosPickerItem?
    @State private var isShowingCancelConfirmation: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(DataContainer.self) private var dataContainer
    
    var body: some View {
        NavigationStack {
            ScrollView {
                constantStack
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Greatful For")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        if title.isEmpty, note.isEmpty, imageData == nil {
                            dismiss()
                        } else {
                            isShowingCancelConfirmation = true
                        }
                    }
                    .confirmationDialog("Discard Moment", isPresented: $isShowingCancelConfirmation) {
                        Button("Discard Moment") {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", systemImage: "checkmark") {
                        let newMoment = Moment(
                            title: title,
                            note: note,
                            imageData: imageData,
                            timeStamp: .now
                        )
                        dataContainer.context.insert(newMoment)
                        do {
                            try dataContainer.context.save()
                            dismiss()
                        } catch {
                            // Don't dismiss
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private var photoPicker: some View {
        PhotosPicker(selection: $newPhoto) {
            Group {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo.badge.plus")
                        .font(.largeTitle)
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.4, opacity: 0.32))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .onChange(of: newPhoto) {
            guard let newPhoto else { return }
            Task {
                imageData = try await newPhoto.loadTransferable(type: Data.self)
            }
        }
    }
    
    var constantStack: some View {
        VStack {
            TextField(text: $title) {
                Text("Title (Required)")
            }
            .font(.title.bold())
            .padding(.top, 10)
            Divider()
            
            TextField(text: $note, axis: .vertical) {
                Text("Log your small wins")
            }
            .multilineTextAlignment(.leading)
            .lineLimit(5...Int.max)
            
            photoPicker
        }
        .padding()
    }
}

#Preview {
    MomentEntryView()
        .sampleDataContainer()
}
