
import UIKit
import MapKit
var SIZE_CELL: CGSize!
import GoogleMaps

class ListTrackers: UITableView{

    
    init(frame:CGRect) {
        super.init(frame: frame, style: .plain)
        SIZE_CELL = CGSize(width: frame.width, height: frame.height * 0.15)
        self.backgroundColor = .white.withAlphaComponent(0.10)
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

extension ToolBarSlide: UITableViewDataSource, UITableViewDelegate {
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STServer.filteredTrackers.count // items - массив данных
    }
    
    // Ячейка для строки в таблице
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tracker") ?? TrackerInfoCell(tracker:STServer.filteredTrackers[indexPath.row])
        (cell as! TrackerInfoCell).update(tracker:STServer.filteredTrackers[indexPath.row])
        //cell?.textLabel?.text = STServer.trackers[indexPath.row].name // Настройка ячейки
        //print((cell as! TrackerInfoCell).name.text!)
        return cell
    }
    
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SIZE_CELL.height
    }
    
    // Обработка выбора ячейки
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        mainView.listMaps.activeView.maps[1].setCameraOnTracker(trackerShowMap: STServer.filteredTrackers[indexPath.row])
//        print("Выбрана строка: \(indexPath.row)")
//    }
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
            if subView is ToolBarSlide {
                setPosXTollBar(duration: 0.2, y: 0.88)
                continue
            }
            if subView is UIVisualEffectView {
                continue
            }
            if subView is ActionMenu {
                continue
            }
            subView.removeFromSuperview()
        }
    }
}
