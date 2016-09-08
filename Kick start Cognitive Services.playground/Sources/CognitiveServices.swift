//
//  CognitiveServices.swift
//  Social Tagger
//
//  Created by Alexander Repty on 16.05.16.
//  Copyright © 2016 maks apps. All rights reserved.
//

import Foundation
import UIKit





/// Lowest level results for both face rectangles and emotion scores. A hit represents one face and its range of emotions.
public typealias EmotionReplyHit = Dictionary<String, AnyObject>
/// Wrapper type for an array of hits (i.e. faces). This is the top-level JSON object.
public typealias EmotionReplyType = Array<EmotionReplyHit>

/**
 Possible values for detected emotions in images.
 */
public enum CognitiveServicesEmotion: String {
    case Anger
    case Contempt
    case Disgust
    case Fear
    case Happiness
    case Neutral
    case Sadness
    case Surprise
}

public struct CognitiveServicesEmotionResult {
    public let frame: CGRect
    public let emotion: CognitiveServicesEmotion
}

/// Result closure type for emotion callbacks.
public typealias EmotionResult = ([CognitiveServicesEmotionResult]?, NSError?) -> (Void)


/// Result closure type for computer vision callbacks. The first parameter is an array of suitable tags for the image.
public typealias CognitiveServicesTagsResult = ([String]?, NSError?) -> (Void)

/// Possible results for faces callbacks
public struct CognitiveServicesFacesResult {
    public var frame: CGRect
    public var faceId : String?
    public var landmarks: [CGPoint]?
    public var age : Int
    public var gender : String
    public var facialHair : String?
    public var glasses : String?
    
    init () {
        frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        faceId = ""
        landmarks = nil
        age = 0
        gender = ""
        facialHair = ""
        glasses = ""
    }
}
/// Result closure type for faces results
public typealias FacesResult = ([CognitiveServicesFacesResult]?, NSError?) -> (Void)


/// Fill in your API key here after getting it from https://www.microsoft.com/cognitive-services/en-US/subscriptions
let CognitiveServicesComputerVisionAPIKey = "<place your key here>"
let CognitiveServicesEmotionAPIKey = "<place your key here>"
let CognitiveServicesFacesAPIKey = "<place your key here>"

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
    static let ReturnFaceId = "returnFaceId"
    static let ReturnFaceLandmarks = "returnFaceLandmarks"
    static let ReturnFaceAttributes = "returnFaceAttributes"
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

///Caseless enum of available face attributes returned for a sigle face
enum CognitiveServicesFaceAttributes {
    static let Age = "age"
    static let Gender = "gender"
    static let Smile = "smile"
    static let FacialHair = "facialHair"
    static let Glasses = "glasses"
    static let HeadPose = "headPose"
}

/// Caseless enum of available JSON dictionary keys for the service's reply.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa and https://dev.projectoxford.ai/docs/services/5639d931ca73072154c1ce89/operations/563b31ea778daf121cc3a5fa for details
enum CognitiveServicesKeys {
    static let Tags = "tags"
    static let Name = "name"
    static let Confidence = "confidence"
    static let FaceRectangle = "faceRectangle"
    static let FaceAttributes = "faceAttributes"
    static let FaceLandmarks = "faceLandmarks"
    static let FaceIdentifier = "faceId"
    static let Scores = "scores"
    static let Height = "height"
    static let Left = "left"
    static let Top = "top"
    static let Width = "width"
    static let Anger = "anger"
    static let Contempt = "contempt"
    static let Disgust = "disgust"
    static let Fear = "fear"
    static let Happiness = "happiness"
    static let Neutral = "neutral"
    static let Sadness = "sadness"
    static let Surprise = "surprise"
    static let Mustache = "mustache"
    static let Beard = "beard"
    static let Sideburns = "sideBurns"
}

/// Caseless enum of various configuration parameters.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
enum CognitiveServicesConfiguration {
    static let AnalyzeURL = "https://api.projectoxford.ai/vision/v1.0/analyze"
    static let EmotionURL = "https://api.projectoxford.ai/emotion/v1.0/recognize"
    static let FaceDetectURL = "https://api.projectoxford.ai/face/v1.0/detect"
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
    

    
    
    
    /**
     Retrieves scores for a range of emotions and calls the completion closure with the most suitable one.
     
     - parameter image:      The image to analyse.
     - parameter completion: Callback closure.
     */
    public func retrievePlausibleEmotionsForImage(_ image: UIImage, completion: EmotionResult) {
        assert(CognitiveServicesEmotionAPIKey.characters.count > 0, "Please set the value of the API key variable (CognitiveServicesEmotionAPIKey) before attempting to use the application.")
        
        print("i got a key - let's do this")
        
        let url = URL(string: CognitiveServicesConfiguration.EmotionURL)
        print("calling the following URL: \(url)")
        let request = NSMutableURLRequest(url: url!)
        
        // The subscription key is always added as an HTTP header field.
        request.addValue(CognitiveServicesEmotionAPIKey, forHTTPHeaderField: CognitiveServicesHTTPHeader.SubscriptionKey)
        // We need to specify that we're sending the image as binary data, since it's possible to supply a JSON-wrapped URL instead.
        request.addValue(CognitiveServicesHTTPContentType.OctetStream, forHTTPHeaderField: CognitiveServicesHTTPHeader.ContentType)
        
        // Convert the image reference to a JPEG binary to submit to the service. If this ends up being over 4 MB, it'll throw an error
        // on the server side. In a production environment, you would check for this condition and handle it gracefully (either reduce
        // the quality, resize the image or prompt the user to take an action).
        let requestData = UIImageJPEGRepresentation(image, 0.9)
        request.httpBody = requestData
        request.httpMethod = CognitiveServicesHTTPMethod.POST
        
        print(request)
        
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
                    var result = [CognitiveServicesEmotionResult]()
                    
                    if let array = collectionObject as? EmotionReplyType {
                        // This is an array of hits, i.e. faces with associated emotions. We iterate through it and
                        // try to get a complete set of coordinates and the most suitable emotion rating for every one.
                        for hit in array {
                            // See if all necessary coordinates for a rectangle are there and create a native data type
                            // with the information.
                            var resolvedFrame: CGRect? = nil
                            if let
                                frame = hit[CognitiveServicesKeys.FaceRectangle] as? Dictionary<String, Int>,
                                let top = frame[CognitiveServicesKeys.Top],
                                let left = frame[CognitiveServicesKeys.Left],
                                let height = frame[CognitiveServicesKeys.Height],
                                let width = frame[CognitiveServicesKeys.Width]
                            {
                                resolvedFrame = CGRect(x: left, y: top, width: width, height: height)
                            }
                            
                            // Find all the available emotions and see which is the highest scoring one.
                            var emotion: CognitiveServicesEmotion? = nil
                            if let
                                emotions = hit[CognitiveServicesKeys.Scores] as? Dictionary<String, Double>,
                                let anger = emotions[CognitiveServicesKeys.Anger],
                                let contempt = emotions[CognitiveServicesKeys.Contempt],
                                let disgust = emotions[CognitiveServicesKeys.Disgust],
                                let fear = emotions[CognitiveServicesKeys.Fear],
                                let happiness = emotions[CognitiveServicesKeys.Happiness],
                                let neutral = emotions[CognitiveServicesKeys.Neutral],
                                let sadness = emotions[CognitiveServicesKeys.Sadness],
                                let surprise = emotions[CognitiveServicesKeys.Surprise]
                            {
                                var maximumValue = 0.0
                                for value in [anger, contempt, disgust, fear, happiness, neutral, sadness, surprise] {
                                    if value <= maximumValue {
                                        continue
                                    }
                                    
                                    maximumValue = value
                                }
                                
                                if anger == maximumValue {
                                    emotion = .Anger
                                } else if contempt == maximumValue {
                                    emotion = .Contempt
                                } else if disgust == maximumValue {
                                    emotion = .Disgust
                                } else if fear == maximumValue {
                                    emotion = .Fear
                                } else if happiness == maximumValue {
                                    emotion = .Happiness
                                } else if neutral == maximumValue {
                                    emotion = .Neutral
                                } else if sadness == maximumValue {
                                    emotion = .Sadness
                                } else if surprise == maximumValue {
                                    emotion = .Surprise
                                }
                            }
                            
                            // If we have both a rectangle and an emotion, we have enough information to store this as
                            // a result set and eventually return it to the caller.
                            if let frame = resolvedFrame, let emotion = emotion {
                                result.append(CognitiveServicesEmotionResult(frame: frame, emotion: emotion))
                            }
                        }
                    }
                    
                    completion(result, nil)
                    return
                }
                catch _ {
                    completion(nil, error as? NSError)
                    return
                }
            } else {
                completion(nil, nil)
                return
            }
        }
        
        task.resume()
    }
    

    /**
     Retrieves face rectangles and features of faces within a picture.
     
     - parameter image:      The image to analyse.
     - parameter completion: Callback closure.
     */
    public func retrieveFacesForImage(_ image: UIImage, completion: FacesResult?) {
        assert(CognitiveServicesFacesAPIKey.characters.count > 0, "Please set the value of the API key variable (CognitiveServicesFacesAPIKey) before attempting to use the application.")
        
        print("i got a key - let's do this")
        
        var urlString = CognitiveServicesConfiguration.FaceDetectURL
        urlString += "?\(CognitiveServicesHTTPParameters.ReturnFaceId)=true&\(CognitiveServicesHTTPParameters.ReturnFaceLandmarks)=true&\(CognitiveServicesHTTPParameters.ReturnFaceAttributes)=age,gender,facialHair,glasses"
        
        let url = URL(string: urlString)
        print("calling the following URL: \(url)")
        let request = NSMutableURLRequest(url: url!)
        
        request.addValue(CognitiveServicesFacesAPIKey, forHTTPHeaderField: CognitiveServicesHTTPHeader.SubscriptionKey)
        request.addValue(CognitiveServicesHTTPContentType.OctetStream, forHTTPHeaderField: CognitiveServicesHTTPHeader.ContentType)
        
        let requestData = UIImageJPEGRepresentation(image, 0.9)
        request.httpBody = requestData
        request.httpMethod = CognitiveServicesHTTPMethod.POST
        
        print(request)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("executed task")
            
            if let error = error {
                completion!(nil, error as NSError?)
                return
            }
            
            if let data = data {
                print("aaand got data! -> \(data)")
                do {
                    let collectionObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("the data: \(collectionObject)")
                    
                    var resultArray = [CognitiveServicesFacesResult]()
                    var result = CognitiveServicesFacesResult()
                    
                    let allData = collectionObject as? [Dictionary<String, AnyObject>]
                    if let dictionary = allData?[0] {
                        
                        let rawFaceRectangle = dictionary[CognitiveServicesKeys.FaceRectangle]
                        if let rect = rawFaceRectangle as? Dictionary<String, Int> {
                            result.frame = CGRect(
                                x: CGFloat(rect[CognitiveServicesKeys.Left]!),
                                y: CGFloat(rect[CognitiveServicesKeys.Top]!),
                                width: CGFloat(rect[CognitiveServicesKeys.Width]!),
                                height: CGFloat(rect[CognitiveServicesKeys.Height]!)
                            )
                        }
                        
                        let rawfaceLandmarks = dictionary[CognitiveServicesKeys.FaceLandmarks]
                        if let landmarks = rawfaceLandmarks as? Dictionary<String, Dictionary<String, Double>> {
                            var landmarkPoints = [CGPoint]()
                            for landmark in landmarks {
                                let points = landmark.value
                                landmarkPoints.append( CGPoint(x: points["x"]!, y: points["y"]!))
                            }
                            result.landmarks = landmarkPoints
                        }
                        
                        let rawAttributes = dictionary[CognitiveServicesKeys.FaceAttributes]
                        if let attributes = rawAttributes as? Dictionary<String, AnyObject> {
                            result.age = attributes[CognitiveServicesFaceAttributes.Age] as! Int
                            result.gender = attributes[CognitiveServicesFaceAttributes.Gender] as! String
                            
                            if let facialHair = attributes[CognitiveServicesFaceAttributes.FacialHair] as? Dictionary<String, Double> {
                                var val : Double = 0
                                for hair in facialHair {
                                    if hair.value > val {
                                        val = hair.value
                                        result.facialHair = hair.key
                                    }
                                }
                            }
                            
                            if let glasses = attributes[CognitiveServicesFaceAttributes.Glasses] as? String {
                                result.glasses = glasses
                            }
                        }
                        
                        result.faceId = dictionary[CognitiveServicesKeys.FaceIdentifier] as? String
                    }
                    
                    resultArray.append(result)
                    
                    print(resultArray)
                    
                    completion!(resultArray, nil)
                    return
                }
                catch _ {
                    completion!(nil, error as NSError?)
                    return
                }
            } else {
                completion!(nil, nil)
                return
            }
        }
        task.resume()
    }

}
