//
//  StartVC.swift
//  MyOkashi
//
//  Created by User5 on 2018/03/08.
//  Copyright © 2018年 User5. All rights reserved.
//

import UIKit

enum ButtonKind:Int {
    //vc.kind = .new　というような記載で呼び出す
    case new = 0
    case edit = 1
}

class StartVC: UIViewController {

    private let userDefaults = UserDefaults.standard
    private var buttonkind: ButtonKind = .new
    private var memberData: MemberData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupUI()

        if loginFlag == 1 {
            loginFlag = 0
            //検索画面に遷移する
            if let searchTableVC = storyboard?.instantiateViewController(withIdentifier: "search") as? SearchTableVC {
//                present(searchTableVC, animated: true, completion: nil)
                self.navigationController?.pushViewController(searchTableVC, animated: true)
            }
            
//            performSegue(withIdentifier: "searchSegue", sender: nil) 
            
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var memberButton: UIButton!
    
    
    @IBAction func tapStartButton(_ sender: Any) {
        startDisp()
    }
    
    
    @IBAction func tapMemberButton(_ sender: Any) {
    }
    
    private func setupUI(){
        
        if isRegisteredMember() {
            memberButton.setTitle("会員情報編集", for: .normal)
            loginButton.isHidden = false
            buttonkind = .edit
            print(memberData!.userLastName)
        } else {
            memberButton.setTitle("会員情報登録", for: .normal)
            loginButton.isHidden = true
            buttonkind = .new
        }
        
        return
        
    }

    func memberRegistDisp() {
        
    }
    
    func startDisp() {
//        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "login") as? LoginVC {
//            present(loginVC, animated: true, completion: nil)
//        }
    }
    
    private func isRegisteredMember() -> Bool {
        
        //会員情報がないなら何もしない
        guard let data = userDefaults.object(forKey: "memberData") as? Data else {
            return false
        }
        //会員情報があるならMemberDataクラスで保持
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? MemberData {
            memberData = MemberData(userLastName: unarchiveEntry.userLastName, userFirstName: unarchiveEntry.userFirstName, email: unarchiveEntry.email, password: unarchiveEntry.password, birthday: unarchiveEntry.birthday)
            
        }
        return true
        
    }
    
    //Segueで遷移する際のメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueName = segue.identifier {
            if segueName == "loginSegue" {
                //ViewControllerをインスタンス化
                let viewController = segue.destination as! LoginVC
                viewController.memberData = memberData
            }
            if segueName == "registSegue" {
                let viewController = segue.destination as! MemberRegistVC
                viewController.memberData = memberData
            }
        }
    }

}
