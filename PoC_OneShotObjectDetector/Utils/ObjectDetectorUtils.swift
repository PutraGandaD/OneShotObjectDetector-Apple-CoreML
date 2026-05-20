//
//  ObjectDetector.swift
//  PoC_OneShotObjectDetector
//
//  Created by Putra Ganda Dewata on 20/05/26.
//

import Vision
import AVFoundation
import Foundation
import UIKit

struct DetectedObject: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect
}

class ObjectDetectorUtils {
    private var requests = [VNRequest]()
    
    var onDetections: (([DetectedObject]) -> Void)? // callback for delivering detection result
    
    func setUpVision() -> NSError? {
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "ObjectDetectorModel", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL)) // load model
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                // handle the detection result (that's why it's called completion handler)
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    // draw vision request results to the UI
                    self.getDetectionResults(results)
                }
            })
            self.requests = [recognitions] // save the request to the array for usage in Request Handler
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func detectObjects(imageData: Data) {
        // define the image request handler that take imageData
        let imageRequestHandler = VNImageRequestHandler(data: imageData, options: [:])
        
        // and then do the request
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    func getDetectionResults(_ results: [VNRecognizedObjectObservation]) {
        // step 1 -> map the result to get the bounding box and confidence
        let detectedObjects = results.map { observation -> DetectedObject in
            let label = observation.labels.first?.identifier ?? "Unknown"
            let confidence = observation.confidence
            let boundingBox = observation.boundingBox
            
            return DetectedObject(
                label: label,
                confidence: confidence,
                boundingBox: boundingBox
            )
        }
        
        // then trigger the callback
        DispatchQueue.main.async {
            self.onDetections?(detectedObjects)
        }
    }
}
