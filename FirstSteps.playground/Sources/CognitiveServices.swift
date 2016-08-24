//
//  CognitiveServices.swift
//  Social Tagger
//
//  Created by Alexander Repty on 16.05.16.
//  Copyright © 2016 maks apps. All rights reserved.
//

import Foundation
import UIKit

/// Result closure type for callbacks. The first parameter is an array of suitable tags for the image.
public typealias CognitiveServicesTagsResult = ([String]?, NSError?) -> (Void)

/// Fill in your API key here after getting it from https://www.microsoft.com/cognitive-services/en-US/subscriptions
let CognitiveServicesComputerVisionAPIKey = "7d6761012715472485d38ebef90a66ac"

/// Caseless enum of available HTTP methods.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesHTTPMethod {
    static let POST = "POST"
}

/// Caseless enum of available HTTP header keys.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesHTTPHeader {
    static let SubscriptionKey = "Ocp-Apim-Subscription-Key"
    static let ContentType = "Content-Type"
}

/// Caseless enum of available HTTP parameters.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesHTTPParameters {
    static let VisualFeatures = "visualFeatures"
    static let Details = "details"
}

/// Caseless enum of available HTTP content types.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesHTTPContentType {
    static let JSON = "application/json"
    static let OctetStream = "application/octet-stream"
    static let FormData = "multipart/form-data"
}

/// Caseless enum of available visual features to analyse the image for.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesVisualFeatures {
    static let Categories = "Categories"
    static let Tags = "Tags"
    static let Description = "Description"
    static let Faces = "Faces"
    static let ImageType = "ImageType"
    static let Color = "Color"
    static let Adult = "Adult"
}

/// Caseless enum of available JSON dictionary keys for the service's reply.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesKeys {
    static let Tags = "tags"
    static let Name = "name"
    static let Confidence = "confidence"
}

/// Caseless enum of various configuration parameters.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesConfiguration {
    static let AnalyzeURL = "https://api.projectoxford.ai/vision/v1.0/analyze"
    static let JPEGCompressionQuality = 0.9 as CGFloat
    static let RequiredConfidence = 0.85
}



public class CognitiveServices: NSObject {
    
    /**
     Retrieves a list of suitable tags for a given image from Microsoft's Cognitive Services API.
     
     - parameter image:      The image to analyse.
     - parameter completion: Callback closure.
     */
    public func retrievePlausibleTagsForImage(_ image: UIImage, _ suggestedConfidence: Double, completion: CognitiveServicesTagsResult) {
        assert(CognitiveServicesComputerVisionAPIKey.characters.count > 0, "Please set the value of the API key variable (CognitiveServicesVisualFeaturesAPIKey) before attempting to use the application.")
        
        print("i got a key - let's do this")
        
        // We need to specify that we want to retrieve tags for our image as a parameter to the URL.
        var urlString = CognitiveServicesConfiguration.AnalyzeURL
        urlString += "?\(CognitiveServicesHTTPParameters.VisualFeatures)=\("\(CognitiveServicesVisualFeatures.Tags)")"
        
        let url = URL(string: urlString)
        print("calling the following URL: \(url)")
        let request = NSMutableURLRequest(url: url!)
        
        // The subscription key is always added as an HTTP header field.
        request.addValue(CognitiveServicesComputerVisionAPIKey, forHTTPHeaderField: CognitiveServicesHTTPHeader.SubscriptionKey)
        // We need to specify that we're sending the image as binary data, since it's possible to supply a JSON-wrapped URL instead.
        request.addValue(CognitiveServicesHTTPContentType.OctetStream, forHTTPHeaderField: CognitiveServicesHTTPHeader.ContentType)
        
        // Convert the image reference to a JPEG binary to submit to the service. If this ends up being over 4 MB, it'll throw an error
        // on the server side. In a production environment, you would check for this condition and handle it gracefully (either reduce
        // the quality, resize the image or prompt the user to take an action).
        let requestData = UIImageJPEGRepresentation(image, CognitiveServicesConfiguration.JPEGCompressionQuality)
        request.httpBody = requestData
        request.httpMethod = CognitiveServicesHTTPMethod.POST
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("executed task")
            if let error = error {
                // In case of an error, handle it immediately and exit without doing anything else.
                completion(nil, error as NSError?)
                return
            }
            
            if let data = data {
                print("aaand got data! -> \(data)")
                do {
                    let collectionObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("the data: \(collectionObject)")
                    var result = [String]()
                    
                    if let dictionary = collectionObject as? Dictionary<String, AnyObject> {
                        // Enumerate through the result tags and find those with a high enough confidence rating, disregard the rest.
                        let tags = dictionary[CognitiveServicesKeys.Tags]
                        if let typedTags = tags as? Array<Dictionary<String, AnyObject>> {                            
                            for tag in typedTags {
                                let name = tag[CognitiveServicesKeys.Name]
                                let confidence = tag[CognitiveServicesKeys.Confidence] as! Double
                                if confidence > suggestedConfidence {
                                    result.append(name! as! String)
                                }
                            }
                        }
                    }
                    
                    print(result)
                    
                    completion(result, nil)
                    return
                }
                catch _ {
                    completion(nil, error as NSError?)
                    return
                }
            } else {
                completion(nil, nil)
                return
            }
        }
        
        task.resume()
    }
}
