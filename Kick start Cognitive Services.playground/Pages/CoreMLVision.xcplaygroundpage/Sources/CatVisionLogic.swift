import Foundation
import Vision
import UIKit

public class CatVisionLogic : NSObject {
    
    var classificationRequest: [VNRequest]? = nil
    var textLabel : UILabel? = nil
    
    public func initRequest(label: UILabel?) {
        do {
            textLabel = label
            // Load the Custom Vision model.
            // To add a new model, drag it to the Xcode project browser making sure that the "Target Membership" is checked.
            // Then update the following line with the name of your new model.
            let model = try VNCoreMLModel(for: catmoodprediction().model)
            let request = VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
            classificationRequest = [ request ]
        } catch {
            fatalError("Can't load Vision ML model: \(error)")
        }
    }
    
    public func doClassification (image: UIImage) {
        do {
            let pixelBuffer = image.pixelBuffer(width: 227, height:227)
            let classifierRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer!, options: [:])
            try classifierRequestHandler.perform(classificationRequest!)
        } catch {
            print(error)
        }
    }
    
    public func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation]
            else { fatalError("unexpected result type from VNCoreMLRequest") }
        
        guard let best = observations.first else {
            fatalError("classification didn't return any results")
        }
        
        DispatchQueue.main.async {
            if let classifierLabel = self.textLabel {
                if best.identifier.starts(with: "Unknown") || best.confidence < 0.50 {
                    classifierLabel.text = "Mhm, no cat or absolutely not sure about it's mood"
                }
                else {
                    classifierLabel.text = "This cat seem to be in a \(best.identifier) mood (\(best.confidence) sure)"
                }
            }
        }
    }


}
