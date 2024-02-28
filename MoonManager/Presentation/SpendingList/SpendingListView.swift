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
    
    @State var isEditSpending: Bool = false
    @State var showAlertRemoveSpending: Bool = false
    
    @State var selectedSpending: Spending? = nil
    
    var partyID: String = ""
    
    init(viewModel: SpendingListViewModel, id: String) {
        self.viewModel = viewModel
//        self.viewModel.action(.onAppear)
        self.partyID = id
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack {
                        VStack(alignment: .center) {
                            Text("SPEDING LIST")
                                .font(.system(size: 34))
                                .fontWeight(.black)
                        }
                        
                        ScrollView(showsIndicators: false) {
                            LazyVStack {
                                ForEach(viewModel.spendings) { spending in
                                    VStack {
                                        VStack(alignment: .leading, spacing: 0) {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                LazyHStack(spacing: 10) {
                                                    VStack {
                                                        HStack(alignment: .center, spacing: 2) {
                                                            Circle()
                                                                .frame(width: 5, height: 5)
                                                                .foregroundStyle(.cyan)
                                                            
                                                            Text(spending.manager.name)
                                                                .font(.system(size: 10))
                                                        }
                                                    }
                                                    
                                                    Divider()
                                                    
                                                    ForEach(spending.members) { member in
                                                        if member.id != spending.manager.id {
                                                            VStack {
                                                                HStack(alignment: .center, spacing: 2) {
                                                                    Text(member.name)
                                                                        .font(.system(size: 10))
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.bottom, 10)
                                            
                                            HStack(alignment: .bottom) {
                                                Text(spending.title)
                                                
                                                Spacer()
                                                
                                                Text("\(spending.cost)원")
                                                    .font(.system(size: 24))
                                                    .fontWeight(.bold)
                                            }
                                            .padding(.bottom, 10)
                                            
                                            Divider()
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(10)
                                    .onTapGesture {
                                        isEditSpending.toggle()
                                        selectedSpending = spending
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .confirmationDialog("Spending", isPresented: $isEditSpending, titleVisibility: .visible) {
                    Button(role: .none) {
                        print("### Spending 수정")
                        isEditSpending.toggle()
                    } label: {
                        Text("수정")
                    }
                    
                    Button(role: .destructive) {
                        print("### Spending 삭제")
                        showAlertRemoveSpending.toggle()
                    } label: {
                        Text("삭제")
                    }
                }
//                } message: {
//                    Text("편집")
//                }
                .alert(
                    Text("삭제하시곘습니까?"),
                    isPresented: $showAlertRemoveSpending
                ) {
                    Button(role: .cancel) {
                        print("### 삭제 취소")
                        selectedSpending = nil
                    } label: {
                        Text("취소")
                    }
                    
                    Button(role: .destructive) {
                        print("### 삭제")
                        if let spending = selectedSpending {
                            viewModel.action(.removeSpending(partyID: partyID, spending: spending))
                            selectedSpending = nil
                        }
                    } label: {
                        Text("삭제")
                    }
                }
            }
        }
        .padding(0.1)
        .onAppear {
            viewModel.action(.onAppear(partyID))
        }
    }
}
