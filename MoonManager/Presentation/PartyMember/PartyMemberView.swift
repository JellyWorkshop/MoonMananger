//
//  PartyMemberView.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI

struct PartyMemberView: View {
    @StateObject var viewModel: PartyMemberViewModel
    @State private var currentTab: Int = 0
    @State var checkReceipt: Bool = false
    @State var showSaveDone: Bool = false
    @Namespace var tabAnimate
        
    let segments: [String] = ["참여했어요", "결제했어요"]
    
    var partyID: String = ""
    var memberID: String = ""
    
    init(viewModel: PartyMemberViewModel, partyID: String, memberID: String) {
        _viewModel = StateObject(wrappedValue: viewModel)
//        self.viewModel.action(.onAppear(member: member))
        self.partyID = partyID
        self.memberID = memberID
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack(alignment: .bottom, spacing: 5) {
                            Spacer()
                            
                            Text(viewModel.member.name)
                                .font(.system(size: 15))
                                .fontWeight(.black)
                            
                            Image(systemName: "doc.text")
                                .foregroundStyle(.black)
                                .onTapGesture {
                                    print("receipt")
                                    checkReceipt.toggle()
                                }
                        }
                        .frame(height: 20)
                        
                        HStack(alignment: .bottom) {
                            Text("합계 : ")
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .padding(.bottom, 2)
                            Text("\(viewModel.totalCost)원")
                                .font(.system(size: 24))
                                .fontWeight(.black)
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(20)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 2)
                )
                .padding(.bottom, 30)
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
//                        .foregroundStyle(.black)
//                        .opacity(0.04)
//                )
//                HStack(alignment: .center, spacing: 0) {
//                    VStack {
//                        Circle()
//                            .foregroundStyle(.white)
//                            .frame(width: 50, height: 50)
//                            .padding(10)
//                            .background(
//                                RoundedRectangle(cornerRadius: 5)
//                                    .foregroundStyle(.black)
//                                    .shadow(radius: 2)
//                            )
//                    }
//                    .padding(10)
//                    .onTapGesture {
//                        print("receipt")
//                        checkReceipt.toggle()
//                    }
//
//                    Spacer()
//                    
//                    VStack(alignment: .trailing, spacing: 10) {
//                        Text(viewModel.member.name)
//                            .font(.system(size: 15))
//                        
//                    }
//                    .padding(10)
//                }
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
//                        .foregroundStyle(.black)
//                        .opacity(0.04)
//                )
                
                HStack(spacing: 40) {
                    ForEach(segments.indices, id: \.self) { index in
                        let title = segments[index]
                        Button {
                            currentTab = index
                        } label: {
                            VStack {
                                if currentTab == index {
                                    Text(title)
                                        .font(.system(size: 14))
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 15)
                                        .foregroundStyle(.white)
                                        .background {
                                            Capsule()
                                                .foregroundStyle(.black)
                                                .matchedGeometryEffect(id: "tab", in: tabAnimate)
                                        }
                                } else {
                                    Text(title)
                                        .font(.system(size: 14))
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 15)
                                        .foregroundStyle(.black)
                                        .background {
                                            Capsule()
                                                .foregroundStyle(.clear)
                                        }
                                }
//
//                                Text(title)
//                                    .font(.system(size: 14))
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 15)
//                                    .foregroundStyle(.black)
//                                    .background {
//                                        if currentTab == index {
//                                            Capsule()
//                                                .foregroundStyle(.cyan)
//                                                .opacity(0.2)
//                                                .matchedGeometryEffect(id: "tab", in: tabAnimate)
//                                        } else {
//                                            Capsule()
//                                                .foregroundStyle(.clear)
//                                        }
//                                    }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
                
//                Divider()
//                    .padding(.bottom, 2)
//                    .padding(.horizontal, 20)
                
                let list = currentTab == 0 ? viewModel.spendingList : viewModel.paymentList
                if list.count > 0 {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 20) {
                            ForEach(list) { spending in
                                VStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack {
                                                HStack(alignment: .center, spacing: 2) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .resizable()
                                                        .foregroundStyle(.cyan)
                                                        .frame(width: 5, height: 5)
                                                    
                                                    Text(spending.manager.name)
                                                        .font(.system(size: 10))
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
                                        
//                                        Divider()
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(10)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 16)
//                                        .foregroundStyle(.black)
//                                        .opacity(0.04)
//                                )
                                .padding(1)
                            }
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        Text(currentTab == 0 ? "참여한 내역이 없어요!" : "결제한 내역이 없어요!")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 10)
                }
            }
            .padding(0.1)
            .onAppear {
                print("PartyMemberView onAppear")
                self.viewModel.action(.onAppear(partyID: partyID, memberID: memberID))
            }
            
            if checkReceipt {
                VStack {
                    VStack(spacing: 0) {
                        VStack(spacing: 10) {
                            HStack(alignment: .center, spacing: 5) {
                                Text("RECEIPT")
                                    .font(.system(size: 24))
                                    .fontWeight(.black)
                                
                                Spacer()
                                
                                Button {
                                    viewModel.saveScreenshot = true
                                } label: {
                                    Image(systemName: "arrow.down.app")
                                }
                                .buttonStyle(.plain)
                                .frame(width: 30, height: 30)
                            }
                            .frame(height: 30)
                            
                            Divider()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack {
                            PersonalReceiptView(checkReceipt: $checkReceipt, showSaveDone: $showSaveDone)
                                .environmentObject(viewModel)
                        }
                        .padding(.bottom, 10)
                                                
                        Button {
                            checkReceipt.toggle()
                        } label: {
                            Text("확인")
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        .frame(height: 40)
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.black)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: 300, maxHeight: 500)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.white)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .alert(isPresented: $showSaveDone) {
                    Alert(title: Text("저장되었습니다."))
                }
                .shadow(radius: 2)
                .padding(0.1)
            }
        }
        .padding(.horizontal, 20)
        .padding(0.1)

    }
}
