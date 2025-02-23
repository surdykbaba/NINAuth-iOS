//
//  DevicesView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI
import EasySkeleton

struct DevicesView: View {
    @StateObject private var viewModel = DeviceViewModel()
    @State private var showAlert: Bool = false
    @State private var error = ErrorBag()
    
    var body: some View {
        if #available(iOS 16.0, *) {
            bodyView
                .toolbarBackground(.bg, for: .navigationBar)
                .toolbarRole(.editor)
        }else {
            bodyView
        }
    }
    
    var bodyView: some View {
        ScrollView {
            if(viewModel.loadingDevices) {
                VStack(spacing: 8) {
                    Spacer().frame(height: 4)
                    DataLoaderView()
                        .frame(height: 120)
                    Spacer().frame(height: 6)
                    DataLoaderView()
                        .frame(height: 120)
                    Spacer().frame(height: 6)
                    DataLoaderView()
                        .frame(height: 120)
                    Spacer().frame(height: 6)
                    DataLoaderView()
                        .frame(height: 120)
                    Spacer().frame(height: 6)
                    DataLoaderView()
                        .frame(height: 120)
                    Spacer().frame(height: 6)
                }.padding(.horizontal, 16)
            }else {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.devices, id: \.self.id!) { dev in
                        SingleDeviceView(device: dev, viewModel: viewModel)
                    }
                }
                .padding(20)
            }
            
            if case .failed(let errorBag) = viewModel.state {
                Color.clear.onAppear {
                    error = errorBag
                    showAlert.toggle()
                }.frame(width: 0, height: 0)
            }
        }
        .setSkeleton($viewModel.loadingDevices)
        .background(Color(.bg))
        .navigationTitle(Text("Devices"))
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.getDevices()
        }
        .alert(error.description, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    DevicesView()
}
