import SwiftUI
import RealmSwift
import LocalAuthentication

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AuthViewModel()
    @StateObject private var linkVM = LinkedIDViewModel()
    @State private var biometricsIsOn = true
    @State private var appLockIsOn = false
    @ObservedResults(User.self) var user
    @ObservedResults(Token.self) var token
    @State private var showSignOut = false
    @State private var showAlert: Bool = false
    @State private var showPin = false
    @State private var msg = ""
    @State private var pin = ""
    private let numberOfFields = 6
    @FocusState var isFocused: Bool
    @State private var isValid = true
    @State private var goToUpdatePin = false
    private let mem = MemoryUtil.init()
    @State private var showSheet = false
    @State private var goToLinkID = false
    @State private var hideIntegrityIndex = true  // ✅ Changed to true to hide by default
    @State private var showAppLockInfo = false

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        VStack(spacing: 6) {
                            Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                                .resizable()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                            
                            Text("\(user.first?.first_name ?? "") \(user.first?.last_name ?? "")")
                                .customFont(.title, fontSize: 24)
                            
                            Text("Last login: \(user.first?.getLastLogin() ?? "")")
                                .customFont(.subheadline, fontSize: 16)
                        }
//                        // Toggle Button to Show/Hide Integrity Index
//                        Button {
//                            hideIntegrityIndex.toggle()
//                        } label: {
//                            Text(hideIntegrityIndex ? "Show Index" : "Hide Index")
//                                .customFont(.subheadline, fontSize: 16)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 16)
//                                .background(Color.grayBackground)
//                                .cornerRadius(12)
//                                .padding(.bottom, 4)
//                        }

                        // Conditional rendering of the Integrity Index section
                        if !hideIntegrityIndex {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("ID Integrity Index: 550")
                                    .customFont(.body, fontSize: 16)

                                NinAuthSlider(value: $linkVM.score)
                                    .padding(.bottom)

                                Button {
                                    showSheet.toggle()
                                } label: {
                                    HStack {
                                        Text("What does my ID integrity index mean?")
                                            .customFont(.body, fontSize: 14)

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color("buttonColor"))
                                    }
                                }
                                .padding(.top, 20)
                            }
                            .padding()
                            .mask(
                                RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke()
                                    .fill(.gray.opacity(0.2))
                            )
                            .padding(.bottom, 30)
                        }

                        legalAndComplaince

                        security
                            .padding(.top, 44)

                        others
                            .padding(.top, 44)
                            .padding(.bottom)

                        NavigationLink(destination: UpdatePinView(oldPIN: pin), isActive: $goToUpdatePin) {}.isDetailLink(false)

                        if case .failed(let errorBag) = viewModel.state {
                            Color.clear.onAppear {
                                msg = errorBag.description
                                showAlert.toggle()
                            }.frame(width: 0, height: 0)
                        }
                    }
                    .foregroundColor(Color(.text))
                }
                .padding()
                .padding(.top, 20)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            NotificationsView()
                        } label: {
                            Image(systemName: "bell.badge")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.red, .black)
                                .customFont(.caption, fontSize: 18)
                                .foregroundStyle(Color.button)
                        }
                        .padding(.trailing)
                    }
                }
                .onAppear {
                    biometricsIsOn = mem.getBoolValue(key: mem.authentication_key)
                    appLockIsOn = mem.getBoolValue(key: mem.lock_app)
                }
            }
            .task {
                await linkVM.getScore(deviceID: appState.getDeviceID())
            }

            BottomSheetView(isPresented: $showSheet) {
                LinkedIDsModalView(showSheet: $showSheet, goToLinkID: $goToLinkID, score: $linkVM.score, scoreToDisplay: $linkVM.displayedScore)
                    .background(Color(.white))
                    .padding(.bottom, 50)
            }

            if viewModel.isLogging == true {
                ProgressView()
                    .scaleEffect(2)
            }
        }
    }

    var biometrics: some View {
        HStack(spacing: 20) {
            Image("fingerprint")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(12)
                .background(Color("grayBackground"))
                .clipShape(Circle())
            
            Toggle(isOn: $biometricsIsOn,
                   label : {
                Text("biometrics".localized)
                    .customFont(.headline, fontSize: 19)
            })
            .onChange(of: biometricsIsOn) { _ in
                if(biometricsIsOn) {
                    enableBiometrics()
                }
                mem.setValue(key: mem.authentication_key, value: biometricsIsOn)
            }
        }
        .alert(msg, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    var legalAndComplaince: some View {
        VStack(alignment: .leading, spacing: 18){
            Text("legal_and_compliance".localized)
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)

            Divider()

            Group {
                Link(destination: URL(string: "https://ninauth.com/privacy-policy")!) {
                    SettingsRow(image: "lock", name: "privacy_policy".localized)
                }

                Link(destination: URL(string: "https://ninauth.com/terms-of-service")!) {
                    SettingsRow( image: "file_text", name: "terms_of_service".localized)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    var security: some View {
        VStack(alignment: .leading, spacing: 18){
            Text("security".localized)
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)

            Divider()

            Group {
                NavigationLink(destination: DataSharingView()) {
                    SettingsRow(image: "wifi_off", name: "offline_data_sharing".localized)
                }

                Button {
                    showPin.toggle()
                } label: {
                    SettingsRow(image: "lock", name: "update_pin".localized)
                }
                .halfSheet(showSheet: $showPin) {
                    requestCodeView
                } onEnd: {
                    Log.info("Dismissed Sheet")
                }

                biometrics

                NavigationLink(destination: DevicesView()) {
                    SettingsRow(image: "device_mobile", name: "devices".localized)
                }

                NavigationLink(destination: LinkedIDsView()) {
                    SettingsRow(image: "linked", name: "Linked IDs")
                }
                NavigationLink(destination: ResetDeviceView()) {
                    SettingsRow(image: "Reset_device", name: "Reset Device")
                        .foregroundColor(.red)
                }


                NavigationLink(destination: LinkedIDsView(), isActive: $goToLinkID) {}.isDetailLink(false)
                    .frame(width: 0, height: 0)

                if(viewModel.logOut) {
                    Color.clear.onAppear {
                        appState.userClickedLogout = true
                        appState.main = UUID()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    var others: some View {
        VStack(alignment: .leading, spacing: 18){
            Text("others")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)

            Divider()

            Group {
                NavigationLink(destination: NotificationsView()) {
                    SettingsRow(image: "notification", name: "notifications".localized)
                }
                
                HStack(spacing: 20) {
                    Image("lock")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(12)
                        .background(Color.grayBackground)
                        .clipShape(Circle())

                    VStack {
                        Toggle(isOn: $appLockIsOn,
                               label : {
                            Text("App Lock on Exit")
                                .customFont(.headline, fontSize: 19)
                        })
                        .onChange(of: appLockIsOn) { newValue in
                            if newValue {
                                showAppLockInfo = true
                            }
                            mem.setValue(key: mem.lock_app, value: appLockIsOn)
                        }
                    }
                }
                .alert("App Lock on Exit", isPresented: $showAppLockInfo) {
                    Button("Got it", role: .cancel) { }
                } message: {
                    Text("Your app will automatically lock after 5 minutes of inactivity.")
                }

//                Button {
//                    showSignOut = true
//                } label: {
//                    SettingsRow(image: "logout", name: "Sign out")
//                }
//                .alert("Sign out?", isPresented: $showSignOut) {
//                    Button("OK", role: .destructive) {
//                        Task {
//                            await viewModel.logoutUser(logOutRequest: LogOutRequest(sessionId: token.first?.session))
//                        }
//                    }
//                    Button("Cancel", role: .cancel) { }
//                } message: {
//                    Text("You are about to sign out of this device")
//                }
            }
        }
        .padding(.horizontal, 20)
    }

    var requestCodeView: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .trailing)
                        .padding(.top, 30)
                        .onTapGesture {
                            showPin.toggle()
                        }
                }
                .padding(.bottom)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter your old PIN to continue")
                        .customFont(.headline, fontSize: 24)
                        .padding(.bottom, 40)

                    OTPView(numberOfFields: numberOfFields, otp: $pin, valid: $isValid)
                        .onChange(of: pin) { newOtp in
                            if newOtp.count == numberOfFields && !newOtp.isEmpty{
                                isValid = true
                            }
                        }
                        .focused($isFocused)

                    Button {
                        if(isValid) {
                            goToUpdatePin.toggle()
                            showPin.toggle()
                        }
                    } label: {
                        Text("Continue")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(isValid ? Color.button : Color.button.opacity(0.2))
                    .cornerRadius(4)
                    .disabled(!isValid)
                }
            }
            .padding()
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
    }

    func enableBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to activate another means of unlocking your application."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        biometricsIsOn = true
                        mem.setValue(key: mem.authentication_key, value: true)
                    } else {
                        msg = authenticationError?.localizedDescription ?? "Failed to authenticate."
                        showAlert.toggle()
                        mem.setValue(key: mem.authentication_key, value: false)
                    }
                }
            }
        } else {
            msg = "No Biometrics available on this device."
            showAlert.toggle()
            mem.setValue(key: mem.authentication_key, value: false)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
