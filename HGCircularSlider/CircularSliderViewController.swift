//
//  CircularSliderViewController.swift
//  HGCircularSlider
//
//  Created by Hamza Ghazouani on 16/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

class CircularSliderViewController: UIViewController {

    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = 100
        circularSlider.endPointValue = 25
        circularSlider.endThumbImage = UIImage(systemName: "doc.append")
        updateTexts()
        circularSlider.addTarget(self, action: #selector(updateTexts), for: .valueChanged)
    }
    
    @objc func updateTexts() {
        maxValueLabel.text = String(format: "%.0f", circularSlider.maximumValue)
        minValueLabel.text = String(format: "%.0f", circularSlider.minimumValue)
        currentValueLabel.text = String(format: "%.0f", circularSlider.endPointValue)
    }
}
