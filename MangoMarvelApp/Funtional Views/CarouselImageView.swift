//
//  CarouselImageView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 8/2/23.
//

import SwiftUI

struct CarouselImagesView<Item: View>: View {
    @State private var index = 0
    let height: CGFloat
    let items: [Item]

    init(height: CGFloat, items: [Item]) {
        self.height = height
        self.items = items
    }

    var body: some View {
        VStack{
            TabView(selection: $index) {
                ForEach((0..<items.count), id: \.self) { index in
                    items[index]
                        .frame(height: height)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .frame(height: height)
    }
}

struct CarouselImageView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselImagesView(height: 200, items: [
            Text("HOLA"), Text("Buenas tardes"), Text("Adios")
        ])
    }
}

struct CardView: View{
    var body: some View{
        Rectangle()
            .fill(Color.pink)
            .frame(height: 200)
            .border(Color.black)
            .padding()
    }
}
