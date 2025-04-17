//
//  ResetDeviceView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 14/04/2025.
//

import SwiftUI

struct ResetDeviceView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AuthViewModel()
    @State private var showAlert: Bool = false
    @State private var error = ErrorBag()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Reset Device")
                    .customFont(.title, fontSize: 24)
                
                
                Text("This will remove all locally stored data and unlink your device. Are you sure?")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(role: .destructive) {
                    Task {
                        await viewModel.resetDevice()
                    }
                } label: {
                    Text("Confirm Reset")
                        .bold()
                }
                .padding()
            }
            .padding()
            .alert(error.description, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
            if case .loading = viewModel.state {
                ProgressView()
                    .scaleEffect(2)
            }
            
            if case .failed(let errorBag) = viewModel.state {
                Color.clear.onAppear {
                    error = errorBag
                    showAlert.toggle()
                }.frame(width: 0, height: 0)
            }
            
            if(viewModel.deviceReset) {
                Color.clear.onAppear {
                    appState.userClickedLogout = true
                    appState.main = UUID()
                }
            }
        }
    }
}

#Preview {
    ResetDeviceView()
        .environmentObject(AppState())
}
