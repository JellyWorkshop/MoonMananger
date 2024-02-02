//
//  PartyView.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI
import Photos

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
    @State var spendingManager: Member = Member()
    @State var showSaveDone: Bool = false
    
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
                                Menu {
                                    Picker(selection: $spendingManager.name) {
                                        if let party = viewModel.party {
                                            ForEach(party.members) { member in
                                                Text(member.name)
                                                    .tag(member.name)
                                            }
                                        }
                                    } label: {
                                    }
                                    .onChange(of: spendingManager) { member in
                                        excludeList.removeAll()
                                    }
                                } label: {
                                    VStack {
                                        Text(spendingManager.name)
                                            .font(.system(size: 14))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                    }
                                    .background(
                                        Capsule()
                                            .foregroundStyle(.cyan)
                                    )
                                    .padding(.bottom, 4)
                                }
                                
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
                        
                        HStack {
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
            .alert(isPresented: $showSaveDone) {
                Alert(title: Text("저장되었습니다."))
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
                                    .foregroundStyle(.yellow)
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
                                    .foregroundStyle(.yellow)
                            )
                            .frame(width: 35, height: 35)
                            .shadow(radius: 2)
                            
                            Button {
                                print("floating button")
                                excludeList.removeAll()
                                title = ""
                                cost = ""
                                addFloating.toggle()
                                if let party = viewModel.party, party.members.count > 0, let member = party.members.first {
                                    spendingManager = member
                                }
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
    }
    
    func deleteSpending(at offsets: IndexSet) {
        print("deleteSpending")
    }
}

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
                    
                    HStack {
                        Text("총 합계 : ")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("\(viewModel.totalCost)원")
                            .fontWeight(.bold)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    if let receipt = viewModel.receipt {
                        VStack {
                            ForEach(receipt.totalMember) { info in
                                if info.cost < 0 {
                                    Text("\(receipt.manager.name) -> \(info.member.name) : \(abs(info.cost))원")
                                } else {
                                    Text("\(info.member.name) -> \(receipt.manager.name) : \(info.cost)원")
                                }
                            }
                            .font(.system(size: 12))
                            
                            Text("*총무가 모든 금액을 받고 따로 결제한 건에 대해 다시 전달해줘요")
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

extension UIView {
    var screenShot: UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .high
        self.layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return capturedImage
    }
}

extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.screenShot
    }
}
