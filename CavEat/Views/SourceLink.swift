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

    var parsedURL: URL? {
        if let url = self.url {
            if let urlObject = URL(string: url) {
                if UIApplication.shared.canOpenURL(urlObject) {
                    return urlObject
                }
            }
        }
        return nil
    }

    var body: some View {
        HStack {
            if parsedURL != nil {
                Text("Source")
                .multilineTextAlignment(.leading)
                .foregroundColor(.blue)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            UIApplication.shared.open(self.parsedURL!)
                        }
                )
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
