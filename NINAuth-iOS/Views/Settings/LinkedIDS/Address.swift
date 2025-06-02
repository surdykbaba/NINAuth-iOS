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
                    Text("Update Address")
                        .customFont(.title, fontSize: 20)
                        .padding(.top, 10)

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
                            
                         
                            if showStateDropdown && !filteredStates.isEmpty {
                                ZStack {
                                    ScrollView {
                                        VStack(spacing: 0) {
                                            ForEach(filteredStates, id: \.self) { state in
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
                                                    .frame(maxWidth: .infinity)
                                                    .contentShape(Rectangle())
                                                }
                                                .background(Color.white)
                                                
                                                if state != filteredStates.last {
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxHeight: 200)
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
                    
                   
                    Text("Supporting Document")
                        .customFont(.title, fontSize: 17)
                        .foregroundColor(.darkGrey)

                   
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
                    
                    
                    if let selectedImage = selectedImage {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Selected Document Preview")
                                    .customFont(.body, fontSize: 15)
                                    .foregroundColor(.darkGrey)
                                
                                Spacer()
                                
                                
                                Button(action: {
                                    self.selectedImage = nil
                                    self.selectedDocument = nil
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.red)
                                }
                            }
                            
                            ZStack(alignment: .topTrailing) {
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
                    }
                    
                   
                    if selectedDocument != nil && selectedImage == nil {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Selected Document")
                                    .customFont(.body, fontSize: 15)
                                    .foregroundColor(.darkGrey)
                                
                                Spacer()
                                
                                // Cancel button to remove file
                                Button(action: {
                                    self.selectedDocument = nil
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.red)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "doc.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.button)
                                
                                Text(selectedDocument ?? "")
                                    .customFont(.body, fontSize: 14)
                                    .foregroundColor(.darkGrey)
                                    .lineLimit(2)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.button.opacity(0.1))
                            )
                        }
                    }
                    
                    Spacer()
                    
                    
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
        
    }
    
    
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





struct UpdateAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAddressView()
    }
}
