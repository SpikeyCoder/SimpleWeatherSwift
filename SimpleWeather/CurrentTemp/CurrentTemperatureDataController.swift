//
//  CurrentTemperatureDataController.swift
//  SimpleWeather
//
//  Created by Kevin Armstrong on 1/18/16.
//  Copyright © 2016 Ryan Nystrom. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Mantle

class CurrentTemperatureDataController: NSObject {
    var currentTemperature : CurrentTemperature
    var currentCoordinate : CLLocationCoordinate2D?
    override init() {
        self.currentTemperature = CurrentTemperature()
    }
 
    func updateCurrentConditions() -> RACSignal?
    {
        if let coordinate: CLLocationCoordinate2D = self.currentCoordinate
        {
            return (fetchCurrentTemperatureForLocation(coordinate)?.doNext({ (temperature:AnyObject!) -> Void in
                if let temp = temperature as? CurrentTemperature
                {
                    self.currentTemperature = temp
                }
                
            })!)!
        }
        return nil
    }
    
    func fetchCurrentTemperatureForLocation(coordinate :CLLocationCoordinate2D) -> RACSignal?
    {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial"
        if let url:NSURL = NSURL(string: urlString)
        {
            return fetchJSONFromURL(url).map { (json:AnyObject!) in
                return try! MTLJSONAdapter.modelOfClass(CurrentTemperature.self, fromJSONDictionary: json as! [NSObject : AnyObject]) as AnyObject!
                } as RACSignal!
        }
        return nil
    }
    
    func fetchJSONFromURL(url:NSURL) -> RACSignal
    {
        print("Fetching: \(url.absoluteString)")
        return RACSignal.createSignal { subscriber  in
            let session = NSURLSession()
            let dataTask:NSURLSessionDataTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let returnedData:NSData = data where error == nil
                {
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(returnedData, options:.MutableContainers)
                        subscriber.sendNext(json)
                    } catch let err as NSError {
                        subscriber.sendError(err)
                    }
                }
                else
                {
                    subscriber.sendError(error)
                }
                subscriber.sendCompleted()
            }
            dataTask.resume()
            return RACDisposable(block: { () -> Void in
                dataTask.cancel()
            })
        }
    }
    
    
//    - (RACSignal *)updateCurrentConditions {
//    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(WXCondition *condition) {
//    self.currentCondition = condition;
//    }];
    
}

class CurrentTemperature
{
    var highTemp : String
    var lowTemp : String
    var currentTemp : String
    var conditions : String
    init()
    {
        self.highTemp = ""
        self.lowTemp = ""
        self.currentTemp = ""
        self.conditions = ""
    }
    convenience init(highTemperature:String, lowTemperature:String, currentTemperature:String, weatherConditions:String)
    {
        self.init()
        self.highTemp = highTemperature
        self.lowTemp = lowTemperature
        self.currentTemp = currentTemperature
        self.conditions = weatherConditions
    }
}
