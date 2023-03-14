//
//  ComicGridBlockItem.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 28/2/23.
//
import SwiftUI

@available(iOS 15.0, *)
struct ComicGridItemView: View {

    let color: Color = [.blue, .red, .cyan, .green, .indigo, .purple, .pink].randomElement()!
    @ObservedObject var comic: ComicGridModel
    @State var mult: CGFloat = 0
    @GestureState var press = false

    var body: some View {
        ZStack(alignment: .top) {

            if let image = comic.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: comic.size.width, maxHeight: comic.size.height)
                    .clipped()
                    .opacity(max(0.3, mult))
//                    .opacity(press ? 1 : 0.3)
//                    .scaleEffect(press ? 2 : 1)
//                    .animation(.spring(response: 0.4, dampingFraction: 0.6))
//                    .gesture(
//                        LongPressGesture(minimumDuration: 1)
//                            .updating($press) { currentState, gestureState, transaction in
//                                gestureState = currentState
//                            }
//                    )
            }

            Text(comic.title)
                .padding(10)
                .font(Font.system(size: 15, weight: .black))
//                .opacity(press ? 0 : 1)
                .opacity( 1 - mult)

        }
        .aspectRatio(comic.size, contentMode: .fill)
//        .onTapGesture {
//            withAnimation {
//                mult = 1
//            }
//        }
    }
}
