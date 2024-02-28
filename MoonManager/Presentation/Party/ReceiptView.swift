//
//  ReceiptView.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 2/16/24.
//

import SwiftUI
import Photos

struct ReceiptView: View {
    @EnvironmentObject var viewModel: PartyViewModel
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
                            
                            Text(viewModel.party?.name ?? "")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.vertical, 30)
                    
                    ForEach(viewModel.party?.spendings ?? []) { spending in
                        VStack {
                            HStack {
                                Text(spending.title)
                                    .font(.system(size: 12))
                                    .frame(alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Text("\(spending.cost)원")
                                    .font(.system(size: 12))
                                    .frame(width: 100, alignment: .trailing)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    HStack(alignment: .center, spacing: 3) {
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
                                            HStack(alignment: .center, spacing: 2) {
                                                Text(member.name)
                                                    .font(.system(size: 10))
                                            }
                                        }
                                    }
                                }
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
                        VStack(alignment: .trailing, spacing: 5) {
                            ForEach(receipt.totalMember) { info in
                                if info.cost != 0 {
                                    VStack(alignment: .trailing, spacing: 2) {
                                        HStack(spacing: 0) {
                                            Spacer()
                                            
                                            Text("\(info.direction == .refund ? receipt.manager.name : info.member.name)")
                                                .fontWeight(.bold)
                                            Text("님!")
                                        }
                                        
                                        HStack(spacing: 10) {
                                            Text("\(info.direction == .refund ? info.member.name : receipt.manager.name)")
                                                .fontWeight(.bold)
                                            +
                                            Text("님께 ")
                                            +
                                            Text("\(abs(info.cost))원 ")
                                                .fontWeight(.bold)
                                            +
                                            Text("보내주세요💎")
                                        }
                                    }
                                }
                            }
                            .font(.system(size: 12))
                            .padding(.bottom, 5)
                            
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
