//
//  PartyView.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI

struct PartyView: View {
    @ObservedObject var viewModel: PartyViewModel
    
    var memberColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
    
    init(viewModel: PartyViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onApear)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        VStack(alignment: .trailing, spacing: 2) {
                            HStack(spacing: 10) {
                                Spacer()
                                
                                VStack {
                                    Text("\(viewModel.party?.members.count ?? 0)")
                                        .font(.system(size: 16))
                                        .padding(5)
                                }
                                .background(
                                    Capsule()
                                        .foregroundStyle(.yellow)
                                )
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text(viewModel.party?.name ?? "")
                                    .font(.system(size: 46))
                                
                                Spacer()
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                    }
                    .background {
                        if let image = viewModel.party?.image, image != "" {
                            Image(image)
                                .resizable()
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.gray)
                        }
                    }
                    .aspectRatio(1, contentMode: .fill)
                    
                    LazyVGrid(columns: memberColumns, spacing: 16) {
                        ForEach(viewModel.party?.members ?? []) { info in
                            VStack(spacing: 5) {
                                HStack {
                                    Spacer()
                                    
                                    Text("⛄️")
                                        .padding(6)
                                        .background(.yellow)
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    
                                    Text(info.name)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fill)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue, lineWidth: 2)
                                    .foregroundStyle(.red)
                            )
                            .padding(1)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.gray)
                                    .opacity(0.1)
                            )
                            .onTapGesture {
                                viewModel.action(.showMember(id: info.id))
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
                            viewModel.party?.members.append(Member(id: UUID().uuidString, name: "유떙땡"))
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(0.1)
    }
}
