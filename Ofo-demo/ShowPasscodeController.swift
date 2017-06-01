//
//  ShowPasscodeController.swift
//  Ofo-demo
//
//  Created by yons on 2017/5/16.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
import SwiftyTimer
import SwiftySound

class ShowPasscodeController: UIViewController {
    
    @IBOutlet weak var label1st: MyPreviewLabel!
    
    @IBOutlet weak var label4th: MyPreviewLabel!
    @IBOutlet weak var label3rd: MyPreviewLabel!
    @IBOutlet weak var label2nd: MyPreviewLabel!
    
    var code = ""
    //[8,4,5,6]
    var passArray : [String] = []
    
    let defaults = UserDefaults.standard
    
    

    
    @IBOutlet weak var countDownLabel: UILabel!
    
    var remindSeconds = 121
    
    var isTorchOn = false
    var isVoiceOn = true
    
    
    @IBOutlet weak var voiceBtn: UIButton!
    
    @IBAction func voiceBtnTap(_ sender: UIButton) {
        if isVoiceOn {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
        } else {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
        }
        
        isVoiceOn = !isVoiceOn
    }
    
    @IBAction func torchBtnTap(_ sender: UIButton) {
        turnTorch()
        
        if isTorchOn {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
            defaults.set(true, forKey: "isVoiceOn")

        } else {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
            defaults.set(false, forKey: "isVoiceOn")

        }
        
        isTorchOn = !isTorchOn
    }
    
    @IBOutlet weak var torchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Timer.every(1) { (timer: Timer) in
            self.remindSeconds -= 1
            self.countDownLabel.text = self.remindSeconds.description
            
            if self.remindSeconds == 0 {
                timer.invalidate()
            }
        }
        
        voiceBtnStatus(voiceBtn: voiceBtn)
        
        self.label1st.text = passArray[0]
        self.label2nd.text = passArray[1]
        self.label3rd.text = passArray[2]
        self.label4th.text = passArray[3]

    }

    @IBAction func reportBtnTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
