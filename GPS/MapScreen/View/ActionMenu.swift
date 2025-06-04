import UIKit

class ActionMenu: UIView {

    let stackView = UIStackView()
    let archiveButton = UIButton()
    let locationButton = UIButton()
    var viewModel:MapViewModel
    var tappedArchiveButton:(()->Void)?
    init(viewModel:MapViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let configImage = UIImage.SymbolConfiguration(pointSize: 20)
    
        archiveButton.setImage(UIImage(systemName: "archivebox", withConfiguration: configImage ), for: .normal)
        locationButton.setImage(UIImage(systemName: "location", withConfiguration: configImage ), for: .normal)
        archiveButton.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        [archiveButton,locationButton].forEach{ button in
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 40),
                button.heightAnchor.constraint(equalToConstant: 40),
            ])
            button.tintColor = .white
            stackView.addArrangedSubview(button)
        }
        let viewSeparator = UIView()
        viewSeparator.backgroundColor = .separator
        viewSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(blur)
        self.addSubview(stackView)
        stackView.addSubview(viewSeparator)
        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: self.topAnchor),
//            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blur.topAnchor.constraint(equalTo: stackView.topAnchor),
            blur.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
//            self.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            viewSeparator.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            viewSeparator.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            viewSeparator.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            viewSeparator.heightAnchor.constraint(equalToConstant: 1),
            
        ])
        
        
    }
    @objc func archiveButtonTapped() {
        tappedArchiveButton?()
    }
}
