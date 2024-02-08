//
//  AddPartyView.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 1/26/24.
//

import SwiftUI
import Photos

struct AddPartyView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var titleText: String = ""
    @State var openPhoto: Bool = false
    @State private var mainImage: UIImage? = nil
    
    var colors: [Color] = [.black, .white]
    @State var selectedColor: Color = .black
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Image(uiImage: mainImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 200, height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, style: StrokeStyle(lineWidth: 5, dash: [5]))
                            .overlay(
                                VStack {
                                    Text(titleText)
                                        .font(.system(size: 16))
                                        .foregroundStyle(selectedColor)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                .padding(10)
                            )
                    )
                    .background {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray)
                            .frame(width: 20, height: 20)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture {
                        if mainImage == nil {
                            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                            switch status {
                            case .notDetermined: // 아직 권한 설정 X
                                PHPhotoLibrary.requestAuthorization { newStatus in
                                    switch newStatus {
                                    case .authorized, .limited: // 권한 승인, 제한된 권한 승인
                                        print("limited access granted")
                                        print("Access denied.")
                                        openPhoto.toggle()
                                    default:
                                        print("denied, .restricted")
                                    }
                                }
                            case .restricted, .denied: // 권한 거부
                                print("Access denied or restricted.")
                            case .authorized: // 권한 승인
                                print("Access already granted.")
                                openPhoto.toggle()
                            case .limited: // 제한된 권한 승인(선택 이미지)
                                print("Access limited.")
                                openPhoto.toggle()
                            @unknown default:
                                print("Unknown authorization status.")
                            }
                        }
                    }
                    .padding(20)
                
                if mainImage != nil {
                    VStack {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.white)
                                    .padding(5)
                            }
                            .background {
                                Circle()
                                    .foregroundStyle(.gray)
                            }
                            .shadow(radius: 2)
                            .onTapGesture {
                                if mainImage != nil {
                                    mainImage = nil
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(width: 220, height: 220)
                }
            }
            
            Text("어떤 모임인가요?")
            
            HStack {
                TextField(text: $titleText) {
                    Text("먹짱들 제주도 뿌셔뿌셔")
                }
                .multilineTextAlignment(.center)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.yellow, lineWidth: 2)
                )
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 7) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .foregroundStyle(color)
                                .frame(width: 25, height: 25)
                                .shadow(radius: 2)
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
                .frame(width: 60, height: 40)
            }
            
            Button {
                guard !titleText.isEmpty else {
                    print("XXX")
                    return
                }
                let id = UUID().uuidString
                let party = Party(id: id, name: titleText, members: [], spendings: [])
                if let image = mainImage {
                    ImageDataSource().saveImage(imageName: id, image: image)
                }
                viewModel.partyList.append(party)
//                viewModel.action(.createParty(party: party))
                dismiss()
            } label: {
                Text("추가")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .frame(height: 40)
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.yellow)
            )
        }
        .padding(20)
        .sheet(isPresented: $openPhoto) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $mainImage)
        }
    }
}
