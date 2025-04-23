//
//  Untitled.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 23/4/25.
//

import SwiftUI

public struct HeaderView: View {
    public var body: some View {
        HStack {
            Text("Welcome to My Library")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
    }
    
    public init() {}
}

public struct HeaderView_Previews: PreviewProvider {
    public static var previews: some View {
        HeaderView()
    }
}

