//
//  ScanViewModel.swift
//  CavEat
//
//  Created by Justin Kufro on 10/27/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI
import Combine

enum ScanVMState {
    case upcScanning
    case nutritionFactScanning
    case ingredientScanning
}

protocol ScanViewModelProtocol {
    func scanCompletionHandler(_ upc: String)
    func captureCompletionHandler(_ image: UIImage?, _ error: Error?)

    func goToUpcScan()
    func goToFactsScan()
    func goToIngredientsScan()

    func acceptUpcAlert()
    func dismissUpcAlert()
    func dismissErrorAlert()

    func handleFoodResult(_ food: Food)
}

class ScanViewModel: ScanViewModelProtocol, ObservableObject {
    @Published var state: ScanVMState = .upcScanning
    @Published var waiting: Bool = false
    @Published var anyAlerts: Bool = false
    @Published var updateBool: Bool = false // hack for taking pictures. split from captureRequested so that view does not continually update when it is flipped back to false
    @Published var showFood: Bool = false

    let apiClient = APIClient()
    let imageReader: ImageReader = ImageReader()

    var food: Food = Food(id: "", upc: 0, name: "Blank Food", ingredients: [], nutritionFacts: [])
    var upc: String?
    var nutritionFactsImage: UIImage?
    var ingredientsImage: UIImage?
    var errorMessage: String = ""
    var promptForManualDecision: Bool = false
    var errorNeedsAttention: Bool = false
    var captureRequested: Bool = false

    func scanCompletionHandler(_ upc: String) {
        if !showFood && self.state == .upcScanning && !promptForManualDecision {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            print("got UPC code")
            self.upc = upc
            self.nutritionFactsImage = nil
            self.ingredientsImage = nil
            DispatchQueue.main.async {
                self.waiting = true
                self.apiClient.findByUpc(upc: upc) { food in
                    self.waiting = false
                    if let food = food {
                        self.handleFoodResult(food)
                    } else { // will need to ask if user wants to manually scan
                        self.promptForManual()
                    }
                }
            }
        }
    }

    func captureCompletionHandler(_ image: UIImage?, _ error: Error?) {
        if self.ingredientsImage != nil { return }
        if let image = image {
            if self.state == .nutritionFactScanning {
                self.nutritionFactsImage = image
                goToIngredientsScan()
            } else if self.state == .ingredientScanning {
                self.ingredientsImage = image
                completeManualScan()
            }
        } else { // something went wrong
            print("got no image result for ingredients")
        }
    }

    func completeManualScan() {
        self.waiting = true
        guard let upc = self.upc else {
            goToUpcScan()
            return
        }
        guard let nutImg = self.nutritionFactsImage else {
            goToFactsScan()
            return
        }
        guard let ingImg = self.ingredientsImage else {
            goToIngredientsScan()
            return
        }

        var nutritionFactsString = ""
        var ingredientsString = ""

        DispatchQueue.main.async {
            let nutritionImgRequestSuccess = self.imageReader.imageToText(image: nutImg) { result in
                if !result.isEmpty { // valid string result
                    nutritionFactsString = result
                    let ingredientsImgRequestSuccess = self.imageReader.imageToText(image: ingImg) { result in
                        if !result.isEmpty { // valid string result
                            ingredientsString = result
                            self.apiClient.findByStrings(upc: upc, nutritionFacts: nutritionFactsString, ingredients: ingredientsString) { food in
                                self.waiting = false
                                if let food = food {
                                    self.handleFoodResult(food)
                                    self.goToUpcScan()
                                } else { // didnt get a food back
                                    self.setError("Did not get result back from server.")
                                }
                            }
                        } else {  // empty result returned for ingredients OCR
                            self.setError("Could not read the ingredients image for text.")
                        }
                    }
                    if !ingredientsImgRequestSuccess { // request to read ingredients image failed
                        self.setError("Request failed to read the ingredients image for text.")
                    }
                } else {  // empty result returned for nutrition facts OCR
                    self.setError("Could not read the nutrition facts image for text.")
                }
                self.waiting = false
            }
            if !nutritionImgRequestSuccess { // request to read ingredients image failed
                self.setError("Request failed to read the nutrition facts image for text.")
            }
        }
    }

    func goToUpcScan() {
        self.state = .upcScanning
        self.upc = nil
        self.nutritionFactsImage = nil
        self.ingredientsImage = nil
    }

    func goToFactsScan() {
        self.state = .nutritionFactScanning
        self.nutritionFactsImage = nil
        self.ingredientsImage = nil
    }

    func goToIngredientsScan() {
        self.state = .ingredientScanning
        self.ingredientsImage = nil
    }

    private func setError(_ errorMessage: String) {
        print(errorMessage)
        self.errorNeedsAttention = true
        self.anyAlerts = self.errorNeedsAttention || self.promptForManualDecision
        self.errorMessage = errorMessage
    }

    private func promptForManual() {
        self.promptForManualDecision = true
        self.anyAlerts = self.errorNeedsAttention || self.promptForManualDecision
    }

    func acceptUpcAlert() {
        self.promptForManualDecision = false
        self.goToFactsScan()
    }

    func dismissUpcAlert() {
        self.promptForManualDecision = false
        self.anyAlerts = self.errorNeedsAttention || self.promptForManualDecision
        self.goToUpcScan()
    }

    func dismissErrorAlert() {
        self.errorNeedsAttention = false
        self.anyAlerts = self.errorNeedsAttention || self.promptForManualDecision
        self.goToUpcScan()
    }

    func handleFoodResult(_ food: Food) {
        showFood = true
        self.food = food
    }
}
