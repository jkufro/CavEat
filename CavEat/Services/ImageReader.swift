//
//  ImageReader.swift
//  CavEat
//
//  Created by Justin Kufro on 10/27/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import SwiftUI
import VisionKit
import Vision

protocol ImageReaderProtocol {
    // true => recognition request initiated
    // false => recognition request could not be initiated
    func imageToText(image: UIImage, _ completion: @escaping (String) -> Void) -> Bool
}

class ImageReader: ImageReaderProtocol {
    func imageToText(image: UIImage, _ completion: @escaping (String) -> Void) -> Bool {
        // UIImageWriteToSavedPhotosAlbum(convertToGrayScale(image: image), nil, nil, nil)
        guard let cgImage = convertToGrayScale(image: image).cgImage else {
            print("Failed to get cgimage from input image")
            return false
        }

        let textRecognitionRequest = getRequest(completion)

        // https://developer.apple.com/documentation/imageio/cgimagepropertyorientation
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
            return true
        } catch {
            print(error)
            return false
        }
    }

    private func getRequest(_ completion: @escaping (String) -> Void) -> VNRecognizeTextRequest {
        let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, _) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    completion(self.getRecognizedText(requestResults))
                    return
                }
            }
            completion("")
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        return textRecognitionRequest
    }

    private func getRecognizedText(_ recognizedText: [VNRecognizedTextObservation]) -> String {
        var result: String = ""
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            result += candidate.string
            result += "\n"
        }
        print(result)
        return result
    }

    // https://stackoverflow.com/questions/22422480/apply-black-and-white-filter-to-uiimage
    private func convertToGrayScale(image: UIImage) -> UIImage {

        // Create image rectangle with current image width/height
        let imageRect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }
}
