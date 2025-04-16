import UIKit

class Image:UIView {
    var img = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    private func setupUI() {
        self.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit // Сохранит пропорции картинки
        
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: self.topAnchor),
            img.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            img.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            img.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }


    func setImage(img:UIImage) {
        self.img.image = img
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
