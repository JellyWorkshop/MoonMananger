//
//  PartyView.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI

struct PartyView: View {
    @ObservedObject var viewModel: PartyViewModel
    
    @State var addFloating: Bool = false
    @State var addSpending: Bool = false
    @State var updateSpending: Bool = false
    @State var addMember: Bool = false
    @State var checkReceipt: Bool = false
    @State var title: String = ""
    @State var cost: String = ""
    @State var memberName: String = ""
    
    let amountList: [Int] = [100000, 50000, 10000, 1000]
    @State var excludeList: [Member] = []
    
    var partyID: String = ""
    
    var memberColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
    
    init(viewModel: PartyViewModel, id: String) {
        self.viewModel = viewModel
        self.viewModel.action(.onAppear)
        self.partyID = id
        print(id)
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack {
                            VStack(alignment: .trailing, spacing: 2) {
                                HStack(spacing: 10) {
                                    Button {
                                        viewModel.action(.showSpendingList(id: partyID))
                                    } label: {
                                        Image(systemName: "list.bullet")
                                            .padding(10)
                                            .foregroundStyle(.white)
                                    }
                                    .buttonStyle(.plain)
                                    .frame(width: 35, height: 35)
                                    .shadow(radius: 2)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("\(viewModel.party?.members.count ?? 0)")
                                            .font(.system(size: 16))
                                            .padding(5)
                                    }
                                    .background(
                                        Capsule()
                                            .foregroundStyle(.cyan)
                                    )
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text(viewModel.party?.name ?? "")
                                        .font(.system(size: 46))
                                    
                                    Spacer()
                                }
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                        }
                        .background {
                            if let image = viewModel.party?.image, image != "" {
                                Image(image)
                                    .resizable()
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .aspectRatio(1.4, contentMode: .fill)
                        
                        LazyVGrid(columns: memberColumns, spacing: 16) {
                            ForEach(viewModel.party?.members ?? []) { info in
                                VStack(spacing: 5) {
                                    HStack {
                                        Circle()
                                            .frame(width: 10, height: 10)
                                            .foregroundStyle(.cyan)
                                            .shadow(radius: 2)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text(info.name)
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fill)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.cyan, lineWidth: 2)
                                )
                                .padding(1)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(.white)
                                        .opacity(0.1)
                                )
                                .onTapGesture {
                                    viewModel.action(.showMember(id: info.id))
                                }
                            }
                            
                            VStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fill)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .padding(1)
                            .onTapGesture {
                                viewModel.party?.members.append(Member(id: UUID().uuidString, name: "어피치"))
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(0.1)
            .sheet(isPresented: $addSpending) {
                VStack {
                    VStack(spacing: 20) {
                        Circle()
                            .foregroundStyle(.yellow)
                            .frame(width: 12, height: 12)
                            .padding(.bottom, 20)
                            .shadow(radius: 6)
                        
                        Divider()
                        
                        TextField(text: $title) {
                            Text("사용처를 입력해주세요")
                        }
                        .multilineTextAlignment(.center)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.yellow, lineWidth: 2)
                        )
                        
                        HStack {
                            Spacer()
                            
                            ForEach(amountList, id: \.self) { amount in
                                Button {
                                    let costValue = (Int(cost) ?? 0) + amount
                                    cost = "\(costValue)"
                                } label: {
                                    Text("+\(amount)")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.white)
                                        .padding(5)
                                }
                                .buttonStyle(.plain)
                                .background(.yellow)
                            }
                        }
                        
                        VStack(spacing: 5) {
                            HStack(alignment: .bottom, spacing: 5) {
                                TextField(text: $cost) {
                                    Text("0")
                                }
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                
                                Text("원")
                                    .padding(.bottom, 4)
                            }
                            
                            Rectangle()
                                .foregroundStyle(.yellow)
                                .frame(height: 2)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("참여자")
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(viewModel.party?.members ?? []) { member in
                                        VStack {
                                            Button {
                                                if excludeList.contains(where: { $0.id == member.id }) {
                                                    excludeList = excludeList.filter({ $0.id != member.id })
                                                } else {
                                                    guard let members = viewModel.party?.members, (members.count-1) > excludeList.count else {
                                                        return
                                                    }
                                                    excludeList.append(member)
                                                }
                                            } label: {
                                                Text(member.name)
                                                    .font(.system(size: 12))
                                                    .padding(.vertical, 2)
                                                    .padding(.horizontal, 10)
                                            }
                                            .buttonStyle(.plain)
                                            .background(
                                                Capsule()
                                                    .foregroundStyle(excludeList.contains(where: { $0.id == member.id }) ? .red : .yellow)
                                            )
                                        }
                                    }
                                }
                                .frame(height: 20)
                            }
                        }
                        
                        HStack {
                            Button {
                                print("addSpending")
                                addSpending.toggle()
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.yellow)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.yellow, lineWidth: 2)
                            )
                            
                            Button {
                                print("addSpending")
                                addSpending.toggle()
                            } label: {
                                Text("추가")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.yellow)
                            )
                        }
                        .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(0.1)
                .presentationDetents([.medium])
            }

            VStack(alignment: .trailing) {
                Spacer()
                
                HStack(alignment: .bottom) {
                    Spacer()
                    
                    VStack(alignment: .center) {
                        if addFloating {
                            Button {
                                print("floating button")
                                checkReceipt.toggle()
                            } label: {
                                Image(systemName: "doc.text")
                                    .padding(10)
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .background(
                                Circle()
                                    .foregroundStyle(.yellow)
                            )
                            .frame(width: 35, height: 35)
                            .shadow(radius: 2)
                            
                            Button {
                                print("floating button")
                                addMember.toggle()
                            } label: {
                                Image(systemName: "person")
                                    .padding(10)
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .background(
                                Circle()
                                    .foregroundStyle(.yellow)
                            )
                            .frame(width: 35, height: 35)
                            .shadow(radius: 2)
                            
                            Button {
                                print("floating button")
                                excludeList.removeAll()
                                title = ""
                                cost = ""
                                addSpending.toggle()
                            } label: {
                                Image(systemName: "wonsign")
                                    .padding(10)
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .background(
                                Circle()
                                    .foregroundStyle(.yellow)
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
                                .foregroundStyle(.yellow)
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
            
//            if addSpending {
//                VStack {
//                    VStack(spacing: 20) {
//                        Circle()
//                            .foregroundStyle(.yellow)
//                            .frame(width: 12, height: 12)
//                            .padding(.bottom, 20)
//                            .shadow(radius: 8)
//                        
//                        Divider()
//                        
//                        TextField(text: $title) {
//                            Text("사용처를 입력해주세요")
//                        }
//                        .multilineTextAlignment(.center)
//                        .padding(5)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(.yellow, lineWidth: 2)
//                        )
//                        
//                        HStack {
//                            Spacer()
//                            
//                            ForEach(amountList, id: \.self) { amount in
//                                Button {
//                                    let costValue = (Int(cost) ?? 0) + amount
//                                    cost = "\(costValue)"
//                                } label: {
//                                    Text("+\(amount)")
//                                        .font(.system(size: 12))
//                                        .foregroundStyle(.white)
//                                        .padding(5)
//                                }
//                                .buttonStyle(.plain)
//                                .background(.yellow)
//                            }
//                        }
//                        
//                        VStack(spacing: 5) {
//                            HStack(alignment: .bottom, spacing: 5) {
//                                TextField(text: $cost) {
//                                    Text("0")
//                                }
//                                .multilineTextAlignment(.trailing)
//                                .keyboardType(.numberPad)
//                                .font(.system(size: 24))
//                                .fontWeight(.bold)
//                                
//                                Text("원")
//                                    .padding(.bottom, 4)
//                            }
//                            
//                            Rectangle()
//                                .foregroundStyle(.yellow)
//                                .frame(height: 2)
//                        }
//                        
//                        VStack(alignment: .leading) {
//                            Text("참여자")
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                LazyHStack {
//                                    ForEach(viewModel.party?.members ?? []) { member in
//                                        VStack {
//                                            Button {
//                                                if excludeList.contains(where: { $0.id == member.id }) {
//                                                    excludeList = excludeList.filter({ $0.id != member.id })
//                                                } else {
//                                                    guard let members = viewModel.party?.members, (members.count-1) > excludeList.count else {
//                                                        return
//                                                    }
//                                                    excludeList.append(member)
//                                                }
//                                            } label: {
//                                                Text(member.name)
//                                                    .font(.system(size: 12))
//                                                    .padding(.vertical, 2)
//                                                    .padding(.horizontal, 5)
//                                            }
//                                            .buttonStyle(.plain)
//                                            .background(
//                                                Capsule()
//                                                    .foregroundStyle(excludeList.contains(where: { $0.id == member.id }) ? .red : .yellow)
//                                            )
//                                        }
//                                    }
//                                }
//                                .frame(height: 20)
//                            }
//                        }
//                        
//                        HStack {
//                            Button {
//                                print("addSpending")
//                                addSpending.toggle()
//                            } label: {
//                                Text("취소")
//                                    .foregroundStyle(.yellow)
//                                    .frame(maxWidth: .infinity, maxHeight: 40)
//                            }
//                            .buttonStyle(.plain)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(.yellow, lineWidth: 2)
//                            )
//                            
//                            Button {
//                                print("addSpending")
//                                addSpending.toggle()
//                            } label: {
//                                Text("추가")
//                                    .foregroundStyle(.white)
//                                    .frame(maxWidth: .infinity, maxHeight: 40)
//                            }
//                            .buttonStyle(.plain)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .foregroundStyle(.yellow)
//                            )
//                        }
//                        .padding(.vertical, 10)
//                    }
//                    .padding(20)
//                    .frame(maxWidth: 300, maxHeight: 400)
//                    .background(
//                        RoundedRectangle(cornerRadius: 16)
//                            .foregroundStyle(.white)
//                    )
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                }
//                .shadow(radius: 2)
//                .padding(0.1)
//            }
            
            if addMember {
                VStack {
                    VStack(spacing: 20) {
                        Circle()
                            .foregroundStyle(.yellow)
                            .frame(width: 12, height: 12)
                            .padding(.bottom, 20)
                            .shadow(radius: 8)
                        
                        Divider()
                        
                        Text("New Member")
                        
                        TextField(text: $memberName) {
                            Text("이름")
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.yellow, lineWidth: 2)
                        )
                        
                        HStack {
                            Button {
                                print("addSpending")
                                addMember.toggle()
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.yellow)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.yellow, lineWidth: 2)
                            )
                            
                            
                            Button {
                                print("member name save")
                                if !memberName.isEmpty {
                                    viewModel.party?.members.append(Member(id: UUID().uuidString, name: "\(memberName)"))
                                    addMember.toggle()
                                    memberName = ""
                                }
                            } label: {
                                Text("저장")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.yellow)
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
                    VStack(spacing: 20) {
                        Circle()
                            .foregroundStyle(.yellow)
                            .frame(width: 12, height: 12)
                            .padding(.bottom, 20)
                            .shadow(radius: 8)
                        
                        Divider()
                        
                        Text("Receipt")
                        
                        ScrollView(showsIndicators: false) {
                            VStack {
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
                                }
                            }
                        }
                        .frame(maxHeight: 350)
                        
                        
                        HStack {
                            Text("총 합계 : ")
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("\(viewModel.totalCost)원")
                                .fontWeight(.bold)
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
    }
    
    func deleteSpending(at offsets: IndexSet) {
        print("deleteSpending")
    }
}
