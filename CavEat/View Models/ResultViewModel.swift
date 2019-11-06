//
//  ResultViewModel.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

protocol ResultViewModelProtocol {
//    func saveFood(newName: String)
}

class ResultViewModel: ObservableObject, ResultViewModelProtocol {
    @Published var food: Food

    init(food: Food) {
        self.food = food
    }
}
