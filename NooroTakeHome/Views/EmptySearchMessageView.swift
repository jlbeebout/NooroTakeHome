//
//  EmptySearchMessageView.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//
import SwiftUI

struct EmptySearchMessageView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("No City Selected")
                .poppins(.semiBold, size: 30)
                .foregroundColor(Color.darkText)
                .lineSpacing(45 - 30)
                .multilineTextAlignment(.center)

            Text("Please Search For A City")
                .poppins(.semiBold, size: 15)
                .foregroundColor(.darkText)
                .lineSpacing(22.5 - 15)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
