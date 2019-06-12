//
//  ProgrammingViewController.swift
//  iRoboCar
//
//  Created by Daniel Morrison on 1/17/19.
//  Copyright © 2019 TheFabFive. All rights reserved.
//

import UIKit
import SwiftReorder
import CoreBluetooth

class ProgrammingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DragDelegate{
    
    func changeSpeedField(_ string: String, _ editingCell: DragTableViewCell) {
        let indexPath: IndexPath = dragTableView.indexPath(for: editingCell)!
        if Double(string)! > Double(1){
            let alert = UIAlertController(title: "Value out of range", message: "Please enter a different value", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            present(alert, animated: true, completion: nil)
        }
        else{
            instructions[indexPath.row].speed = Double(string)
        }
    }
    
    func changeDurationField(_ string: String, _ editingCell: DragTableViewCell) {
        let indexPath: IndexPath = dragTableView.indexPath(for: editingCell)!
        instructions[indexPath.row].duration = Double(string)
    }
    
    func poll(_ characteristic: CBCharacteristic){
        self.periph.readValue(for: characteristic)
    }
    
    var periph: CBPeripheral!
    var _characteristic: CBCharacteristic!
    var characteristicList: [CBCharacteristic]!
    @IBOutlet weak var dragTableView: UITableView!
    @IBOutlet weak var ultraColor: UISegmentedControl!
    var instructions = [Instruction]()
    
    @IBAction func goBtn(_ sender: Any) {
        //Execute chain of instructions via BLE by iterating through Instructions array
        //for i in instructions
        
        let ultraCBUUID = CBUUID(string: ULTRASONIC_DETECTOR)
        let ultraCharacteristic = characteristicList.first {$0.uuid == ultraCBUUID}
        
        DispatchQueue.main.async {
            MyGlobalTimer.sharedInstance.internalTimer = Timer()
            MyGlobalTimer.sharedInstance.internalTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){_ in
                //print("nonsense")
                self.poll(ultraCharacteristic!)
            }
        }
        
        for (index, i) in instructions.enumerated() {
            
            let speed = i.speed / 5
            
            if i.direction == "backward"{
                //Send servo angle (0) since we're going straight backwards
                var servoAngle = Float(0)
                var data1 = Data(buffer: UnsafeBufferPointer(start: &servoAngle, count: 1))
                data1.insert(0x01, at: 0)
                data1.insert(0x01, at: 1)
                let servoCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let servoCharacteristic = self.characteristicList.first {$0.uuid == servoCBUUID}
                self.periph!.writeValue(data1, for: servoCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                
                //Send motor speed
                var fltspeed = Float(-speed)
                var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
                data.insert(0x00, at: 0)
                data.insert(0x01, at: 1)
                let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
                self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                print("backward")
                usleep(useconds_t(i.duration*pow(10, 6)))
            }
                
            else if i.direction == "forward" || i.direction == "stop"{
                //Send servo angle (0) since we're going straight backwards
                var servoAngle = Float(0)
                var data1 = Data(buffer: UnsafeBufferPointer(start: &servoAngle, count: 1))
                data1.insert(0x01, at: 0)
                data1.insert(0x01, at: 1)
                let servoCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let servoCharacteristic = self.characteristicList.first {$0.uuid == servoCBUUID}
                self.periph!.writeValue(data1, for: servoCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                
                //Send motor speed
                var fltspeed = Float(speed)
                var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
                data.insert(0x00, at: 0)
                data.insert(0x01, at: 1)
                let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
                self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                print("forward")
                usleep(useconds_t(i.duration*pow(10, 6)))
            }
                
            else if i.direction == "right"{
                //Send servo angle (4.5) since we're going straight backwards
                var servoAngle = Float(4.5)
                var data1 = Data(buffer: UnsafeBufferPointer(start: &servoAngle, count: 1))
                data1.insert(0x01, at: 0)
                data1.insert(0x01, at: 1)
                let servoCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let servoCharacteristic = self.characteristicList.first {$0.uuid == servoCBUUID}
                self.periph!.writeValue(data1, for: servoCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                
                //Send motor speed
                var fltspeed = Float(speed)
                var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
                data.insert(0x00, at: 0)
                data.insert(0x01, at: 1)
                let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
                self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                print("right")
                usleep(useconds_t(i.duration*pow(10, 6)))
            }
                
            else if i.direction == "left"{
                //Send servo angle (-4.5) since we're going straight backwards
                var servoAngle = Float(-4.5)
                var data1 = Data(buffer: UnsafeBufferPointer(start: &servoAngle, count: 1))
                data1.insert(0x01, at: 0)
                data1.insert(0x01, at: 1)
                let servoCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let servoCharacteristic = self.characteristicList.first {$0.uuid == servoCBUUID}
                self.periph!.writeValue(data1, for: servoCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                
                //Send motor speed
                var fltspeed = Float(speed)
                var data = Data(buffer: UnsafeBufferPointer(start: &fltspeed, count: 1))
                data.insert(0x00, at: 0)
                data.insert(0x01, at: 1)
                let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                let speedCharacteristic = self.characteristicList.first {$0.uuid == speedCBUUID}
                self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
                print("left")
                usleep(useconds_t(i.duration*pow(10, 6)))
            }
            
            /*if index == self.instructions.count - 1{
                var data = Data()
                let quitSpeed = 0
                let quitData = UInt8(quitSpeed)
                data.append(quitData)
                //let speedCBUUID = CBUUID(string: SET_MOTOR_CHARACTERISTIC_UUID)
                //let speedCharacteristic = characteristicList.first {$0.uuid == speedCBUUID}
                //self.periph!.writeValue(data, for: speedCharacteristic!, type: CBCharacteristicWriteType.withResponse)
            }*/
        }
    }
    @IBAction func forward(_ sender: Any) {
        let newInstruct = Instruction(duration: "1", speed: "1", direction: "forward")
        instructions.append(newInstruct)
        let indexPath = IndexPath(row: instructions.count - 1, section: 0)
        dragTableView.beginUpdates()
        dragTableView.insertRows(at: [indexPath], with: .automatic)
        dragTableView.endUpdates()
        view.endEditing(true)
    }
    
    @IBAction func backward(_ sender: Any) {
        let newInstruct = Instruction(duration: "1", speed: "1", direction: "backward")
        instructions.append(newInstruct)
        let indexPath = IndexPath(row: instructions.count - 1, section: 0)
        dragTableView.beginUpdates()
        dragTableView.insertRows(at: [indexPath], with: .automatic)
        dragTableView.endUpdates()
        view.endEditing(true)
    }
    
    @IBAction func stop(_ sender: Any) {
        let newInstruct = Instruction(duration: "1", speed: "0", direction: "stop")
        instructions.append(newInstruct)
        let indexPath = IndexPath(row: instructions.count - 1, section: 0)
        dragTableView.beginUpdates()
        dragTableView.insertRows(at: [indexPath], with: .automatic)
        dragTableView.endUpdates()
        view.endEditing(true)
    }
    @IBAction func left(_ sender: Any) {
        let newInstruct = Instruction(duration: "1", speed: "1", direction: "left")
        instructions.append(newInstruct)
        let indexPath = IndexPath(row: instructions.count - 1, section: 0)
        dragTableView.beginUpdates()
        dragTableView.insertRows(at: [indexPath], with: .automatic)
        dragTableView.endUpdates()
        view.endEditing(true)
    }
    
    @IBAction func right(_ sender: Any) {
        let newInstruct = Instruction(duration: "1", speed: "1", direction: "right")
        instructions.append(newInstruct)
        let indexPath = IndexPath(row: instructions.count - 1, section: 0)
        dragTableView.beginUpdates()
        dragTableView.insertRows(at: [indexPath], with: .automatic)
        dragTableView.endUpdates()
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if instructions.isEmpty == true{
            return 0
        }
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        if !instructions.isEmpty {
            let instruct = instructions[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! DragTableViewCell
            cell.delegate = self
            cell.setInstruction(instruction: instruct)
            return cell
        }

        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            instructions.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragTableView.tableFooterView = UIView()
        dragTableView.reorder.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension ProgrammingViewController: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data model
        instructions.swapAt(sourceIndexPath.item, destinationIndexPath.item)
        print(instructions)
        for i in instructions{
            print(i.direction)
        }
    }
}
