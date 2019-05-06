//
//  ViewController.swift
//  CoreAnimator_Starter
//
//  Created by Harrison Ferrone on 20.05.18.
//  Copyright © 2018 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signInButton.round(cornerRadius: 10, borderWidth: 3, borderColor: UIColor.white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Initially position the signInButton off screen
        signInButton.layer.position.y += AnimationHelper.screenBounds.height

        fadeInViews()
    }
    
    // MARK: User Actions
    @IBAction func SignInOnButtonPressed(_ sender: Any) {
        segueToNextViewController(segueID: Constants.Segues.loadingVC, withDelay: 1.0)
    }
    
    // MARK: Animations
    func fadeInViews() {
        let fade = AnimationHelper.basicFadeAnimation()
        fade.delegate = self
        titleLabel.layer.add(fade, forKey: nil)
        
        // Add a delay of 1 second
        fade.beginTime = AnimationHelper.addDelay(time: 1.0)
        usernameField.layer.add(fade, forKey: nil)
        
        fade.beginTime = AnimationHelper.addDelay(time: 2.0)
        fade.setValue("password", forKey: "animation_name")
        passwordField.layer.add(fade, forKey: nil)
    }
    
    func animateButtonWithSpring() {
        let moveUp = CASpringAnimation(keyPath: AnimationHelper.posY)
        
        // Add the screen height to the signInButton y value to position it off screen
        moveUp.fromValue = signInButton.layer.position.y + AnimationHelper.screenBounds.height
        moveUp.toValue = signInButton.layer.position.y - AnimationHelper.screenBounds.height
        moveUp.duration = moveUp.settlingDuration
        
        // Spring physics properties
        moveUp.initialVelocity = 5
        moveUp.mass = 1  // the heavier the mass, the longer this animation will run
        moveUp.stiffness = 75
        moveUp.damping = 12 // controls how long the animation lasts by simulating friction
        
        // Set the final value of the signInButton position.y before adding the animation.
        /*
            The final postion matches the animation.toValue
            The initial position matches the animation.fromValue
         */
        signInButton.layer.position.y -= AnimationHelper.screenBounds.height
        signInButton.layer.add(moveUp, forKey: nil)
    }
}

// MARK: Delegate Extensions

extension SignInViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // look up key-value pair
        guard let animName = anim.value(forKey: "animation_name") as? String else {
            return
        }
        
        switch animName {
        case "password":
            animateButtonWithSpring()
        default: break
        }
    }
}
