//
//  Result.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct Result: View {
    @Binding var showFood: Bool
    @ObservedObject var resultVM: ResultViewModel
    let dismissCallback: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        self.showFood.toggle()
                        self.dismissCallback()
                    },
                    label: {
                        Text(resultVM.food.createdAt == nil ? "Discard" : "Close").padding()
                    }
                )
                Spacer()
                if resultVM.food.createdAt == nil {
                    Button(
                        action: { self.showFood =  !DataManager.shared.saveFood(food: self.resultVM.food) },
                        label: { Text("Save").padding() }
                    )
                }
            }
            HStack {
                TextField(
                    resultVM.food.name,
                    text: $resultVM.food.name,
                    onEditingChanged: { isEditing in
                        print("FOOD NAME: \(self.resultVM.food.name)")
                        if !isEditing {
                            if self.resultVM.food.createdAt != nil {
                                DataManager.shared.saveFood(food: self.resultVM.food)
                            }
                        }
                    },
                    onCommit: {}
                )
                .foregroundColor(.primary)
                .font(.largeTitle)
                .multilineTextAlignment(.leading)
                  .padding(.leading)
                Spacer()
            }
            FoodList(food: resultVM.food)
        }
    }
}

struct Result_Previews: PreviewProvider {
    static var previews: some View {
        Result(showFood: .constant(true), resultVM: ResultViewModel(
            food:
                Food(
                  apiId: "1",
                    upc: 1234567890,
                    name: "My Food",
                    ingredients: [
                        Ingredient(
                            apiId: "123",
                            name: "Milk",
                            composition: nil,
                            description: nil,
                            source: nil,
                            isWarning: false
                        )
                    ],
                    nutritionFacts: [
                        NutritionFact(
                            apiId: "1",
                            name: "Cholesterol",
                            description: "Needed for the body in moderate amounts. Excess consumption is known to lead to plaque buildup in arteries. This may lead to coronary artery disease, heart attack, or stroke.",
                            source: "https://medlineplus.gov/cholesterol.html",
                            amount: 5.2,
                            unit: "mg",
                            isLimiting: true),
                        NutritionFact(
                            apiId: "2",
                            name: "Dietary Fiber",
                            description: "Helps digestions and prevent constipation, and helps control your weight by making you feel full faster. You should get enough fiber, but adding too much too quickly can lead to gas, bloating, and cramps.",
                            source: "https://medlineplus.gov/dietaryfiber.html",
                            amount: 3,
                            unit: "g",
                            isLimiting: false),
                        NutritionFact(
                            apiId: "3",
                            name: "Energy",
                            description: nil,
                            source: nil,
                            amount: 0,
                            unit: "kcal",
                            isLimiting: false)
                    ]
                )
            ),
            dismissCallback: {}
        )
    }
}
