//
//  LoadingViewController.swift
//  CoreAnimator_Starter
//
//  Created by Harrison Ferrone on 05.06.18.
//  Copyright © 2018 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var setupLabel: UILabel!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clockImage.round(cornerRadius: clockImage.frame.size.width/2, borderWidth: 4, borderColor: UIColor.black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let titleAnimGroup = CAAnimationGroup()
        titleAnimGroup.duration = 1.5
        titleAnimGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        titleAnimGroup.repeatCount = .infinity
        titleAnimGroup.autoreverses = true
        
        titleAnimGroup.animations = [positionPulse(), scalePulse()]
        
        loadingLabel.layer.add(titleAnimGroup, forKey: "title_group")
    
        clockImage.layer.add(createKeyFrameColorAnimation(), forKey: "color_change")
        
        clockImage.layer.position = CGPoint(x: AnimationHelper.screenBounds.width + 200, y: AnimationHelper.screenBounds.height - 250)
        clockImage.layer.add(bounceKeyframeAnimation(), forKey: "bounce")
    }
    
    func positionPulse() -> CABasicAnimation {
        let posY = CABasicAnimation(keyPath: AnimationHelper.posY)
        posY.fromValue = loadingLabel.layer.position.y - 20
        posY.toValue = loadingLabel.layer.position.y + 20
        
        return posY
    }
    
    func scalePulse() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: AnimationHelper.scale)
        scale.fromValue = 1.1
        scale.toValue = 1
        
        return scale
    }
    
    // MARK: Keyframe Animations
    func createKeyFrameColorAnimation() -> CAKeyframeAnimation {
        let colorChange = CAKeyframeAnimation(keyPath: AnimationHelper.borderColor)
        colorChange.duration = 1.5
        colorChange.beginTime = AnimationHelper.addDelay(time: 1.0)
        colorChange.values = [
            UIColor.white.cgColor,
            UIColor.yellow.cgColor,
            UIColor.red.cgColor,
            UIColor.black.cgColor
        ]
        
        colorChange.keyTimes = [0.0, 0.25, 0.75, 1.0] // always have to start with 0.0 and end with 1.0 (these are percentages)
        
        return colorChange
    }
    
    func bounceKeyframeAnimation() -> CAKeyframeAnimation {
        let bounce = CAKeyframeAnimation(keyPath: AnimationHelper.position)
        
        bounce.duration = 3.0
        bounce.values = [
            NSValue(cgPoint: CGPoint(x: 25, y: AnimationHelper.screenBounds.height - 25)), // lower left-hand corner of the screen
            NSValue(cgPoint: CGPoint(x: 175, y: AnimationHelper.screenBounds.height - 100)),
            NSValue(cgPoint: CGPoint(x: 325, y: AnimationHelper.screenBounds.height - 25)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width + 200, y: AnimationHelper.screenBounds.height - 250))
        ]
        
        bounce.keyTimes = [0.0, 0.3, 0.6, 1.0]
        
        return bounce
    }
    
    // MARK: Transitions
}

// MARK: Delegate Extensions
extension LoadingViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //guard let animName = anim.value(forKey: "animation_name") as? String else { return }
    }
}
