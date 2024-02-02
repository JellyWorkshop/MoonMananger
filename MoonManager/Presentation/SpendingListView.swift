//
//  SpendingListView.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 1/12/24.
//

import SwiftUI

enum Privacy: String, Identifiable, CaseIterable {
    case open = "Open"
    case closed = "Closed"
    var id: String { self.rawValue }
}

struct SpendingListView: View {
    @ObservedObject var viewModel: SpendingListViewModel
    
    @State var isEditMember: Bool = false
    @State var isEditSpending: Bool = false
    
    init(viewModel: SpendingListViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onAppear)
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack {
                        HStack {
                            Text("Member")
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                if let party = viewModel.party {
                                    ForEach(party.members) { member in
                                        VStack {
                                            Text(member.name)
                                                .font(.system(size: 12))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                        }
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .foregroundStyle(.yellow)
                                        )
                                        .onTapGesture {
                                            isEditMember.toggle()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack {
                        HStack {
                            Text("Spending")
                            Spacer()
                        }
                        
                        ScrollView(showsIndicators: false) {
                            LazyVStack {
                                if let party = viewModel.party {
                                    ForEach(party.spendings) { spending in
                                        VStack {
                                            HStack {
                                                Text(spending.title)
                                                    .font(.system(size: 12))
                                                    .frame(alignment: .leading)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Spacer()
                                                
                                                Text("\(spending.cost)원")
                                                    .font(.system(size: 12))
                                                    .frame(width: 80, alignment: .trailing)
                                            }
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                LazyHStack {
                                                    HStack(alignment: .center, spacing: 2) {
                                                        Circle()
                                                            .frame(width: 5, height: 5)
                                                            .foregroundStyle(.cyan)
                                                        
                                                        Text(spending.manager.name)
                                                            .font(.system(size: 10))
                                                    }
                                                    
                                                    ForEach(spending.members) { member in
                                                        if member.id != spending.manager.id {
                                                            HStack(alignment: .center, spacing: 2) {
                                                                Circle()
                                                                    .frame(width: 5, height: 5)
                                                                    .foregroundStyle(.yellow)
                                                                
                                                                Text(member.name)
                                                                    .font(.system(size: 10))
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            Divider()
                                        }
                                        .onTapGesture {
                                            isEditSpending.toggle()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .confirmationDialog("Member", isPresented: $isEditMember, titleVisibility: .visible) {
                    Button(role: .none) {
                        print("###@@@")
                        isEditMember.toggle()
                    } label: {
                        Text("수정")
                    }
                    
                    Button(role: .destructive) {
                        print("###@@@")
                        isEditMember.toggle()
                    } label: {
                        Text("삭제")
                    }
                } message: {
                    Text("편집")
                }
                .confirmationDialog("Spending", isPresented: $isEditSpending, titleVisibility: .visible) {
                    Button(role: .none) {
                        print("###$$$")
                        isEditSpending.toggle()
                    } label: {
                        Text("수정")
                    }
                    
                    Button(role: .destructive) {
                        print("###@@@")
                        isEditSpending.toggle()
                    } label: {
                        Text("삭제")
                    }
                } message: {
                    Text("편집")
                }
            }
        }
        .padding(0.1)
    }
}
