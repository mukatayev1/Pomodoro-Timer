//
//  ViewController.swift
//  Pomodoro Focus Timer
//
//  Created by AZM on 2020/10/03.
//

import UIKit

class TimerViewController: UIViewController {
    
    var workingTime: Bool = true
    
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var workingTimeLeft: TimeInterval = 10
    var restingTimeLeft: TimeInterval = 5
    var endTime: Date?
    var timer = Timer()
    let pulseLayer = CAShapeLayer()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 36, weight: .light)
        return label
    }()
    
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
            135, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 10
        view.layer.addSublayer(bgShapeLayer)
    }
    
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
            135, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        
        timeLeftShapeLayer.strokeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 10
        timeLeftShapeLayer.lineCap = CAShapeLayerLineCap.round
        timeLeftShapeLayer.strokeEnd = 0
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
//
    func drawPulsatingLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 138, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 2.0
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.strokeColor = UIColor.purple.cgColor
        pulseLayer.lineCap = .round
        pulseLayer.position = view.center
        view.layer.addSublayer(pulseLayer)
    }
    
    func animatePulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.0
        animation.toValue = 1.4
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        pulseLayer.add(animation, forKey: "scale")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        onOffButtonSubviewed()
        cancelButtonSubviewed()
        activateCancelButton()
        activateButton()
//        //pulsating layer
//        animatePulse()
        
        //timer circle
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        drawPulsatingLayer()
        drawBgShape()
        drawTimeLeftShape()
        drawPulsatingLayer()
        view.addSubview(timeLabel)
        timeLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 100)
        timeLabel.center = view.center
//        // here you define the fromValue, toValue and duration of your animation
//        strokeIt.fromValue = 0
//        strokeIt.toValue = 1
//        strokeIt.duration = timeLeft
//        strokeIt.isRemovedOnCompletion = false
//        // add the animation to your timeLeftShapeLayer
//        timeLeftShapeLayer.add(strokeIt, forKey: nil)
////         define the future end time by adding the timeLeft to now Date()
//        endTime = Date().addingTimeInterval(timeLeft)
//        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    //MARK: - Buttons creation
    
    var onOffButton = OnOffButton()
    var isOn = false
//    var currentLabel = onOffLabels[0]
    
    func onOffButtonSubviewed() {
        view.addSubview(onOffButton)
        onOffButton.translatesAutoresizingMaskIntoConstraints = false
        onOffButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        onOffButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        onOffButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        onOffButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
    }
    
    @objc func OnOffbuttonPressed() {
        
        if onOffButton.currentTitle == "Start" {
            startTimer()
            
            isOn.toggle()
            
            let color = isOn ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1): UIColor.clear
            let title = isOn ? "Pause": "Resume"
            let titleColor = isOn ? .white: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            
            onOffButton.setTitle(title, for: .normal)
            onOffButton.setTitleColor(titleColor, for: .normal)
            onOffButton.backgroundColor = color
        } else {
            isOn.toggle()
            
            let color = isOn ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1): UIColor.clear
            let title = isOn ? "Pause": "Resume"
            let titleColor = isOn ? .white: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            let functionality = isOn ? resumeTimer():pauseTimer()
            
            onOffButton.setTitle(title, for: .normal)
            onOffButton.setTitleColor(titleColor, for: .normal)
            onOffButton.backgroundColor = color
        }
    }
    
    func activateButton() {
        onOffButton.addTarget(self, action: #selector(OnOffbuttonPressed), for: .touchUpInside)
    }
    
    func resetButton() {
        isOn = false
        onOffButton.setTitle("Start", for: .normal)
        onOffButton.backgroundColor = .clear
        onOffButton.setTitleColor(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), for: .normal)
    }

    
    var cancelButton = CancelButton()
    
    func cancelButtonSubviewed() {
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
    func activateCancelButton() {
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
    
    @objc func cancelButtonPressed() {
        resetTimer()
        resetButton()
    }
    
    //MARK: - Functionality
    func startTimer() {
        print("Start process")
        if workingTime {
            //pulsating layer
            animatePulse()
            
    //       define the future end time by adding the timeLeft to now Date()
            endTime = Date().addingTimeInterval(workingTimeLeft)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            // here you define the fromValue, toValue and duration of your animation
    //        strokeIt.fromValue = 0
            strokeIt.toValue = 1
            strokeIt.duration = workingTimeLeft
            strokeIt.isRemovedOnCompletion = false
            // add the animation to your timeLeftShapeLayer
            timeLeftShapeLayer.add(strokeIt, forKey: nil)
        } else {
            print("start resting time")
            //pulsating layer
            animatePulse()
            
    //       define the future end time by adding the timeLeft to now Date()
            endTime = Date().addingTimeInterval(restingTimeLeft)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            // here you define the fromValue, toValue and duration of your animation
    //        strokeIt.fromValue = 0
            strokeIt.toValue = 1
            strokeIt.duration = restingTimeLeft
            strokeIt.isRemovedOnCompletion = false
            // add the animation to your timeLeftShapeLayer
            timeLeftShapeLayer.add(strokeIt, forKey: nil)
            
        }
    }
    
    func pauseTimer() {
        print("Pause the process")
    }
    
    func resumeTimer() {
        print("Resume the process")
    }
    
    func resetTimer() {
        print("Reset the process")
    }
    
    //MARK: - @objc Functions
    
    @objc func updateTime() {
        if workingTime {
            if workingTimeLeft > 0 {
                workingTimeLeft = endTime?.timeIntervalSinceNow ?? 0
                timeLabel.text = workingTimeLeft.time
                //        timeLabel.font = UIFont(name: "AvenirNext", size: 60)
            } else {
                timeLabel.text = "00 : 00"
                timer.invalidate()
                timeLabel.textColor = UIColor.green
                workingTime = false
                resetButton()
            }
        }
        else {
            if restingTimeLeft > 0 {
                restingTimeLeft = endTime?.timeIntervalSinceNow ?? 0
                timeLabel.text = restingTimeLeft.time
                //        timeLabel.font = UIFont(name: "AvenirNext", size: 60)
            } else {
                timeLabel.text = "00 : 00"
                timer.invalidate()
                timeLabel.textColor = UIColor.red
                workingTime = true
                resetButton()
            }
        }
    }

}

extension TimeInterval {
    var time: String {
        return String(format:"%02d : %02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
