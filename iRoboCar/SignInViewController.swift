//
//  SignInViewController.swift
//  iRoboCar
//
//  Created by Daniel Morrison on 1/14/19.
//  Copyright © 2019 TheFabFive. All rights reserved.
//

import UIKit
import CoreBluetooth

class SignInViewController: UIViewController, UITextFieldDelegate {
    var periph: CBPeripheral!
    var characteristic: CBCharacteristic!
    var characteristicList: [CBCharacteristic]!

    @IBOutlet weak var networkName: UITextField!
    @IBOutlet weak var networkPass: UITextField!
    
    func poll(_ characteristic: CBCharacteristic){
        self.periph.readValue(for: characteristic)
    }
    
    @IBAction func networkGo(_ sender: Any) {
        
        print("sending network name")
        let id1 = Data(bytes: [0x00])
        let name = "iPhone (3)"//networkName.text
        let length1 = UInt8(exactly: name.count)
        var data = Data()
        data.append(id1)
        data.append(length1!)
        data.append(name.data(using: String.Encoding.utf8)!)
        
        let nameCBUUID = CBUUID(string: SET_NETWORK_INFO_CHARACTERISTIC_UUID)
        print(nameCBUUID)
        let nameCharacteristic = characteristicList.first {$0.uuid == nameCBUUID}
        for x in characteristicList{
            print(x.uuid)
        }
        self.periph.writeValue(data, for: nameCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        
        //self.periph.setNotifyValue(true, for: nameCharacteristic!)
        
        print("sending network password")
        let pass = "2z62coxa91nuv"//networkPass.text
        let id2 = Data(bytes: [0x01])
        let length2 = UInt8(exactly: pass.count)
        var data2 = Data()
        data2.append(id2)
        data2.append(length2!)
        data2.append(pass.data(using: String.Encoding.utf8)!)
        
        let passCBUUID = CBUUID(string: SET_NETWORK_INFO_CHARACTERISTIC_UUID)
        let passCharacteristic = characteristicList.first {$0.uuid == passCBUUID}
        self.periph.writeValue(data2, for: passCharacteristic!, type: CBCharacteristicWriteType.withResponse)

        DispatchQueue.main.async {
            MyGlobalTimer.sharedInstance.internalTimer = Timer()
            MyGlobalTimer.sharedInstance.internalTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){_ in
                self.poll(passCharacteristic!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        networkName.delegate = self
        networkPass.delegate = self
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
        return .portrait
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewController {
            vc.periph = periph
            vc.characteristic = characteristic
            vc.characteristicList = characteristicList
        }
    }
}

class MyGlobalTimer: NSObject {
    
    static let sharedInstance = MyGlobalTimer()
    var internalTimer: Timer?
    
    private override init() {}
    
    func stopTimer(){
        guard self.internalTimer != nil else {
            fatalError("No timer active, start the timer before you stop it.")
        }
        self.internalTimer?.invalidate()
    }
}
