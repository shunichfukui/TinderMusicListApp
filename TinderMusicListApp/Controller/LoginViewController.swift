//
//  LoginViewController.swift
//  TinderMusicListApp
//
//  Created by USER on 2021/10/10.
//

import UIKit
import Firebase
import FirebaseAuth
import DTGradientButton

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        //ボタンの背景色
        loginButton.setGradientBackgroundColors([UIColor(hex: "E21F70"), UIColor(hex: "FF4D2C")], direction: .toLeft, for: .normal)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func login(_ sender: Any) {
        //もしfieldの値が空でない場合
        if textField.text?.isEmpty != true {
            //textFieldの値（ニックネーム）を自分のアプリ内に保存しておく
            UserDefaults.standard.set(textField.text, forKey: "userName")
        } else {
            //空ならば振動させる
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            print("エラー")
        }
        //FirebaseAuthの中にIDと名前(textField.text)を入れる
        Auth.auth().signInAnonymously { (result, error) in
            if error == nil {
                guard let user = result?.user else{ return }
                
                let userID = user.uid
                UserDefaults.standard.set(userID, forKey: "userID")
                let saveProfile = SaveProfile(userID: userID, userName: self.textField.text!)
                saveProfile.saveProfile()
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
}
