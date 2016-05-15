//
//  BaseService.swift
//  Timer
//
//  Created by Hideo on 5/14/16.
//
//

import Foundation
import Firebase

let BASE_URL = "https://incandescent-heat-8326.firebaseio.com"
let FIREBASE_REF  = Firebase(url: BASE_URL)

let TWITTER_API_KEY = "DzOykhnbEU7vtafFcr7THnTvf"
let TWITTER_AUTH_HELPER = TwitterAuthHelper(firebaseRef: FIREBASE_REF, apiKey: TWITTER_API_KEY)

var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    return currentUser!
}
 