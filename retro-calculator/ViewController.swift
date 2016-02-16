//
//  ViewController.swift
//  retro-calculator
//
//  Created by Hector Rios on 15/02/16.
//  Copyright © 2016 mosby. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl : UILabel!
    
    //MARK: Enums
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
//        case Equals = "="
        case Empty = "Empty"
    }
    
    //MARK: Properties
    
    var buttonSound : AVAudioPlayer!
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation : Operation = Operation.Empty
    var result = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOfURL: soundUrl)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    
    @IBAction func numberPressed(sender: UIButton!) {
        self.playSound()
        
        runningNumber += "\(sender.tag)"
        self.outputLbl.text = runningNumber
    }
    
    
    @IBAction func onDividePresses(sender: UIButton) {
        processOperation(Operation.Divide)
    }


    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    
    @IBAction func onSubtractPressed(sender: UIButton) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    
    @IBAction func onEqualPressed(sender: UIButton) {
        processOperation(self.currentOperation)
    }
    
    //MARK: private functions
    
    func processOperation(op: Operation) {
        self.playSound()
        
        if currentOperation != Operation.Empty {
            
            if self.runningNumber != "" {
                //Run some math
                rightValStr = self.runningNumber
                self.runningNumber = ""
                
                switch currentOperation {
                    
                case Operation.Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                case Operation.Add:
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                case Operation.Divide:
                    //prevent divide by 0
                    if rightValStr == "0" {
                        result = "ERROR"
                    } else {
                        result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                    }
                case Operation.Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                default:
                    //Should never get here.
                    result = "Invalid Operation"
                }
                
                if (result != "ERROR" && result != "Invalid Operation") {
                    leftValStr = result
                }
                
                outputLbl.text = result
            }
            
            currentOperation = op

            
        } else {
            //this is the first time an operator has been pressed.
            leftValStr = self.runningNumber
            self.runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound() {
        if (buttonSound.play()) {
            buttonSound.stop()
            buttonSound.play()
        }
        
        buttonSound.play()
    }
    
}

