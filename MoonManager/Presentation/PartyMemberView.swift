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
    @State var checkReceipt: Bool = false
    @Namespace var name
        
    let segments: [String] = ["참여했어요", "결제했어요"]
    
    init(viewModel: PartyMemberViewModel) {
        self.viewModel = viewModel
        self.viewModel.action(.onAppear)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        Text(viewModel.member.name)
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
                    .onTapGesture {
                        print("receipt")
                        checkReceipt.toggle()
                    }
                }
                
                HStack(spacing: 40) {
                    ForEach(segments.indices, id: \.self) { index in
                        let title = segments[index]
                        Button {
                            currentTab = index
                        } label: {
                            VStack {
                                Text(title)
                                    .font(.system(size: 14))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .foregroundStyle(.gray)
                                    .background {
                                        if currentTab == index {
                                            Capsule()
                                                .foregroundStyle(.yellow)
                                                .matchedGeometryEffect(id: "tab", in: name)
                                        } else {
                                            Capsule()
                                                .foregroundStyle(.clear)
                                        }
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
                                VStack(alignment: .leading, spacing: 0) {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 10) {
                                            VStack {
//                                                Text(spending.manager.name)
//                                                    .font(.system(size: 8))
//                                                    .padding(.vertical, 2)
//                                                    .padding(.horizontal, 5)
//                                                    .background(
//                                                        Capsule()
//                                                            .foregroundStyle(.cyan)
//                                                    )
                                                
                                                HStack(alignment: .center, spacing: 2) {
                                                    Circle()
                                                        .frame(width: 5, height: 5)
                                                        .foregroundStyle(.cyan)
                                                    
                                                    Text(spending.manager.name)
                                                        .font(.system(size: 10))
                                                }
                                            }
                                            
                                            ForEach(spending.members) { member in
                                                if member.id != spending.manager.id {
                                                    VStack {
//                                                        Text(member.name)
//                                                            .font(.system(size: 8))
//                                                            .padding(.vertical, 2)
//                                                            .padding(.horizontal, 5)
//                                                            .background(
//                                                                Capsule()
//                                                                    .foregroundStyle(.yellow)
//                                                            )
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
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        let eachCost = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                                        Text("\(eachCost)원")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(height: 14)
                                    
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
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.white)
                            )
                            .padding(1)
                        }
                    }
                }
                
                Spacer()
            }
            
            if checkReceipt {
                VStack {
                    VStack(spacing: 20) {
                        Circle()
                            .foregroundStyle(.yellow)
                            .frame(width: 12, height: 12)
                            .padding(.bottom, 20)
                            .shadow(radius: 8)
                        
                        Divider()
                        
                        Text(viewModel.member.name)
                            .fontWeight(.bold)
                        
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(viewModel.spendingList) { spending in
                                    VStack(spacing: 8) {
                                        HStack(spacing: 2) {
                                            Text(spending.title)
                                                .font(.system(size: 12))
                                                .frame(alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text("(\(spending.members.count)명)")
                                                .font(.system(size: 10))
                                                .foregroundStyle(.gray)
                                                .frame(alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                            
                                            Text("\(spending.cost)원")
                                                .font(.system(size: 10))
                                                .foregroundStyle(.gray)
                                                .frame(width: 80, alignment: .trailing)
                                        }
                                        
                                        HStack(alignment: .top, spacing: 2) {
                                            Text(spending.manager.name)
                                                .font(.system(size: 10))
                                                .foregroundStyle(.gray)
                                            
                                            Circle()
                                                .frame(width: 3, height: 3)
                                                .foregroundStyle(viewModel.member.id != spending.manager.id ? .cyan : .white)
                                            
                                            Spacer()
                                            
                                            let eachCost = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                                            Text("\(eachCost)원")
                                                .font(.system(size: 14))
                                                .frame(width: 80, alignment: .trailing)
                                        }
                                        
                                        Divider()
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            HStack {
                                Text("총 합계 : ")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("\(viewModel.totalSpending)원")
                                    .fontWeight(.bold)
                            }
                            
                            Text("\(viewModel.member.name)님!")
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                            ForEach(viewModel.totalSpendingList) { totalSpending in
                                HStack(alignment: .center) {
                                    Text("\(totalSpending.manager.name)님께 \(totalSpending.cost)원")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.gray)
                                }
                            }
                            Text("송금해 주세요~")
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                        }
                        
                        Button {
                            print("member name save")
                            checkReceipt.toggle()
                        } label: {
                            Text("확인")
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.yellow)
                        )
                    }
                    .padding(20)
                    .frame(maxWidth: 300, maxHeight: 500)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.white)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .shadow(radius: 2)
                .padding(0.1)
            }
        }
        .padding(.horizontal, 20)
        .padding(0.1)

    }
}
