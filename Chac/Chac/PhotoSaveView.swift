//
//  PhotoSaveView.swift
//  Chac
//
//  Created by 가은 on 1/15/26.
//

import SwiftUI

struct PhotoSaveView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
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
            
            Text("저장 완료")
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
                    title: "갤러리로",
                    backgroundColor: Color(uiColor: .lightGray)) {
                    
                }
                
                moveButton(
                    title: "목록으로",
                    backgroundColor: .gray) {
                    
                }
                
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func moveButton(title: String, backgroundColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text("목록으로")
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
