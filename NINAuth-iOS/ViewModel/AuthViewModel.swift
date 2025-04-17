//
//  AuthViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

import Foundation
import RealmSwift
import CoreLocation

class AuthViewModel: NSObject, ObservableObject  {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var continueReg = false
    @Published var verifyStatus = ""
    @Published var isLoggedIn = false
    @Published private(set) var requestCode: String?
    @Published var logOut = false
    @Published var userLocation: CLLocation? = nil
    @Published var otpTriggered = false
    @Published var otpValidated = false
    @Published var isLogging = false
    @Published var deviceReset = false
    private let locationManager = CLLocationManager()
    private var deniedCount = 0

    private let authService: AuthService
    
    override init() {
        authService = AuthService()
    }
    
    @MainActor
    func registerUser(registerUserRequest: RegisterUserRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.registerUser(registerUserRequest: registerUserRequest)
        switch result {
        case .success(_):
            continueReg = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    @MainActor
    func registerUserSelfie(registerUserSelfieRequest: RegisterUserSelfieRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.registerUserSelfie(registerUserSelfieRequest: registerUserSelfieRequest)
        switch result {
        case .success(let res):
            // NOTE: Verify Status is either "passed" or "process"
            verifyStatus = res["face_auth_completed"].stringValue.lowercased()
            state = .success
        case .failure(let failure):
            state = .failed(failure)
            verifyStatus = "failed"
        }
    }
    
    @MainActor
    func getFaceAuthStatus(deviceID: String) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.getFaceAuthStatus(deviceID: deviceID)
        switch result {
        case .success(let res):
            // NOTE: Verify Status is either "passed" or "process"
            verifyStatus = res["face_auth_completed"].stringValue.lowercased()
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
//    func loginUser(loginUserRequest: LoginUserRequest) async -> Void {
//        guard state != .loading else {
//            return
//        }
//        state = .loading
//        let result = await authService.login(loginUserRequest: loginUserRequest)
//        switch result {
//        case .success(let userResponse):
//            isLoggedIn = true
//            Log.info(userResponse.description)
//            state = .success
//        case .failure(let failure):
//            state = .failed(failure)
//        }
//    }
    
    @MainActor
    func loginWithNIN(loginWithNIN: LoginWithNIN) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.loginWithNIN(loginWithNIN: loginWithNIN)
        switch result {
        case .success(let userResponse):
            isLoggedIn = true
            Log.info(userResponse.description)
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    @MainActor
    func logoutUser(logOutRequest: LogOutRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        isLogging = true
        let result = await authService.logout(logOutRequest: logOutRequest)
        switch result {
        case .success(_):
//            do {
//                let realm = try await Realm()
//                try? realm.write {
//                    realm.deleteAll()
//                }
//            }catch {
//                Log.info(error.localizedDescription)
//            }
            isLogging = false
            logOut = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
            isLogging = false
        }
    }
    
    @MainActor
    func registerWithNIN(registerWithNIN: RegisterWithNIN) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.registerWithNIN(registerWithNIN: registerWithNIN)
        switch result {
        case .success(_):
            continueReg = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    @MainActor
    func updateInfo(updateUserInfo: UpdateUserInfo) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.updateUserInfo(updateUserInfo: updateUserInfo)
        switch result {
        case .success(_):
            state = .success
            continueReg = true
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    @MainActor
    func triggerOTP(sendOTPRequest: SendOTPRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.sendOTP(sendOTPRequest: sendOTPRequest)
        switch result {
        case .success(_):
            state = .success
            otpTriggered = true
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    @MainActor
    func validateOTP(validateOTP: ValidateOTP) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.validateOTP(validateOTP: validateOTP)
        switch result {
        case .success(_):
            state = .success
            otpValidated = true
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    @MainActor
    func resetDevice() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.resetDevice()
        switch result {
        case .success(_):
            state = .success
            deviceReset = true
        case .failure(let failure):
            state = .failed(failure)
        }
    }
}

extension AuthViewModel : CLLocationManagerDelegate {
    
    func initiateLocationRequest() {
        self.locationManager.delegate = self
        if(hasLocationPermission()) {
            locationManager.startUpdatingLocation()
        }else {
            requestAuthorisation()
        }
    }
    
    private func requestAuthorisation(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func hasLocationPermission() -> Bool {
        var hasPermission = false
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            hasPermission = false
        case .authorizedAlways, .authorizedWhenInUse:
            hasPermission = true
        @unknown default:
            hasPermission = false
        }
        return hasPermission
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(status) {
        case .notDetermined, .restricted, .denied :
            deniedCount += 1
            requestAuthorisation()
        case .authorizedAlways, .authorizedWhenInUse:
            Log.info("I have location permission")
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            userLocation = location
            //reverseGeoCodePickLocation(location: location)
        }
    }
    
//    private func reverseGeoCodePickLocation(location: CLLocation) {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { placemarks, error in
//            guard let currentLocPlacemark = placemarks?.first else { return }
//            Log.info(currentLocPlacemark.country ?? "No country found")
//            Log.info(currentLocPlacemark.isoCountryCode ?? "No country code found")
//        }
//    }
}
