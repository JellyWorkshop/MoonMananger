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
        self.viewModel.action(.onAppear)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    var party = Party(DTO: Mock.party1)
                    party.id = UUID().uuidString
                    viewModel.partyList.append(party)
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
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fill)
                        .background {
                            if let image = info.image, image != "" {
                                Image(image)
                                    .resizable()
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundStyle(.white)
                                            .opacity(0.6)
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.gray)
                            }
                        }
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
                        var party = Party(DTO: Mock.party1)
                        party.id = UUID().uuidString
                        viewModel.partyList.append(party)
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
