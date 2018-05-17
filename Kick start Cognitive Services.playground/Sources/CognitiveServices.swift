//
//  CognitiveServices.swift
//  Social Tagger
//
//  Created by Alexander Repty on 16.05.16.
//  Copyright © 2016 maks apps. All rights reserved.
//

import Foundation
import UIKit


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

/// Result closure type for computer vision callbacks. The first parameter is an array of suitable tags for the image.
public typealias CognitiveServicesTagsResult = ([String]?, NSError?) -> (Void)

/// Possible results for cat callbacks
public struct CustomVisionResult {
    public var id : String?
    public var project : String?
    public var iteration : String?
    public var created : String?
    public var preditions : Dictionary<String, AnyObject>?
    
    init () {
        id = ""
        project = ""
        iteration = ""
        created = ""
        preditions = nil
    }
}

public typealias CustomVisionCallback = (String?, NSError?) -> (Void)

/// Possible results for faces callbacks
public struct CognitiveServicesFacesResult {
    public var frame: CGRect
    public var faceId : String?
    public var landmarks: [CGPoint]?
    public var age : Float
    public var gender : String
    public var facialHair : String?
    public var glasses : String?
    public var emotion : CognitiveServicesEmotion?
    public var makeup : String?
    
    init () {
        frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        faceId = ""
        landmarks = nil
        age = 0
        gender = ""
        facialHair = ""
        glasses = ""
        emotion = CognitiveServicesEmotion.Neutral
        makeup = ""
    }
}
/// Result closure type for faces results
public typealias FacesResult = ([CognitiveServicesFacesResult]?, NSError?) -> (Void)

/// Fill in your API key here after getting it from https://www.microsoft.com/cognitive-services/en-US/subscriptions
let CognitiveServicesComputerVisionAPIKey = "xxx"
let CognitiveServicesFacesAPIKey = "xxx"
let CustomVision_instanceID = "xxx"
let CustomVision_iterationID = "xxx"
let CustomVision_predictionKey = "xxx"

/// Caseless enum of available HTTP methods.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
public enum CognitiveServicesHTTPMethod {
    public static let POST = "POST"
}

/// Caseless enum of available HTTP header keys.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
public enum CognitiveServicesHTTPHeader {
    public static let PredictionKey = "Prediction-Key"
    public static let SubscriptionKey = "Ocp-Apim-Subscription-Key"
    public static let ContentType = "Content-Type"
}

/// Caseless enum of available HTTP parameters.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
public enum CognitiveServicesHTTPParameters {
    public static let VisualFeatures = "visualFeatures"
    public static let Details = "details"
    public static let ReturnFaceId = "returnFaceId"
    public static let ReturnFaceLandmarks = "returnFaceLandmarks"
    public static let ReturnFaceAttributes = "returnFaceAttributes"
}

/// Caseless enum of available HTTP content types.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
public enum CognitiveServicesHTTPContentType {
    public static let JSON = "application/json"
    public static let OctetStream = "application/octet-stream"
    public static let FormData = "multipart/form-data"
}

/// Caseless enum of available visual features to analyse the image for.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
public enum CognitiveServicesVisualFeatures {
    public static let Categories = "Categories"
    public static let Tags = "Tags"
    public static let Description = "Description"
    public static let Faces = "Faces"
    public static let ImageType = "ImageType"
    public static let Color = "Color"
    public static let Adult = "Adult"
}

///Caseless enum of available face attributes returned for a sigle face
public enum CognitiveServicesFaceAttributes {
    public static let Age = "age"
    public static let Gender = "gender"
    public static let Smile = "smile"
    public static let FacialHair = "facialHair"
    public static let Glasses = "glasses"
    public static let HeadPose = "headPose"
    public static let Emotion = "emotion"
    public static let Hair = "hair"
    public static let Makeup = "makeup"
    public static let Occlusion = "occlusion"
    public static let Accessories = "accessories"
    public static let Blur = "blur"
    public static let Exposure = "exposure"
    public static let Noise = "noise"
}

/// Caseless enum of available JSON dictionary keys for the service's reply.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa and https://dev.projectoxford.ai/docs/services/5639d931ca73072154c1ce89/operations/563b31ea778daf121cc3a5fa for details
public enum CognitiveServicesKeys {
    public static let Tags = "tags"
    public static let Name = "name"
    public static let Confidence = "confidence"
    public static let FaceRectangle = "faceRectangle"
    public static let FaceAttributes = "faceAttributes"
    public static let FaceLandmarks = "faceLandmarks"
    public static let FaceIdentifier = "faceId"
    public static let Scores = "scores"
    public static let Height = "height"
    public static let Left = "left"
    public static let Top = "top"
    public static let Width = "width"
    public static let Emotion = "emotion"
    public static let Anger = "anger"
    public static let Contempt = "contempt"
    public static let Disgust = "disgust"
    public static let Fear = "fear"
    public static let Happiness = "happiness"
    public static let Neutral = "neutral"
    public static let Sadness = "sadness"
    public static let Surprise = "surprise"
    public static let Mustache = "mustache"
    public static let Beard = "beard"
    public static let Sideburns = "sideBurns"
    public static let EyeMakeup = "eyeMakeup"
    public static let LipMakeup = "lipMakeup"
    public static let Predictions = "predictions"
    public static let Probability = "probability"
    public static let PredictionTagName = "tagName"
    
}

/// Caseless enum of various configuration parameters.
/// See https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa for details
public enum CognitiveServicesConfiguration {
    public static let AnalyzeURL = "https://westeurope.api.cognitive.microsoft.com/vision/v1.0/analyze"
    public static let FaceDetectURL = "https://westeurope.api.cognitive.microsoft.com/face/v1.0/detect"
    public static let JPEGCompressionQuality = 0.9 as CGFloat
    public static let RequiredConfidence = 0.85
}




public class CognitiveServices: NSObject {
    
    /**
     Retrieves a list of suitable tags for a given image from Microsoft's Cognitive Services API.
     
     - parameter image:      The image to analyse.
     - parameter completion: Callback closure.
     */
    public func retrievePlausibleTagsForImage(_ image: UIImage, _ suggestedConfidence: Double, completion: @escaping CognitiveServicesTagsResult) {
        assert(CognitiveServicesComputerVisionAPIKey.characters.count > 0, "Please set the value of the API key variable (CognitiveServicesVisualFeaturesAPIKey) before attempting to use the application.")
        
        print("i got a key - let's do this")
        
        // We need to specify that we want to retrieve tags for our image as a parameter to the URL.
        var urlString = CognitiveServicesConfiguration.AnalyzeURL
        urlString += "?\(CognitiveServicesHTTPParameters.VisualFeatures)=\("\(CognitiveServicesVisualFeatures.Tags)")"
        
        let url = URL(string: urlString)
        print("calling the following URL: \(url!)")
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
    public func retrievePlausibleEmotionsForImage(_ image: UIImage, completion: FacesResult?) {
        assert(CognitiveServicesFacesAPIKey.characters.count > 0, "Please set the value of the API key variable (CognitiveServicesFacesAPIKey) before attempting to use the application.")
        
        print("i got a key - let's do this")
        
        var urlString = CognitiveServicesConfiguration.FaceDetectURL
        urlString += "?\(CognitiveServicesHTTPParameters.ReturnFaceId)=true&\(CognitiveServicesHTTPParameters.ReturnFaceLandmarks)=true&\(CognitiveServicesHTTPParameters.ReturnFaceAttributes)=age,gender,facialHair,glasses,emotion,makeup"
        
        let url = URL(string: urlString)
        print("calling the following URL: \(url!)")
        let request = NSMutableURLRequest(url: url!)
        
        // The subscription key is always added as an HTTP header field.
        request.addValue(CognitiveServicesFacesAPIKey, forHTTPHeaderField: CognitiveServicesHTTPHeader.SubscriptionKey)
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
                        if let rect = rawFaceRectangle as? Dictionary<String, NSNumber> {
                            result.frame = CGRect(
                                x:      CGFloat(rect[CognitiveServicesKeys.Left]!),
                                y:      CGFloat(rect[CognitiveServicesKeys.Top]!),
                                width:  CGFloat(rect[CognitiveServicesKeys.Width]!),
                                height: CGFloat(rect[CognitiveServicesKeys.Height]!)
                            )
                        }
                        
                        let rawAttributes = dictionary[CognitiveServicesKeys.FaceAttributes]
                        if let attributes = rawAttributes as? Dictionary<String, AnyObject> {
                            
                            var emotion: CognitiveServicesEmotion? = nil
                            if  let emotions = attributes[CognitiveServicesKeys.Emotion] as? Dictionary<String, Double>,
                                let anger = emotions[CognitiveServicesKeys.Anger],
                                let contempt = emotions[CognitiveServicesKeys.Contempt],
                                let disgust = emotions[CognitiveServicesKeys.Disgust],
                                let fear = emotions[CognitiveServicesKeys.Fear],
                                let happiness = emotions[CognitiveServicesKeys.Happiness],
                                let neutral = emotions[CognitiveServicesKeys.Neutral],
                                let sadness = emotions[CognitiveServicesKeys.Sadness],
                                let surprise = emotions[CognitiveServicesKeys.Surprise]
                            {
                                print("emotions: \(emotions)")
                                
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
                                
                                result.emotion = emotion
                                
                            }
                        }
                    }
                    
                    resultArray.append(result)
                    
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
        print("calling the following URL: \(url!)")
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
                        if let rect = rawFaceRectangle as? Dictionary<String, NSNumber> {
                            result.frame = CGRect(
                                x:      CGFloat(rect[CognitiveServicesKeys.Left]!),
                                y:      CGFloat(rect[CognitiveServicesKeys.Top]!),
                                width:  CGFloat(rect[CognitiveServicesKeys.Width]!),
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
                            result.age = attributes[CognitiveServicesFaceAttributes.Age] as! Float
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
    
    
    /*https://southcentralus.api.cognitive.microsoft.com/customvision/v2.0/Prediction/3ff8662d-5c31-4cac-adba-56a9e39d8029/image?iterationId=cdb0cb47-d39f-4241-93e7-5ea102cac513*/
    /**
     Retrieves prediction from custom trained vision service - is the cat grumpy or not? :)
     - parameter image:      The image to analyse.
     - parameter completion: Callback closure.
     */
    public func retrieveCatPredictionForImage(_ image: UIImage, completion: CustomVisionCallback?) {
        
        let CustomVision_baseURL = "https://southcentralus.api.cognitive.microsoft.com/customvision/v2.0/Prediction/\(CustomVision_instanceID)/image?iterationId=\(CustomVision_iterationID)"
        
        let url = URL(string: CustomVision_baseURL)
        print("calling the following URL: \(url!)")
        let request = NSMutableURLRequest(url: url!)
        
        request.addValue(CustomVision_predictionKey, forHTTPHeaderField: CognitiveServicesHTTPHeader.PredictionKey)
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
                    
                    let allData = collectionObject as! Dictionary<String, AnyObject>
                    let thePredictions = allData[CognitiveServicesKeys.Predictions] as? Array<Dictionary<String, AnyObject>>
                    print("predictions --> \(String(describing: thePredictions))")
                    if let predictions = thePredictions {
                        var value = 0.0
                        var tag = ""
                        for prediction in predictions {
                            let predictionVal = prediction[CognitiveServicesKeys.Probability] as! Double
                            let name = prediction[CognitiveServicesKeys.PredictionTagName] as! String
                            if predictionVal > value {
                                value = predictionVal
                                tag = name
                            }
                        }
                        print("the cat is --> \(tag)")
                        completion!(tag, nil)
                        return
                    } else {
                        completion!(nil, nil)
                    }
                    
                    
                } catch _ {
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
