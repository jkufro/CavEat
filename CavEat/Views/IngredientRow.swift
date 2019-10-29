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
      VStack(alignment: HorizontalAlignment.leading) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(ingredient.name)
                          .font(.title)
                        if ingredient.isWarning {
                            Image(systemName: "exclamationmark.circle.fill")
                            .imageScale(.medium)
                            .foregroundColor(Color.red)
                        }
                    }
                    Text(ingredient.composition!)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                }

                Spacer()
            }
            .padding(.bottom)

            Text(ingredient.getDescription())
                .font(.callout)
              .padding(.bottom)
                .lineLimit(nil)
            SourceLink(url: ingredient.source)
        }.padding(.leading)

    }
}

struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        IngredientRow(ingredient: Ingredient(id: "2", name: "Whole Wheat", composition: "moisture (14%), protein (9-14%), fat (1-2%), carbohydrates (54-62%), fiber (1.7-2.6%) and ash (1.2-1.7%)",
          description: "made of ground entire wheat kernels.",
          source: "https://bakerpedia.com/ingredients/whole-wheat-flour/", isWarning: false))
    }
}

