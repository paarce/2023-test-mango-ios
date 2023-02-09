//
//  InfoGenericView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 7/2/23.
//

import SwiftUI


struct LoadingGenericListView: View {
    var body: some View { Text("LOADING....") }
}

struct ErrorGenericListView: View {
    var body: some View { Text("ERROR....") }
}

struct InfoGenericView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingGenericListView()
        ErrorGenericListView()
    }
}
