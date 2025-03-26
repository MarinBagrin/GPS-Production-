import UIKit


enum Conection {
    case missing, low, low_medium, medium, stable
}

class TrackerInfoCell:UITableViewCell {
    var stackCell:TrackerCellStack!
    var tracker:Tracker!
    init(tracker:Tracker) {
        super.init(style: .default, reuseIdentifier: "tracker")
        
        stackCell = TrackerCellStack(name: tracker.name, id: tracker.id, battery: tracker.battery, typeGpsConnection: tracker.connectionGPS, typeNetConnection: tracker.connectionNET)
        self.tracker = tracker
        
        let tapSetCamera = UITapGestureRecognizer(target: self, action: #selector(handleSetCamera))
        self.addGestureRecognizer(tapSetCamera)
        
        setupUI()
        print("create new")
    }
    private func setupUI() {
        self.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.75)
        self.contentView.addSubview(stackCell)
        stackCell.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
    }
    
    func update(tracker:Tracker) {
        stackCell.update(tracker:tracker)
    }
    
    @objc func handleSetCamera() {
        if (tracker.long != 0 && tracker.lat != 0) {
            
            print(tracker.name!, tracker.long!, tracker.lat!)
            mainView.listMaps.activeView.maps[0].setCameraOnTracker(trackerShowMap: tracker)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TrackerCellStack: UIStackView {
    var name = UILabel()
    var battery = BatteryView()
    var typeGpsConnection = Image()
    var typeNetConnection = Image()
    
    init(name:String,id:Int,battery:Int,typeGpsConnection: Conection,typeNetConnection: Conection ) {
        super.init(frame: .zero)
        
        self.name.text = name
        self.name.font = UIFont.systemFont(ofSize: 14, weight: .bold) // шрифт 14, жирный
        self.name.textColor = .white // белый цвет текста
        self.name.textAlignment = .center // выравнивание по центру
        self.name.backgroundColor = UIColor.darkGray // темный фон
        self.name.layer.shadowColor = UIColor.black.cgColor // черная тень
        self.name.layer.shadowOpacity = 0.5 // прозрачность тени
        self.name.layer.shadowOffset = CGSize(width: 2, height: 2) // смещение тени
        self.name.layer.shadowRadius = 3 // радиус тени
        self.battery.setLevel(procentsLevel: battery)
        self.isUserInteractionEnabled = true
//        switch typeNetConnection {
//        case Conection.missing:
//            self.typeNetConnection.img = UIImageView(image: UIImage(named: "signal-status-missing.png"))
//        case Conection.medium:
//            self.typeNetConnection.img = UIImageView(image: UIImage(named: "signal-status-medium.png"))
//        case Conection.stable:
//            self.typeNetConnection.img = UIImageView(image: UIImage(named: "signal-status-stable.png"))
//        }
//        switch typeGpsConnection {
//        case Conection.missing:
//            self.typeGpsConnection.img = UIImageView(image: UIImage(named: "satellite-missing.png"))
//        case Conection.medium:
//            self.typeGpsConnection.img = UIImageView(image: UIImage(named: "satellite-medium.png"))
//        case Conection.stable:
//            self.typeGpsConnection.img = UIImageView(image: UIImage(named: "satellite-stable.png"))
//        }
        self.battery.translatesAutoresizingMaskIntoConstraints = false
        setupStack()
        setupUI()

    }
    private func setupUI() {
        NSLayoutConstraint.activate([
            battery.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.95),
            //battery.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.60)
        ])
        NSLayoutConstraint.activate([
            name.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
            //battery.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.60)
        ])
        name.isUserInteractionEnabled = false
        battery.isUserInteractionEnabled = false
        typeGpsConnection.isUserInteractionEnabled = false
        typeNetConnection.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
    }
    private func setupStack() {
        axis = .horizontal // Или .vertical
        distribution = .fillEqually // Варианты: .fill, .fillEqually, .fillProportionally, .equalSpacing, .equalCentering
        alignment = .center
        spacing = 25
        
        name.setContentCompressionResistancePriority(.required, for: .horizontal)
        battery.setContentCompressionResistancePriority(.required, for: .horizontal)
//        typeGpsConnection.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        typeNetConnection.setContentHuggingPriority(.required, for: .horizontal)

        self.addArrangedSubview(name)
        self.addArrangedSubview(battery)
        self.addArrangedSubview(typeGpsConnection)
        self.addArrangedSubview(typeNetConnection)
    }
    func update(tracker:Tracker) {
        name.text = tracker.name
        battery.setLevel(procentsLevel: tracker.battery)
        switch tracker.connectionNET {
        case Conection.missing:
            self.typeNetConnection.setImage(img: UIImage(named: "signal-status-missing.png")!)
        case Conection.low:
            self.typeNetConnection.setImage(img: UIImage(named: "signal-status-low.png")!)
        case Conection.low_medium:
            self.typeNetConnection.setImage(img: UIImage(named: "signal-status-low-medium.png")!)

        case Conection.medium:
            self.typeNetConnection.setImage(img: UIImage(named: "signal-status-medium.png")!)
        case Conection.stable:
            self.typeNetConnection.setImage(img: UIImage(named: "signal-status-stable.png")!)
        

        }
        switch tracker.connectionGPS {
        case Conection.missing:
            self.typeGpsConnection.setImage(img: UIImage(named: "satellite-missing.png")!)
        case Conection.medium:
            self.typeGpsConnection.setImage(img: UIImage(named: "satellite-medium.png")!)
        case Conection.stable:
            self.typeGpsConnection.setImage(img: UIImage(named: "satellite-stable.png")!)
        case Conection.low:
            break
        case Conection.low_medium:
            break

        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
























//import UIKit
//
//
//enum Conection {
//    case missing, medium, stable
//}
//
//class TrackerInfoCell:UITableViewCell {
//    var stackCell:TrackerCellStack!
//
//    init(name:String,id:String,battery:CGFloat,typeGpsConnection: Conection,typeNetConnection: Conection ) {
//        super.init(style: .default, reuseIdentifier: "tracker")
//
//        stackCell = TrackerCellStack(name: name, id: id, battery: battery, typeGpsConnection: typeGpsConnection, typeNetConnection: typeNetConnection)
//
//
//        setupUI()
//    }
//    func setupUI() {
//        self.contentView.addSubview(stackCell)
//    }
//
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
//class TrackerCellStack: UIStackView {
//    var name = UILabel()
//    var battery = BatteryView()
//    var typeGpsConnection: UIImageView!
//    var typeNetConnection: UIImageView!
//
//    init(name:String,id:String,battery:CGFloat,typeGpsConnection: Conection,typeNetConnection: Conection ) {
//        super.init(frame: CGRect(x: 0, y: 0, width: SIZE_CELL.width, height: SIZE_CELL.height))
//
//        self.name.text = name
//        self.battery.setLevel(procentsLevel: battery)
//        switch typeNetConnection {
//        case Conection.missing:
//            self.typeNetConnection = UIImageView(image: UIImage(named: "signal-status-missing.png"))
//        case Conection.medium:
//            self.typeNetConnection = UIImageView(image: UIImage(named: "signal-status-medium.png"))
//        case Conection.stable:
//            self.typeNetConnection = UIImageView(image: UIImage(named: "signal-status-stable.png"))
//        }
//        switch typeGpsConnection {
//        case Conection.missing:
//            self.typeGpsConnection = UIImageView(image: UIImage(named: "satellite-missing.png"))
//        case Conection.medium:
//            self.typeGpsConnection = UIImageView(image: UIImage(named: "satellite-medium.png"))
//        case Conection.stable:
//            self.typeGpsConnection = UIImageView(image: UIImage(named: "satellite-stable.png"))
//        }
//        setupStack()
//    }
//    func setupStack() {
//        axis = .horizontal // Или .vertical
//        distribution = .equalSpacing // Варианты: .fill, .fillEqually, .fillProportionally, .equalSpacing, .equalCentering
//        spacing = 25
//        alignment = .center
//
//        self.addArrangedSubview(name)
//        self.addArrangedSubview(battery)
//        self.addArrangedSubview(typeGpsConnection)
//        self.addArrangedSubview(typeNetConnection)
//    }
//
//
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
