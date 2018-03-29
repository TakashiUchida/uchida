//
//  MemberRegistVC.swift
//  MyOkashi
//
//  Created by User5 on 2018/03/08.
//  Copyright © 2018年 User5. All rights reserved.
//

import UIKit
import SwiftCop

class MemberRegistVC: UIViewController, UITextFieldDelegate, UIToolbarDelegate {
    
//    private let swiftcop = SwiftCop()
    
    //変数を宣言する
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()

    var toolBar:UIToolbar!
    
    let swiftCop = SwiftCop()
    var memberData: MemberData?
    
    
    @IBOutlet weak var userLastNameText: UITextField!
    @IBOutlet weak var userFirstNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var birthdayText: UITextField!
    
    let birthdayPicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userLastNameText.delegate = self
        self.userFirstNameText.delegate = self
        self.emailText.delegate = self
        self.passwordText.delegate = self
        self.birthdayText.delegate = self
        
        setupUI()
        setValidation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI() {

        setupPicker()
        
        //会員情報があるなら表示
        if memberData == nil {
            return
        }
        userLastNameText.text = memberData!.userLastName
        userFirstNameText.text = memberData!.userFirstName
        emailText.text = memberData!.email
        passwordText.text = memberData!.password
        birthdayText.text = memberData?.birthday
    }
    
    private func setupPicker() {
        
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy/MM/dd"
        birthdayText.text = dateFormat.string(from: nowDate as Date)
        self.birthdayText.delegate = self
        
        //DatePickerの設定
        birthdayPicker.locale = Locale(identifier: "ja_JP")
        birthdayPicker.datePickerMode = UIDatePickerMode.date
        birthdayText.inputView = birthdayPicker
        birthdayText.inputAccessoryView = createToolBar()
        
    }
    
    func createToolBar() -> UIView? {
        //DatePickerに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .default
        pickerToolBar.tintColor = UIColor.black
        pickerToolBar.backgroundColor = UIColor.white
        
        //ボタンの設定(右寄せ)
        let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        //完了ボタンを設定
        let toolBarButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.done))
        
        //キャンセルボタンを設定
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.tapCancelButton))
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [cancelButton, spaceBarButton,  toolBarButton]
        
        return pickerToolBar
        
    }
    
    //完了ボタンを押した時の処理
    @objc func done() {

        let pickerDate = birthdayPicker.date
        birthdayText.text = dateFormat.string(from: pickerDate)
        self.view.endEditing(true)
    }
    
    //キャンセルボタンを押した時の処理
    @objc func tapCancelButton() {
        birthdayText.resignFirstResponder()
    }
    
    
    @IBAction func tapRegistButton(_ sender: Any) {

        //正しく入力されているかどうかチェック
        if isErrorCheck() {
          return
        }

        let memberData = MemberData(
            userLastName: userLastNameText.text!, userFirstName: userFirstNameText.text!, email
            : emailText.text!, password: passwordText.text!, birthday: birthdayText.text!)
        //シリアライズ
        let archive = NSKeyedArchiver.archivedData(withRootObject: memberData)
        userDefaults.set(archive, forKey:"memberData")
        userDefaults.synchronize()
        
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Returnキーを押したと判定される直前イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    private func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //swiftCopエラーの条件を設定する
    private func setValidation() {
        
        swiftCop.addSuspect(Suspect(view: userLastNameText, sentence: "名前(姓)を入力してください", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: userFirstNameText, sentence: "名前(名)を入力してください", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: emailText, sentence: "メールアドレスを正しく入力してください", trial: Trial.email))
        swiftCop.addSuspect(Suspect(view: passwordText, sentence: "パスワードは６文字以上で入力してください", trial: Trial.length(.minimum, 6)))
//        swiftCop.addSuspect(Suspect(view: passwordText, sentence: "パスワードの文字が不正です", trial: Trial.format("[A-Z0-9a-z._%+-@!#$&]")))

    }
    
    //SwiftCopでチェック（エラーがあればメッセージを表示）
    private func isErrorCheck() -> Bool {
        
        if let guilty = swiftCop.isGuilty(userLastNameText) {
            userLastNameText.becomeFirstResponder()
            popErrorMessage(guilty.verdict())
            return true
        }
        if let guilty = swiftCop.isGuilty(userFirstNameText) {
            userFirstNameText.becomeFirstResponder()
            popErrorMessage(guilty.verdict())
            return true
        }
        if let guilty = swiftCop.isGuilty(emailText) {
            emailText.becomeFirstResponder()
            popErrorMessage(guilty.verdict())
            return true
        }
        if let guilty = swiftCop.isGuilty(passwordText) {
            passwordText.becomeFirstResponder()
            popErrorMessage(guilty.verdict())
            return true
        }
        
        return false
    }
    
    //エラーをポップアップで表示
    private func popErrorMessage(_ sender: String) {
        
        let alertMessage = sender
        let alertTitle = "警告"
        
        //アラートダイアログを生成
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        //OKボタンの定義
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in }
        
        //OKボタンを追加
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        return
        
    }
    
}
