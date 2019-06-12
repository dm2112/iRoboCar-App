//
//  GameScene.swift
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//
import SpriteKit
import WebKit
import Foundation
import CoreBluetooth
import Charts

class GameScene: SKScene {
    var periph: CBPeripheral!
    var _characteristic: CBCharacteristic!
    var characteristicList: [CBCharacteristic]!
    var appleNode: SKSpriteNode?
    let setJoystickStickImageBtn = SKLabelNode()
    let setJoystickSubstrateImageBtn = SKLabelNode()
    let joystickStickColorBtn = SKLabelNode(text: "Sticks random color")
    let joystickSubstrateColorBtn = SKLabelNode(text: "Substrates random color")
    var slider : UISlider!
    var prevQuantXVelo: Double = 0
    var prevQuantYVelo: Double = 0
    //var rightPercent = SKLabelNode()
    //var leftPercent = SKLabelNode()
    
    var numbers : [Double] = []
    
    var joystickStickImageEnabled = false {
        didSet {
            //let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveAnalogStick.stick.image = nil//image
            steerAnalogStick.stick.image = nil//image
            //setJoystickStickImageBtn.text = "\(joystickStickImageEnabled ? "Remove" : "Set") stick image"
        }
    }
    
    var joystickSubstrateImageEnabled = false {
        didSet {
            //let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrate.image = nil//image
            steerAnalogStick.substrate.image = nil//image
            //setJoystickSubstrateImageBtn.text = "\(joystickSubstrateImageEnabled ? "Remove" : "Set") substrate image"
        }
    }
    
    let moveAnalogStick = 🕹(diameter: 100) // from Emoji
    let steerAnalogStick = AnalogJoystick(diameter: 100) // from Class

    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        
        backgroundColor = UIColor.clear
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 40, y: moveAnalogStick.radius + 40)
        addChild(moveAnalogStick)
        steerAnalogStick.position = CGPoint(x: self.frame.maxX - steerAnalogStick.radius - 40, y:steerAnalogStick.radius + 40)
        //rightPercent.position = CGPoint(x: self.frame.maxX - steerAnalogStick.radius - 20, y: steerAnalogStick.radius + 120)
        //leftPercent.position = CGPoint(x: self.frame.maxX - moveAnalogStick.radius - 20, y: moveAnalogStick.radius + 120)
        addChild(steerAnalogStick)
        //addChild(rightPercent)
        var start = DispatchTime.now().uptimeNanoseconds // Start time
        var end: UInt64!   // End time
        
        //MARK: Handlers begin
        moveAnalogStick.beginHandler = { [unowned self] in
            
        }
        
        moveAnalogStick.trackingHandler = { [unowned self] jData in
            var quantYVelo = Double(0)
            if self.slider != nil{
                quantYVelo = Double(jData.velocity.y) / (250 - Double(self.slider.value))
            }
            else{
                quantYVelo = Double(jData.velocity.y) / 250
            }
            
            print(quantYVelo)
            //self.leftPercent.text = String(quantYVelo*20) + "%"
            //self.leftPercent.fontSize = 40
            
            //large enough change in joystick to send a new command.
            if abs(self.prevQuantYVelo-quantYVelo) >= 0.015
            {
                //self.numbers.append(quantYVelo)
                //self.updateGraph()
                var fltspeed = Float(quantYVelo)
                var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
                data.insert(0x00, at: 0)
                data.insert(0x00, at: 1)
                //let data = string.data(using: String.Encoding.utf8)
                let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
                self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                self.prevQuantYVelo = quantYVelo
            }
            
            else{
                //User has camped out on a certain section of the joystick, so send a signal
                //every two seconds while they are on the same zone.
                end = DispatchTime.now().uptimeNanoseconds
                if end - start >= 2000000000{
                    start = DispatchTime.now().uptimeNanoseconds
                    var fltspeed: Float!
                    fltspeed = Float(quantYVelo)
                    var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
                    data.insert(0x00, at: 0)
                    data.insert(0x00, at: 1)
                    //let data = string.data(using: String.Encoding.utf8)
                    let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                    let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
                    self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                }
            }
        }
        
        moveAnalogStick.stopHandler = { [unowned self] in
            
            var fltspeed: Float!
            fltspeed = Float(0)
            
            var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
            data.insert(0x00, at: 0)
            data.insert(0x00, at: 1)
            //let data = string.data(using: String.Encoding.utf8)
            let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
            let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
            self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
        
        steerAnalogStick.trackingHandler = { [unowned self] jData in
            let quantXVelo = Double(jData.velocity.x) / 10
            //self.rightPercent.text = String(quantXVelo*20) + "%"
            //self.rightPercent.fontSize = 40
            //self.rightPercent.text = String(quantXVelo) + "%"
            
            
            if abs(self.prevQuantXVelo-quantXVelo) >= 1
            {
                var fltspeed = Float(quantXVelo)
                var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
                data.insert(0x01, at: 0)
                data.insert(0x00, at: 1)
                //let data = string.data(using: String.Encoding.utf8)
                let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                print(self.characteristicList)
                let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
                self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                self.prevQuantXVelo = quantXVelo
            }
        }
        
        steerAnalogStick.stopHandler =  { [unowned self] in
            
        }
        
        //MARK: Handlers end
        //let selfHeight = frame.height
        let btnsOffset: CGFloat = 10
        let btnsOffsetHalf = btnsOffset / 2
        
        setJoystickStickImageBtn.fontColor = UIColor.black
        setJoystickStickImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .bottom
        setJoystickStickImageBtn.position = CGPoint(x: frame.midX, y: moveAnalogStick.position.y - btnsOffsetHalf)
        addChild(setJoystickStickImageBtn)
        
        setJoystickSubstrateImageBtn.fontColor  = UIColor.black
        setJoystickSubstrateImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .top
        setJoystickSubstrateImageBtn.position = CGPoint(x: frame.midX, y: moveAnalogStick.position.y + btnsOffsetHalf)
        addChild(setJoystickSubstrateImageBtn)
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        
        setRandomStickColor()
        
        view.isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            let node = atPoint(touch.location(in: self))
            
            switch node {
            case setJoystickStickImageBtn:
                joystickStickImageEnabled = !joystickStickImageEnabled
            case setJoystickSubstrateImageBtn:
                joystickSubstrateImageEnabled = !joystickSubstrateImageEnabled
            case joystickStickColorBtn:
                setRandomStickColor()
            case joystickSubstrateColorBtn:
                setRandomSubstrateColor()
            default: break
                
            }
        }
    }
    
    func setRandomStickColor() {
        let randomColor = UIColor.random()
        moveAnalogStick.stick.color = randomColor
        steerAnalogStick.stick.color = randomColor
    }
    
    func setRandomSubstrateColor() {
        let randomColor = UIColor.random()
        moveAnalogStick.substrate.color = randomColor
        steerAnalogStick.substrate.color = randomColor
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    /*func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        lineChart.data = data //finally - it adds the chart data to the chart and causes an update
        //lineChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }*/
}

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}

class JoystickNumbers{
    
    static let shared = JoystickNumbers()
    
    init(){}
    var x: Double!
    var y: Double!
}
