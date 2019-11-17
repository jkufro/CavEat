//
//  Scan.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI
import AVFoundation

struct Scan: View {
    @ObservedObject var scanVM: ScanViewModel

    init() {
        scanVM = ScanViewModel()
    }

    var currentHeaderView: AnyView {
        switch scanVM.state {
        case .upcScanning:
            return AnyView(UPCScan())
        case .nutritionFactScanning, .ingredientScanning:
            return AnyView(ManualScanHeader(
                state: scanVM.state,
                pressHandler: scanVM.goToUpcScan
            ))
        default:
            return AnyView(Text("Something went wrong!"))
        }
    }

    var upcAlert: Alert {
        Alert(
            title: Text("UPC Not Found"),
            message: Text("Would you like to scan the nutrition facts and ingredients list?"),
            primaryButton: .default(Text("Scan"), action: scanVM.acceptUpcAlert),
            secondaryButton: .cancel(scanVM.dismissUpcAlert)
        )
    }

    var errorAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text(self.scanVM.errorMessage),
            dismissButton: .default(Text("OK"), action: scanVM.dismissErrorAlert)
        )
    }

    var body: some View {
        ZStack {
            if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
                VStack {
                    Text("Please enable camera access under:")
                        .font(.subheadline)
                        .frame(width: 300)
                        .foregroundColor(.primary)
                        .padding(.bottom)
                    Text("Settings > CavEat > Camera")
                        .font(.headline)
                        .frame(width: 300)
                        .foregroundColor(.primary)
                }
            }

            ScanCap(
                captureRequested: $scanVM.captureRequested,
                scanCompletionHandler: scanVM.scanCompletionHandler,
                captureCompletionHandler: scanVM.captureCompletionHandler
            )

            currentHeaderView

            if scanVM.state == .nutritionFactScanning || scanVM.state == .ingredientScanning {
                CaptureButton(pressHandler: {
                    if !self.scanVM.waiting && !self.scanVM.captureRequested {
                        self.scanVM.updateBool = !self.scanVM.updateBool
                        self.scanVM.captureRequested = true
                    }
                })
            }

            if scanVM.waiting {
                LoadingOverlay()
            }
        }
        .sheet(
            isPresented: $scanVM.showFood,
            onDismiss: scanVM.goToUpcScan,
            content: {
                Result(showFood: self.$scanVM.showFood,
                       resultVM: ResultViewModel(food: self.scanVM.food),
                       dismissCallback: {}
                )
            }
        )
        .alert(isPresented: $scanVM.anyAlerts, content: {
            if scanVM.promptForManualDecision {
                return self.upcAlert
            } else {
                return self.errorAlert
            }
        })
    }
}

struct Scan_Previews: PreviewProvider {
    static var previews: some View {
        Scan()
    }
}
