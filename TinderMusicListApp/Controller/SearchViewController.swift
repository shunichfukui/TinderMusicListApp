//
//  SearchViewController.swift
//  TinderMusicListApp
//
//  Created by USER on 2021/10/10.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON
import DTGradientButton
import Firebase
import FirebaseAuth
import ChameleonFramework


class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIImageView!
    @IBOutlet weak var listButton: UIButton!

    var artistNameArray = [String]()
    var musicNameArray = [String]()
    var previewURLArray = [String]()
    var imageStringArray = [String]()
    var userID = String()
    var userName = String()
    var autoID = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "autoID") != nil {
            autoID = UserDefaults.standard.object(forKey: "autoID") as! String
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
        
        if UserDefaults.standard.object(forKey: "userID") != nil  && UserDefaults.standard.object(forKey: "userName") != nil {
            userID = UserDefaults.standard.object(forKey: "userID") as! String
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        favButton.setGradientBackgroundColors([UIColor(hex: "E21F70"), UIColor(hex: "FF4D2C")], direction: .toLeft, for: .normal)
        listButton.setGradientBackgroundColors([UIColor(hex: "FF8968"), UIColor(hex: "FF62A5")], direction: .toLeft, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ナビゲーションバーの色を変える
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.flatRed()
        //ナビゲーションバーのbackボタン消す
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Searchを行う
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    

    @IBAction func moveToSelectCardView(_ sender: Any) {
        //パースを行う
    }
    
    func moveToCard(){
        performSegue(withIdentifier: "selectVC", sender: nil)
    }
    
    
}
