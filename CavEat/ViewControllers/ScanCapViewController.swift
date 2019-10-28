//
//  ScanCapViewController.swift
//  CavEat
//
//  Created by Justin Kufro on 10/28/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import AVFoundation
import UIKit

protocol BarCodeScannerDelegate: class {
    func codeDidFind(_ code: String)
}

protocol ImageCaptureDelegate: class {
    func photoCaptureCompletion(_ image: UIImage?, _ error: Error?)
}

protocol ScanCapDelegate: ImageCaptureDelegate, BarCodeScannerDelegate {}

// https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code
// http://zacstewart.com/2018/10/09/mocking-the-isight-camera-in-the-ios-simulator.html
class ScanCapViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: ScanCapDelegate? // swiftlint:disable:this weak_delegate
    var photoOutput: AVCapturePhotoOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }

    // swiftlint:disable function_body_length
    func setupCaptureSession() {
        DispatchQueue.main.async {
            print("setting up capture session")
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                print("authorized")
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        print("authorized")
                    } else {
                        return
                    }
                }
            case .denied: // The user has previously denied access.
                return
            case .restricted: // The user can't grant access due to restrictions.
                return
            default:
                return
            }
            print("capture session is authorized")

            self.captureSession = AVCaptureSession()
            print("got captureSession")

            guard let videoCaptureDevice = self.getBackCameraDevice() else {
                self.failed()
                return
            }
            print("got videoCaptureDevice")

            let videoInput: AVCaptureDeviceInput
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                print("could not get video input!")
                return
            }
            print("got videoInput")

            if self.captureSession.canAddInput(videoInput) {
                self.captureSession.addInput(videoInput)
            } else {
                self.failed()
                return
            }
            print("added input")

            let metadataOutput = AVCaptureMetadataOutput()

            if self.captureSession.canAddOutput(metadataOutput) {
                self.captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean13, .code128]
            } else {
                self.failed()
                return
            }
            print("added barcode output")

            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([
                AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            ], completionHandler: nil)

            if self.captureSession.canAddOutput(self.photoOutput!) {
                self.captureSession.addOutput(self.photoOutput!)
            } else {
                self.failed()
                return
            }
            print("added photo output")

            self.captureSession.startRunning()
            print("started session")

            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.frame = self.view.layer.bounds
            self.previewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
            print("added previewLayer")
        }
    }
    // swiftlint:enable function_body_length

    func failed() {
        let alertController = UIAlertController(
            title: "Scanning not supported",
            message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
        captureSession = nil
        view.backgroundColor = UIColor.red
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            print("running stopped capture")
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("stopping capture session")
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
        print("capture session stopped")
    }

    func captureImage() {
        print("capturing image")
        let settings = AVCapturePhotoSettings()
        if let photoOut = self.photoOutput {
            photoOut.capturePhoto(with: settings, delegate: self)
        } else {
            print("no photo out")
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("took image")
        if let error = error {
            self.delegate?.photoCaptureCompletion(nil, error)
        } else if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            self.delegate?.photoCaptureCompletion(image, nil)
        } else {
            self.delegate?.photoCaptureCompletion(nil, nil)
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            found(code: stringValue)
        }
    }

    func found(code: String) {
        self.delegate?.codeDidFind(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private func getBackCameraDevice() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video, position: .back) {
            return device
        } else {
            return nil
        }
    }
}
