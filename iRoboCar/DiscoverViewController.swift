//
//  DiscoverViewController.swift
//  iRoboCar
//
//  Created by Daniel Morrison on 2/14/19.
//  Copyright © 2019 TheFabFive. All rights reserved.
//

import UIKit
import UIKit
import SpriteKit
import Charts
import CoreBluetooth

class DiscoverViewController: UIViewController {

    var periph: CBPeripheral!
    var characteristic: CBCharacteristic!
    var characteristicList: [CBCharacteristic]!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var joystickView: UIView!
    //@IBOutlet weak var lineChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: joystickView.bounds.size)
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        //let scene = GameScene(size: self.view.bounds.size)
        scene.backgroundColor = .white
        scene.periph = periph
        scene._characteristic = characteristic
        scene.characteristicList = characteristicList
        scene.slider = slider
        //scene.lineChart = lineChart
        if let skView = joystickView as? SKView {
            skView.allowsTransparency = true
            skView.ignoresSiblingOrder = false
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
        return .landscapeRight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}
