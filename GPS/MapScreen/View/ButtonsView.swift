import UIKit

class SortButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.black, for: .selected)
        
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray6.cgColor
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)

        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем действие на нажатие
        self.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleSelection() {
        self.isSelected.toggle()
        self.backgroundColor = self.isSelected ? .systemGreen.withAlphaComponent(0.7) : UIColor.lightGray.withAlphaComponent(0.5)
        self.layer.borderColor = self.isSelected ? UIColor.black.cgColor : UIColor.systemGray6.cgColor
        //self.setTitleColor(self.isSelected ? .black : .white, for: .normal)
    }
}

