import UIKit

class TrackerInfoCell:UITableViewCell {
    var name = UILabel()
    var id = UILabel()
    var status = UIImageView()
    var battery = UIView()
    var typeGpsConnection: UIImageView!
    var typeNetConnection: UIImageView!
    
    init(name:String,id:String,battery:Int,typeGpsConnection: Conection,typeNetConnection: Conection ) {
        super.init(style: .default, reuseIdentifier: "tracker")
        self.name.text = name
        self.id.text = id
        //battery
        switch typeNetConnection {
        case Conection.missing:
            self.typeNetConnection = UIImageView(image: UIImage(named: "signal-status-missing.png"))
        case Conection.medium:
            self.typeNetConnection = UIImageView(image: UIImage(named: "signal-status-medium.png"))
        case Conection.stable:
            self.typeNetConnection = UIImageView(image: UIImage(named: "signal-status-stable.png"))
        }
        switch typeGpsConnection {
        case Conection.missing:
            self.typeGpsConnection = UIImageView(image: UIImage(named: "satellite-missing.png"))
        case Conection.medium:
            self.typeGpsConnection = UIImageView(image: UIImage(named: "satellite-medium.png"))
        case Conection.stable:
            self.typeGpsConnection = UIImageView(image: UIImage(named: "satellite-stable.png"))
        }
    }
    func setName(){
        self.name.frame = CGRect(x: 0, y: FRAME_LIST.height * 0.33, width: FRAME_LIST.width * 0.04, height: FRAME_LIST.height * 0.33)
        contentView.addSubview(name)
    }
    func setId(){
        self.id.frame = CGRect(x: FRAME_LIST.width * 0.08, y: FRAME_LIST.height * 0.33, width: FRAME_LIST.width * 0.12, height: FRAME_LIST.height * 0.33)
        contentView.addSubview(id)
    }
    func setStatus(){
        self.status.frame = CGRect(x: FRAME_LIST.width * 0.56, y: FRAME_LIST.height * 0.33, width: FRAME_LIST.width * 0.16, height: FRAME_LIST.height * 0.33)
        contentView.addSubview(status)
    }
    func setBattery(){
        self.battery.frame = CGRect(x: FRAME_LIST.width * 0.62, y: FRAME_LIST.height * 0.33, width: FRAME_LIST.width * 0.16, height: FRAME_LIST.height * 0.33)
        //contentView.addSubview(battery)
    }
    func setTypeGpsConnection(){
        self.typeGpsConnection.frame = CGRect(x: FRAME_LIST.width * 0.78, y: FRAME_LIST.height * 0.33, width: FRAME_LIST.width * 0.16, height: FRAME_LIST.height * 0.33)
        contentView.addSubview(typeGpsConnection)

    }
    func setTypeNetConnection(){
        self.typeNetConnection.frame = CGRect(x: FRAME_LIST.width * 0.80, y: FRAME_LIST.height * 0.33, width: FRAME_LIST.width * 0.16, height: FRAME_LIST.height * 0.33)
        contentView.addSubview(typeNetConnection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



enum Conection {
    case missing, medium, stable
}

