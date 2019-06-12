//
//  EducationViewController.swift
//  iRoboCar
//
//  Created by Daniel Morrison on 2/14/19.
//  Copyright © 2019 TheFabFive. All rights reserved.
//

import UIKit

class EducationViewController: UIViewController{

    @IBOutlet weak var gearText: UITextView!
    @IBOutlet weak var servoText: UITextView!
    @IBOutlet weak var blueWroomText: UITextView!
    @IBOutlet weak var cameraWroomText: UITextView!
    @IBOutlet weak var cameraText: UITextView!
    @IBOutlet weak var ultraText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func gearButton(_ sender: Any) {
        gearText.isHidden = !gearText.isHidden
        servoText.isHidden = true
        cameraText.isHidden = true
        blueWroomText.isHidden = true
        cameraWroomText.isHidden = true
        ultraText.isHidden = true
    }
    @IBAction func servoButton(_ sender: Any) {
        servoText.isHidden = !servoText.isHidden
        gearText.isHidden = true
        cameraText.isHidden = true
        blueWroomText.isHidden = true
        cameraWroomText.isHidden = true
        ultraText.isHidden = true
    }
    @IBAction func cameraButton(_ sender: Any) {
        cameraText.isHidden = !cameraText.isHidden
        gearText.isHidden = true
        servoText.isHidden = true
        blueWroomText.isHidden = true
        cameraWroomText.isHidden = true
        ultraText.isHidden = true
    }
    @IBAction func cameraWroomButton(_ sender: Any) {
        cameraWroomText.isHidden = !cameraWroomText.isHidden
        gearText.isHidden = true
        servoText.isHidden = true
        cameraText.isHidden = true
        blueWroomText.isHidden = true
        ultraText.isHidden = true
    }
    @IBAction func blueWroomButton(_ sender: Any) {
        blueWroomText.isHidden = !blueWroomText.isHidden
        gearText.isHidden = true
        servoText.isHidden = true
        cameraText.isHidden = true
        cameraWroomText.isHidden = true
        ultraText.isHidden = true
    }
    
    @IBAction func ultraButton(_ sender: Any) {
        ultraText.isHidden = !ultraText.isHidden
        gearText.isHidden = true
        servoText.isHidden = true
        cameraText.isHidden = true
        cameraWroomText.isHidden = true
        blueWroomText.isHidden = true
    }
}
