//
//  SignViewController.swift
//  Timer
//
//  Created by Hideo on 5/12/16.
//
//

import UIKit
import Firebase

class SignViewController: UIViewController, UIActionSheetDelegate, UITextFieldDelegate {

    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.layer.masksToBounds = true
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.whiteColor().CGColor
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        usernameField.layer.masksToBounds = true
        usernameField.layer.borderWidth = 1
        usernameField.layer.borderColor = UIColor.whiteColor().CGColor
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordField.layer.masksToBounds = true
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.whiteColor().CGColor
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignViewController.photoTapped))
        
        photoView.userInteractionEnabled = true
        photoView.addGestureRecognizer(tapGestureRecognizer)
        
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func clearBtnPressed(sender: AnyObject) {
        
        emailField.text = ""
        passwordField.text = ""
        usernameField.text = ""
        
    }
    
    
    @IBAction func registerBtnPressed(sender: AnyObject) {
        
        if emailField.text != "" && passwordField.text != "" && usernameField.text != "" {
            
            NSLog("Register progress")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var _ : NSError
            var _: NSDictionary
            
            appDelegate.appRootRef.createUser(emailField.text, password: passwordField.text, withValueCompletionBlock: { error, result in
                if error != nil {
                    
                }else {
                    let uid = result["uid"] as? String
                    NSLog("successfully created user account with uid: \(uid)")
                    
                }
            })
        }else {
            NSLog("Register Warning")
            let alertController = UIAlertController(title: "Warning!", message: "Please input your info", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        switch buttonIndex {
        case 1:
            NSLog("take photo")
        case 2:
            NSLog("photo library")
        default:
            break
        }
    }

    func photoTapped() {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Photo Library")
        actionSheet.showInView(self.view)
        }
}
