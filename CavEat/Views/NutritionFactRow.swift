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
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading) {
            Button(
                action: {
                    withAnimation {
                        self.showDetail.toggle()
                    }
                },
                label: {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(nutritionFact.name)
                                    .font(.title)
                                    .foregroundColor(.primary)
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
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                            .rotationEffect(.degrees(showDetail ? 90 : 0))
                            .padding()
                    }
                    .padding(.bottom)
                }
            )

            if showDetail {
                VStack(alignment: .leading) {
                    Text(nutritionFact.getDescription())
                        .font(.callout)
                        .padding(.bottom)
                        .fixedSize(horizontal: false, vertical: true)
                    SourceLink(url: nutritionFact.source)
                }
                .animation(.easeInOut)
            }
        }.padding(.leading)

    }
}

struct NutritionFactRow_Previews: PreviewProvider {
    static var previews: some View {
        NutritionFactRow(nutritionFact: NutritionFact(id: "2", name: "Dietary Fiber", description: "Helps digestions and prevent constipation, and helps control your weight by making you feel full faster. You should get enough fiber, but adding too much too quickly can lead to gas, bloating, and cramps.", source: "https://medlineplus.gov/dietaryfiber.html", amount: 3, unit: "g", isLimiting: false))
    }
}
