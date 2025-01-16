//
//  ContentView.swift
//  Banner
//
//  Created by 袁量 on 2025/1/16.
//

import SwiftUI

struct BannerView: View {
    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var isShowDetailView = false
    @State private var images = imageModels
    
    var body: some View {
        ZStack {
            GeometryReader { outerView in
                HStack(spacing: 0) {
                    ForEach(images.indices, id: \.self) { index in
                        GeometryReader { innerView in
                            CardView(image: images[index].image, imageName: images[index].imageName, onDelete: {
                                print("@yl delette index \(index)-\(images[index].image)")
                                withAnimation {
                                    images.remove(at: index)
                                    currentIndex = max(0, min(currentIndex, images.count - 1))
                                }
                            })
                        }
                        .frame(width: outerView.size.width)
                        .onTapGesture {
                            print("@yl click index \(index)-\(images[index].image)")
                        }
                    }
                }
                .padding(.horizontal, 0)
                .frame(width: outerView.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * (outerView.size.width))
                .offset(x: self.dragOffset)
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
                    .overlay(
                        Text(imageName)
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(10)
                            .padding([.bottom, .leading])
                            .opacity(1.0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    )
                
                Button(action: {
                    onDelete()
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


#Preview {
    BannerView()
}
