//
//  Navigation.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var selectedView = UserDefaults.standard.bool(forKey: "introAlreadyShown") ? 1 : 2
    // for demo purposes later we might just want to disable setting 'introAlreadyShown' to true below
    @State var showIntroSheet = !UserDefaults.standard.bool(forKey: "introAlreadyShown")

    var body: some View {
        TabView(selection: $selectedView) {
          if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
              SavedScans()
                  .tabItem {
                      Image(systemName: "rectangle.stack").imageScale(.large)
                        .rotationEffect(.degrees(-90))
                      Text("Saved Scans")
                  }.tag(0)
              Scan()
                  .edgesIgnoringSafeArea(.top)
                  .tabItem {
                      Image(systemName: "barcode.viewfinder").imageScale(.large)
                        .rotationEffect(.degrees(-90))
                      Text("Scan")
                  }.tag(1)
              DVSettings()
                  .tabItem {
                      Image(systemName: "gear").imageScale(.large)
                        .rotationEffect(.degrees(-90))
                      Text("DV Settings")
                  }.tag(2)
          }
          else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
              SavedScans()
                  .tabItem {
                      Image(systemName: "rectangle.stack").imageScale(.large)
                      .rotationEffect(.degrees(90))
                      Text("Saved Scans")
                  }.tag(0)
              Scan()
                  .edgesIgnoringSafeArea(.top)
                  .tabItem {
                      Image(systemName: "barcode.viewfinder").imageScale(.large)
                        .rotationEffect(.degrees(90))
                      Text("Scan")
                  }.tag(1)
              DVSettings()
                  .tabItem {
                      Image(systemName: "gear").imageScale(.large)
                        .rotationEffect(.degrees(90))
                      Text("DV Settings")
                  }.tag(2)
          }
          else{
              SavedScans()
                  .tabItem {
                      Image(systemName: "rectangle.stack").imageScale(.large)
                      Text("Saved Scans")
                  }.tag(0)
              Scan()
                  .edgesIgnoringSafeArea(.top)
                  .tabItem {
                      Image(systemName: "barcode.viewfinder").imageScale(.large)
                      Text("Scan")
                  }.tag(1)
              DVSettings()
                  .tabItem {
                      Image(systemName: "gear").imageScale(.large)
                      Text("DV Settings")
                  }.tag(2)
          }
        }
        .edgesIgnoringSafeArea(.top)
        .sheet(
            isPresented: $showIntroSheet,
            onDismiss: {
                //UserDefaults.standard.set(true, forKey: "introAlreadyShown")
                self.showIntroSheet = false
                self.selectedView = 1 // hack to reload the view so that scanning works after the modal is dismissed
            },
            content: {
                VStack {
                    HStack {
                        Button("Close") {
                            //UserDefaults.standard.set(true, forKey: "introAlreadyShown")
                            self.showIntroSheet = false
                            self.selectedView = 1
                        }
                        Spacer()
                    }
                    Text("CavEat")
                        .font(.title)
                        .padding(.bottom)
                    VStack(alignment: .leading) {
                        Text("Thank you for downloading CavEat!")
                            .padding(.bottom)
                        Text("CavEat (ca·ve·at) is designed to provide you with insights on food products that you are considering purchasing at the store.")
                            .padding(.bottom)
                        Text("When you scan an item you may receive opinionated information, insights, or warnings based on a product's nutrition facts and ingredients.")
                            .padding(.bottom)
                        Text("If we do not recognize a product's bar code you will still be able to receive your information! Simply follow the on-screen prompts to take pictures of the nutrition facts label and ingredients list.")
                            .padding(.bottom)
                    }
                    Spacer()
                }.padding()
            }
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
