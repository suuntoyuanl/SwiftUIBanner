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
    @State private var isShowDetailView = false
    
    var body: some View {
        ZStack {
            GeometryReader { outerView in
                HStack(spacing: 0) { // 设置 Banner 之间的间隙
                    ForEach(imageModels.indices, id: \.self) { index in
                        GeometryReader { innerView in
                            CardView(image: imageModels[index].image, imageName: imageModels[index].imageName)
                                // 透明度效果
//                                .opacity(self.currentIndex == index ? 1.0 : 0.7)
                        }
                        .frame(width: outerView.size.width) // 每个 Banner 占屏幕宽度的 75%
                        .onTapGesture {
//                            self.isShowDetailView = true
                        }
                    }
                }
                .padding(.horizontal, 0) // 确保左右边的部分 Banner 可见
                .frame(width: outerView.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * (outerView.size.width)) // 根据索引偏移
                .offset(x: self.dragOffset) // 拖动偏移
                .gesture(
                    !self.isShowDetailView ?
                    DragGesture()
                        .updating(self.$dragOffset, body: { value, state, _ in
                            state = value.translation.width
                        })
                        .onEnded { value in
                            let threshold = outerView.size.width * 0.4
                            var newIndex = Int(-value.translation.width / threshold) + self.currentIndex
                            newIndex = min(max(newIndex, 0), imageModels.count - 1)
                            self.currentIndex = newIndex
                        }
                    : nil
                )
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3), value: dragOffset)
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
    var body: some View {
        
        ZStack {
            
            GeometryReader { geometry in
                
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                    .overlay(
                        Text(imageName)
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(10)
                            .background(Color.white)
                            .padding([.bottom, .leading])
                            .opacity(1.0)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                    )
            }
        }
    }
}


#Preview {
    ContentView()
}
