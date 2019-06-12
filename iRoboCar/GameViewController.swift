//
//  GameViewController.swift
//  stick test
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2019 Daniel Morrison. All rights reserved.
//

import UIKit
import SpriteKit
import WebKit
import CoreBluetooth
import SwiftSocket
import CocoaAsyncSocket

class GameViewController: UIViewController, GCDAsyncUdpSocketDelegate {
    var periph: CBPeripheral!
    var characteristic: CBCharacteristic!
    var characteristicList: [CBCharacteristic]!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var bground: UIImageView!
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var joystickView: UIView!
    
    var hostIP : String = "172.20.10.11" //"127.0.0.1"
    var port : UInt16 = 8888
    var socket : GCDAsyncUdpSocket!
    var buffer: Data!
    var longData = Data()
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        let start: UInt8 = 0xFF
        let finish: UInt8 = 0xD9
        
        print("#bytes: \(data.count)")
        print(longData.count)
        
        if !longData.isEmpty && data.last == finish{
            print("yerp")
            self.longData.append(data)
            print(longData.count)
            self.bground.image = UIImage.init(data: self.longData)
            longData = Data()
            return
            
        }
            
        else if longData.isEmpty && data.first == start{
            self.longData.append(data)
            return
        }
        
        else if !longData.isEmpty && data.first != start && data.last != finish {
            self.longData.append(data)
            return
        }
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("YAYYY")
    }
    
    func setUpConnection() {
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try socket.bind(toPort: port)
            try socket.connect(toHost: hostIP, onPort: port)
            try socket.enableBroadcast(true)
            try socket.beginReceiving()
            send(message: "B")
        } catch let err {
            print(err)
        }
        
        
        //socket.send("B".data(using: .utf8)!, withTimeout: 2, tag: 0)
        //let str = "message received"

        //socket.send(str.data(using: .utf8)!, withTimeout: 2, tag: 0)
    }
    
    func send(message:String){
        guard let data = message.data(using: .utf8) else { return }
        socket.send(data, withTimeout: 2, tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConnection()
        print("oogo")
        
        let scene = GameScene(size: joystickView.bounds.size)
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        //let scene = GameScene(size: self.view.bounds.size)
        scene.backgroundColor = .white
        scene.periph = periph
        scene._characteristic = characteristic
        scene.characteristicList = characteristicList
        scene.slider = slider
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
        socket.close()
    }
}
