//
//  NutritionFactsList.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct NutritionFactsList: View {
    var nutritionFacts: [NutritionFact]
    var body: some View {
        List(nutritionFacts) { nutritionFact in
            NutritionFactRow(nutritionFact: nutritionFact)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct NutritionFactsList_Previews: PreviewProvider {
    static var previews: some View {
        NutritionFactsList(nutritionFacts: [
            NutritionFact(id: "1",
                          name: "Cholesterol",
                          description: "Needed for the body in moderate amounts. Excess consumption is known to lead to plaque buildup in arteries. This may lead to coronary artery disease, heart attack, or stroke.",
                          source: "https://medlineplus.gov/cholesterol.html",
                          amount: 5.2,
                          unit: "mg",
                          isLimiting: true),
             NutritionFact(id: "2",
                           name: "Dietary Fiber",
                           description: "Helps digestions and prevent constipation, and helps control your weight by making you feel full faster. You should get enough fiber, but adding too much too quickly can lead to gas, bloating, and cramps.",
                           source: "https://medlineplus.gov/dietaryfiber.html",
                           amount: 3,
                           unit: "g",
                           isLimiting: false),
             NutritionFact(id: "3",
                           name: "Energy",
                           description: nil,
                           source: nil,
                           amount: 0,
                           unit: "kcal",
                           isLimiting: false)
        ])
    }
}
