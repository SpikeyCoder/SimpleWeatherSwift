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
    let apiKey = "8a9a4b36a224b8b0d349e971d321541f"
    override init() {
        self.currentTemperature = CurrentTemperature()
        super.init()
        
        if let currentTempSignal:RACSignal = self.updateCurrentTemperature()
        {
            RACObserve(self, keyPath: "currentLocation").flattenMap({ (newLocation:AnyObject!) -> RACStream! in
                return RACSignal.combineLatest([currentTempSignal])
            }).deliverOn(RACScheduler.mainThreadScheduler()).subscribeError({ (error) -> Void in
                TSMessage.showNotificationWithTitle("Error", subtitle: "There was a problem fetching the latest weather", type: TSMessageNotificationType.Error)
            })
        }
        else
        {
            TSMessage.showNotificationWithTitle("Error", subtitle: "There was a problem fetching the latest weather", type: TSMessageNotificationType.Error)
        }
    }
 
    func updateCurrentTemperature() -> RACSignal?
    {
        if let coordinate: CLLocationCoordinate2D = self.currentCoordinate
        {
            return (fetchCurrentTemperatureForLocation(coordinate)?.doNext({ (temperature:AnyObject!) -> Void in
                if let temp = temperature as? CurrentTemperature
                {
                    self.currentTemperature = temp
                }})!)!
        }
        return nil
    }
    
    func fetchCurrentTemperatureForLocation(coordinate :CLLocationCoordinate2D) -> RACSignal?
    {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&APPID=\(self.apiKey)"
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
    
}
