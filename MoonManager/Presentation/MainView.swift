//
//  ContentView.swift
//  MoonManager
//
//  Created by cschoi on 12/28/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var partyColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 2)
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onApear)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.partyList.append(Party(DTO: Mock
                        .party1))
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.black)
                }

                Spacer()
            }
            .padding(.vertical, 10)
            
            ScrollView {
                LazyVGrid(columns: partyColumns, spacing: 16) {
                    ForEach(viewModel.partyList) { info in
                        VStack {
                            Text(info.name)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fill)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.gray)
                        )
                        .onTapGesture {
                            viewModel.action(.showParty(id: info.id))
                        }
                    }
                    
                    VStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(1)
                    .onTapGesture {
                        viewModel.partyList.append(Party(DTO: Mock.party1))
                    }
                }
            }
            
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(0.1)
        .onAppear {
            print("hi")
        }
        
    }
}
