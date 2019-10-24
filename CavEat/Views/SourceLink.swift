//
//  SourceLink.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct SourceLink: View {
    var url: String?

    var body: some View {
        HStack {
            if url != nil {
                Text("Source")
                .foregroundColor(Color.blue)
                .multilineTextAlignment(.leading)
            }
            Spacer()
        }

    }
}

struct SourceLink_Previews: PreviewProvider {
    static var previews: some View {
        SourceLink(url: "http://www.google.com/")
    }
}
