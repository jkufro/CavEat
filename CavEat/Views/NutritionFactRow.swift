//
//  NutritionFactRow.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct NutritionFactRow: View {
    var nutritionFact: NutritionFact

    var body: some View {
        ResultRow(
            title: nutritionFact.name,
            isWarning: nutritionFact.isWarning(),
            subtitle: nutritionFact.measurement(),
            description: nutritionFact.getDescription(),
            source: nutritionFact.source
        )
    }
}

struct NutritionFactRow_Previews: PreviewProvider {
    static var previews: some View {
        NutritionFactRow(nutritionFact: NutritionFact(apiId: "2", name: "Dietary Fiber", description: "Helps digestions and prevent constipation, and helps control your weight by making you feel full faster. You should get enough fiber, but adding too much too quickly can lead to gas, bloating, and cramps.", source: "https://medlineplus.gov/dietaryfiber.html", amount: 3, unit: "g", isLimiting: false))
    }
}
