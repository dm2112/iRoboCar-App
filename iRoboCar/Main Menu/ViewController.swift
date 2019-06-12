//
//  ViewController.swift
//  iRoboCar
//
//  Created by Daniel Morrison on 11/6/18.
//  Copyright © 2018 TheFabFive. All rights reserved.
//

import UIKit
import CoreBluetooth

let CHARACTERISTIC_UUID_RX = "c0de0003-feed-f00d-c0ff-eeb3d05ebeef"

let FAB_FIVE_SERVICE_UUID = "c0de0000-feed-f00d-c0ff-eeb3d05ebeef"
let ULTRASONIC_DETECTOR = "c0de0001-feed-f00d-c0ff-eeb3d05ebeef"
let SET_MOTOR_CHARACTERISTIC_UUID = "c0de0002-feed-f00d-c0ff-eeb3d05ebeef"
//let SET_PID_CHARACTERISTIC_UUID = "c0de0004-feed-f00d-c0ff-eeb3d05ebeef"
let SET_NETWORK_INFO_CHARACTERISTIC_UUID = "c0de0003-feed-f00d-c0ff-eeb3d05ebeef"

let carServiceCBUUID = CBUUID(string: FAB_FIVE_SERVICE_UUID)
let carLEDCharacteristicCBUUID = CBUUID(string: CHARACTERISTIC_UUID_RX)

class ViewController: UIViewController {
    var centralManager: CBCentralManager!
    var carPeripheral: CBPeripheral!
    var _characteristic: CBCharacteristic?
    var characteristicList = [CBCharacteristic]()

    @IBOutlet weak var toggleLEDBtn: UIButton!
    
    @IBAction func toggleLED(_ sender: Any) {
        if(toggleLEDBtn.titleLabel?.textColor == UIColor.white) {
            //send bluetooth control to ESP32 to turn on led
            toggleLEDBtn.setTitleColor(UIColor.green, for: .normal)
            let string = "on"
            let data = string.data(using: String.Encoding.utf8)
            let characteristic = _characteristic
            carPeripheral!.writeValue(data!, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
        }
        
        else {
            //send bluetooth control to ESP32 to turn off led
            toggleLEDBtn.setTitleColor(UIColor.white, for: .normal)
            let string = "off"
            let data = string.data(using: String.Encoding.utf8)
            let characteristic = _characteristic
            carPeripheral!.writeValue(data!, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    @IBOutlet weak var adventureBtn: UIButton!
    @IBOutlet weak var discoverBtn: UIButton!
    @IBOutlet weak var programBtn: UIButton!
    @IBOutlet weak var educationBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleLEDBtn.titleLabel?.textColor = UIColor.white
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        adventureBtn.layer.shadowColor = UIColor.purple.cgColor
        adventureBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        adventureBtn.layer.shadowOpacity = 1
        adventureBtn.layer.shadowRadius = 1.0
        adventureBtn.clipsToBounds = false
        
        discoverBtn.layer.shadowColor = UIColor.purple.cgColor
        discoverBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        discoverBtn.layer.shadowOpacity = 1
        discoverBtn.layer.shadowRadius = 1.0
        discoverBtn.clipsToBounds = false
        
        programBtn.layer.shadowColor = UIColor.purple.cgColor
        programBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        programBtn.layer.shadowOpacity = 1
        programBtn.layer.shadowRadius = 1.0
        programBtn.clipsToBounds = false
        
        educationBtn.layer.shadowColor = UIColor.purple.cgColor
        educationBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        educationBtn.layer.shadowOpacity = 1
        educationBtn.layer.shadowRadius = 1.0
        educationBtn.clipsToBounds = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait //return the value as per the required orientation
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            print(carServiceCBUUID)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    //let's "discover" our ESP32
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        if peripheral.name == "iRoboCar"{
            carPeripheral = peripheral
            carPeripheral.delegate = self
            centralManager.stopScan()
            centralManager.connect(carPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.discoverServices([carServiceCBUUID])
        let alert = UIAlertController(title: "Successfully connected to iRoboCar!", message: "BLE connected", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
        let alert = UIAlertController(title: "BLE disconnected!", message: "What happened?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("No connection")
    }
}

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            //print(service.characteristics ?? "characteristics are nil")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                //peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
                _characteristic = characteristic
                characteristicList.append(characteristic)
            }
            else if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
                _characteristic = characteristic
                characteristicList.append(characteristic)
            }
            else if characteristic.properties.contains(.write){
                print("\(characteristic.uuid): properties contains .write")
                //peripheral.setNotifyValue(true, for: characteristic)
                _characteristic = characteristic
                characteristicList.append(characteristic)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var connected = Data(bytes: [0x01])
        //let more = Data(bytes: [0x01])
        //connected.append(more)
        switch characteristic.uuid {
            
            //case carLEDCharacteristicCBUUID:
               //print(characteristic.value ?? "no value")
        case CBUUID(string: SET_NETWORK_INFO_CHARACTERISTIC_UUID):
            print(String(data: characteristic.value!, encoding: String.Encoding.utf8))
            //print(String(data: connected, encoding: String.Encoding.utf8))
            
            if characteristic.value?.last == 0x01{
                print("connected")
                if MyGlobalTimer.sharedInstance.internalTimer != nil{
                    DispatchQueue.main.async {
                        MyGlobalTimer.sharedInstance.internalTimer!.invalidate()
                    }
                }
                
                let alert = UIAlertController(title: "Successfully connected iRoboCar to WiFi!", message: "WiFi connected", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default){_ in self.performSegue(withIdentifier: "weewoo", sender: nil)
                    //MyGlobalTimer.sharedInstance.stopTimer()
                })
                
                present(alert, animated: true, completion: nil)
            }
        case CBUUID(string: ULTRASONIC_DETECTOR):
            //print("ultra\( characteristic.value?.last)")
            if characteristic.value?.last == 0x01{
                print("connected")
                if MyGlobalTimer.sharedInstance.internalTimer != nil{
                    DispatchQueue.main.async {
                        MyGlobalTimer.sharedInstance.internalTimer!.invalidate()
                    }
                }
                let alert = UIAlertController(title: "Object detected!", message: "Something is going to hit iRoboCar! Program ended", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default){_ in
                    //MyGlobalTimer.sharedInstance.stopTimer()
                })
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        default:
            print("Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil){
            print("oof")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewController {
            vc.periph = carPeripheral
            vc.characteristic = _characteristic
            vc.characteristicList = characteristicList
        }
        if let vc = segue.destination as? SignInViewController{
            vc.periph = carPeripheral
            vc.characteristic = _characteristic
            vc.characteristicList = characteristicList
        }
        if let vc = segue.destination as? DiscoverViewController{
            vc.periph = carPeripheral
            vc.characteristic = _characteristic
            vc.characteristicList = characteristicList
        }
        if let vc = segue.destination as? ProgrammingViewController{
            vc.periph = carPeripheral
            vc.characteristicList = characteristicList
        }
    }
}

