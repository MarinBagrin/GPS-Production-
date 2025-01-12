//
//  ListMaps.swift
//  GPS
//
//  Created by Marin on 30.12.2024.
//
import UIKit
import GoogleMaps

protocol ProListMaps {
    
}

class ListMaps: UIView, ProListMaps {
    var activeView: ActiveView!
    var backView: BackView!
    
    init(superFrame: CGRect) {
        let childFrame = superFrame
        //CGRect(x: 0, y: superFrame.height / 2, width: superFrame.width, height: superFrame.height / 2) polovina
        super.init(frame: childFrame)
        activeView = ActiveView(superFrame: frame)
        self.addSubview(activeView)
        
        backView = BackView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 0.8))
        self.addSubview(backView)
        
        mainView.view.addSubview(activeView.maps[0].getUIView())
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ActiveView: UIView {
    
    var maps:[UIMap] = [GoogleMap(mainView.view.frame),AppleMap(mainView.view.frame)]
    var buttons:[UIButton] = []
    
    init(superFrame: CGRect) {
        let selfFrame = CGRect(x: 0, y: superFrame.height * 0.8, width: superFrame.width, height: superFrame.height * 0.2)
        super.init(frame: selfFrame)
        backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        setButtons()
        
    }
    func setButtons() {
        var step = frame.width * 0.1
        for i in 0..<maps.count {
            
            let calculateFrame = CGRect(x: step, y: frame.height * 0.2, width: frame.width * 0.2, height: frame.width * 0.2 )
            step += frame.width * 0.1 * 3
            let button = UIButton()
            
            var config = UIButton.Configuration.plain()
            config.image = resizeImage(image: UIImage(named: "map"+String(i))!, targetSize: CGSize(width: frame.width * 0.2, height: frame.width * 0.2))
            config.baseBackgroundColor = .blue
            button.configuration = config
            button.frame = calculateFrame
                
            button.addTarget(self, action: #selector(showMap(_:)), for: .touchUpInside)
            self.addSubview(button)
            buttons.append(button)

        }
    }
    @objc func showMap(_ sender:UIButton) {
        mainView.view.subviews[0].removeFromSuperview() // delete MAP from 0 index because map always is on 0 index un view root
        for i in 0..<buttons.count {
            if sender == buttons[i] {
                mainView.view.insertSubview(maps[i].getUIView(), at: 0)
            }
        }
        showMainView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class BackView: UIView {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        showMainView()
    }
}


