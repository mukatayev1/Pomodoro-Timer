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
    var seconds: Int = 0
    var durationSeconds: Int = 0
    
//    var workingTimeLeftInSecs: Int = 10
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var isOn = false
    var timer = Timer()
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    let pulseLayer = CAShapeLayer()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 40, weight: .thin)
        return label
    }()
    
    
    func timeLabelSubviewed() {
        view.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "#working time"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        //        label.font = UIFont(name: "AvenirNext", size: 36)
        return label
    }()
    
    func textLabelSubviewed() {
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
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
        
        timeLeftShapeLayer.strokeColor = #colorLiteral(red: 0.4352941176, green: 0.2901960784, blue: 0.5568627451, alpha: 1).cgColor
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
        pulseLayer.strokeColor = #colorLiteral(red: 0.6666666667, green: 0.2901960784, blue: 0.5568627451, alpha: 1).cgColor
        pulseLayer.lineCap = .round
        pulseLayer.position = view.center
        view.layer.addSublayer(pulseLayer)
    }
    
    func animatePulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        pulseLayer.add(animation, forKey: "scale")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8058375635, green: 0.8058375635, blue: 0.8058375635, alpha: 1)
        overrideUserInterfaceStyle = .light
        onOffButtonSubviewed()
        cancelButtonSubviewed()
        setTimerButtonSubviewed()
        timeLabelSubviewed()
        textLabelSubviewed()
        activateCancelButton()
        activateButton()
        activateSetTimerButton()
        timerLabel.text = String(seconds)
        
        //timer circle
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
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
            
            let color = isOn ? #colorLiteral(red: 0.4352941176, green: 0.2901960784, blue: 0.5568627451, alpha: 1): UIColor.clear
            let title = isOn ? "Pause": "Resume"
            let titleColor = isOn ? .white: #colorLiteral(red: 0.4352941176, green: 0.2901960784, blue: 0.5568627451, alpha: 1)
            
            onOffButton.setTitle(title, for: .normal)
            onOffButton.setTitleColor(titleColor, for: .normal)
            onOffButton.backgroundColor = color
        } else {
            isOn.toggle()
            
            let color = isOn ? #colorLiteral(red: 0.4352941176, green: 0.2901960784, blue: 0.5568627451, alpha: 1): UIColor.clear
            let title = isOn ? "Pause": "Resume"
            let titleColor = isOn ? .white: #colorLiteral(red: 0.4352941176, green: 0.2901960784, blue: 0.5568627451, alpha: 1)
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
        onOffButton.setTitleColor(#colorLiteral(red: 0.4352941176, green: 0.2901960784, blue: 0.5568627451, alpha: 1), for: .normal)
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
    
    //Set Timer Button
    var setTimerButton = OnOffButton()
    
    func setTimerButtonSubviewed() {
        view.addSubview(setTimerButton)
        setTimerButton.setTitle("Set Timer", for: .normal)
        setTimerButton.translatesAutoresizingMaskIntoConstraints = false
        setTimerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        setTimerButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        setTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setTimerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
    }
    
    func activateSetTimerButton() {
        setTimerButton.addTarget(self, action: #selector(SetTimerButtonPressed), for: .touchUpInside)
    }
    
    @objc func SetTimerButtonPressed() {
        //delegate
        let controller = SetupViewController()
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    //MARK: - Functionality
    
    func startTimer() {
        print("Start process")
        isTimerRunning = true
        //        pulsating layer
        animatePulse()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
//        strokeIt.byValue = 1/seconds
        strokeIt.duration = CFTimeInterval(durationSeconds)
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
        print(durationSeconds)
    }
    
    func resumeTimer() {
        print("Resume the process")
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        let pausedTime = timeLeftShapeLayer.timeOffset
        timeLeftShapeLayer.speed = 1.0
        timeLeftShapeLayer.timeOffset = 0.0
        timeLeftShapeLayer.beginTime = 0.0
        let timeSincePause = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        timeLeftShapeLayer.beginTime = timeSincePause
        
    }
    
    func resetTimer() {
        print("Reset the process")
        timeLeftShapeLayer.removeAllAnimations()
        pulseLayer.removeAllAnimations()
        
        timer.invalidate()
        
        isTimerRunning = false
    }

    //MARK: - @objc Functions
    
    @objc func updateTimer() {
        if seconds > 0 {
            //decrement seconds
            seconds = seconds - 1
        } else if minutes > 0 && seconds == 0 {
            minutes = minutes - 1
            seconds = 59
        } else if hours > 0 && minutes == 0 && seconds == 0 {
            hours = hours - 1
            minutes = 59
            seconds = 59
        }
        timerLabel.text = secondConverter(seconds)
    }
    
    func secondConverter(_ secondsToConvert: Int) -> String {
        
        let hrs: Int = secondsToConvert / 3600
        let remainderFromHrs: Int = secondsToConvert - (hrs * 3600)
        let mins: Int = remainderFromHrs / 60
        let secs: Int = secondsToConvert - (hrs * 3600) - (mins * 60)
        
        hours = hrs
        minutes = mins
        seconds = secs
        
        var convertedTimer = ""
        if secondsToConvert > 3599 {
            convertedTimer = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        } else {
            convertedTimer = String(format: "%02d : %02d", minutes, seconds)
        }
        
        return convertedTimer
//        print(convertedTimer)
    }
    
    func timeLabelUpdateFromDelegate(time: TimeInterval) {
        durationSeconds = Int(time)
        timerLabel.text = secondConverter(durationSeconds)
        
    }
    
    
}

//MARK: - Extensions

extension TimerViewController: SetupViewControllerDelegate {
    func didSetTimer(_ time: TimeInterval) {
        self.dismiss(animated: true) {
            self.timeLabelUpdateFromDelegate(time: time)
//            self.converter(secondsToConvert self.durationSeconds)
        }
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
