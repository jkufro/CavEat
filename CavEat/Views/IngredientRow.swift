//
//  IngredientRow.swift
//  CavEat
//
//  Created by John Kim on 10/29/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.

import SwiftUI

struct IngredientRow: View {
    var ingredient: Ingredient

    var body: some View {
        ResultRow(
            title: ingredient.name,
            isWarning: ingredient.isWarning,
            subtitle: ingredient.composition,
            description: ingredient.getDescription(),
            source: ingredient.source
        )
    }
}

struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        IngredientRow(ingredient: Ingredient(id: "2", name: "Whole Wheat", composition: "moisture (14%), protein (9-14%), fat (1-2%), carbohydrates (54-62%), fiber (1.7-2.6%) and ash (1.2-1.7%)",
          description: "made of ground entire wheat kernels.",
          source: "https://bakerpedia.com/ingredients/whole-wheat-flour/", isWarning: false))
    }
}
