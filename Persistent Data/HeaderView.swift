//
//  HeaderView.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            Color.white.shadow(color: Color.black.opacity(0.2), radius: 2, x: 0.0, y: 2.0)
            VStack {
                Spacer()
                Text("Logo")
                Text("Event Bridge")
                    .font(.caption)
                    .padding(.bottom)
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
