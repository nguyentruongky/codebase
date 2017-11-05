//
//  RecordView.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/27/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

protocol knRecordViewDelegate: class {
    
    func didFinishRecording(recordFileUrl: URL)
    
    func closeRecordView()
    
}

class knRecordView: knView {
    
    struct knFonts {
        
        private init() { }
        static let mediumFont = UIFont.systemFont(ofSize: 15)
        
    }
    
    struct knColors {
        private init() { }
        
        static let kn_127 = UIColor.color(value: 127)
        static let kn_229 = UIColor.color(value: 229)
        static let kn_241_147_78 = UIColor.color(r: 241, g: 147, b: 78)
        static let kn_133_189_175 = UIColor.color(r: 133, g: 189, b: 175)
        static let kn_119_203_189 = UIColor.color(r: 119, g: 203, b: 189)
        
    }
    
    
    
    fileprivate let howToStart = "Tap & Hold to Record Voice"
    fileprivate let howToCancel = "To cancel, drag your finger off record"
    fileprivate let readyToCancel = "Release to cancel recording"
    
    fileprivate var audioRecorder: AVAudioRecorder? /* recorder */
    
    fileprivate let timingLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = knFonts.mediumFont
        label.textColor = knColors.kn_127
        label.text = "00:00"
        label.numberOfLines = 0
        return label
    }() /* timingLabel */
    
    weak var delegate: knRecordViewDelegate?
    
    fileprivate lazy var descriptionLabel: UILabel = { [weak self] in
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = knFonts.mediumFont
        label.textColor = knColors.kn_127
        label.text = self?.howToStart
        label.numberOfLines = 0
        return label

    }() /* descriptionLabel */

    fileprivate lazy var recordButton: UIButton = { [weak self] in
        
        let title = "Record"
        let color = UIColor.white

        let button = UIButton()
        button.backgroundColor = knColors.kn_241_147_78
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = knFonts.mediumFont
        button.addTarget(self, action: #selector(handleStartRecording), for: .touchDown)
        button.addTarget(self, action: #selector(handleStopRecording), for: .touchUpInside)
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        return button
        
    }() /* recordButton */
    
    fileprivate var doCancel = false
    
    let cancelColorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = knColors.kn_241_147_78
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() /* cancelColorView */

    let recordBar: UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = knColors.kn_229
        view.clipsToBounds = true
        return view
        
    }() /* recordBar */
    
    let circleAnimationView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() /* circleAnimationView */
    
    let microImageView: UIImageView = {
        
        let imageName = "micro"
        let iv = UIImageView(image: UIImage(named: imageName)?.changeColor())
        iv.tintColor = knColors.kn_133_189_175
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }() /* microImageView */
    
    override func setupView() {

        let topBar = UIView()
        topBar.backgroundColor = .white
        topBar.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close")?.changeColor(), for: .normal)
        closeButton.tintColor = knColors.kn_119_203_189
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)

        topBar.addSubview(circleAnimationView)
        topBar.addSubview(microImageView)
        topBar.addSubview(timingLabel)
        topBar.addSubview(closeButton)
        
        circleAnimationView.size(CGSize(width: 32, height: 32))
        circleAnimationView.createRoundCorner(16)
        circleAnimationView.center(toView: microImageView)

        microImageView.size(CGSize(width: 12, height: 12))
        microImageView.vertical(toView: topBar)
        microImageView.left(toView: topBar, space: 16)
        
        closeButton.size(CGSize(width: 44, height: 44))
        closeButton.vertical(toView: topBar)
        closeButton.right(toView: topBar, space: -16)
        
        timingLabel.center(toView: topBar)

        recordBar.addSubview(recordButton)
        recordBar.addSubview(descriptionLabel)
        
        descriptionLabel.top(toView: recordBar, space: 8)
        descriptionLabel.centerX(toView: recordBar)
        
        recordButton.centerX(toView: recordBar)
        recordButton.centerY(toView: recordBar, space: 8)
        recordButton.size(CGSize(width: 90, height: 90))
        recordButton.createRoundCorner(45)
        addSubview(topBar)
        addSubview(recordBar)
        
        topBar.horizontal(toView: self)
        topBar.height(44)
        
        recordBar.horizontal(toView: self)
        recordBar.height(150)
        
        recordBar.insertSubview(cancelColorView, belowSubview: recordButton)
        cancelColorView.createRoundCorner(35)
        cancelColorView.size(toView: recordButton, greater: -20)
        cancelColorView.center(toView: recordButton)
        
        
        addConstraints(withFormat: "V:|[v0][v1]|", views: topBar, recordBar)

        setupRecorder()
    }

    var seconds = 0 {
        didSet {
            timingLabel.text = Date.dateFrom(second: seconds)?.toString("mm:ss")
        }
    }
    
    fileprivate var recording: Bool = false {
        didSet {    animateRecording()      }
    }

    fileprivate var timer: Timer? /* timer */
    
    fileprivate var fileRecordUrl: URL? /* fileRecordUrl */
    
    fileprivate func generateRecordUrl() -> URL {
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("fixir_rec_\(Date().toString("yy_MM_dd_hh_mm_ss"))")
        return soundFileURL
    }
    
    fileprivate func setupRecorder() {

        let recordSettings =
            [
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
                AVEncoderBitRateKey: 16,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100.0
                
            ] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            fileRecordUrl = generateRecordUrl()
            try audioRecorder = AVAudioRecorder(url: fileRecordUrl!, settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
            
        } catch let error as NSError {
            
            print("audioSession error: \(error.localizedDescription)")
        }
    }

}


extension knRecordView {
    
    func close() {
        removeFromSuperview()
    }
    
    func show() {
        
    }
}



// MARK: Handler and Animation
extension knRecordView {
    
    @objc func handleClose() {
        delegate?.closeRecordView()
    }
    
    @objc func handleTimer() {
        seconds += 1
    }

    fileprivate func animateRecording() {
        
        func doAnimate() {
            recordButton.setTitle(recording == true ? "Recording..." : "Record", for: .normal)
            descriptionLabel.text = recording == true ? howToCancel : howToStart
            timingLabel.textColor = recording == true ? knColors.kn_241_147_78 : knColors.kn_127
            let scale: CGFloat = recording == true ? 0.95 : 1
            recordButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        UIView.animate(withDuration: 0.2, animations: {     doAnimate()     })
    }
}








// MARK: Handle Recording
extension knRecordView {
    
    func setMicroViewAnimate(_ animate: Bool) {
        
        if animate == true {
            circleAnimationView.backgroundColor = knColors.kn_241_147_78
            circleAnimationView.transform = CGAffineTransform(scaleX: 1, y: 1)
            microImageView.tintColor = .white
            UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [.autoreverse, .repeat], animations: {
                self.circleAnimationView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            })
        }
        else {
            circleAnimationView.layer.removeAllAnimations()
            circleAnimationView.backgroundColor = .clear
            circleAnimationView.transform = CGAffineTransform(scaleX: 1, y: 1)
            microImageView.tintColor = knColors.kn_133_189_175
        }
    }
    
    @objc func handleStartRecording() {
        
        guard audioRecorder?.isRecording == false else { return }
        
        setMicroViewAnimate(true)
        setupRecorder()
        seconds = 0
        recording = true
        timingLabel.text = "00:00"
        
        audioRecorder?.record()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleStopRecording(tapGesture: UITapGestureRecognizer) {
        
        guard audioRecorder?.isRecording == true else { return }
        stopRecording()
        delegate?.didFinishRecording(recordFileUrl: fileRecordUrl!)
    }

    func stopRecording() {
        seconds = 0
        recording = false
        timer?.invalidate()
        audioRecorder?.stop()
        setMicroViewAnimate(false)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        func isOutsideOfButton() -> Bool {
            let location = gesture.location(in: recordButton)
            return location.x > recordButton.frame.width || location.y > recordButton.frame.height
        }
        
        func changeUiToCancelState() {

            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                self?.cancelColorView.transform = CGAffineTransform(scaleX: 10, y: 10)
            })

            descriptionLabel.text = readyToCancel
            descriptionLabel.textColor = .white
            recordButton.backgroundColor = .white
            recordButton.setTitleColor(knColors.kn_241_147_78, for: .normal)
        }
        
        func changeUiToNormalState() {
            recordButton.backgroundColor = knColors.kn_241_147_78
            recordButton.setTitleColor(.white, for: .normal)
            descriptionLabel.text = howToStart
            descriptionLabel.textColor = knColors.kn_241_147_78
        }
        
        func changeUiToRecordingState() {
            
            UIView.animate(withDuration: 0.1, animations: {
                self.cancelColorView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            changeUiToNormalState()
            descriptionLabel.text = howToCancel
        }

        switch gesture.state {
        case .began: break
            
        case .changed:
            let isMovingOutofButton = isOutsideOfButton()
            doCancel = isMovingOutofButton
            isMovingOutofButton ? changeUiToCancelState() : changeUiToRecordingState()
            break
            
        case .ended:
            
            cancelColorView.transform = CGAffineTransform(scaleX: 1, y: 1)
            changeUiToNormalState()
            
            guard audioRecorder?.isRecording == true else { return }
            stopRecording()
            
            if doCancel == false {
                delegate?.didFinishRecording(recordFileUrl: fileRecordUrl!)
            }
            
            break
            
        default:
            break
        }
    }
}





extension knRecordView: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
}
























