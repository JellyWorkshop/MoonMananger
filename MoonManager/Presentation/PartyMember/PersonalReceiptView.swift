//
//  PersonalReceiptView.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 2/16/24.
//

import SwiftUI
import Photos

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
                                    .frame(width: 100, alignment: .trailing)
                            }
                            
                            HStack(alignment: .top, spacing: 2) {
//                                Text(spending.manager.name)
//                                    .font(.system(size: 10))
//                                    .foregroundStyle(.gray)
//                                
//                                Circle()
//                                    .frame(width: 3, height: 3)
//                                    .foregroundStyle(viewModel.member.id != spending.manager.id ? .cyan : .white)
                                
                                Spacer()
                                
                                let eachCost = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                                Text("\(eachCost)원")
                                    .font(.system(size: 14))
                                    .frame(width: 100, alignment: .trailing)
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
                                            Text("보내주세요💎")
                                        } else {
                                            Spacer()
                                            
                                            HStack(spacing: 0) {
                                                Text("\(info.member.name)")
                                                    .fontWeight(.bold)
                                                Text("님께")
                                            }
                                            
                                            Text("\(info.cost)원")
                                                .fontWeight(.bold)
                                            Text("받으세요💎")
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
                                                Text("보내주세요💎")
                                            } else {
                                                Spacer()
                                                
                                                HStack(spacing: 0) {
                                                    Text("\(receipt.manager.name)")
                                                        .fontWeight(.bold)
                                                    Text("님께")
                                                }
                                                
                                                Text("\(abs(info.cost))원")
                                                    .fontWeight(.bold)
                                                Text("받으세요💎")
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
