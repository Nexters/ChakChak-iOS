//
//  PhotoSelectView.swift
//  Chac
//
//  Created by 가은 on 1/15/26.
//

import SwiftUI

struct PhotoSelectView: View {
    
    private enum Strings {
        static let selectAll = "전체 선택"
        static let selectPhoto = "사진 선택"
        static let selectPhotoDescription = "사진을 선택해주세요"
    }
    
    @State private var moveToPhotoSaveView = false
    @State private var moveToPhotoDetailView = false
    
    private let tempCount = 40
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("서울 광진구광진구 광진구광진구광진구광진구")
                        .font(.title2)
                        .lineLimit(2)
                    
                    Text("0/\(tempCount) 선택")
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text(Strings.selectAll)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray)
                        )
                }
                .foregroundStyle(.gray)

            }
            .padding(.horizontal, 20)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(0..<tempCount) { index in
                        photo()
                            .onTapGesture {
                                // TODO: 사진 선택
                            }
                            .onLongPressGesture(minimumDuration: 0.3) {
                                print(#function, "\(index) long press")
                                moveToPhotoDetailView = true
                            }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Button {
                moveToPhotoSaveView = true
            } label: {
                Text(Strings.selectPhotoDescription)
                    .foregroundStyle(.black.opacity(0.7))
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.6))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.white)
            
        }
        .padding(.top, 12)
        .navigationTitle(Strings.selectPhoto)
        .fullScreenCover(isPresented: $moveToPhotoSaveView) {
            PhotoSaveView()
        }
        .fullScreenCover(isPresented: $moveToPhotoDetailView) {
            PhotoDetailView()
        }
    }
    
    @ViewBuilder
    private func photo() -> some View {
        Image("")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(.gray)
            )
            .overlay(alignment: .topTrailing) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
                    .padding(5)
            }
        
    }
}

#Preview {
    PhotoSelectView()
}
