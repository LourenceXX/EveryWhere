//
//  LoginController.swift
//  Lgin
//
//  Created by 5981762989 on 2016/11/02.
//  Copyright © 2016年 5981762989. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


@IBDesignable

class LoginController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate{
    
    var messageController: MessagesController?

    
    @IBInspectable
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    @IBInspectable
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(colorLiteralRed: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    
        button.addTarget(self, action:#selector(handleLoginRegister), for: .touchUpInside)
        return button

    }()
    
      
     
     func handleLoginRegister() {
     if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
     handleLogin()
     } else {
     handleRegister()
     }
     }
     
     func handleLogin() {
     guard let email = emailtextField.text, let password = passwordtextField.text else {
     print("Form is not valid")
     return
     }
     FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
     
     if error != nil {
     print(error ?? 2)
     return
     }
     
     //successfully logged in our user
        self.messageController?.fetchUserAndSetupNavBarTitle()
        self.dismiss(animated: true, completion: nil)
     
     })
     
     }



    

    @IBInspectable
    let nametextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
@IBInspectable
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorLiteralRed: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    @IBInspectable
    
    let emailtextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    @IBInspectable
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorLiteralRed: 20/255, green: 50/255, blue: 50/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @IBInspectable
    let passwordtextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
        
    }()
    @IBInspectable
   lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
    
            return imageView
    }()
    
    
    
    @IBInspectable
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        
        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of nameTextField
        nametextFieldHeightAnchor?.isActive = false
        nametextFieldHeightAnchor = nametextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nametextFieldHeightAnchor?.isActive = true
        
        emailtextFieldHeightAnchor?.isActive = false
        emailtextFieldHeightAnchor = emailtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailtextFieldHeightAnchor?.isActive = true
        
        passwordtextFieldHeightAnchor?.isActive = false
        passwordtextFieldHeightAnchor = passwordtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordtextFieldHeightAnchor?.isActive = true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 12, y: 520, width: view.frame.width - 24, height: 50)
        //loginButton.frame = CGRect(
        loginButton.delegate = self
        

    
        view.backgroundColor = UIColor(red: 25/255, green: 55/255, blue: 110/255, alpha: 1)

        
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupInputsLoginRegisterButton()
        setupProfileImageView()
        setupLoginregisterSegmentedControl()
        //facebookloginbutton()
        
    }
    

    //facebook login
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
    print("Successfully logged in with facebook")
    }
    
    
    /*
    func facebookloginbutton(){
        facebookloginbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookloginbutton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        facebookloginbutton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        facebookloginbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
 
 */
    func setupLoginregisterSegmentedControl(){
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    
    
   func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
 
    @IBInspectable
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    @IBInspectable
    var nametextFieldHeightAnchor: NSLayoutConstraint?
    @IBInspectable
    var emailtextFieldHeightAnchor: NSLayoutConstraint?
    @IBInspectable
    var passwordtextFieldHeightAnchor: NSLayoutConstraint?
    
    
    
    
    func setupInputsContainerView(){
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        

        inputsContainerView.addSubview(nametextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailtextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordtextField)
        
        
        
        nametextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nametextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nametextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nametextFieldHeightAnchor = nametextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nametextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: nametextField.frame.size.height - width, width:  nametextField.frame.size.width, height: nametextField.frame.size.height)
        
        border.borderWidth = width
        nametextField.layer.addSublayer(border)
        nametextField.layer.masksToBounds = true
        
        
        emailtextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailtextField.topAnchor.constraint(equalTo: nametextField.bottomAnchor).isActive = true
        emailtextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailtextFieldHeightAnchor = emailtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailtextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordtextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordtextField.topAnchor.constraint(equalTo: emailtextField.bottomAnchor).isActive = true
        passwordtextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordtextFieldHeightAnchor = passwordtextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordtextFieldHeightAnchor?.isActive = true
        
    }
    
  
    
    
    func setupInputsLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
//extension UIColor {
  //  convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
        
        //self.init(red: r/255, green: g/255, blude: b/255, alpha: 1)
    

