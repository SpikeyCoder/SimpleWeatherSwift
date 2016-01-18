//
//  CurrentTemperatureViewController.swift
//  SimpleWeather
//
//  Created by Kevin Armstrong on 1/17/16.
//  Copyright © 2016 Ryan Nystrom. All rights reserved.
//

import UIKit

class CurrentTemperatureViewController: UIViewController {
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highLowTempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurredBackgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
