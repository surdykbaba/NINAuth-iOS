//
//  HideWithScreenshot.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 04/03/2025.
//

import SwiftUI

struct HideWithScreenshot: ViewModifier {
    @State private var size: CGSize?

    func body(content: Content) -> some View {
        ScreenshotPreventView {
            ZStack {
                content
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    size = proxy.size
                                }
                        }
                    )
            }
        }
        .frame(width: size?.width, height: size?.height)
    }
}

#Preview {
    Text("Hello, World!")
        .modifier(HideWithScreenshot())
}

struct ScreenshotPreventView<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    @State private var hostingController: UIHostingController<Content>?

    var body: some View {
        _ScreenshotPreventHelper(hostingController: $hostingController)
            .overlay(
                GeometryReader { geometry in
                    let size = geometry.size
                    Color.clear
                        .preference(key: SizeKey.self, value: size)
                        .onPreferenceChange(SizeKey.self) { newValue in
                            if hostingController == nil {
                                hostingController = UIHostingController(rootView: content)
                                hostingController?.view.backgroundColor = .clear
                                hostingController?.view.frame = CGRect(origin: .zero, size: size)
                            }
                        }
                }
            )
    }
}

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

fileprivate struct _ScreenshotPreventHelper<Content: View>: UIViewRepresentable {
    @Binding var hostingController: UIHostingController<Content>?

    func makeUIView(context: Context) -> UIView {
        let secureField = UITextField()
        secureField.isSecureTextEntry = true
        if let textLayoutView = secureField.subviews.first {
            return textLayoutView
        }
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Adding hosting view as a Subview to the TextLayout View
        if let hostingController, !uiView.subviews.contains(where: { $0.tag == 100 }) {
            uiView.addSubview(hostingController.view)
        }
    }
}

extension View {
    func hideWithScreenshot() -> some View {
        modifier(HideWithScreenshot())
    }
}
