//
//  LoginViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 28/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var entrarButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        loginTextField.tag = 0
        senhaTextField.delegate = self
        senhaTextField.tag = 1
        entrarButton.layer.cornerRadius = 20
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillShow(_:)),
            name: Notification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillHide(_:)),
            name: Notification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func didTapEntrar(_ sender: UIButton) {
        if (loginTextField.text?.isEmpty)! || loginTextField.text == " " || (senhaTextField.text?.isEmpty)! || senhaTextField.text == " " {
            let alert = UIAlertController(title: "Atenção", message: "Algum dos campos digitados pode estar vazio.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            DataBase.CredencialManager.get(usuario: loginTextField.text!, senha: senhaTextField.text!) { (credencial) in
                guard credencial != nil else {
                    let alert = UIAlertController(title: "Atenção", message: "Login ou senha inválidos!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            senhaTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    //MARK: - Auxiliar Functions
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }

}