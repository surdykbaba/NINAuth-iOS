//  ServiceSelectionView.swift
//  NINAuth-iOS
//

import SwiftUI

// MARK: - Models
struct ServiceCategory: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let services: [DigitalService]
}

struct DigitalService: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let iconName: String
    let color: Color
}

// MARK: - Main Views
struct AddServiceView: View {
    @State private var selectedCategory: ServiceCategory?
    @State private var showFilterSheet = false
    @State private var navigateToGovernmentServices = false
    
    let categories: [ServiceCategory] = [
        ServiceCategory(
            title: "Digital Government Services",
            icon: "building.columns.fill",
            color: Color.green,
            services: [
                DigitalService(
                    title: "Nigerian Passport",
                    subtitle: "Government Services",
                    imageName: "passport_image",
                    iconName: "card1",
                    color: Color.green
                ),
                DigitalService(
                    title: "Driver's License",
                    subtitle: "Government Services",
                    imageName: "license_image",
                    iconName: "card2",
                    color: Color.red
                ),
                DigitalService(
                    title: "Voter's Card",
                    subtitle: "Government Services",
                    imageName: "voter_image",
                    iconName: "card3",
                    color: Color.green
                ),
                DigitalService(
                    title: "State Residence Permit",
                    subtitle: "Government Services",
                    imageName: "residence_image",
                    iconName: "card4",
                    color: Color.orange
                )
            ]
        ),
        ServiceCategory(
            title: "Driving and Transport",
            icon: "car.fill",
            color: Color.blue,
            services: []
        ),
        ServiceCategory(
            title: "Tax, Insurance and Benefits",
            icon: "doc.text.fill",
            color: Color.orange,
            services: []
        ),
        ServiceCategory(
            title: "Financial Services",
            icon: "building.columns.fill",
            color: Color.cyan,
            services: []
        ),
        ServiceCategory(
            title: "Memberships",
            icon: "person.2.fill",
            color: Color.gray,
            services: []
        )
    ]
    
    // Get the government services category
    private var governmentServicesCategory: ServiceCategory {
        return categories.first { $0.title.contains("Government") } ?? categories[0]
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add a Service")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Keep all your IDs for easy access and verification")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Categories List
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(categories) { category in
                            CategoryRowView(category: category)
                                .onTapGesture {
                                    // Always navigate to government services
                                    selectedCategory = governmentServicesCategory
                                    navigateToGovernmentServices = true
                                }
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    
                }
                
                Spacer()
                
               
              
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Go back action
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(categories: categories)
            }
            .background(
                NavigationLink(
                    destination: CategoryDetailView(category: governmentServicesCategory),
                    isActive: $navigateToGovernmentServices,
                    label: { EmptyView() }
                )
            )
        }
    }
}

struct CategoryRowView: View {
    let category: ServiceCategory
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(category.color)
                    .frame(width: 48, height: 48)
                
                Image(systemName: category.icon)
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
            
            // Title
            Text(category.title)
                .font(.headline)
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .contentShape(Rectangle())
    }
}

struct CategoryDetailView: View {
    let category: ServiceCategory
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var selectedServiceID: String?
    @State private var navigateToPassportDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Government Services")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Store your digital IDs for easy access to government services.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            // Featured Service
            FeaturedServiceCard()
                .padding(.horizontal)
            
            // Search Bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search ID", text: $searchText)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                
                Button(action: {
                    showFilterSheet = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            // Services List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(category.services) { service in
                        DigitalServiceRowView(digitalService: service)
                            .onTapGesture {
                                selectedServiceID = service.title
                                navigateToPassportDetails = true
                            }
                    }
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.green)
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            // Use all categories from the AddServiceView
            FilterSheetView(categories: AddServiceView().categories)
        }
        .background(
            NavigationLink(
                destination: PassportDetailsView(selectedID: selectedServiceID),
                isActive: $navigateToPassportDetails,
                label: { EmptyView() }
            )
        )
    }
}

struct FeaturedServiceCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Using a Rectangle with gradient as a fallback if the image doesn't exist
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.yellow]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
                .cornerRadius(12)
                .overlay(
                    Image("maincard4") // Replace with your image asset name
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                )
            
            // Add to Wallet Button
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Add to wallet action
                    }) {
                        Text("Add to Wallet")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .frame(height: 200)
    }
}

struct DigitalServiceRowView: View {
    let digitalService: DigitalService
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon placeholder with fallback
            ZStack {
               
                
                Image(digitalService.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 32)
                    .cornerRadius(4)
            }
            
            // Title
            Text(digitalService.title)
                .font(.headline)
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .contentShape(Rectangle())
    }
}

struct FilterSheetView: View {
    let categories: [ServiceCategory]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with close button
            HStack {
                Text("Add a service")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.title3)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            // Categories List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(categories) { category in
                        CategoryRowView(category: category)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                                // Navigate to category detail
                            }
                    }
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.top, 20)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Preview
struct AddServiceView_Previews: PreviewProvider {
    static var previews: some View {
        AddServiceView()
    }
}
