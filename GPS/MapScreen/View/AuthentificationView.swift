//
//  Autorization.swift
//  GPS
//
//  Created by Marin on 02.01.2025.
//

import UIKit

class AuthenticationView: UIView {
    
    var menuAuth: MenuAuth!
    var blurView: UIVisualEffectView!
    var organisation: String!
    var showScreenSettings:(()->Void?)?
    var viewModel:MapViewModel
    init(frame: CGRect, viewModel:MapViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
        bind()
    }
    private func setupUI() {
        let blurEffect = UIBlurEffect(style: .dark) // .dark, .extraLight, .regular, .prominent
        
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = frame
        blurView.alpha = 0.95
        self.addSubview(blurView)
        
        menuAuth = MenuAuth(frame: self.frame,viewModel: viewModel)
        menuAuth.setingsButton.addTarget(self, action: #selector(touchShowSettings), for: .touchUpInside)

        self.addSubview(menuAuth)
    }
    func bind() {
        viewModel.isAuthenticated.bind{[weak self] stateAuthenticated in
            switch stateAuthenticated {
            case .no:
                self?.isHidden = false
            case .yes:
                self?.isHidden = true
            default:
                break
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func touchShowSettings() {
        showScreenSettings?()
        
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
    var setingsButton = UIButton(frame: .zero)
    var viewModel:MapViewModel
    var taskConnection:Task<Void,Never>?
    var taskCheckingAuth:Task<Void,Never>?
    
    
    lazy var unitateY = frame.height / 10
    lazy var unitateX = frame.width / 10
    
    
    
    init(frame: CGRect, viewModel:MapViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect(x: frame.width / 8, y: frame.height / 4, width: frame.width - (frame.width/8 * 2), height: frame.height/2))
        setupUI()
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind() {
        viewModel.isConnected.bind{ [weak self] isConnected in
            if (!isConnected) {
                print("Authentication IsConnected: false")
                self?.taskConnection = Task {
                    await self?.activateStateConnectingServer()
                    await MainActor.run{
                        self?.unActiveStateConnectingServer()
                    }
                }
            }
            else {
                print("Authentication IsConnected: true")
            }
        }
        
        viewModel.isAuthenticated.bind{[weak self] stateAuthenticated in
            guard let self = self else {print("error guard ViewAuth");return}
            switch stateAuthenticated {
            case .yes:
                break
            case .no:
                if !self.viewModel.isSavedCredentails {
                    login.text = ""
                    password.text = ""
                }
            case .wrong:
                break
                //pri nt worng
            case .processing:
                self.taskCheckingAuth = Task {
                    await self.activeStateCheckingAuth()
                    await MainActor.run {
                        self.unActivateStateCheckingAuth()
                    }
                }
            }
        }
    }
    
    
    private func setupUI() {
        self.addSubview(login)
        self.addSubview(password)
        self.addSubview(checkAuth)
        self.addSubview(copyright)
        self.addSubview(tryConnectServer)
        self.addSubview(logInfo)
        self.addSubview(setingsButton)

        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        self.layer.cornerRadius = 5
        setingsButton.setImage(resizeImage(image: UIImage(named: "settings-icon.png")!,targetSize: CGSize(width: frame.width ,height: frame.width )), for: .normal)
        
        setingsButton.translatesAutoresizingMaskIntoConstraints = false
        setingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
      
        
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
        login.font = UIFont.boldSystemFont(ofSize: 16)
        if viewModel.isSavedCredentails {
            login.text = viewModel.getCredentialsAuth().login
        }
        
        login.attributedPlaceholder = NSAttributedString(
            string: "Login",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        var spaceLeft = UIView(frame: CGRect(x: 0, y: 0, width: login.frame.width * 0.05, height: login.frame.height))
        login.leftView = spaceLeft
        login.leftViewMode = .always
        
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
        password.isSecureTextEntry = true
        spaceLeft = UIView(frame: CGRect(x: 0, y: 0, width: password.frame.width * 0.05, height: password.frame.height))
        password.leftView = spaceLeft
        password.leftViewMode = .always
        if viewModel.isSavedCredentails {
            password.text = viewModel.getCredentialsAuth().password
        }
        password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        
        checkAuth.setTitle(translate[lang]!["login"], for: .normal)
        checkAuth.frame = .zero
        checkAuth.backgroundColor = .systemGreen.withAlphaComponent(0.375)
        checkAuth.layer.borderColor = UIColor.black.cgColor
        checkAuth.layer.borderWidth = 1
        checkAuth.layer.cornerRadius = 2
        
        checkAuth.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkAuth.topAnchor.constraint(equalTo: password.bottomAnchor, constant:10),
            checkAuth.leadingAnchor.constraint(equalTo: password.leadingAnchor),
            checkAuth.widthAnchor.constraint(equalTo: password.widthAnchor),
            //            checkAuth.heightAnchor.constraint(equalTo: password.widthAnchor,multiplier: 0.45)
        ])
        checkAuth.addTarget(self, action: #selector(pressedCheckAuth), for: .touchDown)
        copyright.text = "Copyright Infoexpres 2013-2025    v.2.0"
        copyright.adjustsFontSizeToFitWidth = true
        copyright.frame = CGRect(x: unitateX * 2, y:frame.height-17, width: unitateX * 6, height: 17)
        
        tryConnectServer.frame = self.bounds
        tryConnectServer.backgroundColor = .black.withAlphaComponent(0.75)
        tryConnectServer.isHidden = true
        //logInfo.text = translate[lang]!["servconat0"]
        

        logInfo.font = UIFont(name: "SF Pro Display", size: 20)
        logInfo.frame = CGRect(x: frame.width * 0, y: frame.height * 0.05, width: frame.width , height: frame.height * 0.05)
        logInfo.textAlignment = .center
        NSLayoutConstraint.activate([
            setingsButton.topAnchor.constraint(equalTo: checkAuth.bottomAnchor,constant: 15),
            setingsButton.centerXAnchor.constraint(equalTo: checkAuth.centerXAnchor),
            setingsButton.widthAnchor.constraint(equalTo: checkAuth.widthAnchor,multiplier: 0.5),
            setingsButton.heightAnchor.constraint(equalTo: checkAuth.widthAnchor,multiplier: 0.5),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //lsb.constant = password.frame.width * 0.75
        
    }
    
    func activateStateConnectingServer() async {
        tryConnectServer.isHidden = false
        logInfo.textColor = .white
        while(!viewModel.isConnected.value) {
            
            await MainActor.run {
                self.logInfo.text = translate[lang]!["servconat0"]
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                self.logInfo.text = translate[lang]!["servconat1"]
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                self.logInfo.text = translate[lang]!["servconat2"]
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                self.logInfo.text = translate[lang]!["servconat3"]
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }
    func unActiveStateConnectingServer() {
        taskConnection?.cancel()
        logInfo.text = ""
        logInfo.textColor = .systemBlue
        tryConnectServer.isHidden = true
    }
    
    func activeStateCheckingAuth() async {
        await MainActor.run{
            checkAuth.isEnabled = false
        }
        while(viewModel.isAuthenticated.value == .processing) {
            await MainActor.run{
                self.logInfo.text = translate[lang]!["authing0"]
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run{
                self.logInfo.text = translate[lang]!["authing1"]
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run{
                self.logInfo.text = translate[lang]!["authing2"]
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run{
                self.logInfo.text = translate[lang]!["authing3"]
            }
        }
    }
    func unActivateStateCheckingAuth() {
        
        taskCheckingAuth?.cancel()
        
        logInfo.text = ""

        checkAuth.isEnabled = true
    }
    //objc's

    @objc func pressedCheckAuth(){
        viewModel.checkAuthentification(login: login.text ?? "", password: password.text ?? "")
    }
    @objc func settingsButtonTapped() {
        viewModel.settingsButtonTapped()
    }
}

