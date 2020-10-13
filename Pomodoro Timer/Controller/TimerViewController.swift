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
    
    var workingTimeLeftInSecs: Int = 1500
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
        label.text = "25 : 00"
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
    
    //MARK: - Func from Settings page
    
//    func randomFunction(sender: UIButton) {
//
//        let vc =  SetupViewController()
//        self.present(vc, animated: true, completion: nil)
//
//        vc.completionHandler = { interval in
//            DispatchQueue.main.async {
//                self.didSetupTime(chosenInterval: interval)
//            }
//        }
//    }
//
//    private func didSetupTime(chosenInterval: TimeInterval) {
//        let difference = chosenInterval
//        if difference > 0 {
//            let hrs: Int = Int(difference / 3600)
//            let remainder: Int = Int(difference) - (hrs*3600)
//            let mins: Int = remainder / 60
//            let secs: Int = Int(difference) - (hrs*3600) - (mins*60)
//
//            hours = hrs
//            minutes = mins
//            seconds = secs
//            timeLabel.text = ("\(hrs) : \(mins) : \(secs)")
//            print("\(hrs) : \(mins) : \(secs)")
//        } else {
//            print("negative countdown")
//        }
//    }
    
    //MARK: - Functionality
    func startTimer() {
        print("Start process")
        isTimerRunning = true
        //        pulsating layer
        animatePulse()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        strokeIt.toValue = 1
        strokeIt.duration = CFTimeInterval(workingTimeLeftInSecs)
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
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
        
        timer.invalidate()
        workingTimeLeftInSecs = 10    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
//        timeLabel.text = dataFromSetupVC
        
        isTimerRunning = false
    }
    
    //MARK: - @objc Functions
    
    @objc func updateTime() {
        if workingTimeLeftInSecs > 1 {
            workingTimeLeftInSecs -= 1
//            timeLabel.text = dataFromSetupVC
            
        } else {
            timeLabel.text = "00 : 00"
            timer.invalidate()
            //            timeLabel.textColor = UIColor.green
            //            workingTime = false
            resetButton()
            pulseLayer.removeAllAnimations()
        }
    }
    
//    func updateTimer() {
//        if seconds > 0 {
//            //decrement seconds
//            seconds = seconds - 1
//        } else if minutes > 0 && seconds == 0{
//            //decrement minutes
//            minutes = minutes - 1
//            seconds = 59
//        } else if hours > 0 && minutes == 0 && seconds == 0 {
//            //decrement hours
//            hours = hours - 1
//            minutes = 59
//            seconds = 59
//        }
////        updateLabel()
//    }
    
    
    
    
}

//MARK: - Extensions

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
