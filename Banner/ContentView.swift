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
    
    var body: some View {
        ZStack {
            GeometryReader { outerView in
                HStack(spacing: 0) {
                    ForEach(images.indices, id: \.self) { index in
                        GeometryReader { innerView in
                            CardView(
                                image: images[index].image,
                                imageName: images[index].imageName
                            ) {
                                // 删除回调
                                withAnimation {
                                    images.remove(at: index)
                                    currentIndex = max(0, min(currentIndex, images.count - 1))
                                }
                            }
                            .opacity(self.currentIndex == index ? 1.0 : 0.75)
                        }
                        .frame(width: outerView.size.width)
                    }
                }
                .frame(width: outerView.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * outerView.size.width)
                .offset(x: self.dragOffset)
                .gesture(
                    DragGesture()
                        .updating(self.$dragOffset, body: { value, state, _ in
                            state = value.translation.width
                        })
                        .onEnded { value in
                            let threshold = outerView.size.width * 0.3
                            var newIndex = Int(-value.translation.width / threshold) + self.currentIndex
                            newIndex = min(max(newIndex, 0), images.count - 1)
                            withAnimation {
                                self.currentIndex = newIndex
                            }
                        }
                )
            }

            VStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(images.indices, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.blue : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentIndex)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .frame(height: 200)
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
