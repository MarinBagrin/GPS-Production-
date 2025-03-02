import UIKit

class SortButton:UIButton {
     init(frame: CGRect,tittle:String) {
         super.init(frame: frame)
         self.backgroundColor = UIColor.systemGray6
         self.layer.cornerRadius = 10
         self.setTitle(tittle, for: .normal)
         self.setTitleColor(UIColor.white, for: .normal)
         self.setTitleColor(UIColor.systemBlue, for: .selected)
         self.layer.shadowColor = UIColor.black.cgColor
         self.layer.shadowOffset = CGSize(width: 0, height: 2)
         self.layer.shadowRadius = 4
         self.layer.shadowOpacity = 0.3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
