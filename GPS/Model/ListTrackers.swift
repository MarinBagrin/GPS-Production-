//
//  ListTrackers.swift
//  GPS
//
//  Created by Marin on 03.01.2025.
//

import UIKit
import GoogleMaps
import MapKit

class ListTrackers: UIView {
    lazy var unitateY = frame.height / 10
    lazy var unitateX = frame.width / 10
    //
    var state: State!
    var list: UITableView!
    var backMain: UIButton!
    //
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0-frame.width, y: 0, width: frame.width, height: frame.height))
        
        setState()
        setList()
        setBackMain()
    }
    //
    func setState() {
        state = State(frame: frame)
        self.addSubview(state)
    }
    //
    func setList() {
        list = UITableView()
        
        list.frame = CGRect(x: 0, y:frame.height * 0.25, width: frame.width * 0.8, height:frame.height * 0.75 )
        list.backgroundColor = .white
        
        list.dataSource = self
        list.delegate = self
        self.addSubview(list)
    }
    func setBackMain(){
        backMain = UIButton()
        backMain.frame = CGRect(x: frame.width * 0.8, y: 0, width: frame.width * 0.2, height: frame.height)
        backMain.addTarget(self, action: #selector(backMainOfButton), for: .touchUpInside)
        self.addSubview(backMain)
    }
    //
    @objc func backMainOfButton() {
        showMainView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class State: UIView {
    //
    lazy var unitateX = frame.width / 10
    lazy var unitateY = frame.height / 10
    //
    var backMain = UIButton()
    var statusLabel = UILabel()
    var batteryLabel = UILabel()
    var gpsValidilityLabel = UILabel()
    var filterName = UIButton()
    var filterID = UIButton()
    var showID = UIButton()
    override init(frame:CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width:frame.width * 0.8 , height: frame.height * 0.25) )
        backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        setBackMain()
        setStausLabel()
        setBattertLabel()
        setGpsValidilityLabel()
        setFilterName()
        setFilterID()
        setShowID()
        
        
    }
    //
    func setBackMain() {
        backMain.frame = CGRect(x: unitateX * 8, y: unitateY * 2, width: unitateX * 2, height: unitateY * 2)
        print(backMain.frame.height)
        var config = UIButton.Configuration.plain()
        config.image = resizeImage(image: UIImage(named: "back")!, targetSize: CGSize(width: unitateX * 2, height: unitateY * 2))
        
        backMain.configuration = config
        backMain.addTarget(self, action: #selector(backMainOfButton), for: .touchUpInside)
        self.addSubview(backMain)
    }
    func setStausLabel() {
        statusLabel.frame = CGRect(x: unitateX / 10, y: unitateY * 2, width: unitateX * 5, height: 24)
        statusLabel.text = "Status: Online"
        statusLabel.textColor = .black
        statusLabel.font = UIFont.systemFont(ofSize: 20)

        self.addSubview(statusLabel)
    }
    func setBattertLabel() {
        batteryLabel.frame = CGRect(x: unitateX / 10, y: unitateY * 4.5, width: unitateX * 5, height: 24)
        batteryLabel.text = "Batterty : 100%"
        batteryLabel.textColor = .black
        batteryLabel.font = UIFont.systemFont(ofSize: 20)

        self.addSubview(batteryLabel)

    }
    func setGpsValidilityLabel() {
        gpsValidilityLabel.frame = CGRect(x: unitateX / 10, y: unitateY * 7, width: unitateX * 5, height: 24)
        gpsValidilityLabel.text = "GPS: Validility"
        gpsValidilityLabel.textColor = .black
        gpsValidilityLabel.font = UIFont.systemFont(ofSize: 20)
        
        self.addSubview(gpsValidilityLabel)
    }
    //buttons
    func setFilterName() {
        filterName.frame = CGRect(x: frame.width * 0, y: frame.height - 30, width: frame.width * 0.33, height: 30)
        filterName.setTitle("By name", for: .normal)
        filterName.setImage(resizeImage(image: UIImage(named: "unselectedCircle.png")!, targetSize: CGSize(width: 25, height: 25)), for: .normal)
        filterName.setImage(resizeImage(image: UIImage(named: "selectedCircle.png")!, targetSize: CGSize(width: 25, height: 25)), for: .selected)
        filterName.setTitleColor(UIColor.black, for: .normal)
        filterName.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        filterName.addTarget(self, action: #selector(changeFilterByName), for: .touchUpInside)
        filterName.isSelected = true
        
        self.addSubview(filterName)
        
    }
    func setFilterID() {
        filterID.frame = CGRect(x: frame.width * 0.33, y: frame.height - 30, width: frame.width * 0.33, height: 30)
        filterID.setTitle("By ID", for: .normal)
        filterID.setImage(resizeImage(image: UIImage(named: "unselectedCircle.png")!, targetSize: CGSize(width: 25, height: 25)), for: .normal)
        filterID.setImage(resizeImage(image: UIImage(named: "selectedCircle.png")!, targetSize: CGSize(width: 25, height: 25)), for: .selected)
        filterID.setTitleColor(UIColor.black, for: .normal)
        filterID.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        filterID.addTarget(self, action: #selector(changeFilterByName), for: .touchUpInside)
        
        self.addSubview(filterID)
        
    }
    func setShowID() {
        showID.frame = CGRect(x: frame.width * 0.66, y: frame.height - 30 , width: frame.width * 0.33, height: 30)
        showID.setTitle("Show ID", for: .normal)
        showID.setImage(resizeImage(image: UIImage(named: "unselectedSquare.png")!, targetSize: CGSize(width: 30, height: 30)), for: .normal)
        showID.setImage(resizeImage(image: UIImage(named: "selectedSquare.png")!, targetSize: CGSize(width: 30, height: 30)), for: .selected)
        showID.setTitleColor(UIColor.black, for: .normal)
        showID.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        showID.addTarget(self, action: #selector(changeShowID), for: .touchUpInside)
        
        self.addSubview(showID)
        
    }
    
    //@objc's funs
    @objc func changeFilterByName() {
        filterID.isSelected.toggle()
        filterName.isSelected.toggle()
    }
    @objc func changeShowID() {
        showID.isSelected.toggle()
        mainView.listTrackers.list.reloadData()
    }
    @objc func backMainOfButton () {
        showMainView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension  ListTrackers:  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Обычно 1, но можно больше
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STServer.trackers.count // Количество строк в секции
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = STServer.trackers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tracker") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "tracker")
        cell.backgroundColor = .white
        var config = cell.defaultContentConfiguration()
        config.textProperties.color = .black
        config.secondaryTextProperties.color = .black
        config.text = String(track.name)
        if mainView.listTrackers.state.showID.isSelected {
            config.secondaryText = String(track.id)
        }
        cell.contentConfiguration = config
        print(indexPath.row)
        return cell
    }
}
extension ListTrackers: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true) // Снимаем выделение строки
        }
        
        // Этот метод используется для управления высотой ячейки
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60 // Устанавливаем высоту каждой ячейки
        }
        
        // Этот метод вызывается для добавления действий в ячейки (например, свайп для удаления)
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let actionShowOnMap = UIContextualAction(style: .normal, title: "Show on Map") {_,_,_ in
                for map in mainView.listMaps.activeView.maps {
                    map.setCameraOnTracker(trackerShowMap: STServer.trackers[indexPath.row])
                }
                showMainView()
            }
            
            return UISwipeActionsConfiguration(actions: [actionShowOnMap])
        }
}
func showMainView() {
    for subView in mainView.view.subviews {
        
        if !(subView is MKMapView || subView is GMSMapView) {
            if subView is ListTrackers {
                UIView.animate(withDuration: 1, animations:{ subView.frame = Frames.beforeListTrackers }) {_ in subView.removeFromSuperview()}
                continue
            }
            if subView is ToolBar {
                continue
            }
            if subView is ActionMenu {
                continue
            }
            subView.removeFromSuperview()
        }
    }
}


