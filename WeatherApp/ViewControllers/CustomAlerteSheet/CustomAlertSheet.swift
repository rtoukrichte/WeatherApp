//
//  CustomAlertSheet.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import UIKit

protocol CustomAlertViewDelegate: AnyObject {
    func validerActionDelegateAlertSheet(name: String)
    func closeActionDelegateAlertSheet()
}

class CustomAlertSheet: UIViewController, UITextFieldDelegate {
    
    let screenWidth          = UIScreen.main.bounds.width
    let screenHeight         = UIScreen.main.bounds.height
    
    weak var delegate: CustomAlertViewDelegate?
    
    @IBOutlet weak var actionAlertSheet: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var validerBtn: UIButton!
    @IBOutlet weak var cityTxtField: UITextField!
    
    var titleLabel : String!
    var validerBtnTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        actionAlertSheet.layer.cornerRadius  = 5
        actionAlertSheet.layer.masksToBounds = true
        titleLabel = "Add new city to your list"
        validerBtnTitle = "Add"
        validerBtn.setTitle(validerBtnTitle, for: .normal)
        self.labelTitle.text = titleLabel
        
        cityTxtField.delegate = self
        if let isFieldCityEmpty = cityTxtField.text?.isEmpty, isFieldCityEmpty {
            validerBtn.isEnabled = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillMoveUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewWillMoveUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillMoveDown()
    }
    
    @IBAction func validerAction(_ sender: Any) {
        //view.removeFromSuperview()
        delegate?.validerActionDelegateAlertSheet(name: self.cityTxtField.text ?? "")
    }
    
    @IBAction func closeAction(_ sender: Any) {
        //view.removeFromSuperview()
        self.cityTxtField.text = ""
        delegate?.closeActionDelegateAlertSheet()
    }
    
    func viewWillMoveUp() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { self.view.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight) }, completion: nil)
    }
    
    func viewWillMoveDown() {
        //self.view.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { self.view.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.screenHeight) }, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (textField.text as? NSString)!.replacingCharacters(in: range, with: string)

        if !text.isEmpty{
            validerBtn.isEnabled = true
        } else {
            validerBtn.isEnabled = false
        }
        return true
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
