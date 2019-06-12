//
//  DragTableViewCell.swift
//  iRoboCar
//
//  Created by Daniel Morrison on 1/17/19.
//  Copyright © 2019 TheFabFive. All rights reserved.
//

import UIKit

protocol DragDelegate: class {
    func changeSpeedField(_ string: String, _ editingCell: DragTableViewCell)
    func changeDurationField(_ string: String, _ editingCell: DragTableViewCell)
}

class DragTableViewCell: UITableViewCell, UITextFieldDelegate{

    @IBOutlet weak var speedField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var directionImageView: UIImageView!
    weak var delegate: DragDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        speedField.delegate = self
        durationField.delegate = self
        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: "boopla")
        ]
        
        numberToolbar.sizeToFit()
        
        speedField.inputAccessoryView = numberToolbar
        durationField.inputAccessoryView = numberToolbar//do it for every relevant textfield if there are more than one
        // Do any additional setup after loading the view.
    }
    
    @objc func boopla () {
        speedField.resignFirstResponder()
        durationField.resignFirstResponder()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInstruction(instruction: Instruction){
        if instruction.direction == "forward"{
            directionImageView.image = UIImage(named: "up-arrow")
            speedField.text = "1"
            durationField.text = "1"
        }
        else if instruction.direction == "backward"{
            directionImageView.image = UIImage(named: "down-arrow")
            speedField.text = "1"
            durationField.text = "1"
        }
        else if instruction.direction == "right"{
            directionImageView.image = UIImage(named: "right-arrow")
            speedField.text = "1"
            durationField.text = "1"
        }
        else if instruction.direction == "left"{
            directionImageView.image = UIImage(named: "left-arrow")
            speedField.text = "1"
            durationField.text = "1"
        }
        else if instruction.direction == "stop"{
            directionImageView.image = UIImage(named: "stop")
            speedField.text = "0"
            durationField.text = "1"
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1{
            delegate?.changeSpeedField(textField.text!, self)
        }
        else if textField.tag == 2{
            delegate?.changeDurationField(textField.text!, self)
        }
        return true
    }
    
}
