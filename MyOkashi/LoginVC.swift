//
//  LoginVC.swift
//  MyOkashi
//
//  Created by User5 on 2018/03/08.
//  Copyright © 2018年 User5. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var memberData: MemberData?
    
    @IBOutlet weak var emailText: UITextField!    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var incorrectImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailText.delegate = self
        self.passwordText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapLoginButton(_ sender: Any) {
        
        if isCheckLogin() {
            
            loginFlag = 1
            //画面を閉じる
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            //ログイン失敗時の音と画像を表示
            failLogin()
            
            //ポップアップの作成
            let alertMessage = "メールアドレスまたはパスワードが違います"
            let alertTitle = "警告"
            
            //アラートダイアログを生成
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            
            //OKボタンの定義
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in }
            
            //OKボタンを追加
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            
            //入力テキストのクリア
            emailText.text = ""
            passwordText.text = ""
            
            return
            
        }
        
    }
    
    private func isCheckLogin() -> Bool {
        //メールアドレスのチェック
        if emailText.text != memberData?.email {
            return false
        }
        //パスワードのチェック
        if passwordText.text != memberData?.password {
            return false
        }
        return true
    }

    //不正解の時は×を表示して消す
    private func failLogin() {
        //不正解を伝える音を鳴らす
        AudioServicesPlayAlertSound(1024)
        //アニメーション
        UIView.animate(withDuration: 2.0, animations: {
            self.incorrectImageView.alpha = 1.0
            self.incorrectImageView.alpha = 0.0
        })

    }
    
    // Returnキーを押したと判定される直前イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }

}
