//
//  CapScanViewController.swift
//  CavEat
//
//  Created by Justin Kufro on 10/27/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import AVFoundation
import UIKit

//protocol ImageCaptureDelegate {
//    func photoCaptureCompletion(_ image: UIImage?, _ error: Error?)
//}
//
//protocol BarCodeScannerDelegate {
//    func codeDidFind(_ code: String)
//}

// https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code
// http://zacstewart.com/2018/10/09/mocking-the-isight-camera-in-the-ios-simulator.html
class CapScanViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    static var shared = CapScanViewController()

    var scanning: Bool = true

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDelegate: ImageCaptureDelegate?
    var scanDelegate: BarCodeScannerDelegate?
    var photoOutput: AVCapturePhotoOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }

    func checkAuthorization() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                return true
            case .notDetermined: // The user has not yet been asked for camera access.
                var auth = false
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    auth = granted
                }
                return auth
            case .denied: // The user has previously denied access.
                return false
            case .restricted: // The user can't grant access due to restrictions.
                return false
            default:
                return false
        }
    }

    func setupCaptureSession() {
        print("setting up capture session")
        view.backgroundColor = UIColor.blue

        guard checkAuthorization() else {
            failed()
            return
        }
        print("capture session is authorized")

        captureSession = AVCaptureSession()
        print("got captureSession")

        guard let videoCaptureDevice = getBackCameraDevice() else {
            failed()
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

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        print("added input")

        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .code128]
        } else {
            failed()
            return
        }
        print("added scanning output")

        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([
            AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        ], completionHandler: nil)

        if captureSession.canAddOutput(self.photoOutput!) {
            captureSession.addOutput(self.photoOutput!)
        } else {
            failed()
            return
        }
        print("added photo output")

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        print("added previewLayer")

        captureSession.startRunning()
        print("started session")
        view.backgroundColor = UIColor.green
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
        view.backgroundColor = UIColor.red
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            print("running stopped capture")
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("stopping capture session")
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        print("capture session stopped")
    }

    func captureImage() {
        let settings = AVCapturePhotoSettings()

        //self.photoCaptureCompletionBlock = completion
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            self.captureDelegate?.photoCaptureCompletion(nil, error)
        } else if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            self.captureDelegate?.photoCaptureCompletion(image, nil)
        } else {
            self.captureDelegate?.photoCaptureCompletion(nil, nil)
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if scanning {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }
        }
    }

    func found(code: String) {
        self.scanDelegate?.codeDidFind(code)
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
            //fatalError("Missing expected back camera device.")
            return nil
        }
    }
}
