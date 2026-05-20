//
//  ResultView.swift
//  PoC_OneShotObjectDetector
//
//  Created by Putra Ganda Dewata on 20/05/26.
//

import SwiftUI
import UIKit

struct ResultView: View {
    @Binding var imageData: Data?

    private let detector = ObjectDetectorUtils()
    @State private var detectedObjects: [DetectedObject] = []

    var body: some View {
        ZStack {
            if let data = imageData, let uiImage = UIImage(data: data) {
                GeometryReader { geo in
                    ZStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()

                        // Overlay detections
                        ForEach(detectedObjects) { obj in
                            let rect = convertBoundingBox(obj.boundingBox, in: geo.size)

                            ZStack(alignment: .topLeading) {
                                Rectangle()
                                    .stroke(Color.yellow, lineWidth: 2)
                                    .background(Color.yellow.opacity(0.2))
                                    .frame(width: rect.width, height: rect.height)
                                    .position(x: rect.midX, y: rect.midY)

                                Text("\(obj.label) \(Int(obj.confidence * 100))%")
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.black.opacity(0.7))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .offset(x: rect.minX, y: rect.minY - 22)
                            }
                        }
                    }
                }
            } else {
                Text("No image")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Detections")
        .onAppear {
            _ = detector.setUpVision()
            detector.onDetections = { objects in
                self.detectedObjects = objects
            }

            // detect object on init since image is passed
            if let data = imageData {
                detector.detectObjects(imageData: data)
            }
        }
        .onChange(of: imageData) { _, newValue in
            // just incase if onappear late to trigger detect object
            if let data = newValue {
                detector.detectObjects(imageData: data)
            } else {
                detectedObjects = []
            }
        }
    }

    private func convertBoundingBox(_ boundingBox: CGRect, in size: CGSize) -> CGRect {
        let w = boundingBox.width * size.width
        let h = boundingBox.height * size.height
        let x = boundingBox.minX * size.width
        let y = (1 - boundingBox.minY - boundingBox.height) * size.height
        return CGRect(x: x, y: y, width: w, height: h)
    }
}

#Preview {
//    ResultView(imageData: .constant(nil))
}
