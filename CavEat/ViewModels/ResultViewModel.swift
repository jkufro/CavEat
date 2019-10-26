//
//  ResultViewModel.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

protocol ResultViewModelProtocol {
    func renameFood(newName:String) -> Void
    func renameAndSaveFood(newName:String) -> Void
}

class ResultViewModel: ObservableObject, ResultViewModelProtocol {
    @Published var food: Food

    init(food:Food) {
        self.food = food
    }

    func renameFood(newName:String) {
        
    }

    func renameAndSaveFood(newName:String) {

    }
}
