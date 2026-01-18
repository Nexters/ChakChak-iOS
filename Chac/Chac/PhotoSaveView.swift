//
//  PhotoSaveView.swift
//  Chac
//
//  Created by 가은 on 1/15/26.
//

import SwiftUI

struct PhotoSaveView: View {
    
    private enum Strings {
        static let completeSave = "저장 완료"
        static let moveToGallery = "갤러리로"
        static let moveToPhotoList = "목록으로"
    }
    
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                    coordinator.popToRoot()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical, 14)
            
            Spacer()
            
            Image("")
                .frame(width: 128, height: 140)
                .background(.gray)
                .padding(20)
            
            Text(Strings.completeSave)
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            Text("총 00장의 사진이 포함된 앨범을 \n갤러리에 저장했어요!")
                .multilineTextAlignment(.center)
                .font(.system(size: 16))
                .foregroundStyle(.gray)
            
            Spacer()
            Spacer()
            
            HStack(spacing: 8) {
                
                moveButton(
                    title: Strings.moveToGallery,
                    backgroundColor: Color(uiColor: .lightGray)) {
                    
                }
                
                moveButton(
                    title: Strings.moveToPhotoList,
                    backgroundColor: .gray) {
                        dismiss()
                        coordinator.popToRoot()
                }
                
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func moveButton(title: String, backgroundColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
        }
    }
}

#Preview {
    PhotoSaveView()
}
