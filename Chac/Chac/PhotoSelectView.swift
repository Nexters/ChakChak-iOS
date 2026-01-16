//
//  PhotoSelectView.swift
//  Chac
//
//  Created by 가은 on 1/15/26.
//

import SwiftUI

struct PhotoSelectView: View {
    @State private var moveToNextView = false
    
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
                    Text("전체 선택")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray)
                        )
                }
                .foregroundStyle(.gray)

            }
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(0..<tempCount) { index in
                        photo()
                    }
                }
            }
            .padding(.bottom, 64)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .overlay(alignment: .bottom) {
            Button {
                moveToNextView = true
            } label: {
                Text("사진을 선택해주세요")
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
        .navigationTitle("사진 선택")
        .fullScreenCover(isPresented: $moveToNextView) {
            PhotoSaveView()
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
