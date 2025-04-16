import UIKit
class SortContainer: UIStackView {
    var sortByGps = SortButton(title: translate[lang]!["gps"]!)
    var sortByName = SortButton(title: translate[lang]!["name"]!)
    var sortByOnline = SortButton(title: translate[lang]!["online"]!)
    var sortByBattey = SortButton(title: translate[lang]!["battery"]!)
    override init(frame: CGRect) {
        super.init(frame:CGRect(x: frame.width * borderTB[2], y: frame.height * 0.120 , width: frame.width * borderTB[3], height: frame.height * 0.05))
        setupUI()
        setupContainer()
    }
    func setupUI() {
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.50)
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
    }

    func setupContainer() {
        axis = .horizontal // Или .vertical
        distribution = .fillEqually // Варианты: .fill, .fillEqually, .fillProportionally, .equalSpacing, .equalCentering
        spacing = 25
        alignment = .center 
        
        self.addArrangedSubview(sortByName)
        self.addArrangedSubview(sortByBattey)
        self.addArrangedSubview(sortByGps)
        self.addArrangedSubview(sortByOnline)
    }

    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
