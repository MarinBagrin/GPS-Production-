import UIKit
class AuthenticateController:UIViewController {
    var coordinator:AuthenticateCoordinator
    var viewModel:MapViewModel
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    var heading = UILabel()
    //var logoImage = UIImageView(image: UIImage(named: "logo.png"))
    var loginField = UITextField()
    var passwordField = UITextField()
    var credentialsButton = UIButton()
    var settingsButton = UIButton()
    let stackFields = UIStackView()
    let loading = kryg()

    init(_ viewModel:MapViewModel,coordinator:AuthenticateCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    deinit {
        print("deinitnyslya ")
        coordinator.removeFromSuperCoordinator()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    func bind() {
        viewModel.isConnected.bind { [weak self] isConnected in
            if isConnected {
                self?.credentialsButton.isEnabled = true
                self?.credentialsButton.backgroundColor = .systemBlue
                self?.credentialsButton.layer.borderWidth = 0
                self?.heading.text = "INFOEXPRES"
                
                self?.loading.stop()
            }
            else {
                self?.setDisableUIForLoading(with: "Connecting")
            }
        }
        viewModel.isAuthenticated.bind {[weak self] stateAuth in
            switch stateAuth {
            case .yes:
                
                self?.dismiss(animated: true)
                
            case .wrong, .no:
                print(stateAuth)
                if self?.viewModel.isConnected.value != false {
                    DispatchQueue.main.async {
                        self?.credentialsButton.isEnabled = true
                        self?.credentialsButton.backgroundColor = .systemBlue
                        self?.credentialsButton.layer.borderWidth = 0
                        self?.heading.text = "INFOEXPRES"
                    }
                    
                    self?.loading.stop()
                }
            case .processing:
                self?.setDisableUIForLoading(with: "Authenticate")
                //                Task {[weak self] in
                //                    try? await Task.sleep(nanoseconds: 4 * 1_000_000_000)
                //                    if self?.viewModel.isAuthenticated.value == .processing {
                //                        await MainActor.run {
                //                            self?.credentialsButton.isEnabled = true
                //                            self?.credentialsButton.backgroundColor = .systemBlue
                //                            self?.credentialsButton.layer.borderWidth = 0
                //                            self?.heading.text = "INFOEXPRES"
                //
                //                            self?.loading.stop()
                //                        }
                //                    }
                //                }
            }
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    private func recursChangeBackColor() {
        UIView.animate(withDuration: 5,delay: 0,options: [.allowUserInteraction], animations: { [weak self] in
            self?.view.backgroundColor = [.systemMint.withAlphaComponent(0.20),  .systemTeal.withAlphaComponent(0.20),  .blue.withAlphaComponent(0.20)].randomElement()}) {  [weak self] _ in
                self?.recursChangeBackColor()
            }
    }
    private func setDisableUIForLoading(with: String = "INFOEXPRES") {
        DispatchQueue.main.async {
            self.heading.text = with
            self.credentialsButton.isEnabled = false
            self.credentialsButton.backgroundColor = .systemGray
            self.credentialsButton.layer.borderWidth = 1
            self.credentialsButton.layer.borderColor = UIColor.black.cgColor
        }
        self.loading.start()
    }
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector( dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        //self.view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.45)
        let secondBackColor = UIView()

        self.view.addSubview(secondBackColor)
        self.view.addSubview(blur)
        blur.isUserInteractionEnabled = false
        secondBackColor.isUserInteractionEnabled = false
        self.view.addSubview(heading)
        self.view.addSubview(loading)
        
        self.view.addSubview(stackFields)

        self.view.addSubview(credentialsButton)
        self.view.addSubview(settingsButton)

        
        secondBackColor.frame = self.view.frame
        secondBackColor.backgroundColor = .black.withAlphaComponent(0.33)
        blur.translatesAutoresizingMaskIntoConstraints = false
        heading.translatesAutoresizingMaskIntoConstraints = false
        credentialsButton.translatesAutoresizingMaskIntoConstraints = false
        stackFields.translatesAutoresizingMaskIntoConstraints = false
        loading.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        //heading.textAlignment = .center
        heading.font = .systemFont(ofSize: 24, weight: .semibold)
        
        //logoImage.contentMode = .scaleAspectFit
        
        stackFields.axis = .vertical
        stackFields.spacing = 24
        stackFields.isUserInteractionEnabled = true
        loading.backgroundColor = .clear

        
        [loginField,passwordField].forEach{ field in
            field.translatesAutoresizingMaskIntoConstraints = false
            stackFields.addArrangedSubview(field)
            
            let space = UIView()
            space.translatesAutoresizingMaskIntoConstraints = false
            field.leftViewMode = .always
            field.leftView = space
            NSLayoutConstraint.activate([
                space.widthAnchor.constraint(equalToConstant: 16),
                field.heightAnchor.constraint(equalToConstant: 72),
            ])
            field.layer.cornerRadius = 16
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.lightGray.cgColor
            field.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        }
        loginField.placeholder = "Login"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        if viewModel.isSavedCredentails {
            let credentials = viewModel.getCredentialsAuth()
            loginField.text = credentials.login
            passwordField.text = credentials.password
        }
        credentialsButton.addTarget(self, action: #selector(credentialsButtonTapped), for: .touchUpInside)
        credentialsButton.setTitle(translate[lang]!["login"]!, for: .normal)
        credentialsButton.layer.cornerRadius = 20
        credentialsButton.backgroundColor = .systemBlue
        
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.systemBlue, for: .normal)
        settingsButton.backgroundColor = .clear
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.borderColor = UIColor.systemBlue.cgColor
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            blur.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            blur.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1),
            blur.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            blur.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
           
            heading.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 0),
            heading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            heading.heightAnchor.constraint(equalToConstant: 50),
            //heading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.),
            
            loading.trailingAnchor.constraint(equalTo: heading.leadingAnchor, constant: -8),
            loading.widthAnchor.constraint(equalToConstant: 50),
            loading.heightAnchor.constraint(equalToConstant: 50),
            loading.topAnchor.constraint(equalTo: heading.topAnchor),
            //heading.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            stackFields.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            stackFields.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            stackFields.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -24),
            credentialsButton.topAnchor.constraint(equalTo: stackFields.bottomAnchor, constant: 8),
            credentialsButton.widthAnchor.constraint(equalTo: stackFields.widthAnchor, multiplier: 1),
            credentialsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            credentialsButton.heightAnchor.constraint(equalToConstant: 40),
            
            settingsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            settingsButton.widthAnchor.constraint(equalTo: credentialsButton.widthAnchor, multiplier: 1),
            settingsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            settingsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        recursChangeBackColor()
       
    }
    @objc func credentialsButtonTapped() {
        print("pidoras")
        guard let login = loginField.text else {return}
        guard let password = passwordField.text else {return}
        viewModel.checkAuthentification(login: password , password: password)
        
    }
    @objc func settingsButtonTapped() {
        print("Settings button tap")
        coordinator.showSettingsVC() // делаем в первую очередь потому что может удалится VC

        self.dismiss(animated: true) //и программа не дойдет до выполнения этой функции
    }
    
}

class kryg:UIView {
    private var startAngle = CGFloat(0)
    private var endAngle = CGFloat(0)
    private var isTurnEnd = true
    private var ticker:CADisplayLink?
    private var colors = [UIColor]()
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        ticker = CADisplayLink(target: self, selector: #selector(updateAngle))
        ticker?.add(to: .main, forMode: .common)
        ticker?.isPaused = true
        [UIColor.systemGray3,UIColor.systemGray4,UIColor.systemGray5,UIColor.systemGray6].forEach{ color in
                self.colors.append(color.withAlphaComponent(0.8))
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.addArc(center: CGPoint(x: 25, y: 25),
                   radius: 12.5,
                   startAngle: .deg(startAngle),
                   endAngle: .deg(endAngle),
                   clockwise: false)
        ctx.setStrokeColor(UIColor.systemBlue.cgColor)
        ctx.setLineWidth(2)
        ctx.strokePath()
    }
    func start() {
        if ticker?.isPaused ?? false{
            self.isHidden = false
            startAngle = -90
            endAngle = 91
            ticker?.isPaused = false
            print("start")
        }
    }
    func stop() {
        ticker?.isPaused = true
        self.isHidden = true
        
    }
    @objc func updateAngle() {
        if abs(endAngle - startAngle) >= 360 || endAngle - startAngle <=  0 {
            isTurnEnd.toggle()
        }
        
        if isTurnEnd {
            endAngle += 4
            startAngle += 2
            
        }
        else {
            startAngle += 4
            endAngle += 2
            
        }
        setNeedsDisplay()
    }
    
}
extension CGFloat {
    static func deg(_ degrees: CGFloat) -> CGFloat {
        degrees * .pi / 180
    }
}
