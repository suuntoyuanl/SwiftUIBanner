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
                HStack(spacing: 20) { // 设置 Banner 之间的间隙
                    ForEach(imageModels.indices, id: \.self) { index in
                        GeometryReader { innerView in
                            CardView(image: imageModels[index].image, imageName: imageModels[index].imageName)
                            
                                // 如果点击，图片向上移动
                                .offset(y: self.isShowDetailView ? -innerView.size.height * 0.3 : 0)
                                // 缩放效果
                                .scaleEffect(self.currentIndex == index ? 1.0 : 0.9)
                                // 透明度效果
                                .opacity(self.currentIndex == index ? 1.0 : 0.7)
                        }
                        .frame(width: outerView.size.width * 0.75) // 每个 Banner 占屏幕宽度的 75%
                        .onTapGesture {
                            self.isShowDetailView = true
                        }
                    }
                }
                .padding(.horizontal, (outerView.size.width - outerView.size.width * 0.75) / 2) // 确保左右边的部分 Banner 可见
                .frame(width: outerView.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * (outerView.size.width * 0.75 + 20)) // 根据索引偏移
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
            
            // 详情页
            if self.isShowDetailView {
                DetailView(imageName: imageModels[currentIndex].imageName)
                    .offset(y: 200)
                    .transition(.move(edge: .bottom))
                
                // 关闭按钮
                Button(action: {
                    self.isShowDetailView = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .contentShape(Rectangle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
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
    var body: some View {
        
        ZStack {
            
            GeometryReader { geometry in
                
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .cornerRadius(15)
                
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



struct DetailView: View {
    
    let imageName: String
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    
                    // 图片名称
                    Text(self.imageName)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.heavy)
                        .padding(.bottom, 30)
                    
                    // 描述文字
                    Text("要想在一个生活圈中生活下去，或者融入职场的氛围，首先你要学习这个圈子的文化和发展史，并尝试用这个圈子里面的“话术”和他们交流，这样才能顺利地融入这个圈子。")
                        .padding(.bottom, 40)
                    
                    // 按钮
                    Button(action: {
                        
                    }) {
                        
                        Text("知道了")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                .background(Color.white)
                .cornerRadius(15)
            }
        }
    }
}
