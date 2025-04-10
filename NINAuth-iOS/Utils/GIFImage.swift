//
//  GIFImage.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 10/04/2025.
//

import WebKit
import SwiftUI

struct GifImage: UIViewRepresentable {
    private let name: String
        
    //initialize a name
    init(_ name: String){
        self.name = name
    }
    
    func makeUIView(context: Context) -> UIGIFImage {
        return UIGIFImage(name: name)
    }
    //send data from SwiftUI to UIView
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.updateGIF(name: name)
    }
}

public class UIGIFImage: UIView {
    private let imageView = UIImageView()
    private var name: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
        initView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        self.addSubview(imageView)
    }
    
    func updateGIF(data: Data) {
        updateWithImage {
            UIImage.gifImage(data: data)
        }
    }
    
    func updateGIF(name: String) {
        updateWithImage {
            UIImage.gifImage(name: name)
        }
    }
    
    private func updateWithImage(_ getImage: @escaping () -> UIImage?) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = getImage()
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func initView() {
        imageView.contentMode = .scaleAspectFit
    }
}

public extension UIImage {
    class func gifImage(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil)
        else {
            return nil
        }
        let count = CGImageSourceGetCount(source)
        let delays = (0..<count).map {
            // store in ms and truncate to compute GCD more easily
            Int(delayForImage(at: $0, source: source) * 1000)
        }
        let duration = delays.reduce(0, +)
        let gcd = delays.reduce(0, gcd)
        
        var frames = [UIImage]()
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frame = UIImage(cgImage: cgImage)
                let frameCount = delays[i] / gcd
                
                for _ in 0..<frameCount {
                    frames.append(frame)
                }
            } else {
                return nil
            }
        }
        
        return UIImage.animatedImage(with: frames,
                                     duration: Double(duration) / 1000.0)
    }
    
    class func gifImage(name: String) -> UIImage? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return gifImage(data: data)
    }
}

private func gcd(_ a: Int, _ b: Int) -> Int {
    let absB = abs(b)
        let r = abs(a) % absB
        if r != 0 {
            return gcd(absB, r)
        } else {
            return absB
        }
}

private func delayForImage(at index: Int, source: CGImageSource) -> Double {
    let defaultDelay = 1.0
        
    let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
    let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
    defer {
        gifPropertiesPointer.deallocate()
    }
    let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
    if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
        return defaultDelay
    }
    let gifProperties = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
    var delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                         Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                                     to: AnyObject.self)
    if delayWrapper.doubleValue == 0 {
        delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                         Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                                    to: AnyObject.self)
    }
    
    if let delay = delayWrapper as? Double,
       delay > 0 {
        return delay
    } else {
        return defaultDelay
    }
}

struct GIFImageTest: View {
    var body: some View {
        VStack {
            GifImage("ninc")
                .frame(height: 300)
        }
    }
}


struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        GIFImageTest()
    }
}
