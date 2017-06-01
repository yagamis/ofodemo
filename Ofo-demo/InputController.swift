//
//  InputController.swift
//  Ofo-demo
//
//  Created by yons on 2017/5/14.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
import APNumberPad

class InputController: UIViewController,APNumberPadDelegate,UITextFieldDelegate {
    var isFlashOn = false
    var isVoiceOn = true
    let defaults = UserDefaults.standard

    
    
    
    @IBAction func flashBtnTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        
        if isFlashOn {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        } else {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
        }
    }

    @IBAction func voiceBtnTap(_ sender: UIButton) {
        isVoiceOn = !isVoiceOn
        
        if isVoiceOn {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
            
            
            defaults.set(true, forKey: "isVoiceOn")
            
        } else {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
            
            defaults.set(false, forKey: "isVoiceOn")
        }
        
        
    }
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var goBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "车辆解锁"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .plain, target: self, action: #selector(backToScan))
        
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("确定", for: .normal)
        inputTextField.inputView = numberPad
        inputTextField.delegate = self
        
        goBtn.isEnabled = false
   
        voiceBtnStatus(voiceBtn: voiceBtn)
    }
    
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        checkPass()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.characters.count + string.characters.count - range.length
        
        if newLength > 0 {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
            goBtn.backgroundColor = UIColor.ofo
            goBtn.isEnabled = true
            
        } else {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_unenable"), for: .normal)
            goBtn.backgroundColor = UIColor.groupTableViewBackground
            goBtn.isEnabled = false
        }
        
        
        return newLength <= 8
        
    }
    
    
    func backToScan()  {
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBtnTap(_ sender: UIButton) {
        checkPass()
    }
    
    var passArray: [String] = []
    
    
    func checkPass()  {
        if !inputTextField.text!.isEmpty {
            let code = inputTextField.text!
            
            NetworkHelper.getPass(code: code, completion: { (pass) in
                if let pass = pass {
                    
                    self.passArray = pass.characters.map{
                        return $0.description
                    }
                    
                    self.performSegue(withIdentifier: "showPasscode", sender: self)
                } else {
                    print("没获取到！")
                    self.performSegue(withIdentifier: "showErrorView", sender: self)
                }
            })
  
            
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPasscode" {
            let destVC = segue.destination as! ShowPasscodeController
            
            destVC.passArray = self.passArray

        }
    }
    

}
