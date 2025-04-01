//
//  Autorization.swift
//  GPS
//
//  Created by Marin on 02.01.2025.
//

import UIKit

class Authentication: UIView {
    
    var menuAuth: MenuAuth!
    var blurView: UIVisualEffectView!
    var organisation: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .dark) // .dark, .extraLight, .regular, .prominent
        
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = frame
        blurView.alpha = 0.95
        self.addSubview(blurView)
        
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
    var tryConnectServer = UIView()
    var logInfo = UILabel()
    var state:String!
    var setingsButton:UIButton!
    //
    lazy var unitateY = frame.height / 10
    lazy var unitateX = frame.width / 10
    //
    override init(frame: CGRect) {
        let childFrame = CGRect(x: frame.width / 8, y: frame.height / 4, width: frame.width - (frame.width/8 * 2), height: frame.height/2)
        super.init(frame: childFrame)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        self.layer.cornerRadius = 5
        //self.layer.borderWidth = 1
        setPaswword()
        setLoggin()
        setCheckAuth()
        setCopyright()
        setLogInfo()
        setTryConnectServer()
        setSetingsButton()
        
    }
    //
    lazy var tsb = setingsButton.topAnchor.constraint(equalTo: password.bottomAnchor)
    lazy var lsb = setingsButton.leadingAnchor.constraint(equalTo: password.leadingAnchor)
    lazy var wsb = setingsButton.widthAnchor.constraint(equalTo: password.widthAnchor,multiplier: 0.225)
    lazy var hsb = setingsButton.heightAnchor.constraint(equalTo: password.widthAnchor,multiplier: 0.225)
    func setSetingsButton() {
        
        setingsButton = UIButton(frame: .zero)
        setingsButton.setImage(resizeImage(image: UIImage(named: "settings-icon.png")!,targetSize: CGSize(width: frame.width ,height: frame.width )), for: .normal)
        setingsButton.addTarget(self, action: #selector(presentSettings), for: .touchUpInside)
        self.addSubview(setingsButton)

        setingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([tsb,lsb,wsb,hsb])
    }
    //
    //
    func setTryConnectServer() {
        tryConnectServer.frame = self.bounds
        tryConnectServer.backgroundColor = .black.withAlphaComponent(0.75)
        logInfo.text = translate[lang]!["servconat0"]
        setActiveTryingConnect()
    }
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        lsb.constant = password.frame.width * 0.75
//        wsb.constant = 1
        //hsb.constant = password.frame.width * 0.1
        print(123)
    }
    func setLogInfo() {
        logInfo.font = UIFont(name: "Arial", size: 20)
        logInfo.frame = CGRect(x: frame.width * 0, y: frame.height * 0.05, width: frame.width , height: frame.height * 0.05)
        logInfo.textAlignment = .center
    }
    //
    func setLoggin() {
        
        login.frame = CGRect(x: unitateX * 2, y: unitateY * 2, width:unitateX*6 , height: unitateY)
        login.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        login.layer.borderColor = UIColor.black.cgColor
        login.layer.borderWidth = 1
        login.layer.borderColor = UIColor.systemGray6.cgColor
        login.layer.cornerRadius = 4
        login.layer.shadowColor = UIColor.black.cgColor
        login.layer.shadowOffset = CGSize(width: 0, height: 2)
        login.layer.shadowRadius = 4
        login.layer.shadowOpacity = 0.3
        login.textColor = .black
        if (UserDefaults.standard.bool(forKey: "isSaved")) {
            login.text = UserDefaults.standard.string(forKey: "login") ?? ""
        }

        login.attributedPlaceholder = NSAttributedString(
            string: "    Login",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        let spaceLeft = UIView(frame: CGRect(x: 0, y: 0, width: login.frame.width * 0.05, height: login.frame.height))
        login.leftView = spaceLeft
        self.addSubview(login)
       
    }
    //
    private func setPaswword() {
        password.frame = CGRect(x: unitateX * 2, y: unitateY * 3+10, width: unitateX * 6, height: unitateY)
        password.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        password.layer.borderColor = UIColor.black.cgColor
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.systemGray6.cgColor
        password.layer.cornerRadius = 4
        password.layer.shadowColor = UIColor.black.cgColor
        password.layer.shadowOffset = CGSize(width: 0, height: 2)
        password.layer.shadowRadius = 4
        password.layer.shadowOpacity = 0.3
        password.textColor = .black
        if (UserDefaults.standard.bool(forKey: "isSaved")) {
            password.text = UserDefaults.standard.string(forKey: "password") ?? ""
        }
        password.attributedPlaceholder = NSAttributedString(
            string: "    Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        //razobratsyalet spaceLeft = UIView(frame: CGRect(x: 0, y: 0, width: password.frame.width * 0.05, height: password.frame.height))
        //razobratsyapassword.leftView = spaceLeft
        self.addSubview(password)
    }
    //
    private func setCheckAuth() {
        checkAuth.setTitle(translate[lang]!["login"], for: .normal)
        checkAuth.frame = .zero
        checkAuth.backgroundColor = .systemGreen.withAlphaComponent(0.375)
        checkAuth.layer.borderColor = UIColor.black.cgColor
        checkAuth.layer.borderWidth = 1
        checkAuth.layer.cornerRadius = 2
        self.addSubview(checkAuth)

        checkAuth.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkAuth.topAnchor.constraint(equalTo: password.bottomAnchor, constant:6),
            checkAuth.leadingAnchor.constraint(equalTo: password.leadingAnchor),
            checkAuth.widthAnchor.constraint(equalTo: password.widthAnchor,multiplier: 0.70),
//            checkAuth.heightAnchor.constraint(equalTo: password.widthAnchor,multiplier: 0.45)
        ])
        checkAuth.addTarget(self, action: #selector(checkUserAuth), for: [.touchUpInside,.touchUpOutside])
        checkAuth.addTarget(self, action: #selector(pressedCheckAuth), for: .touchDown)
    }
    //
    private func setCopyright() {
        copyright.text = "Copyright Infoexpres 2013-2025    v.2.0"
        copyright.adjustsFontSizeToFitWidth = true
        copyright.frame = CGRect(x: unitateX * 2, y:frame.height-17, width: unitateX * 6, height: 17)
        self.addSubview(copyright)
    
    }
     func setActiveTryingConnect() {
        logInfo.text = translate[lang]!["servconat0"]
        logInfo.removeFromSuperview()
        logInfo.textColor = .white

        tryConnectServer.addSubview(logInfo)
        self.addSubview(tryConnectServer)
        DispatchQueue.global().async {
            while(g_server.isConnected == false) {
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["servconat0"]
                }
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["servconat1"]
                }
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["servconat2"]
                }
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["servconat3"]
                }
                Thread.sleep(forTimeInterval: 0.5)

            }
            self.setUnActiveTryingConnect()
        }
            
        
    }
    func setUnActiveTryingConnect() {
        DispatchQueue.main.async{
            
            self.logInfo.text = translate[lang]!["plsauth"]
            self.logInfo.removeFromSuperview()
            self.logInfo.textColor = .systemBlue
            self.addSubview(self.logInfo)
            self.tryConnectServer.removeFromSuperview()
        }
    }
    func setLogInfoCheckAuth() {
        DispatchQueue.global().async{
            while( self.state != "UnAllowAuth" && self.state != "AllowAuth") {
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["authing0"]
                }
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["authing1"]
                }
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["authing2"]
                }
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["authing3"]
                }
            }
            if (self.state == "AllowAuth") {
                self.setUnActiveTryingConnect()
            }
            else {
                DispatchQueue.main.async{
                    self.logInfo.text = translate[lang]!["incpaslog"]
                }
            }
            self.state = ""
        }
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //objc's
    @objc func presentSettings() {
        mainView.present(settingsView,animated: true)
    }
    @objc func pressedCheckAuth(){
        UIView.animate(withDuration: 0.5){
            self.checkAuth.backgroundColor = .systemGreen.withAlphaComponent(0.80)
        }
    }
    @objc func checkUserAuth() {
        ///проверка на то если введенные данные верны и если да то загрузка в базу данных с удаленного сервера всех данных об этои пользователе/ в это слуае у меня пока что нету данных серверу и по этому я сдлеаю так что бы при нажатие кнопки якобы юзер заходил в систему
//        mainView.authentication.removeFromSuperview()
        g_server.sendMessage(text: (login.text ?? "") + "/" + (password.text ?? "") + "/")
        //g_server.receiveData()
        if (UserDefaults.standard.bool(forKey: "isSaved")) {
            UserDefaults.standard.set(login.text, forKey: "login")
            UserDefaults.standard.set(password.text, forKey: "password")
        }
        else {
            login.text = ""
            password.text = ""
        }
        
        UIView.animate(withDuration: 0.250){
            self.checkAuth.backgroundColor = .systemGreen.withAlphaComponent(0.375)
        }
        setLogInfoCheckAuth()
        //settingsView.modalPresentationStyle = .fullScreen // Можно убрать, если нужен стиль по умолчанию

    }
}

