//
//  SaveProfile.swift
//  MusicListShare
//
//  Created by USER on 2021/10/02.
//

import Foundation
import Firebase
import PKHUD

class SaveProfile {
    //サーバーに値を飛ばす
    var userID:String! = ""
    var userName:String! = ""
    var ref:DatabaseReference!
    
    init(userID:String, userName:String) {
        self.userID = userID
        self.userName = userName
        
        //ログインの時に拾えるuidを先頭につけて送信する　受診時もuidから引っ張ってくる
        ref = Database.database().reference().child("profile").childByAutoId()
    }
    init(snapShot:DataSnapshot) {
        ref = snapShot.ref
        if let value = snapShot.value as? [String:Any] {
            userID = value["userID"] as? String
            userName = value["userName"] as? String
        }
    }

    func toContents()->[String:Any] {
        return ["userID":userID!, "userName":userName as Any]
    }

    func saveProfile() {
        ref.setValue(toContents())
        UserDefaults.standard.set(ref.key, forKey: "autoID")
    }
}
