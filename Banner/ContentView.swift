//
//  ContentView.swift
//  Banner
//
//  Created by 袁量 on 2025/1/16.
//

import SwiftUI

struct ContentView: View {
    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var images = imageModels // 动态维护数据源
    @State private var finalOffset: CGFloat = 0 // 记录滚动的最终偏移量

    var body: some View {
        GeometryReader { outerView in
            VStack {
                // 滑动的图片部分
                HStack(spacing: 0) {
                    ForEach(images.indices, id: \.self) { index in
                        CardView(
                            image: images[index].image,
                            imageName: images[index].imageName,
                            onDelete: {
                                withAnimation {
                                    images.remove(at: index)
                                    currentIndex = max(0, min(currentIndex, images.count - 1))
                                }
                            }
                        )
                        .frame(width: outerView.size.width)
                    }
                }
                .offset(x: finalOffset + dragOffset) // 总偏移量
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            // 滑动结束后的逻辑
                            let threshold = outerView.size.width / 3 // 滑动触发的阈值
                            let cardWidth = outerView.size.width
                            let dragDistance = value.translation.width
                            
                            // 判断目标卡片索引
                            if dragDistance < -threshold {
                                currentIndex = min(currentIndex + 1, images.count - 1)
                            } else if dragDistance > threshold {
                                currentIndex = max(currentIndex - 1, 0)
                            }
                            
                            // 更新最终偏移量
                            withAnimation(.easeOut(duration: 0.3)) {
                                finalOffset = -CGFloat(currentIndex) * cardWidth
                            }
                        }
                )
                
                // 页码指示器
                HStack(spacing: 8) {
                    ForEach(images.indices, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.blue : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 16)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct CardView: View {
    let image: String
    let imageName: String
    let onDelete: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .overlay(
                        Text(imageName)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding([.bottom, .leading], 16)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    )
                
                Button(action: {
                    onDelete() // 调用删除回调
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topTrailing)
                .offset(x: -16, y: 16)
            }
        }
    }
}
