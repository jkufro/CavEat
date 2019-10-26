//
//  ScanCap.swift
//  CavEat
//
//  Created by Justin Kufro on 10/28/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import SwiftUI

// https://ibigbug.online/how-to-scan-qrcode-with-swiftui
struct ScanCap: UIViewControllerRepresentable {
    @Binding var captureRequested: Bool
    let scanCompletionHandler: (String) -> Void
    let captureCompletionHandler: (_ image: UIImage?, _ error: Error?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ScanCapViewController {
        let vc = ScanCapViewController()
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ vc: ScanCapViewController, context: Context) {
        if captureRequested {
            captureRequested = false;
            vc.captureImage()
        }
    }

    class Coordinator: NSObject, ScanCapDelegate {

        func codeDidFind(_ code: String) {
            print(code)
            self.parent.scanCompletionHandler(code)
        }

        func photoCaptureCompletion(_ image: UIImage?, _ error: Error?) {
            self.parent.captureCompletionHandler(image, error)
        }

        var parent: ScanCap

        init(_ parent: ScanCap) {
            self.parent = parent
        }
    }
}

#if DEBUG
struct ScanCap_Previews: PreviewProvider {
    static var previews: some View {
        ScanCap(captureRequested: .constant(false), scanCompletionHandler: {_ in}, captureCompletionHandler: {_,_  in })
    }
}
#endif
