//
//  ViewController.swift
//  simpleScoreboardDemo
//
//  Created by rjjq on 2022/7/20.
//

import UIKit
import Foundation

struct Stack {
    private var items: [State] = []
    
    func peek() -> State? {
        guard let topElement = items.first else { return nil }
        return topElement
    }
    
    mutating func pop() -> State {
        return items.removeFirst()
    }
    
    mutating func push(_ element: State) {
        items.insert(element, at: 0)
    }
}

struct State {
    let leftScoresValue: Int
    let rightScoresValue: Int
    let leftWinsValue: Int
    let rightWinsValue: Int
    let played: Int
    let leftServeLabelValue: Bool
    let rightServeLabelValue: Bool
    let leftName: String
    let rightName: String
}

class ViewController: UIViewController {
    @IBOutlet weak var leftScores: UIButton!
    @IBOutlet weak var rightScores: UIButton!
    @IBOutlet weak var leftWins: UIButton!
    @IBOutlet weak var rightWins: UIButton!
    @IBOutlet weak var leftServeLabel: UILabel!
    @IBOutlet weak var rightServeLabel: UILabel!
    @IBOutlet weak var leftNameText: UITextField!
    @IBOutlet weak var rightNameText: UITextField!
    
    var leftScoresValue = 0
    var rightScoresValue = 0
    var leftWinsValue = 0
    var rightWinsValue = 0
    var played = 0
    var states = Stack()
    var leftName = "player 1"
    var rightName = "player 2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        reset(0)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }

    @IBAction func rewind(_ sender: Any) {
        if states.peek() != nil {
            let state = states.pop()
            
            leftScoresValue = state.leftScoresValue
            rightScoresValue = state.rightScoresValue
            leftWinsValue = state.leftWinsValue
            rightWinsValue = state.rightWinsValue
            played = state.played
            
            leftServeLabel.isHidden = state.leftServeLabelValue
            rightServeLabel.isHidden = state.rightServeLabelValue
            
            leftNameText.text = state.leftName
            rightNameText.text = state.rightName
            
            updateAllScores()
        }
    }
    
    func snapshot() {
        let state = State(leftScoresValue: leftScoresValue, rightScoresValue: rightScoresValue, leftWinsValue: leftWinsValue, rightWinsValue: rightWinsValue, played: played, leftServeLabelValue: leftServeLabel.isHidden, rightServeLabelValue: rightServeLabel.isHidden, leftName: leftName, rightName: rightName)
        
        states.push(state)
    }
    
    func toggleServe() {
        leftServeLabel.isHidden = !leftServeLabel.isHidden
        rightServeLabel.isHidden = !rightServeLabel.isHidden
    }
    
    func swapName() {
        (leftName, rightName) = (rightName, leftName)
        leftNameText.text = leftName
        rightNameText.text = rightName
    }
    
    func updateAllScores() {
        leftWins.setTitle(String(leftWinsValue), for: .normal)
        rightWins.setTitle(String(rightWinsValue), for: .normal)
        leftScores.setTitle(String(leftScoresValue), for: .normal)
        rightScores.setTitle(String(rightScoresValue), for: .normal)
    }
    
    func checkStatus() {
        if leftScoresValue == 11 && rightScoresValue < 10 {
            leftWinsValue += 1
            updateAllScores()
            clearScores()
            return
        }
        
        if rightScoresValue == 11 && leftScoresValue < 10 {
            rightWinsValue += 1
            updateAllScores()
            clearScores()
            return
        }
        
        if (leftScoresValue < 10 && rightScoresValue < 10) ||
           (leftScoresValue >= 10 && rightScoresValue < 10) ||
           (leftScoresValue < 10 && rightScoresValue >= 10) {
            if played % 2 == 0 {
                toggleServe()
            }
        } else if leftScoresValue >= 10 && rightScoresValue >= 10 {
            
            if (leftScoresValue - rightScoresValue) > 1 {
                leftWinsValue += 1
                updateAllScores()
                clearScores()
                return
            }
            
            if (rightScoresValue - leftScoresValue) > 1 {
                rightWinsValue += 1
                updateAllScores()
                clearScores()
                return
            }
            
            toggleServe()
        }
    }
    
    func clearScores() {
        played = 0
        leftScoresValue = 0
        rightScoresValue = 0
        updateAllScores()
    }
    
    @IBAction func changeSide(_ sender: Any) {
        snapshot()
        
        swapName()
        toggleServe()
        
        (leftWinsValue, rightWinsValue) = (rightWinsValue, leftWinsValue)
        (leftScoresValue, rightScoresValue) = (rightScoresValue, leftScoresValue)
        
        updateAllScores()
    }
    
    @IBAction func reset(_ sender: Any) {
        played = 0
        
        leftServeLabel.isHidden = false
        rightServeLabel.isHidden = true
        
        leftScoresValue = 0
        rightScoresValue = 0
        leftWinsValue = 0
        rightWinsValue = 0
        
        leftNameText.text = leftName
        rightNameText.text = rightName
        
        updateAllScores()
    }
    
    @IBAction func addLeftScore(_ sender: Any) {
        snapshot()
        
        played += 1
        leftScoresValue += 1
        updateAllScores()
        checkStatus()
    }
    
    @IBAction func addRightScore(_ sender: Any) {
        snapshot()
        
        played += 1
        rightScoresValue += 1
        updateAllScores()
        checkStatus()
    }
    
    @IBAction func addLeftWin(_ sender: Any) {
        snapshot()
        
        leftWinsValue += 1
        updateAllScores()
    }
    
    
    @IBAction func addRightWin(_ sender: Any) {
        snapshot()
        
        rightWinsValue += 1
        updateAllScores()
    }
    
    @IBAction func updateLeftName(_ sender: Any) {
        leftName = leftNameText.text ?? ""
    }
    
    @IBAction func updateRightName(_ sender: Any) {
        rightName = rightNameText.text ?? ""
    }
}

