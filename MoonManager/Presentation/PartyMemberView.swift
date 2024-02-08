//
//  PartyMemberView.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI
import Photos

struct PartyMemberView: View {
    @ObservedObject var viewModel: PartyMemberViewModel
    @State private var currentTab: Int = 0
    @State var checkReceipt: Bool = false
    @State var showSaveDone: Bool = false
    @Namespace var name
        
    let segments: [String] = ["참여했어요", "결제했어요"]
    
    @State var member: Member
    
    init(viewModel: PartyMemberViewModel, member: Member) {
        self.viewModel = viewModel
        self.member = member
//        self.viewModel.action(.onAppear(member: member))
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
                            Text("합계 : ")
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                            Text("\(viewModel.totalCost)원")
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
            .alert(isPresented: $showSaveDone) {
                Alert(title: Text("저장되었습니다."))
            }
            .onAppear {
                print("onAppear")
                self.viewModel.action(.onAppear(member: member))
            }
            
            if checkReceipt {
                VStack {
                    VStack(spacing: 0) {
                        VStack(spacing: 10) {
                            HStack(alignment: .center, spacing: 5) {
                                Circle()
                                    .foregroundStyle(.yellow)
                                    .frame(width: 8, height: 8)
                                
                                Text("Receipt")
                                
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
                                .foregroundStyle(.yellow)
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
                .shadow(radius: 2)
                .padding(0.1)
            }
        }
        .padding(.horizontal, 20)
        .padding(0.1)

    }
}

struct PersonalReceiptView: View {
    @EnvironmentObject var viewModel: PartyMemberViewModel
    @Binding var checkReceipt: Bool
    @Binding var showSaveDone: Bool
    
    @State var scrollHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("MOON MANAGER")
                                .font(.system(size: 24))
                                .fontWeight(.black)
                            
                            HStack(spacing: 5) {
                                Text(viewModel.party?.name ?? "")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                
                                Text(viewModel.member.name)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                            }
                            
                        }
                    }
                    .padding(.vertical, 30)
                    
                    ForEach(viewModel.spendingList) { spending in
                        VStack {
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
                    
                    HStack {
                        Text("합계 : ")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("\(viewModel.totalCost)원")
                            .fontWeight(.bold)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    if let receipt = viewModel.receipt {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(receipt.totalMember) { info in
                                if receipt.manager.id == viewModel.member.id {
                                    HStack(alignment: .center, spacing: 2) {
                                        if info.cost < 0 {
                                            Spacer()
                                            
                                            HStack(spacing: 0) {
                                                Text("\(info.member.name)")
                                                    .fontWeight(.bold)
                                                Text("님께")
                                            }
                                            
                                            Text("\(abs(info.cost))원")
                                                .fontWeight(.bold)
                                            Text("보내주세요💸")
                                        } else {
                                            Spacer()
                                            
                                            HStack(spacing: 0) {
                                                Text("\(info.member.name)")
                                                    .fontWeight(.bold)
                                                Text("님께")
                                            }
                                            
                                            Text("\(info.cost)원")
                                                .fontWeight(.bold)
                                            Text("받으세요💸")
                                        }
                                    }
                                    .font(.system(size: 12))
                                    .padding(.bottom, 5)
                                    
                                } else if info.member.id == viewModel.member.id {
                                    if info.cost != 0 {
                                        HStack(alignment: .center, spacing: 2) {
                                            if info.cost > 0 {
                                                Spacer()
                                                
                                                HStack(spacing: 0) {
                                                    Text("\(receipt.manager.name)")
                                                        .fontWeight(.bold)
                                                    Text("님께")
                                                }
                                                
                                                Text("\(info.cost)원")
                                                    .fontWeight(.bold)
                                                Text("보내주세요💸")
                                            } else {
                                                Spacer()
                                                
                                                HStack(spacing: 0) {
                                                    Text("\(receipt.manager.name)")
                                                        .fontWeight(.bold)
                                                    Text("님께")
                                                }
                                                
                                                Text("\(abs(info.cost))원")
                                                    .fontWeight(.bold)
                                                Text("받으세요💸")
                                            }
                                        }
                                        .font(.system(size: 12))
                                        .padding(.bottom, 5)
                                    }
                                }
                            }
                            
                            Text("*총무가 모든 금액을 받고 따로 결제한 건에 대해 다시 전달해줘요!")
                                .foregroundStyle(.gray)
                                .font(.system(size: 10))
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal, 20)
                .background(
                    GeometryReader { proxy in
                        Color.clear.onAppear {
                            scrollHeight = proxy.size.height
                        }
                    }
                )
                .onReceive(viewModel.$saveScreenshot) { isSave in
                    if isSave {
                        viewModel.saveScreenshot = false
                        screenShot()
                    }
                }
            }
        }
    }
    
    func screenShot() {
        let size = CGSize(width: UIScreen.main.bounds.size.width * 0.8, height: scrollHeight)
        let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: size)
            
        PHPhotoLibrary.requestAuthorization({ status in
            switch status {
            case .authorized:
                UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil)
                showSaveDone.toggle()
            case .denied:
                break
            case .restricted, .notDetermined:
                break
            default:
                break
            }
        })
    }
}
