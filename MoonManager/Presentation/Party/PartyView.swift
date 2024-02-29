//
//  PartyView.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI

struct PartyView: View {
    @StateObject var viewModel: PartyViewModel
    
    @State var addFloating: Bool = false
    @State var addSpending: Bool = false
    @State var updateSpending: Bool = false
    @State var addMember: Bool = false
    @State var checkReceipt: Bool = false
    @State var memberName: String = ""
    @State var showSaveDone: Bool = false
    @State var showAlertAddMember: Bool = false
    @State var isEditMember: Bool = false
    @State var showAlertRemoveMember: Bool = false
    
    @State var selectedMember: Member = Member()
    
    var partyID: String = ""
    
    var memberColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
    
    init(viewModel: PartyViewModel, id: String) {
        _viewModel = StateObject(wrappedValue: viewModel)
//        self.viewModel.action(.onAppear(id: id))
        self.partyID = id
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(spacing: 25) {
                        VStack {
                            VStack(alignment: .trailing, spacing: 2) {
                                HStack(spacing: 10) {
                                    Button {
                                        viewModel.action(.showSpendingList(id: partyID))
                                    } label: {
                                        Image(systemName: "list.bullet")
                                            .padding(10)
                                            .foregroundStyle(.black)
                                    }
                                    .buttonStyle(.plain)
                                    .frame(width: 35, height: 35)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("\(viewModel.party?.members.count ?? 0)")
                                            .font(.system(size: 16))
                                            .padding(5)
                                    }
                                    .background(
                                        Capsule()
                                            .foregroundStyle(.black)
                                    )
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text(viewModel.party?.name ?? "")
                                        .font(.system(size: 46))
                                        .foregroundStyle(.black)
                                        .fontWeight(.black)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                        }
                        .background {
                            if let image = ImageDataSource().loadImage(imageName: viewModel.party?.id ?? "") {
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 1)
                        )
                        .aspectRatio(1.4, contentMode: .fill)
                        .padding(1)
                        
                        LazyVGrid(columns: memberColumns, spacing: 16) {
                            ForEach(viewModel.party?.members ?? []) { info in
                                VStack(spacing: 5) {
//                                    VStack(alignment: .trailing) {
//                                        HStack {
////                                            Circle()
////                                                .frame(width: 10, height: 10)
////                                                .foregroundStyle(.black)
//                                            
////                                            Image(systemName: "placeholdertext.fill")
////                                                .resizable()
////                                                .frame(width: 10, height: 10)
////                                                .foregroundStyle(.black)
////                                                .padding(2)
//                                            
//                                            Spacer()
//                                        }
//                                        
//                                        Spacer()
//                                        
//                                        Text(info.name)
//                                            .foregroundStyle(.white)
//                                            .font(.system(size: 20))
//                                            .fontWeight(.black)
//                                    }
                                    
                                    ZStack(alignment: .center) {
//                                        Circle()
//                                            .foregroundStyle(.cyan)
//                                            .opacity(0.3)
//                                            .frame(width: 45, height: 45)
////                                            .overlay {
////                                                Circle()
////                                                    .stroke(.cyan, lineWidth: 1)
////                                            }
//                                            .padding(.trailing, 35)
                                        
                                        Text(info.name)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.black)
                                            .fontWeight(.black)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fill)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 16)
//                                        .stroke(.black, lineWidth: 1)
//                                )
                                .padding(1)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(.black)
                                        .opacity(0.04)
                                )
                                .onTapGesture {
                                    viewModel.action(.showMember(member: info))
                                }
                                .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                                    print("### onLongPressGesture \(info.name)")
                                    selectedMember = info
                                    isEditMember.toggle()
                                })
                            }
                            
                            VStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.black)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fill)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color.black, lineWidth: 1)
//                            )
                            .padding(1)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.black)
                                    .opacity(0.04)
                            )
                            .onTapGesture {
                                print("addMember")
                                addMember.toggle()
                                addFloating = false
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(0.1)
            .sheet(isPresented: $addSpending) {
                if let members = viewModel.party?.members, !members.isEmpty, let manager = members.first {
                    AddSpendingView(spendingManager: manager, addSpending: $addSpending)
                        .environmentObject(viewModel)
                }
            }
            .confirmationDialog("Member", isPresented: $isEditMember, titleVisibility: .visible) {
                Button(role: .none) {
                    print("### Member 수정")
                    isEditMember.toggle()
                } label: {
                    Text("수정")
                }
                
                Button(role: .destructive) {
                    print("### Member 삭제")
                    showAlertRemoveMember.toggle()
                } label: {
                    Text("삭제")
                }
            }
//            } message: {
//                Text("")
//            }
            .alert(
                Text("삭제하시곘습니까?"),
                isPresented: $showAlertRemoveMember
            ) {
                Button(role: .cancel) {
                    print("### 삭제 취소")
                    selectedMember = Member()
                } label: {
                    Text("취소")
                }
                
                Button(role: .destructive) {
                    print("### 삭제")
                    viewModel.action(.removeMember(member: selectedMember))
                    selectedMember = Member()
                } label: {
                    Text("삭제")
                }
            }
            .onAppear {
                print("PartyView onAppear")
                self.viewModel.action(.onAppear(id: partyID))
            }

            VStack(alignment: .trailing) {
                Spacer()
                
                HStack(alignment: .bottom) {
                    Spacer()
                    
                    VStack(alignment: .center) {
                        if addFloating {
                            Button {
                                print("floating button")
                                addFloating.toggle()
                                checkReceipt.toggle()
                            } label: {
                                Image(systemName: "doc.text")
                                    .padding(10)
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .background(
                                Circle()
                                    .foregroundStyle(.black)
                            )
                            .frame(width: 35, height: 35)
                            .shadow(radius: 2)
                            
                            Button {
                                print("floating button")
                                addFloating.toggle()
                                addMember.toggle()
                            } label: {
                                Image(systemName: "person")
                                    .padding(10)
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .background(
                                Circle()
                                    .foregroundStyle(.black)
                            )
                            .frame(width: 35, height: 35)
                            .shadow(radius: 2)
                            
                            Button {
                                print("floating button")
                                if let members = viewModel.party?.members, !members.isEmpty {
                                    addSpending.toggle()
                                    addFloating.toggle()
                                } else {
                                    showAlertAddMember.toggle()
                                }
                            } label: {
                                Image(systemName: "wonsign")
                                    .padding(10)
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .background(
                                Circle()
                                    .foregroundStyle(.black)
                            )
                            .frame(width: 35, height: 35)
                            .shadow(radius: 2)
                        }
                        
                        Button {
                            print("floating button")
                            withAnimation(.smooth(duration: 0.5)) {
                                addFloating.toggle()
                            }
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .padding(15)
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .foregroundStyle(.black)
                        )
                        .shadow(radius: 2)
                        .rotation3DEffect(
                            addFloating ? Angle(degrees: 180) : .zero,
                            axis: (x: 0.0, y: 0.0, z: 1.0)
                        )
                    }
                }
            }
            .padding(20)
            .padding(0.1)
            
            if addMember {
                VStack {
                    VStack(spacing: 25) {
                        VStack(alignment: .center) {
                            Text("ADD MEMBER")
                                .font(.system(size: 24))
                                .fontWeight(.black)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("New member")
                                .font(.system(size: 13))
                            
                            TextField(text: $memberName) {
                                Text("새로운 멤버의 이름을 입력해 주세요")
                                    .font(.system(size: 14))
                            }
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.black, lineWidth: 1)
                            )
                        }
                        
                        HStack {
                            Button {
                                print("addMember")
                                addMember.toggle()
                                memberName = ""
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.black)
                                    .frame(width: 90, height: 40)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.black, lineWidth: 2)

                            )
                            
                            Button {
                                print("member name save")
                                if !memberName.isEmpty {
                                    viewModel.action(.addMember(name: memberName))
                                    addMember.toggle()
                                    memberName = ""
                                }
                            } label: {
                                Text("추가")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                            )
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: 300, maxHeight: 250)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.white)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .shadow(radius: 2)
                .padding(0.1)
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
                            ReceiptView(checkReceipt: $checkReceipt, showSaveDone: $showSaveDone)
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
    }
    
    func deleteSpending(at offsets: IndexSet) {
        print("deleteSpending")
    }
}
