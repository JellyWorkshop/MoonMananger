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
    
    @State var isAddParty: Bool = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onAppear)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isAddParty.toggle()
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
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fill)
                        .background {
                            if let image = ImageDataSource().loadImage(imageName: info.id) {
                                Image(uiImage: image)
                                    .resizable()
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundStyle(.white)
                                            .opacity(0.5)
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
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $isAddParty, content: {
            AddPartyView()
                .environmentObject(viewModel)
                .presentationDetents([.medium])
        })
        .padding(.horizontal, 20)
        .padding(0.1)
        .onAppear {
            print("hi")
        }
        
    }
}
