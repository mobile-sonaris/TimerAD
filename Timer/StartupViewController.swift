//
//  StartupViewController.swift
//  Timer
//
//  Created by Hideo on 5/13/16.
//
//

import UIKit

class StartupViewController: UIViewController {

    @IBOutlet weak var slideMenuItem: UIBarButtonItem!
    
    @IBOutlet weak var viewallBtn: UIButton!
    @IBOutlet weak var restaurantBtn: UIButton!
    @IBOutlet weak var shoppingBtn: UIButton!
    @IBOutlet weak var fashionBtn: UIButton!
    @IBOutlet weak var beautyBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width * 0.7
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func slideMenuToggle(sender: AnyObject) {
        
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction func viewallBtnPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toHomeSegue", sender: nil)
    }
    
    @IBAction func restaurantBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toHomeSegue", sender: nil)
    }
    @IBAction func fashionBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toHomeSegue", sender: nil)
    }

    @IBAction func shoppingBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toHomeSegue", sender: nil)
    }
    @IBAction func favouriteBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toHomeSegue", sender: nil)
    }
    
    @IBAction func beautyBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toHomeSegue", sender: nil)
    }
    
}
