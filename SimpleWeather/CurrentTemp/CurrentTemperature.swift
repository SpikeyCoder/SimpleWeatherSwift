//
//  CurrentTemperature.swift
//  SimpleWeather
//
//  Created by Kevin Armstrong on 1/19/16.
//  Copyright © 2016 Ryan Nystrom. All rights reserved.
//

import UIKit
import Mantle

class CurrentTemperature : MTLModel
{
    var highTemp : String?
    var lowTemp : String?
    var currentTemp : String?
    var conditions : String?
    var imgName : String?
    var icon : String?
    
    class func imageMap() -> NSDictionary
    {
        var imageMap = NSDictionary()
        
        imageMap = [
            "01d" : "weather-clear",
            "02d" :  "weather-few",
            "03d" :  "weather-few",
            "04d" :  "weather-broken",
            "09d" :  "weather-shower",
            "10d" :  "weather-rain",
            "11d" :  "weather-tstorm",
            "13d" :  "weather-snow",
            "50d" :  "weather-mist",
            "01n" :  "weather-moon",
            "02n" :  "weather-few-night",
            "03n" :  "weather-few-night",
            "04n" :  "weather-broken",
            "09n" :  "weather-shower",
            "10n" :  "weather-rain-night",
            "11n" :  "weather-tstorm",
            "13n" :  "weather-snow",
            "50n" :  "weather-mist"]
        
        return imageMap
    }
    
    class func imageName(iconName : String) -> NSString
    {
        if let image = self.imageMap()["\(iconName)"] as? NSString {
            return image
        }
        return ""
    }
    
    class func JSONKeyPathsByPropertyKey() -> NSDictionary {
        return [
            "date": "dt",
            "locationName": "name",
            "humidity": "main.humidity",
            "temperature": "main.temp",
            "tempHigh": "main.temp_max",
            "tempLow": "main.temp_min",
            "sunrise": "sys.sunrise",
            "sunset": "sys.sunset",
            "conditionDescription": "weather.description",
            "condition": "weather.main",
            "icon": "weather.icon",
            "windBearing": "wind.deg",
            "windSpeed": "wind.speed",
        ];
    }
    
   class func conditionJSONTransformer() -> NSValueTransformer
    {
        return self.conditionDescriptionJSONTransformer()
    }
    
    class func iconJSONTransformer() -> NSValueTransformer
    {
        return self.conditionDescriptionJSONTransformer()
    }
    
    
    class func sunriseJSONTransformer() -> NSValueTransformer
    {
        return self.dateJSONTransformer()
    }
    
    class func sunsetJSONTransformer() -> NSValueTransformer
    {
        return self.dateJSONTransformer()
    }
    
    class func windSpeedJSONTransformer() -> NSValueTransformer
    {
        return MTLValueTransformer.reversibleTransformerWithForwardBlock({ (num) -> AnyObject! in
            if let number = num as? NSNumber {
                return Int(number.floatValue*2.23694)
            }
            return nil
            }, reverseBlock: { (speed) -> AnyObject! in
                if let pulledSpeed = speed as? NSNumber {
                    return Int(pulledSpeed.floatValue/2.23694)
                }
                return nil
        })
    }
    
    class func conditionDescriptionJSONTransformer() -> NSValueTransformer
    {
        return MTLValueTransformer.reversibleTransformerWithForwardBlock({ (values) -> AnyObject! in
            if let descriptionValues = values as? NSArray {
                return descriptionValues.firstObject
            }
            return nil
            }, reverseBlock: { (str) -> AnyObject! in
                if let string = str as? NSString {
                    return [string]
                }
                return nil
        })
    }
    
    class func dateJSONTransformer() -> NSValueTransformer
    {
        return MTLValueTransformer.reversibleTransformerWithForwardBlock({ (str) -> AnyObject! in
            if let dateString = str as? NSString {
                return NSDate(timeIntervalSince1970: Double(dateString.floatValue))
            }
            return nil
            }, reverseBlock: { (date) -> AnyObject! in
                if let currentDate = date as? NSDate {
                    return "\(currentDate.timeIntervalSince1970)"
                }
                return nil
        })
    }
}
