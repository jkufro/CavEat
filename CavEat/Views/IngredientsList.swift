//
//  IngredientList.swift
//  CavEat
//
//  Created by John Kim on 10/29/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct IngredientsList: View {
    var ingredients: [Ingredient]
    var body: some View {
        List(ingredients) { ingredient in
            IngredientRow(ingredient: ingredient)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct IngredientList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsList(ingredients: [
            Ingredient(id: "2", name: "Whole Wheat", composition: "moisture (14%), protein (9-14%), fat (1-2%), carbohydrates (54-62%), fiber (1.7-2.6%) and ash (1.2-1.7%)",
            description: "made of ground entire wheat kernels.",
            source: "https://bakerpedia.com/ingredients/whole-wheat-flour/", isWarning: false)
        ])
    }
}
