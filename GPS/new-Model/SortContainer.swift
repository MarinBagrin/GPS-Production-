import UIKit

class SortContainer:UIView {
    var sortById: SortButton!
    var sortByName: SortButton!
    var sortByOnline: SortButton!
    
    override init(frame: CGRect) {
        super.init(frame:CGRect(x: frame.width * 0.025, y: frame.height * 0.120 , width: frame.width * 0.80, height: frame.height * 0.05))
        
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.25)
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
        setSortById();
        setSortByName();
        setSortByOnline();
    }
    
    func setSortById() {
        sortById = SortButton(frame: CGRect(x: frame.width * 0.065, y: frame.height * 0.20, width: frame.width * 0.20, height: frame.height * 0.60),tittle: "Id")
        
        
        self.addSubview(sortById)
    }
    func setSortByName() {
        sortByName = SortButton(frame: CGRect(x: frame.width * (0.065 + 0.33), y: frame.height * 0.20, width: frame.width * 0.20, height: frame.height * 0.60),tittle: "Name")
        
        
        
        self.addSubview(sortByName)
    }
    func setSortByOnline() {
        sortByOnline = SortButton(frame: CGRect(x: frame.width * (0.065 + 0.66), y: frame.height * 0.20, width: frame.width * 0.20, height: frame.height * 0.60),tittle: "Online")
        
       
        
        self.addSubview(sortByOnline)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
