//
//  ToolBar.swift
//  GPS
//
//  Created by Marin on 29.12.2024.
import UIKit
import Foundation

class ToolBar: UIView{

    var listTrackersButton = UIButton()
    var choiceMapButton = UIButton()

    
    
    init(superFrame: CGRect) {
        let childFrame = CGRect(x: 0, y: superFrame.height-75, width: superFrame.width, height: 75)
        super.init(frame: childFrame )
        backgroundColor =  UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)// #A7D7C5// #2C2C2C
        layer.cornerRadius = 20
        //MARK: moreButton
        setMoreButton()        ///
        //MARK: choiceMapButton
        setChoiceMap()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        mainView.view.addSubview(mainView.listMaps)

    }
    func setMoreButton() {
        listTrackersButton.frame = CGRect(x: frame.width * 0.075, y: frame.height * 0.2, width:frame.width * 0.1 , height: frame.width * 0.1)

        var configButton = UIButton.Configuration.plain()
        configButton.image = resizeImage(image: UIImage(named: "more.png")!, targetSize: CGSize(width: frame.width * 0.1, height: frame.width * 0.1))
        listTrackersButton.configuration = configButton
        
        listTrackersButton.addTarget(self, action: #selector(showListTrackers), for: .touchUpInside)
        self.addSubview(listTrackersButton)
    }
    func setChoiceMap() {
        choiceMapButton.frame = CGRect(x: frame.width - (frame.width * 0.075 + frame.width * 0.1), y: frame.height * 0.2, width: frame.width * 0.1, height: frame.width * 0.1)
        var config = UIButton.Configuration.plain()
        config.image = resizeImage(image: UIImage(named: "maps.png")!, targetSize:CGSize(width: frame.width * 0.1, height: frame.width * 0.1) )
        
        choiceMapButton.configuration = config
        
        choiceMapButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        self.addSubview(choiceMapButton)
    }
    @objc func showListTrackers() {
        mainView.view.addSubview(mainView.listTrackers)
        UIView.animate(withDuration: 0.5) { mainView.listTrackers.frame.origin.x = 0 }
    }
}




func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
