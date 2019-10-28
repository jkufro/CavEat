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
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return false
        }

        let textRecognitionRequest = getRequest(completion)

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
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
        }
        return result
    }

}
