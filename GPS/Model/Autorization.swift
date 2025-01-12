//
//  Autorization.swift
//  GPS
//
//  Created by Marin on 02.01.2025.
//

import UIKit

class Authentication: UIView {
    
    var menuAuth: MenuAuth!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        //
        menuAuth = MenuAuth(frame: self.frame)
        self.addSubview(menuAuth)
    }

    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuAuth: UIView {
    //
    var login:UITextField = UITextField()
    var password:UITextField = UITextField()
    var checkAuth:UIButton = UIButton()
    var copyright: UILabel = UILabel()
    //
    lazy var unitateY = frame.height / 10
    lazy var unitateX = frame.width / 10
    //
    override init(frame: CGRect) {
        let childFrame = CGRect(x: frame.width / 8, y: frame.height / 4, width: frame.width - (frame.width/8 * 2), height: frame.height/2)
        super.init(frame: childFrame)
        backgroundColor = .lightGray
        //Login
        setPaswword()
        setLoggin()
        setCheckAuth()
        setCopyright()
    }
    //
    func setLoggin() {
        
        login.frame = CGRect(x: unitateX * 2, y: unitateY * 2, width:unitateX*6 , height: unitateY)
        login.placeholder = " Login"
        login.backgroundColor = .white
        login.layer.borderColor = UIColor.black.cgColor
        login.layer.borderWidth = 0
        login.layer.cornerRadius = 4
        login.textColor = .black
        self.addSubview(login)
    }
    //
    func setPaswword() {
        password.frame = CGRect(x: unitateX * 2, y: unitateY * 3+10, width:unitateX*6 , height: unitateY)
        password.placeholder = " Password"
        password.isSecureTextEntry = true
        password.backgroundColor = .white
        password.layer.borderColor = UIColor.black.cgColor
        password.layer.borderWidth = 0
        password.layer.cornerRadius = 4
        password.textColor = .black
        self.addSubview(password)
    }
    //
    func setCheckAuth() {
        checkAuth.setTitle("Log in", for: .normal)
        checkAuth.frame = CGRect(x: unitateX * 3, y: unitateY * 4 + 20, width:unitateX * 4, height: unitateY)
        checkAuth.backgroundColor = .systemGray
        checkAuth.layer.borderColor = UIColor.black.cgColor
        checkAuth.layer.borderWidth = 1
        checkAuth.layer.cornerRadius = 2
        checkAuth.addTarget(self, action: #selector(checkUserAuth), for: .touchUpInside)
        self.addSubview(checkAuth)
    }
    //
    func setCopyright() {
        copyright.text = "Copyright Infoexpres 2013-2019    v.1.0"
        copyright.adjustsFontSizeToFitWidth = true
        copyright.frame = CGRect(x: unitateX * 2, y:frame.height-17, width: unitateX * 6, height: 17)
        self.addSubview(copyright)
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //objc's
    @objc func checkUserAuth() {
        ///проверка на то если введенные данные верны и если да то загрузка в базу данных с удаленного сервера всех данных об этои пользователе/ в это слуае у меня пока что нету данных серверу и по этому я сдлеаю так что бы при нажатие кнопки якобы юзер заходил в систему
        mainView.authentication.removeFromSuperview()
        self.login.text = ""
        self.password.text = ""
    }
}

