//
//  SinInViewController.swift
//  railswiftiOS
//
//  Created by 水野徹 on 2018/09/16.
//  Copyright © 2018年 Toru Mizuno. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SinInViewController: UIViewController {
    
    @IBOutlet weak var signupname: UITextField!
    @IBOutlet weak var signupemail: UITextField!
    @IBOutlet weak var signuppassword: UITextField!
    
    @IBOutlet weak var loginemail: UITextField!
    @IBOutlet weak var loginpassword: UITextField!
    
    @IBOutlet weak var updatepassword1: UITextField!
    @IBOutlet weak var updatepassword2: UITextField!
    
    @IBOutlet weak var profileupdatename: UITextField!
    @IBOutlet weak var profileupdateemail: UITextField!
    
    
    //これらは取得したらすぐにAppDelegateにあげるのが望ましい
    var accesstoken: String!
    var client: String!
    var uid:String!
    
    //このページで通信して保存や呼び出しをするのに、一旦待機させたいので作っている
    var webuserid: Int!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signupbutton(_ sender: Any) {
        
        //パラメーターを辞書で入れていく//左辺がカラム名、右辺が値
        var params: [String: String] = [:]
        params["user_name"] = signupname.text!
        params["email"] = signupemail.text!
        params["password"] = signuppassword.text!
        
        Alamofire.request("http://localhost:3000/api/auth", method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            //エラーがなかった場合
            if response.response?.statusCode == 200 {
                
                //responseからヘッダー情報を取り出して変数に保存する
                self.accesstoken = (response.response?.allHeaderFields["access-token"] as? String)!
                self.client = (response.response?.allHeaderFields["client"] as? String)!
                self.uid = (response.response?.allHeaderFields["uid"] as? String)!
                
                //通信後にこれらの情報を取ってこれていた場合は
                if self.accesstoken != nil && self.client != nil && self.uid != nil {
                    print("webuser保存に成功しました")
                    
                    //responseから保存したアカウントデータのIDを抜き出す
                    let json:JSON = JSON(response.result.value ?? kill)
                    json.forEach { (arg) in
                        let (_, json) = arg
                        self.webuserid = json["id"].intValue
                        //ユーザー名を取り出すのもあり
                    }
                    
                    let webuserid: Int = self.webuserid//optionalをintに変換
                    let accesstoken: String = self.accesstoken//optionalをintに変換
                    let client: String = self.client//optionalをintに変換
                    let uid: String = self.uid//optionalをintに変換
                    
                    print("accesstoken: \(String(describing: accesstoken))")
                    print("client: \(String(describing: client))")
                    print("uid: \(String(describing: uid))")
                    print("WebuserID: \(String(describing: webuserid))")
                    
                    let webuser = Webuser()
                    //パラメーターセット
                    webuser.web_user_id = webuserid
                    
                    //appDelegateに上げる
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.webuser = webuser
                    appDelegate.accesstoken = accesstoken
                    appDelegate.client = client
                    appDelegate.uid = uid
                    
                }
                
                //エラーがあった場合
            } else {
                print("Error: \(String(describing: response.error))")
            }
            
        }
    }
    
    
    
    
    @IBAction func loginbutton(_ sender: Any) {
        //パラメーターを辞書で入れていく//左辺がカラム名、右辺が値
        var params: [String: String] = [:]
        params["email"] = loginemail.text!
        params["password"] = loginpassword.text!
        
        Alamofire.request("http://localhost:3000/api/auth/sign_in", method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            //エラーがなかった場合
            if response.response?.statusCode == 200 {
                
                //responseからヘッダー情報を取り出して変数に保存する
                self.accesstoken = (response.response?.allHeaderFields["access-token"] as? String)!
                self.client = (response.response?.allHeaderFields["client"] as? String)!
                self.uid = (response.response?.allHeaderFields["uid"] as? String)!
                
                //通信後にこれらの情報を取ってこれていた場合は
                if self.accesstoken != nil && self.client != nil && self.uid != nil {
                    
                    //responseからとって来たアカウントのデータのIDを抜き出す
                    let json:JSON = JSON(response.result.value ?? kill)
                    json.forEach { (arg) in
                        let (_, json) = arg
                        self.webuserid = json["id"].intValue
                        //ユーザー名を取り出すのもあり
                    }
                    
                    let webuserid: Int = self.webuserid//optionalをintに変換
                    let accesstoken: String = self.accesstoken//optionalをstringに変換
                    let client: String = self.client//optionalをstringに変換
                    let uid: String = self.uid//optionalをstringに変換
                    
                    print("WebuserID: \(String(describing: webuserid))")
                    print("accesstoken: \(String(describing: accesstoken))")
                    print("client: \(String(describing: client))")
                    print("uid: \(String(describing: uid))")
                    
                    let webuser = Webuser()
                    //パラメーターセット
                    webuser.web_user_id = webuserid
                    
                    //appDelegateに上げる
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.webuser = webuser
                    appDelegate.accesstoken = accesstoken
                    appDelegate.client = client
                    appDelegate.uid = uid
                    
                }
                //エラーがあった場合何度か通信を試みてみる
            } else {
                
                //何度か通信を試みてみる
                
                print("Error: \(String(describing: response.error))")
            }
            
        }
    }
    
    
    
    
    @IBAction func updatepasswordbutton(_ sender: Any) {
        //パラメーターを辞書で入れていく//左辺がカラム名、右辺が値
        var params: [String: String] = [:]
        params["password"] = updatepassword1.text!
        params["password_confirmation"] = updatepassword1.text!
        
        //ログインやサインアップでこれらの情報を取ってこれていた場合は
        if self.accesstoken != nil && self.client != nil && self.uid != nil {
            
            //取り出したトークン情報をヘッダーに格納
            var headers: [String : String] = [:]
            headers["access-token"] = self.accesstoken
            headers["client"] = self.client
            headers["uid"] = self.uid
            
            print("Request: \(String(describing: self.accesstoken))")
            print("Request: \(String(describing: self.client))")
            print("Request: \(String(describing: self.uid))")
            
            Alamofire.request("http://localhost:3000/api/auth/password", method: .put, parameters: params, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                //アクセスできた場合
                if response.response?.statusCode == 200 {
                    print("パスワード変更にアクセスできました")
                    
                    //アクセスできなかった場合
                } else {
                    
                    //何度か通信を試みてみる
                    
                    print("パスワード変更にアクセスできませんでした")
                    
                }
                
            }
            
            //ヘッダー情報を取ってこれていなかった場合
        } else {
            
            //ログインしていないと警告を出す
            
        }
        
    }
    
    
    
    
    @IBAction func profileupdatebutton(_ sender: Any) {
        
        //パラメーターを辞書で入れていく//左辺がカラム名、右辺が値
        var params: [String: String] = [:]
        params["user_name"] = profileupdatename.text!
        params["email"] = profileupdateemail.text!
        
        //ログインやサインアップでこれらの情報を取ってこれていた場合は
        if self.accesstoken != nil && self.client != nil && self.uid != nil {
            
            //取り出したトークン情報をヘッダーに格納
            var headers: [String : String] = [:]
            headers["access-token"] = self.accesstoken
            headers["client"] = self.client
            headers["uid"] = self.uid
            
            print("Request: \(String(describing: self.accesstoken))")
            print("Request: \(String(describing: self.client))")
            print("Request: \(String(describing: self.uid))")
            
            Alamofire.request("http://localhost:3000/api/auth", method: .put, parameters: params, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                //アクセスできた場合(webuser側の更新ができた場合)
                if response.response?.statusCode == 200 {
                    print("パスワード以外の変更にアクセスできました")
                    print("webuserの更新に成功しました")
                    
                    //更新したwebuserのIDを抜き出す
                    
                    //responseから保存したアカウントデータのIDを抜き出す
                    let json:JSON = JSON(response.result.value ?? kill)
                    json.forEach { (arg) in
                        let (_, json) = arg
                        self.webuserid = json["id"].intValue
                        //ユーザー名を取り出すのもあり
                    }
                    //アクセスできたら、再びアクセストークンなどをレスポンスから取り出す必要がある
                    //responseからヘッダー情報を取り出して変数に保存する
                    self.accesstoken = (response.response?.allHeaderFields["access-token"] as? String)!
                    self.client = (response.response?.allHeaderFields["client"] as? String)!
                    self.uid = (response.response?.allHeaderFields["uid"] as? String)!
                    
                    let webuserid: Int = self.webuserid//optionalをintに変換
                    let accesstoken: String = self.accesstoken//optionalをStringに変換
                    let client: String = self.client//optionalをStringに変換
                    let uid: String = self.uid//optionalをStringに変換
                    
                    print("accesstoken: \(String(describing: accesstoken))")
                    print("client: \(String(describing: client))")
                    print("uid: \(String(describing: uid))")
                    print("WebuserID: \(String(describing: webuserid))")
                    
                    let webuser = Webuser()
                    //パラメーターセット
                    webuser.web_user_id = webuserid
                    
                    //appDelegateに上げる
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.webuser = webuser
                    appDelegate.accesstoken = accesstoken
                    appDelegate.client = client
                    appDelegate.uid = uid
                    
                    //変更にアクセスできなかった場合
                } else {
                    
                    print("変更にアクセスできませんでした")
                    
                }
                
            }
            
            //ヘッダー情報を取ってこれていなかった場合
        } else {
            
            //ログインしていないと警告を出す
            
        }
        
    }
    
    
    

}
