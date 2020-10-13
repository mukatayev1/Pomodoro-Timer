//
//  ViewController.swift
//  Pomodoro Focus Timer
//
//  Created by AZM on 2020/10/03.
//

import UIKit

class TimerViewController: UIViewController {
    
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 3600
    
//    var workingTimeLeftInSecs: Int = 10
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var isOn = false
    var timer = Timer()
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    let pulseLayer = CAShapeLayer()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00 ; 00"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 40, weight: .thin)
        return label
    }()
    
    func timeLabelSubviewed() {
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "#working time"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        //        label.font = UIFont(name: "AvenirNext", size: 36)
        return label
    }()
    
    func textLabelSubviewed() {
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -280).isActive = true
    }
    
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius: 135, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 10
        view.layer.addSublayer(bgShapeLayer)
    }
    
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius: 135, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        
        timeLeftShapeLayer.strokeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 10
        timeLeftShapeLayer.lineCap = CAShapeLayerLineCap.round
        timeLeftShapeLayer.strokeEnd = 0
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    func drawPulsatingLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 138, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 2.0
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.strokeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        pulseLayer.lineCap = .round
        pulseLayer.position = view.center
        view.layer.addSublayer(pulseLayer)
    }
    
    func animatePulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 1.0
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
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        onOffButtonSubviewed()
        cancelButtonSubviewed()
        timeLabelSubviewed()
        textLabelSubviewed()
        activateCancelButton()
        activateButton()
        timeLabel.text = converter(time: TimeInterval(seconds))
        
        //timer circle
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        drawPulsatingLayer()
        drawBgShape()
        drawTimeLeftShape()
        drawPulsatingLayer()
        
    }
    
    //MARK: - Buttons creation
    
    //Start, Resume, Pause Button
    var onOffButton = OnOffButton()
    
    func onOffButtonSubviewed() {
        view.addSubview(onOffButton)
        onOffButton.translatesAutoresizingMaskIntoConstraints = false
        onOffButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        onOffButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        onOffButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        onOffButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
    }
    
    @objc func OnOffbuttonPressed() {
        if onOffButton.currentTitle == "Start" &&  isTimerRunning == false {
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
            let _: () = isOn ? resumeTimer():pauseTimer()
            
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
    
    //Cancel Button
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
        isTimerRunning = true
        //        pulsating layer
        animatePulse()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        strokeIt.toValue = 1
        strokeIt.duration = CFTimeInterval(seconds)
        strokeIt.isRemovedOnCompletion = false
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
    }
    
    func pauseTimer() {
        print("Pause the process")
        timer.invalidate()
        
        let pausedTime = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        timeLeftShapeLayer.speed = 0.0
        timeLeftShapeLayer.timeOffset = pausedTime
        isTimerRunning = false
    }
    
    func resumeTimer() {
        print("Resume the process")
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        let pausedTime = timeLeftShapeLayer.timeOffset
        timeLeftShapeLayer.speed = 1.0
        timeLeftShapeLayer.timeOffset = 0.0
        timeLeftShapeLayer.beginTime = 0.0
        let timeSincePause = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        print(timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime)
        timeLeftShapeLayer.beginTime = timeSincePause
        
    }
    
    func resetTimer() {
        print("Reset the process")
        timeLeftShapeLayer.removeAllAnimations()
        pulseLayer.removeAllAnimations()
        
        timer.invalidate()
        seconds = 10    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
//        timeLabel.text = dataFromSetupVC
        
        isTimerRunning = false
    }
    
    func converter(time: TimeInterval) -> String {
        var timeConverted = ""
        if seconds > 0 {
            let hrs: Int = Int(seconds / 3600)
            let remainder: Int = Int(seconds) - (hrs*3600)
            let mins: Int = remainder / 60
            let secs: Int = Int(seconds) - (hrs*3600) - (mins*60)
            
            hours = hrs
            minutes = mins
            seconds = secs
            
            if seconds >= 3600 {
                timeConverted = String(format:"S%02i : %02i : %02i", hours, minutes, seconds)
            } else {
                timeConverted = String(format:"%02i : %02i", minutes, seconds)
            }
        }
        return timeConverted
    }

    //MARK: - @objc Functions
    
    @objc func updateTimer() {
        if seconds > 0 {
            //decrement seconds
            seconds = seconds - 1
        } else if minutes > 0 && seconds == 0 {
            //decrement minutes
            minutes = minutes - 1
            seconds = 59
        } else if hours > 0 && minutes == 0 && seconds == 0 {
            //decrement hours
            hours = hours - 1
            minutes = 59
            seconds = 59
        } else if hours == 0 && minutes == 0 && seconds == 1{
            timeLabel.text = "00 : 00"
            timer.invalidate()
            resetButton()
            pulseLayer.removeAllAnimations()
        } 
//        timeLabel.text = converter(time: TimeInterval(seconds))
    }
    
//    @objc func updateTimer() {
//        if seconds > 0 {
//            //decrement seconds
//            seconds = seconds - 1
//        } else if minutes > 0 && seconds == 0 {
//            //decrement minutes
//            minutes = minutes - 1
//            seconds = 59
//        } else if hours > 0 && minutes == 0 && seconds == 0 {
//            //decrement hours
//            hours = hours - 1
//            minutes = 59
//            seconds = 59
//        } else {
//
//            timeLabel.text = "00 : 00"
//            timer.invalidate()
//            resetButton()
//            pulseLayer.removeAllAnimations()
//        }
//        updateLabel()
//    }
    
//    func updateLabel() {
//
//        if seconds > 3600 {
//            timeLabel.text = "\(hours) : \(minutes) : \(seconds)"
//        } else {
//            timeLabel.text = "\(minutes) : \(seconds)"
//        }
//
//    }
    
    
    
}

//MARK: - Extensions

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
