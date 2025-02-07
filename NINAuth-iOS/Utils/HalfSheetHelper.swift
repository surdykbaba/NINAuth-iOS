//
//  HalfSheetHelper.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 07/02/2025.
//

import Foundation
import SwiftUI

//UIKit Integration
struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {

    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()

    let controller = UIViewController()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            // present ModalView
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        }
        else {
            //Close view when showSheet is toggled again
            uiViewController.dismiss(animated: true)
        }
    }

    // On Dismiss
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper

        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}

//Custom UIHostingController for halfSheer
class CustomHostingController<Content: View>: UIHostingController<Content> {

    override func viewDidLoad() {
        view.backgroundColor =  .clear

        //setting presentation controller properties
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]

            //To show grab portion
            presentationController.prefersGrabberVisible = true
        }
    }
}
