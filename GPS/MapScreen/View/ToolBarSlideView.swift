
import UIKit
var borderTB = [0, 0, 0.05, 0.90]
var SIZE_CELL: CGSize!

class ToolBarSlideView:UIView {
    var setingsButton: UIButton!
    var searchTracker: UITextField!
    var slider: UIView!
    var listTrackers: UITableView!
    var sortContainer: SortContainer!
    var nameSortContainer: UILabel!
    var list:UITableView!
    var direction:[CGFloat]  = [0,0,0]
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var viewModel:MapViewModel
    private var screen: CGRect
    private var i = 0;
    
    init(frame:CGRect,viewModel:MapViewModel) {
        self.viewModel = viewModel
        screen = frame
        super.init(frame: CGRect(x: 0, y: frame.height * 90, width: frame.width, height: frame.height * 0.0865 ))
        setupUI()
        bindingMapViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bindingMapViewModel() {
        viewModel.trackers.bind{[weak self] trackersViewModel in
            DispatchQueue.main.async {
                self?.listTrackers.reloadData()
            }
        }
        viewModel.redrawTrackersTable.bind{[weak self] isNeededRedraw in
            if (isNeededRedraw) {
                DispatchQueue.main.async {
                    self?.listTrackers.reloadData()
                }
            }
        }
    }
    private func setupUI() {
        self.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.60)
        self.layer.cornerRadius = 15
        
        blurView.frame = screen // Растягиваем на весь_экр
        self.clipsToBounds = true
       

        
        
        
        setingsButton = UIButton(frame: CGRect(x: frame.width * 0.85, y: frame.height * 0.20, width: frame.height * 0.45, height: frame.height * 0.45))
        setingsButton.setImage(resizeImage(image: UIImage(named: "settings-icon.png")!,targetSize: CGSize(width: frame.width ,height: frame.width )), for: .normal)
        setingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .allTouchEvents)
        
        
        searchTracker = UITextField(frame: CGRect(x: frame.width * borderTB[2], y: frame.height * 0.20, width: frame.width * borderTB[3], height: frame.height * 0.45))
        searchTracker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        searchTracker.layer.cornerRadius = 10
        searchTracker.placeholder = translate[lang]!["sgtracker"]!
        searchTracker.delegate = self

        self.frame = CGRect(x: 0, y: screen.height * 0.88, width: screen.width, height: screen.height)
        
        slider = UIView(frame: CGRect(x: frame.width * 0.45, y: frame.height * 0.005, width: frame.width * 0.10, height: frame.height * 0.004))
        slider.backgroundColor = .white.withAlphaComponent(0.95)
        slider.layer.cornerRadius = 2
        
        let image = UIImageView(image: UIImage(named:"lupa.png"))
        image.frame = CGRect(x: searchTracker.frame.width * 0.01, y: searchTracker.frame.height * 0.20, width:  searchTracker.frame.width * 0.08, height:  searchTracker.frame.height * 0.6)
        image.contentMode = .scaleAspectFit
        searchTracker.addSubview(image)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width:  searchTracker.frame.width * 0.1, height:  searchTracker.frame.height * 1))
        searchTracker.leftView = container
        searchTracker.leftViewMode = .always
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panGesture)
        
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureUp.direction = .up
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureDown.direction = .down
        
        self.addGestureRecognizer(swipeGestureUp)
        self.addGestureRecognizer(swipeGestureDown)
        
        sortContainer = SortContainer(frame: self.frame)
    
        nameSortContainer = UILabel(frame: CGRect(x: frame.width * borderTB[2], y: frame.height * 0.0950 , width: frame.width * 0.80, height: frame.height * 0.02))
        nameSortContainer.text = translate[lang]!["sortby"]!
        nameSortContainer.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        
        listTrackers = UITableView(frame: CGRect(x: frame.width * borderTB[2], y: frame.height * 0.180, width: frame.width * borderTB[3], height: frame.height * 0.385))
        listTrackers.delegate = self
        listTrackers.dataSource = self
        listTrackers.backgroundColor = .white.withAlphaComponent(0.10)
        listTrackers.layer.cornerRadius = 5
        listTrackers.layer.shadowColor = UIColor.black.cgColor
        listTrackers.layer.shadowOffset = CGSize(width: 0, height: 2)
        listTrackers.layer.shadowRadius = 4
        listTrackers.layer.shadowOpacity = 0.3
        
        self.addSubview(blurView)
        self.addSubview(setingsButton)
        self.addSubview(searchTracker)
        self.addSubview(slider)
        self.addSubview(sortContainer)
        self.addSubview(listTrackers)
        self.addSubview(nameSortContainer)
    }
   
    @objc func settingsButtonTapped() {
        viewModel.settingsButtonTapped()
    }
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        self.searchTracker.resignFirstResponder() // Скрываем клавиатуру при нажатии "Return"
        
        var flag = false
        let translation = gesture.translation(in: self.superview)
        switch gesture.state {
        case .changed:
            
            if (self.frame.origin.y > self.frame.height * 0.40) {
                if (self.frame.origin.y < self.frame.height * 0.88 || translation.y < 0) {
                    flag = true
                }
            }
            else if (self.frame.origin.y <= self.frame.height * 0.40 && translation.y > 0) {
                flag = true
            }
            if (flag) {
                frame.origin.y += translation.y
                i += 1
                direction[i%3] = translation.y
            }
            
        case .ended:
            if (self.frame.origin.y > self.frame.height * 0.80) {
                UIView.animate(withDuration: 0.2,animations: {
                    self.frame.origin.y = self.frame.height * 0.930
                }){ _ in
                    UIView.animate(withDuration: 0.2) {
                        self.frame.origin.y = self.frame.height * 0.88
                    }
                }
            }
            else if (checkDirectory() == 1) {
                UIView.animate(withDuration: 0.2,animations: {
                    self.frame.origin.y = self.frame.height * 0.930
                }){ _ in
                    UIView.animate(withDuration: 0.2) {
                        self.frame.origin.y = self.frame.height * 0.88
                    }
                }
            }
            else {
                UIView.animate(withDuration: 0.2){
                    self.frame.origin.y = self.frame.height * 0.40
                }
                
            }
        default:
            break
        }
        
        
        gesture.setTranslation(.zero, in: self.superview)
    }
    
    
    
    
    @objc func handleSwipe(_ gesture:UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            UIView.animate(withDuration: 0.2) {
                self.frame.origin.y = self.frame.height * 0.35
            }
            print("Swipe Up")
        case .down:
            UIView.animate(withDuration: 0.2,animations: {
                self.frame.origin.y = self.frame.height * 0.930
            }){ _ in
                UIView.animate(withDuration: 0.2) {
                    self.frame.origin.y = self.frame.height * 0.88
                }
            }
            print("Swipe Down")
            
        default:
            break
        }
    }

    func checkDirectory() -> Int {
        //print(direction[0],direction[1],direction[2])
        if ( direction[0] > 0  && direction[1] > 0 && direction[2] > 0 ) {
            return 1
        }
        if ( direction[0] < 0  && direction[1] < 0 && direction[2] < 0 ) {
            return -1
        }
        return 0
        
    }
    func setPosXTollBar(duration:Double, y: CGFloat) {
        UIView.animate(withDuration: duration){
            self.frame.origin.y = self.screen.height * y
        }
    }
}

extension ToolBarSlideView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Скрываем клавиатуру при нажатии "Return"
            return true
        }
    func textFieldDidBeginEditing(_ textField:UITextField) {
        setPosXTollBar(duration:0.3,y:0.05)
//        if (checkFullCharSpace(textField: textField)) {
//            textField.text = ""
//        }
    }
    func textFieldDidEndEditing(_ textField:UITextField) {
        setPosXTollBar(duration: 0.2, y: 0.40)
//        if (checkFullCharSpace(textField: textField)) {
//            textField.text = ""
//        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let str:String = textField.text!
        
        return true
    }
    
}

func checkFullCharSpace(textField:UITextField) -> Bool{
    for char in textField.text! {
        if (char != " ") {
            return false
        }
    }
    return true
}

extension ToolBarSlideView: UITableViewDataSource, UITableViewDelegate {
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackers.value.count // items - массив данных
    }
    
    // Ячейка для строки в таблице
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "tracker") ?? TrackerInfoCell(tracker:STServer.filteredTrackers[indexPath.row])
        //(cell as! TrackerInfoCell).update(tracker:STServer.filteredTrackers[indexPath.row])
        //cell?.textLabel?.text = STServer.trackers[indexPath.row].name // Настройка ячейки
        //print((cell as! TrackerInfoCell).name.text!)
        let cell = TrackerInfoCell(tracker: viewModel.trackers.value[indexPath.row].value)
        cell.update(tracker: viewModel.trackers.value[indexPath.row].value)
        return cell
    }
    
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listTrackers.frame.height * 0.15
    }
    
    // Обработка выбора ячейки
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        mainView.listMaps.activeView.maps[1].setCameraOnTracker(trackerShowMap: STServer.filteredTrackers[indexPath.row])
//        print("Выбрана строка: \(indexPath.row)")
//    }
}
