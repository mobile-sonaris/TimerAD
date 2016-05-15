//
//  LoginViewController.swift
//  Timer
//
//  Created by Hideo on 5/12/16.
//
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.layer.masksToBounds = true
        emailField.layer.borderColor = UIColor.whiteColor().CGColor
        emailField.layer.borderWidth = 1.0
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordField.layer.masksToBounds = true
        passwordField.layer.borderColor = UIColor.whiteColor().CGColor
        passwordField.layer.borderWidth = 1.0
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        emailField.delegate = self
        passwordField.delegate = self
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil {
            
            NSLog("\(CURRENT_USER.authData)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func loginBtnPressed(sender: AnyObject) {
        
        let email = self.emailField.text
        let password = self.passwordField.text
        
        self.performSegueWithIdentifier("toStartupSegue", sender: nil)
        
        if email != "" && password != "" {
            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: {
                (error, authData) -> Void in
                if error == nil {
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    print("Logged In : ")
                    //self.performSegueWithIdentifier("toStartupSegue", sender: nil)
                }else {
                    print(error)
                }
            })
        }else {
            
            let alert = UIAlertController(title: "Error", message: "Enter Email and password", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        /* logout code */
        //CURRENT_USER.unauth()
        //NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        /*             */
    }
    
    
    
    @IBAction func forgotBtnPressed(sender: AnyObject) {
        
        
    }
    @IBAction func fbBtnPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toStartupSegue", sender: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {(facebookResult, facebookError) ->
            Void in
            if facebookError != nil {
                print("Facebook login failed. Error\(facebookError)")
            }else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            }else {
                print("Facebook login success")
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                appDelegate.appRootRef.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Login failed. \(error)")
                    }else {
                        print("Logged in! \(authData)")
                        //self.performSegueWithIdentifier("toStartupSegue", sender: nil)
                        let newUser = [
                            "provider": authData.provider,
                            "displayName": authData.providerData["displayName"] as? NSString as? String,
                            "email": authData.providerData["email"] as? NSString as? String
                        ]
                        
                        appDelegate.appRootRef.childByAppendingPath("users")
                        .childByAppendingPath(authData.uid).setValue(newUser)
                        
                        //// to Start up view controller 
                        let mainStoryboard = UIStoryboard.init(name: "Storyboard", bundle: nil)
                        let mainNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("MainNavigationController")
                        self.presentViewController(mainNavigationController, animated: true, completion: nil)
                    }
                    
                });
                
            }
        });
    }
    @IBAction func twitterBtnPressed(sender: AnyObject) {
        
        TWITTER_AUTH_HELPER.selectTwitterAccountWithCallback { (error, accounts) in
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }else if accounts.count == 1 {
                let account = accounts[0] as? ACAccount
                TWITTER_AUTH_HELPER.authenticateAccount(account, withCallback: { (error, authData) in
                    if error != nil {
                        
                        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }else {
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                        print("Logged in ")
                
                    }
                })
            }
            
            else if accounts.count > 1 {
                let actionSheetController = UIAlertController(title: "Select Twitter Account", message: nil, preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                actionSheetController.addAction(cancelAction)
                
                for account in accounts {
                    let twitterAccountAction = UIAlertAction(title: account.username, style: .Default, handler: { (action) in
                        let twitterHandle = action.title
                        for account in TWITTER_AUTH_HELPER.accounts {
                            if twitterHandle == account.username {
                                
                                TWITTER_AUTH_HELPER.authenticateAccount(account as! ACAccount, withCallback: { (error, authData) in
                                    if error != nil {
                                        
                                        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                                        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                        alert.addAction(action)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }else {
                                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                                        print("Logged in ")
                                        
                                    }
                                })
                            }
                        }
                    })
                    
                    actionSheetController.addAction(twitterAccountAction)
                }
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
        }
                
    }
    @IBAction func createBtnPressed(sender: AnyObject) {
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
}
