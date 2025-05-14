//  IDscanner.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 13/05/2025.
//

import SwiftUI
import AVFoundation
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct IDScannerView: View {
    @State private var captureMode: CaptureMode = .auto
    @State private var isCapturing = false
    @State private var capturedImage: UIImage?
    @State private var extractedData: IDData?
    @State private var fullExtractedText: String = ""
    @State private var qrCodeImage: UIImage?
    @State private var showQRCode = false
    @State private var stopCamera = false
    @State private var scanProgress: String = "Scan front of ID"
    @State private var isProcessing = false

    enum CaptureMode {
        case manual, auto
    }

    var body: some View {
        ZStack {
            CameraView(
                capturedImage: $capturedImage,
                isCapturing: $isCapturing,
                stopCamera: $stopCamera,
                captureMode: captureMode
            )
            .ignoresSafeArea()

            // ID Frame Overlay
            GeometryReader { geometry in
                ZStack {
                    // Dark overlay with hole for ID frame
                    Color.black.opacity(0.6)
                        .mask(
                            FrameMaskView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        )
                        .ignoresSafeArea()
                    
                    // ID frame border
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: geometry.size.width * 0.85, height: geometry.size.width * 0.55)
                        .shadow(color: .white.opacity(0.3), radius: 2)
                    
                    // Corner markers
                    CornerMarkersView()
                        .frame(width: geometry.size.width * 0.85, height: geometry.size.width * 0.55)
                }
            }

            VStack {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "cancel")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "bolt.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }
                }
                .padding()

                Spacer()

                VStack(spacing: 24) {
                    Text(scanProgress)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)

                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }

                    HStack(spacing: 0) {
                        Button(action: { captureMode = .manual }) {
                            Text("Manual")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(captureMode == .manual ? .black : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(captureMode == .manual ? Color.white : Color.clear)
                                )
                        }

                        Button(action: { captureMode = .auto }) {
                            Text("Auto capture")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(captureMode == .auto ? .black : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(captureMode == .auto ? Color.white : Color.clear)
                                )
                        }
                    }
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.2)))
                    .frame(maxWidth: 280)

                    if captureMode == .manual && !isProcessing {
                        Button(action: {
                            isCapturing = true
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                        .frame(width: 80, height: 80)
                                )
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: capturedImage) { newImage in
            if let image = newImage {
                isProcessing = true
                scanProgress = "Processing..."
                performOCROnImage(image)
            }
        }
        .sheet(isPresented: $showQRCode) {
            QRCodeView(
                qrCodeImage: qrCodeImage,
                extractedData: extractedData,
                fullText: fullExtractedText
            )
        }
    }

    func performOCROnImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            isProcessing = false
            scanProgress = "Failed to process image"
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.scanProgress = "No text detected"
                }
                return
            }

            var allText: [String] = []
            var structuredData: [String: String] = [:]
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                let text = topCandidate.string
                allText.append(text)
                
                // Extract structured data
                if let field = extractFieldWithValue(from: text) {
                    structuredData[field.key] = field.value
                }
            }

            let fullText = allText.joined(separator: "\n")
            
            DispatchQueue.main.async {
                // Extract specific fields or use default values
                let extractedData = IDData(
                    surname: structuredData["surname"] ?? extractFieldValue(from: fullText, keywords: ["surname", "last name"]),
                    firstname: structuredData["firstname"] ?? extractFieldValue(from: fullText, keywords: ["first name", "given name"]),
                    middlename: structuredData["middlename"] ?? extractFieldValue(from: fullText, keywords: ["middle name", "other name"]),
                    gender: structuredData["gender"] ?? extractFieldValue(from: fullText, keywords: ["gender", "sex"]),
                    dateOfBirth: structuredData["dob"] ?? extractFieldValue(from: fullText, keywords: ["date of birth", "dob", "birth date"]),
                    documentNumber: structuredData["documentnumber"] ?? extractFieldValue(from: fullText, keywords: ["document number", "id number", "nin"]),
                    nationality: structuredData["nationality"] ?? extractFieldValue(from: fullText, keywords: ["nationality", "citizen"]),
                    idType: structuredData["idtype"] ?? extractFieldValue(from: fullText, keywords: ["id type", "document type"]),
                    issuedDate: structuredData["issueddate"] ?? extractFieldValue(from: fullText, keywords: ["issued date", "issue date"]),
                    expiryDate: structuredData["expirydate"] ?? extractFieldValue(from: fullText, keywords: ["expiry date", "expiration", "valid until"]),
                    address: structuredData["address"] ?? extractFieldValue(from: fullText, keywords: ["address", "residence"]),
                    placeOfBirth: structuredData["placeofbirth"] ?? extractFieldValue(from: fullText, keywords: ["place of birth", "birth place"]),
                    height: structuredData["height"] ?? extractFieldValue(from: fullText, keywords: ["height"]),
                    eyeColor: structuredData["eyecolor"] ?? extractFieldValue(from: fullText, keywords: ["eye color", "eyes"]),
                    signature: structuredData["signature"] ?? extractFieldValue(from: fullText, keywords: ["signature"]),
                    rawText: fullText
                )

                self.extractedData = extractedData
                self.fullExtractedText = fullText

                // Generate QR code with raw OCR text instead of structured data
                if let qrImage = self.generateQRCode(from: fullText) {
                    self.qrCodeImage = qrImage
                    self.showQRCode = true
                    self.scanProgress = "Scan complete!"
                } else {
                    self.scanProgress = "Failed to generate QR code"
                }

                self.isCapturing = false
                self.isProcessing = false
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["en-US"]

        do {
            try requestHandler.perform([request])
        } catch {
            DispatchQueue.main.async {
                self.isProcessing = false
                self.scanProgress = "Error: \(error.localizedDescription)"
            }
        }
    }

    func extractFieldWithValue(from text: String) -> (key: String, value: String)? {
        let patterns = [
            "surname": "(?i)(?:surname|last\\s?name)[:\\s]+([^\\n]+)",
            "firstname": "(?i)(?:first\\s?name|given\\s?name)[:\\s]+([^\\n]+)",
            "middlename": "(?i)(?:middle\\s?name|other\\s?name)[:\\s]+([^\\n]+)",
            "gender": "(?i)(?:gender|sex)[:\\s]+([^\\n]+)",
            "dob": "(?i)(?:date\\s?of\\s?birth|dob|birth\\s?date)[:\\s]+([^\\n]+)",
            "documentnumber": "(?i)(?:document\\s?number|id\\s?number|nin)[:\\s]+([^\\n]+)",
            "nationality": "(?i)(?:nationality|citizen)[:\\s]+([^\\n]+)",
            "address": "(?i)(?:address|residence)[:\\s]+([^\\n]+)",
            "height": "(?i)height[:\\s]+([^\\n]+)",
            "eyecolor": "(?i)(?:eye\\s?color|eyes)[:\\s]+([^\\n]+)"
        ]
        
        for (field, pattern) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
               let valueRange = Range(match.range(at: 1), in: text) {
                return (field, String(text[valueRange]).trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        return nil
    }

    func extractFieldValue(from text: String, keywords: [String]) -> String {
        let lines = text.split(separator: "\n")
        
        for (index, line) in lines.enumerated() {
            let lowercasedLine = line.lowercased()
            
            for keyword in keywords {
                if lowercasedLine.contains(keyword.lowercased()) {
                    // Check if the value is on the same line after a colon or space
                    if let colonIndex = line.firstIndex(of: ":") {
                        let value = line[line.index(after: colonIndex)...].trimmingCharacters(in: .whitespacesAndNewlines)
                        if !value.isEmpty {
                            return value
                        }
                    }
                    
                    // Check if the value is on the next line
                    if index + 1 < lines.count {
                        let nextLine = String(lines[index + 1]).trimmingCharacters(in: .whitespacesAndNewlines)
                        if !nextLine.isEmpty && !nextLine.lowercased().contains(":") {
                            return nextLine
                        }
                    }
                    
                    // Try to extract value from the same line
                    let components = line.split(separator: " ", maxSplits: keyword.split(separator: " ").count)
                    if components.count > 1 {
                        return components.suffix(from: 1).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
            }
        }
        
        return ""
    }

    func generateQRCode(from rawText: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        // Use the raw text directly instead of structured data
        filter.message = Data(rawText.utf8)

        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return nil
    }
}

// Frame Mask View for dark overlay with cutout
struct FrameMaskView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.black)
                
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: geometry.size.width * 0.85, height: geometry.size.width * 0.55)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
        }
    }
}

// Corner Markers View
struct CornerMarkersView: View {
    let markerSize: CGFloat = 30
    let markerThickness: CGFloat = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Top Left
                Path { path in
                    path.move(to: CGPoint(x: 0, y: markerSize))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: markerSize, y: 0))
                }
                .stroke(Color.white, lineWidth: markerThickness)
                
                // Top Right
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width - markerSize, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: markerSize))
                }
                .stroke(Color.white, lineWidth: markerThickness)
                
                // Bottom Left
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height - markerSize))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: markerSize, y: geometry.size.height))
                }
                .stroke(Color.white, lineWidth: markerThickness)
                
                // Bottom Right
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width - markerSize, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - markerSize))
                }
                .stroke(Color.white, lineWidth: markerThickness)
            }
        }
    }
}

struct IDData: Codable {
    let surname: String
    let firstname: String
    let middlename: String
    let gender: String
    let dateOfBirth: String
    let documentNumber: String
    let nationality: String
    let idType: String
    let issuedDate: String
    let expiryDate: String
    let address: String
    let placeOfBirth: String
    let height: String
    let eyeColor: String
    let signature: String
    let rawText: String
    
    init(surname: String = "", firstname: String = "", middlename: String = "",
         gender: String = "", dateOfBirth: String = "", documentNumber: String = "",
         nationality: String = "", idType: String = "", issuedDate: String = "",
         expiryDate: String = "", address: String = "", placeOfBirth: String = "",
         height: String = "", eyeColor: String = "", signature: String = "", rawText: String = "") {
        self.surname = surname
        self.firstname = firstname
        self.middlename = middlename
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.documentNumber = documentNumber
        self.nationality = nationality
        self.idType = idType
        self.issuedDate = issuedDate
        self.expiryDate = expiryDate
        self.address = address
        self.placeOfBirth = placeOfBirth
        self.height = height
        self.eyeColor = eyeColor
        self.signature = signature
        self.rawText = rawText
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var isCapturing: Bool
    @Binding var stopCamera: Bool
    let captureMode: IDScannerView.CaptureMode
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.delegate = context.coordinator
        controller.captureMode = captureMode
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.captureMode = captureMode
        if isCapturing {
            uiViewController.capturePhoto()
            isCapturing = false
        }
        if stopCamera {
            uiViewController.stopSession()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CameraViewControllerDelegate {
        let parent: CameraView
        init(_ parent: CameraView) {
            self.parent = parent
        }
        func didCaptureImage(_ image: UIImage) {
            parent.capturedImage = image
        }
    }
}

protocol CameraViewControllerDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
}

class CameraViewController: UIViewController {
    weak var delegate: CameraViewControllerDelegate?
    var captureMode: IDScannerView.CaptureMode = .auto
    
    private let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    private func setupCamera() {
        captureSession.beginConfiguration()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        delegate?.didCaptureImage(image)
    }
}

struct QRCodeView: View {
    let qrCodeImage: UIImage?
    let extractedData: IDData?
    let fullText: String
    @Environment(\.dismiss) var dismiss
    @State private var showRawText = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("QR Code Generated")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let qrImage = qrCodeImage {
                        Image(uiImage: qrImage)
                            .interpolation(.none)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    
                    if let data = extractedData {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Extracted Data")
                                .font(.headline)
                                .padding(.bottom, 8)
                            
                            Group {
                                InfoRow(label: "Surname", value: data.surname)
                                InfoRow(label: "First Name", value: data.firstname)
                                InfoRow(label: "Middle Name", value: data.middlename)
                                InfoRow(label: "Gender", value: data.gender)
                                InfoRow(label: "Date of Birth", value: data.dateOfBirth)
                                InfoRow(label: "Document Number", value: data.documentNumber)
                            }
                            
                            Group {
                                InfoRow(label: "Nationality", value: data.nationality)
                                InfoRow(label: "ID Type", value: data.idType)
                                InfoRow(label: "Issued Date", value: data.issuedDate)
                                InfoRow(label: "Expiry Date", value: data.expiryDate)
                                InfoRow(label: "Address", value: data.address)
                                InfoRow(label: "Place of Birth", value: data.placeOfBirth)
                                InfoRow(label: "Height", value: data.height)
                                InfoRow(label: "Eye Color", value: data.eyeColor)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        Button(action: {
                            showRawText.toggle()
                        }) {
                            Label(
                                showRawText ? "Hide Raw Text" : "Show Raw Text",
                                systemImage: showRawText ? "eye.slash" : "eye"
                            )
                            .font(.callout)
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 8)
                        
                        if showRawText {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Raw OCR Text")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: true) {
                                    Text(data.rawText)
                                        .font(.system(.caption, design: .monospaced))
                                        .padding()
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(8)
                                }
                                .frame(maxHeight: 200)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationBarItems(
                trailing: Button("Close") {
                    dismiss()
                }
            )
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(width: 120, alignment: .leading)
            Text(value.isEmpty ? "—" : value)
                .font(.callout)
                .fontWeight(.medium)
            Spacer()
        }
    }
}

struct IDScannerView_Previews: PreviewProvider {
    static var previews: some View {
        IDScannerView()
    }
}
