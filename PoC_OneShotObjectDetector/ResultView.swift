//
//  ResultView.swift
//  PoC_OneShotObjectDetector
//
//  Created by Putra Ganda Dewata on 20/05/26.
//

import SwiftUI

struct ResultView: View {
    @Binding var imageData: Data?
    
    var body: some View {
        ZStack {
            if let uiImage = UIImage(data: imageData!) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
//    ResultView()
}
