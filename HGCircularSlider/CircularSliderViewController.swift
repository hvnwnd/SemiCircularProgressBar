//
//  CircularSliderViewController.swift
//  HGCircularSlider
//
//  Created by Hamza Ghazouani on 16/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

class CircularSliderViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = 100
        circularSlider.endPointValue = 25
        circularSlider.endThumbImage = UIImage(named: "rounded-rectangle") // UIImage(systemName: "target")
        updateTexts()
        circularSlider.addTarget(self, action: #selector(updateTexts), for: .valueChanged)
    }
    
    @objc func updateTexts() {
        maxValueLabel.text = String(format: "%.0f", circularSlider.maximumValue)
        minValueLabel.text = String(format: "%.0f", circularSlider.minimumValue)
        
        let newValue = Int(circularSlider.endPointValue / 5)
        currentValueLabel.text = String(format: "%.0f", CGFloat(newValue) * 5)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.circularSlider.endPointValue = CGFloat(Int(textField.text!) ?? 0)
        }

        currentValueLabel.text = String(format: "%.0f", CGFloat(circularSlider.endPointValue))
        return true
    }
}
