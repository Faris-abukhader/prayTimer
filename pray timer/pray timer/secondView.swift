//
//  secondView.swift
//  pray timer
//
//  Created by admin on 2021/8/9.
//

import SwiftUI

struct secondView: View {
    @Environment(\.presentationMode) var dis
    var body: some View {
        Button(action: {dis.wrappedValue.dismiss()}, label: {Text("Go back")})
    }
}

struct secondView_Previews: PreviewProvider {
    static var previews: some View {
        secondView()
    }
}
