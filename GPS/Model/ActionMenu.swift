//
//  ActionMenu.swift
//  GPS
//
//  Created by Marin on 08.01.2025.
//

import UIKit

class ActionMenu: UIView {
    var selectMap: UIButton = UIButton()
    var showLoaction: UIButton = UIButton()
    
    override init(frame: CGRect) {
        let heightRect = frame.height * 0.25
        super.init(frame:CGRect(x: frame.width * 0.88, y: heightRect * 0.25 , width: frame.width * 0.10, height: heightRect * 0.40))
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 0
        setChangeMap()
        setShowLocation()
        
        
    }
    func setChangeMap() {
        selectMap.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 0.49)
        selectMap.backgroundColor = .systemGray6
        selectMap.layer.cornerRadius = 10
        selectMap.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        selectMap.setImage(resizeImage(image: UIImage(named: "unselectedSloi.png")!, targetSize: CGSize(width: frame.width * 0.80, height: frame.height * 0.80) ), for: .normal)
        selectMap.setImage(resizeImage(image: UIImage(named: "selectedSloi.png")!, targetSize: CGSize(width: frame.width * 0.80, height: frame.height * 0.80) ), for: .selected)
        selectMap.addTarget(self, action: #selector(selectMapFromList), for: .touchUpInside)
        self.addSubview(selectMap)
        //var config = UIButton.Configuration.plain()
    }
    func setShowLocation() {
        showLoaction.frame = CGRect(x: 0, y: frame.height * 0.51, width: frame.width, height: frame.height * 0.49)
        showLoaction.backgroundColor = .systemGray6
        showLoaction.layer.cornerRadius = 10
        showLoaction.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        showLoaction.setImage(resizeImage(image: UIImage(named: "unselectedLocation.png")!, targetSize: CGSize(width: frame.width * 0.80, height: frame.height * 0.80 )), for: .normal)
        showLoaction.setImage(resizeImage(image: UIImage(named: "selectedLocation.png")!, targetSize: CGSize(width: frame.width * 0.80, height: frame.height * 0.80 )), for: .selected)
        showLoaction.addTarget(self, action: #selector(startUpdating), for: .touchUpInside)
        self.addSubview(showLoaction)

    }
    @objc func startUpdating(sender:UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            LocationData.shared.startLocationUpdating()
        }
        else {
            LocationData.shared.stoptLocationUpdating()
        }
    }
    @objc func selectMapFromList() {
        selectMap.isSelected.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
