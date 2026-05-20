//
//  ContentView.swift
//  PoC_OneShotObjectDetector
//
//  Created by Putra Ganda Dewata on 20/05/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showCamera: Bool = false
    @State private var hasPhoto: Bool = false
    @State private var imageData: Data? = nil
    @State private var showAccessError: Bool = false

    
    var body: some View {
        NavigationStack {
            CameraView(
                showCamera: $showCamera,
                showAccessError: $showAccessError,
                hasPhoto: $hasPhoto
            )
        }
    }
}

#Preview {
    ContentView()
}
