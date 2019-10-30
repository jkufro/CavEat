//
//  ResultRow.swift
//  CavEat
//
//  Created by Justin Kufro on 10/29/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct ResultRow: View {
    @State private var showDetail = false
    let title: String
    let isWarning: Bool
    let subtitle: String?
    let description: String
    let source: String?

    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            Button(
                action: {
                    //withAnimation {
                        self.showDetail.toggle()
                    //}
                },
                label: {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                if isWarning {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .imageScale(.medium)
                                        .foregroundColor(Color.red)
                                }
                            }
                            if subtitle != nil && subtitle != "" {
                                Text(subtitle!)
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.gray)
                            }
                        }

                        Spacer()
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                            .rotationEffect(.degrees(showDetail ? 90 : 0))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()

                    }
                    //.padding(.bottom)
                }
            )

            if showDetail {
                VStack(alignment: .leading) {
                    Text(description)
                        .font(.callout)
                        .padding(.bottom)
                        .lineLimit(nil)
                    SourceLink(url: source)
                }
            }
            //.animation(.linear)
        }.padding(.leading)
    }
}

struct ResultRow_Previews: PreviewProvider {
    static var previews: some View {
        ResultRow(title: "Milk", isWarning: true, subtitle: "(made of milk)", description: "Milk is a nutrient-rich, white liquid food produced by the mammary glands of mammals. It is the primary source of nutrition for infant mammals (including humans who are breastfed) before they are able to digest other types of food.", source: "https://www.google.com")
    }
}
