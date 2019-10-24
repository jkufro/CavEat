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
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(nutritionFact.name)
                            .font(.body)
                        if nutritionFact.isWarning() {
                            Image(systemName: "exclamationmark.circle.fill")
                            .imageScale(.medium)
                            .foregroundColor(Color.red)
                        }
                    }
                    Text(nutritionFact.measurement())
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                }

                Spacer()
            }
            .padding(.bottom)

            Text(nutritionFact.getDescription())
                .font(.body)
                .padding(.bottom)
                .lineLimit(nil)
            SourceLink(url: nutritionFact.source)
        }.padding(.leading)

    }
}

struct NutritionFactRow_Previews: PreviewProvider {
    static var previews: some View {
        NutritionFactRow(nutritionFact: NutritionFact(id: "2", name: "Dietary Fiber", description: "Helps digestions and prevent constipation, and helps control your weight by making you feel full faster. You should get enough fiber, but adding too much too quickly can lead to gas, bloating, and cramps.", source: "https://medlineplus.gov/dietaryfiber.html", amount: 3, unit: "g"))
    }
}
