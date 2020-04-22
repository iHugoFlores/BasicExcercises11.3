//
//  ViewController.swift
//  AccessOne
//
//  Created by Josue Arambula on 4/20/20.
//  Copyright © 2020 Josue Arambula. All rights reserved.
//

import UIKit
import LocalAuthentication

//enum LAError : Int {
//    case AuthenticationFailed
//    case UserCancel
//    case UserFallback
//    case SystemCancel
//    case PasscodeNotSet
//    case TouchIDNotAvailable
//    case TouchIDNotEnrolled
//}

class ViewController: UIViewController, UIAlertViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationWithTouchID()
    }
    
    
    @IBOutlet weak var grayView: UIView!
    
    
    @IBOutlet weak var testButton: UILabel!
    
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var greenView: UIView!
     @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var salesCountLabel: UIButton!
    
    


    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         testButton.text = NSLocalizedString("String with spaces", comment: "the label color name etc bla bla bla")
    }
    

    @IBAction func changeColor(_ sender: Any) {
        
        segmentedControl.isAccessibilityElement = false
        
        switch segmentedControl.selectedSegmentIndex
           {
           case 0:
            blueView.isHidden = true
            greenView.isHidden = false
            grayView.isHidden = true
            
            blueView.isAccessibilityElement = false
            grayView.isAccessibilityElement = false
            
            greenView.isAccessibilityElement = true
            greenView.accessibilityIdentifier = NSLocalizedString("String with spaces", comment: "the color of the view")
            greenView.accessibilityLabel = "a new label"
            
           case 1:
               blueView.isHidden = false
               greenView.isHidden = true
               grayView.isHidden = true
            
            
            greenView.isAccessibilityElement = false
            grayView.isAccessibilityElement = false
            
            blueView.isAccessibilityElement = true
            blueView.accessibilityIdentifier = "blue"
            blueView.accessibilityLabel = "Blue Demon"
            
            
        case 2:
            blueView.isHidden = true
            greenView.isHidden = true
            grayView.isHidden = false
           default:
               break
           }
        
    }

    
//func showPasswordAlert() {
//    let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
//    ac.addAction(UIAlertAction(title: "OK", style: .default))
//    present(ac, animated: true)
//}

}

extension ViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"


        
        var authError: NSError?
        let reasonString = "To access the secure data, please"
        if #available(iOS 8.0, macOS 10.12.1, *) {
            // Check if the device can evaluate the policy.
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                
                localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                          //TODO: User authenticated successfully, take appropriate action
                            // completion()
                            print("User was authenticated correctly")
                        } else {
                          //TODO: User did not authenticate successfully, look at error and take appropriate action
                          guard let error = evaluateError else { return }
                          print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                          
                          //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                        }
                    }
                }
            } else {
                guard let error = authError else { return }
                //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
                print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
            }
        }

    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case LAError.biometryNotAvailable.rawValue:
                    message = "Authentication could not start because the device does not support biometric authentication."
                
                case LAError.biometryLockout.rawValue:
                    message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
                case LAError.biometryNotEnrolled.rawValue:
                    message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
                default:
                    message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
                case LAError.touchIDLockout.rawValue:
                    message = "Too many failed attempts."
                
                case LAError.touchIDNotAvailable.rawValue:
                    message = "TouchID is not available on the device"
                
                case LAError.touchIDNotEnrolled.rawValue:
                    message = "TouchID is not enrolled on the device"
                
                default:
                    message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
