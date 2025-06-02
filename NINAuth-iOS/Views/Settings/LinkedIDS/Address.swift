//
//  Address.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 02/06/2025.
//
import SwiftUI
import PhotosUI
import UIKit

struct UpdateAddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var residentialAddress = ""
    @State private var stateText = ""
    @State private var selectedLGA = "Select LGA"
    @State private var selectedDocumentType = "Select document type"
    @State private var showingDocumentPicker = false
    @State private var selectedDocument: String? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showStateDropdown = false
    @State private var filteredStates: [String] = []
    
    // Sample data
    let states = [
        "Abia State", "Adamawa State", "Akwa Ibom State", "Anambra State", "Bauchi State",
        "Bayelsa State", "Benue State", "Borno State", "Cross River State", "Delta State",
        "Ebonyi State", "Edo State", "Ekiti State", "Enugu State", "Gombe State",
        "Imo State", "Jigawa State", "Kaduna State", "Kano State", "Katsina State",
        "Kebbi State", "Kogi State", "Kwara State", "Lagos State", "Nasarawa State",
        "Niger State", "Ogun State", "Ondo State", "Osun State", "Oyo State",
        "Plateau State", "Rivers State", "Sokoto State", "Taraba State", "Yobe State",
        "Zamfara State", "Abuja FCT"
    ]
    
    let lgas = ["Oshodi/Isolo LGA", "Ikeja LGA", "Alimosho LGA", "Surulere LGA"]
    let documentTypes = ["Utility Bill", "National ID", "Passport", "Driver's License"]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                 
                    // Title
                    Text("Update Address")
                        .customFont(.title, fontSize: 20)
                        .padding(.top, 10)
                    
                    // Residential address
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Residential address")
                            .customFont(.subheadline, fontSize: 16)
                            .foregroundColor(.darkGrey)
                        
                        TextField("e.g 5, Anthony road, Garki", text: $residentialAddress)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // State with searchable dropdown
                    VStack(alignment: .leading, spacing: 8) {
                        Text("State")
                            .customFont(.subheadline, fontSize: 16)
                            .foregroundColor(.darkGrey)
                        
                        VStack(spacing: 0) {
                            HStack {
                                TextField("Type or select state", text: $stateText)
                                    .padding()
                                    .onChange(of: stateText) { newValue in
                                        filterStates(searchText: newValue)
                                        showStateDropdown = !newValue.isEmpty
                                    }
                                    .onTapGesture {
                                        if stateText.isEmpty {
                                            filteredStates = states
                                            showStateDropdown = true
                                        }
                                    }
                                
                                Button(action: {
                                    if stateText.isEmpty {
                                        filteredStates = states
                                    }
                                    showStateDropdown.toggle()
                                }) {
                                    Image(systemName: showStateDropdown ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.darkGrey)
                                        .padding(.trailing)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            
                            // Dropdown list
                            if showStateDropdown && !filteredStates.isEmpty {
                                VStack(spacing: 0) {
                                    ForEach(filteredStates.prefix(5), id: \.self) { state in
                                        Button(action: {
                                            stateText = state
                                            showStateDropdown = false
                                        }) {
                                            HStack {
                                                Text(state)
                                                    .foregroundColor(.black)
                                                    .padding(.vertical, 12)
                                                    .padding(.horizontal, 16)
                                                Spacer()
                                            }
                                        }
                                        .background(Color.white)
                                        
                                        if state != filteredStates.prefix(5).last {
                                            Divider()
                                        }
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        .background(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                                .zIndex(1)
                            }
                        }
                    }
                    
                    // Local Government Area
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Local Government Area")
                            .customFont(.subheadline, fontSize: 16)
                            .foregroundColor(.darkGrey)

                        
                        Menu {
                            ForEach(lgas, id: \.self) { lga in
                                Button(lga) {
                                    selectedLGA = lga
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedLGA)
                                    .foregroundColor(selectedLGA == "Select LGA" ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    // Supporting Document
                    Text("Supporting Document")
                        .customFont(.title, fontSize: 17)
                        .foregroundColor(.darkGrey)

                    // Document Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Document Type")
                            .customFont(.subheadline, fontSize: 16)
                            .foregroundColor(.darkGrey)

                        
                        Menu {
                            ForEach(documentTypes, id: \.self) { docType in
                                Button(docType) {
                                    selectedDocumentType = docType
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedDocumentType)
                                    .foregroundColor(selectedDocumentType == "Select document type" ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    
                    // Upload Document
                    Button(action: {
                        showingDocumentPicker = true
                    }) {
                        HStack(spacing: 15) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.button.opacity(0.1))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "arrow.up.doc")
                                    .font(.system(size: 24))
                                    .foregroundColor(.button)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(selectedDocument ?? "Upload Document")
                                    .customFont(.subheadline, fontSize: 16)
                                    .foregroundColor(.darkGrey)
                                
                                Text("Choose from your device")
                                    .customFont(.body, fontSize: 15)
                                    .foregroundColor(.darkGrey)
                            }
                            
                            Spacer()
                        }
                        
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.button, style: StrokeStyle(lineWidth: 1, dash: [5]))
                        )
                    }
                    
                    // Show selected image preview if available
                    if let selectedImage = selectedImage {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Selected Document Preview")
                                .customFont(.body, fontSize: 15)
                                .foregroundColor(.darkGrey)
                            
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.button.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // Submit Button
                    Button(action: {
                        // Handle submission
                        print("Form submitted")
                        print("Address: \(residentialAddress)")
                        print("State: \(stateText)")
                        print("LGA: \(selectedLGA)")
                        print("Document Type: \(selectedDocumentType)")
                        print("Document: \(selectedDocument ?? "None")")
                    }) {
                        Text("Submit")
                            .customFont(.title, fontSize: 18)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.button)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .onTapGesture {
                showStateDropdown = false
            }
            .onAppear {
                filteredStates = states
            }
            
            // Bottom sheet overlay
            if showingDocumentPicker {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingDocumentPicker = false
                    }
                
                VStack {
                    Spacer()
                    DocumentPickerView(
                        selectedDocument: $selectedDocument,
                        selectedImage: $selectedImage,
                        isPresented: $showingDocumentPicker
                    )
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.3))
            }
        }
        .navigationBarHidden(true)
    }
    
    // Function to filter states based on search text
    private func filterStates(searchText: String) {
        if searchText.isEmpty {
            filteredStates = states
        } else {
            filteredStates = states.filter { state in
                state.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

// Simple bottom sheet view for document selection
struct DocumentPickerView: View {
    @Binding var selectedDocument: String?
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    @State private var showingCamera = false
    @State private var showingFilePicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            // Header
            HStack {
                Text("Choose an action")
                    .customFont(.title, fontSize: 17)
                    .foregroundColor(.darkGrey)
                    .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .customFont(.title, fontSize: 17)
                        .foregroundColor(.darkGrey)
                        .padding(.top, 20)
                }
            }
            .padding(.horizontal, 20)
            
            // Options
            HStack(spacing: 60) {
                // Take a photo
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.blue)
                    }
                    
                    Text("Take a photo")
                        .font(.system(size: 16, weight: .medium))
                }
                .onTapGesture {
                    showingCamera = true
                }
                
                // Select a file
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "folder.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.orange)
                    }
                    
                    Text("Select a file")
                        .font(.system(size: 16, weight: .medium))
                }
                .onTapGesture {
                    showingFilePicker = true
                }
            }
            .padding(.top, 50)
           
        }
        .frame(height: 255)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedCorner(radius: 22, corners: [.topLeft, .topRight]))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        .sheet(isPresented: $showingCamera) {
            CameraView(selectedImage: $selectedImage, selectedDocument: $selectedDocument, isPresented: $isPresented)
        }
        .sheet(isPresented: $showingFilePicker) {
            FilePickerView(selectedDocument: $selectedDocument, isPresented: $isPresented)
        }
    }
}

// Camera view
struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedDocument: String?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
                parent.selectedDocument = "Photo captured"
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
                parent.selectedDocument = "Photo captured"
            }
            
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

// File picker view
struct FilePickerView: UIViewControllerRepresentable {
    @Binding var selectedDocument: String?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: FilePickerView
        
        init(_ parent: FilePickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            let fileName = url.lastPathComponent
            parent.selectedDocument = "File selected: \(fileName)"
            parent.isPresented = false
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
        }
    }
}

struct UpdateAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAddressView()
    }
}
