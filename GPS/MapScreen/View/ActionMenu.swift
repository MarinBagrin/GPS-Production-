import UIKit
class ActionMenu:UIVisualEffectView {
    
    var viewModel:MapViewModel?
    var stackActionMenu = UIStackView()
    var archiveButton = UIButton()
    var swithOnSelfLocationButton = UIButton()
    var archiveButtonTapped:(()->Void)?
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(viewModel:MapViewModel) {
        self.viewModel = viewModel
        super.init(effect: UIBlurEffect(style: .dark))
        setupUI()
    }
    private func setupUI() {
        
        self.contentView.addSubview(stackActionMenu)
        
        self.layer.cornerRadius = 8
        
        self.clipsToBounds = true
        
        archiveButton.translatesAutoresizingMaskIntoConstraints = false
        swithOnSelfLocationButton.translatesAutoresizingMaskIntoConstraints = false
        stackActionMenu.translatesAutoresizingMaskIntoConstraints = false
        
        archiveButton.setImage(UIImage(named: "archive.png"), for: .normal)
        swithOnSelfLocationButton.setImage(UIImage(named: "self.png"), for: .normal)
        
        stackActionMenu.addArrangedSubview(archiveButton)
        stackActionMenu.addArrangedSubview(swithOnSelfLocationButton)
        
        stackActionMenu.axis = .vertical
        stackActionMenu.alignment = .center
        stackActionMenu.distribution = .fillEqually
        
        archiveButton.addTarget(self, action: #selector(didTapArchiveButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackActionMenu.topAnchor.constraint(equalTo: self.topAnchor),
            stackActionMenu.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackActionMenu.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackActionMenu.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    @objc func didTapArchiveButton() {
        archiveButtonTapped?()
    }
}
