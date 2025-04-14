//
//  QRCodeScannerRep.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 27/02/2025.
//

import SwiftUI
import SwiftQRCodeScanner

struct QRCodeScanner: UIViewControllerRepresentable {
    @Binding var result: String?
    
    typealias UIViewControllerType = QRCodeScannerController
    
    func makeUIViewController(context: Context) -> QRCodeScannerController {
        var configuration = QRScannerConfiguration()
        configuration.title = ""
        configuration.readQRFromPhotos = false
        configuration.flashOnImage = UIImage(systemName: "flashlight.on.fill")
        configuration.cancelButtonTintColor = .greenText
        let scanner = QRCodeScannerController(qrScannerConfiguration: configuration)
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: QRCodeScannerController, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, QRScannerCodeDelegate {
        
        var parent: QRCodeScanner
        
        init(_ parent: QRCodeScanner) {
            self.parent = parent
        }
        
        
        func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
            Log.info(result)
            parent.result = result
        }
        
        func qrScanner(_ controller: UIViewController, didFailWithError error: SwiftQRCodeScanner.QRCodeError) {
            
        }
        
        func qrScannerDidCancel(_ controller: UIViewController) {
            
        }
        
    }
}
