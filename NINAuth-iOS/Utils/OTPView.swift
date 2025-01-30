//
//  OTPView.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 30/01/2025.
//

import SwiftUI
import Combine

struct OTPView: View {
    let numberOfFields: Int
    @Binding private var otp: String
    @FocusState private var fieldFocus: Int?
    @State var enterValue: [String]
    @State var oldValue = ""
    @State private var borderColor = Color.black
    @Binding private var valid: Bool
    
    init(numberOfFields: Int, otp: Binding<String>, valid: Binding<Bool>) {
        self.numberOfFields = numberOfFields
        self.enterValue = Array(repeating: "", count: numberOfFields)
        _otp = otp
        _valid = valid
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                ForEach(0..<numberOfFields, id: \.self) { index in
                    TextField("", text: $enterValue[index], onEditingChanged: { editing in
                        if editing {
                            oldValue = enterValue[index]
                        }
                    })
                    .foregroundColor(Color.white)
                    .keyboardType(.numberPad)
                    .frame(width: 44, height: 56)
                    .background(Color.gray)
                    .cornerRadius(5)
                    .multilineTextAlignment(.center)
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            fieldFocus = 0
                        }
                    }
                    .overlay(
                        withAnimation(.easeOut(duration: 0.1)) {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(fieldFocus == index ? Color.white : borderColor, lineWidth: 1)
                        }
                    )
                    .onAppear {
                        if valid == true {
                            borderColor = Color.gray
                        }else {
                            borderColor = .red
                        }
                    }
                    .onChange(of: valid) { newVal in
                        if valid == true {
                            borderColor = Color.gray
                        }else {
                            borderColor = .red
                        }
                    }
                    .onChange(of: enterValue[index]) { newValue in
                        if !newValue.isEmpty {
                            // Update to new value if there is already a value.
                            if enterValue[index].count > 1 {
                                let currentValue = Array(enterValue[index])
                                
                                // ADD THIS IF YOU DON'T HAVE TO HIDE THE KEYBOARD WHEN THEY ENTERED
                                // THE LAST VALUE.
                                // if oldValue.count == 0 {
                                //    enterValue[index] = String(enterValue[index].suffix(1))
                                //    return
                                // }
                                if oldValue.isEmpty == true {
                                    enterValue[index] = String(enterValue[index].suffix(1))
                                    return
                                }
                                
                                if currentValue[0] == Character(oldValue) {
                                    enterValue[index] = String(enterValue[index].suffix(1))
                                } else {
                                    enterValue[index] = String(enterValue[index].prefix(1))
                                }
                            }
                            
                            // MARK: - Move to Next
                            if index == numberOfFields - 1 {
                                // COMMENT IF YOU DON'T HAVE TO HIDE THE KEYBOARD WHEN THEY ENTERED
                                // THE LAST VALUE.
                                fieldFocus = nil
                            } else {
                                self.fieldFocus = (self.fieldFocus ?? 0) + 1
                            }
                            otp = self.getString(array: enterValue)
                        } else {
                            // MARK: - Move back
                            fieldFocus = (fieldFocus ?? 0) - 1
                            otp = self.getString(array: enterValue)
                        }
                    }
                }
            }
            if valid == false {
                Text("The code you entered is incorrect")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.red)
            }
        }
    }
    
    private func limitText(_ upper: Int) {
        if otp.count > upper {
            otp = String(otp.prefix(upper))
        }
    }
    
    private func getString(array : [String]) -> String {
        let str = array.joined(separator: "")
        return str
    }
    
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(numberOfFields: 6, otp: .constant("5678"), valid: .constant(false))
    }
}
