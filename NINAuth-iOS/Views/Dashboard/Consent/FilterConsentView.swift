//
//  FilterConsentView.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 27/02/2025.
//

import SwiftUI

struct FilterConsentView: View {
    @Binding var display : Bool
    @State private var startDate = ""
    @State private var endDate = ""
    @State private var isActive = 0
    @State private var showCalendar = false
    @State private var date = Date()
    @State private var dob = ""
    @State private var dateType = 0
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Filter")
                .customFont(.headline, fontSize: 24)
                .padding(.top, 24)
            
            Text("Period")
                .customFont(.headline, fontSize: 16)
                .padding(.top, 24)
            
            groupButton
            
            HStack {
                TextField("Start date", text: $startDate)
                    .padding(15)
                    .background(.white)
                    .disabled(true)
                    .onTapGesture {
                        dateType = 0
                        showCalendar.toggle()
                    }
                
                Image(.filterCalendar)
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke()
                    .fill(.gray)
            )
            .onChange(of: startDate) { _ in
                
            }
            .padding(.top, 25)
            
            HStack {
                TextField("End date", text: $endDate)
                    .padding(15)
                    .background(.white)
                    .disabled(true)
                    .onTapGesture {
                        dateType = 1
                        showCalendar.toggle()
                    }
                
                Image(.filterCalendar)
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke()
                    .fill(.gray)
            )
            .onChange(of: endDate) { _ in
                
            }
            .padding(.top, 16)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    display.toggle()
                } label: {
                    Text("Clear all")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.greenText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color(.currentDeviceBackground))
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.greenText), lineWidth: 1)
                )

                Button {
                    display.toggle()
                } label: {
                    Text("Apply")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.button)
                .cornerRadius(4)

            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showCalendar) {
            calendar
        }
    }
    
    private var groupButton: some View {
        HStack {
            Button {
                withAnimation {
                    isActive = 0
                }
            } label: {
                Capsule()
                    .fill(isActive == 0 ? Color(.currentDeviceBackground) : Color(.infoBackground))
                    .frame(height: 36)
                    .overlay(
                        Text("Custom period")
                            .customFont(.headline, fontSize: 14)
                            .foregroundColor(isActive == 0 ? Color(.button) : Color(.text))
                    )
                    .overlay(
                        Capsule()
                            .stroke(isActive == 0 ? Color(.button) : Color(.transparentGreenBackground), lineWidth: 1)
                    )

            }

            Button {
                withAnimation {
                    isActive = 1
                }
            } label: {
                Capsule()
                    .fill(isActive == 1 ? Color(.currentDeviceBackground) : Color(.infoBackground))
                    .frame(height: 36)
                    .overlay(
                        Text("Current week")
                            .customFont(.headline, fontSize: 14)
                            .foregroundColor(isActive == 1 ? Color(.button) : Color(.text))
                    )
                    .overlay(
                        Capsule()
                            .stroke(isActive == 1 ? Color(.button) : Color(.transparentGreenBackground), lineWidth: 1)
                    )
            }

            Button {
                withAnimation {
                    isActive = 2
                }
            } label: {
                Capsule()
                    .fill(isActive == 2 ? Color(.currentDeviceBackground) : Color(.infoBackground))
                    .frame(height: 36)
                    .overlay(
                        Text("Last week")
                            .customFont(.headline, fontSize: 14)
                            .foregroundColor(isActive == 2 ? Color(.button) : Color(.text))
                    )
                    .overlay(
                        Capsule()
                            .stroke(isActive == 2 ? Color(.button) : Color(.transparentGreenBackground), lineWidth: 1)
                    )
            }

        }
        .foregroundColor(Color(.text))
        .padding(.top, 12)
    }
    
    private var calendar: some View {
        ZStack {
            Color.white
            VStack {
                DatePicker(
                    "dob".localized, selection: $date,
                    in: ...Date(),
                    displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .onChange(of: date) { _ in
                    dob = dateFormatter.string(from: date)
                    if(dateType == 0) {
                        startDate = dob
                    }else {
                        endDate = dob
                    }
                    showCalendar.toggle()
                }
            }
            .customFont(.body, fontSize: 16)
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    FilterConsentView(display: .constant(true))
}
