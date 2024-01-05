//
//  ContentView.swift
//  MoonManager
//
//  Created by cschoi on 12/28/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onApear)
    }
    
    var body: some View {
        VStack {
            Color(.gray)
            Text("Main View~!")
        }
        .onAppear {
            print("hi")
        }
        
    }
}
