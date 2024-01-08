//
//  PartyMemberView.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI

struct PartyMemberView: View {
    @ObservedObject var viewModel: PartyMemberViewModel
    @State private var currentTab: Int = 0
    @Namespace var name
    
    let segments: [String] = ["참여 금액", "결제한 금액"]
    
    init(viewModel: PartyMemberViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onApear)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text("이땡땡")
                        .font(.system(size: 15))
                    HStack {
                        Text("총 금액 : ")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                        Text("\(viewModel.totalSpending)원")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.yellow)
                    }
                }
                
                VStack {
                    Circle()
                        .foregroundStyle(.yellow)
                        .frame(width: 50, height: 50)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.cyan)
                                .shadow(radius: 2)
                        )
                }
                .padding(20)
            }
            
            HStack(spacing: 60) {
                ForEach(segments.indices, id: \.self) { index in
                    let title = segments[index]
                    Button {
                        currentTab = index
                    } label: {
                        VStack {
                            Text(title)
                            
                            if currentTab == index {
                                Color.black
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "tab", in: name)
                            } else {
                                Color.clear.frame(height: 2)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                let list = currentTab == 0 ? viewModel.spendingList : viewModel.paymentList
                LazyVStack {
                    ForEach(list) { spending in
                        VStack {
                            VStack(alignment: .leading) {
                                LazyHStack(spacing: 10) {
                                    ForEach(spending.members) { member in
                                        VStack {
                                            Text(member.name)
                                                .font(.system(size: 8))
                                                .padding(3)
                                                .background(
                                                    Capsule()
                                                        .foregroundStyle(.yellow)
                                                )
                                        }
                                    }
                                }
                                
                                HStack(alignment: .bottom) {
                                    Text(spending.title)
                                    
                                    Spacer()
                                    
                                    Text("\(spending.cost)원")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 10)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.yellow, lineWidth: 1)
                        )
                        .padding(1)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(0.1)

    }
}
