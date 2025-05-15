import UIKit
class AuthenticateController:UIViewController {
    var coordinator:AuthenticateCoordinator
    var viewModel:MapViewModel
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    var heading = UILabel()
    var logoImage = UIImageView(image: UIImage(named: "logo.png"))
    var loginField = UITextField()
    var passwordField = UITextField()
    var credentialsButton = UIButton()
    var settingsButton = UIButton()
    let stackFields = UIStackView()

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
//        coordinator.remove
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func recursChangeBackColor() {
        UIView.animate(withDuration: 5, animations: { [weak self] in
            self?.view.backgroundColor = [.systemMint.withAlphaComponent(0.45), .systemIndigo.withAlphaComponent(0.45), .systemBlue.withAlphaComponent(0.45)].randomElement()}) {  [weak self] _ in
                self?.recursChangeBackColor()
            }
    }
    private func setupUI() {
        
        //self.view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.45)
        
        self.view.addSubview(blur)
        //self.view.addSubview(heading)
        self.view.addSubview(logoImage)
        self.view.addSubview(loginField)
        self.view.addSubview(passwordField)
        self.view.addSubview(credentialsButton)
        self.view.addSubview(stackFields)
        self.view.addSubview(settingsButton)
        
        blur.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        heading.translatesAutoresizingMaskIntoConstraints = false
        credentialsButton.translatesAutoresizingMaskIntoConstraints = false
        stackFields.translatesAutoresizingMaskIntoConstraints = false
        
        heading.text = "Infoexpres"
        heading.textAlignment = .center
        heading.font = UIFont(name: "Arial", size: 24)
        
        logoImage.contentMode = .scaleAspectFit
        
        stackFields.axis = .vertical
        stackFields.spacing = 24
        
        [loginField,passwordField].forEach{ field in
            field.translatesAutoresizingMaskIntoConstraints = false
            stackFields.addArrangedSubview(field)
            
            let space = UIView()
            space.translatesAutoresizingMaskIntoConstraints = false
            field.leftViewMode = .always
            field.leftView = space
            NSLayoutConstraint.activate([
                space.widthAnchor.constraint(equalToConstant: 12),
                field.heightAnchor.constraint(equalToConstant: 60),
            ])
            field.layer.cornerRadius = 8
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.white.cgColor
        }
        loginField.placeholder = "Login"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        
        credentialsButton.setTitle(translate[lang]!["login"]!, for: .normal)
        credentialsButton.layer.cornerRadius = 12
        credentialsButton.backgroundColor = .systemBlue
        NSLayoutConstraint.activate([
            blur.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            blur.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1),
            blur.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            blur.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            logoImage.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            logoImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 48),
            stackFields.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            stackFields.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            stackFields.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 24),
            credentialsButton.topAnchor.constraint(equalTo: stackFields.bottomAnchor, constant: 8),
            credentialsButton.widthAnchor.constraint(equalTo: stackFields.widthAnchor, multiplier: 1),
            credentialsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            credentialsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        recursChangeBackColor()
        let cerc = kryg(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        self.view.addSubview(cerc)
    }
    
}

class kryg:UIView {
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.move(to: CGPoint(x: 0,  y: 0))   // стартовая точка
        ctx.addLine(to: CGPoint(x: 50, y: 50)) // конец линии
        ctx.setStrokeColor(UIColor.systemRed.cgColor) // цвет линии
        ctx.setLineWidth(1)                           // толщина
        ctx.strokePath()                              // вывести на экран

    }
}
