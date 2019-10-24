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
        VStack {
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
                .padding(.leading)
                Spacer()
            }
            .padding(.bottom)

            Text(nutritionFact.getDescription())
                .font(.body)
        }

    }
}

struct NutritionFactRow_Previews: PreviewProvider {
    static var previews: some View {
        NutritionFactRow(nutritionFact: NutritionFact(id: "1", name: "Cholesterol", description: "Needed for the body in moderate amounts. Excess consumption is known to lead to plaque buildup in arteries. This may lead to coronary artery disease, heart attack, or stroke.", source: "https://medlineplus.gov/cholesterol.html", amount: 5.2, unit: "mg"))
    }
}
