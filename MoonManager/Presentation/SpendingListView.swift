//
//  SpendingListView.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 1/12/24.
//

import SwiftUI

struct SpendingListView: View {
    @ObservedObject var viewModel: SpendingListViewModel
    
    init(viewModel: SpendingListViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onAppear)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
