//
//  AddSpendingView.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 2/22/24.
//

import SwiftUI

struct AddSpendingView: View {
    @EnvironmentObject var viewModel: PartyViewModel
    @Binding var addSpending: Bool
    
    @State var spendingTitle: String = ""
    @State var spendingCost: String = ""
    @State var spendingManager: Member
    @State var excludeList: [Member] = []
    
    @State var showAlertIsEmpty: Bool = false
    
    let amountList: [Int] = [100000, 50000, 10000, 1000]
    
    init(
        spendingManager: Member,
        addSpending: Binding<Bool>
    ) {
        self.spendingManager = spendingManager
        _addSpending = addSpending
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                VStack(alignment: .center) {
                    Text("ADD SPENDING")
                        .font(.system(size: 24))
                        .fontWeight(.black)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("지출 내역")
                        .font(.system(size: 13))
                    
                    TextField(text: $spendingTitle) {
                        Text("지출의 명칭을 입력해 주세요")
                            .font(.system(size: 14))
                    }
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 1)
                    )
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("지출 금액")
                        .font(.system(size: 13))
                    
                    HStack {
                        Spacer()
                        
                        ForEach(amountList, id: \.self) { amount in
                            Button {
                                let costValue = (Int(spendingCost) ?? 0) + amount
                                spendingCost = "\(costValue)"
                            } label: {
                                Text("+\(amount)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white)
                                    .padding(5)
                            }
                            .buttonStyle(.plain)
                            .background(.black)
                        }
                    }
                    
                    VStack(spacing: 5) {
                        HStack(alignment: .bottom, spacing: 5) {
                            TextField(text: $spendingCost) {
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
                            .foregroundStyle(.gray)
                            .frame(height: 1)
                    }
                    .frame(height: 40)
                }
                
                HStack(alignment: .bottom, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Manager")
                            .font(.system(size: 11))
                        
                        Menu {
                            Picker(selection: $spendingManager) {
                                if let party = viewModel.party {
                                    ForEach(party.members) { member in
                                        Text(member.name)
                                            .tag(member)
                                    }
                                }
                            } label: {
                            }
                            .onChange(of: spendingManager) { member in
                                excludeList.removeAll()
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.cyan)
                                    .frame(width: 17, height: 17)
                                
                                Text(spendingManager.name)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                    .bold()
                                    .padding(.vertical, 4)
                            }
                        }
                        .frame(height: 40)
                    }
                    
                    Divider()
                        .frame(height: 40)
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Member")
                            .font(.system(size: 11))
                        
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
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                        }
                                        .buttonStyle(.plain)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(excludeList.contains(where: { $0.id == member.id }) ? .white : .black, lineWidth: 1)
                                        )
                                        .padding(.horizontal, 2)
                                    }
                                }
                            }
                            
                        }
                        .frame(height: 40)
                    }
                }
                
                HStack {
                    Button {
                        print("addSpending")
                        addSpending.toggle()
                    } label: {
                        Text("취소")
                            .foregroundStyle(.black)
                            .frame(width: 100, height: 40)
                    }
                    .buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 2)
                    )
                    
                    Button {
                        print("addSpending")
                        if !spendingTitle.isEmpty, Int(spendingCost) ?? 0 > 0 {
                            addSpending.toggle()
                            viewModel.action(.addSpending(title: spendingTitle, cost: Int(spendingCost) ?? 0, manager: spendingManager, excludeMembers: excludeList))
                        } else {
                            print("showAlertIsEmpty")
                            showAlertIsEmpty.toggle()
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
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .alert(isPresented: $showAlertIsEmpty) {
                Alert(title: Text("값을 모두 채워주세요!"))
            }
            
            Spacer()
        }
        .padding(0.1)
        .presentationDetents([.medium])
    }
}
