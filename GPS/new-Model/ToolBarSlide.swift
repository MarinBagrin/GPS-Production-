import UIKit
var borderTB = [0, 0, 0.05, 0.90]

class ToolBarSlide:UIView {
    var setingsButton: UIButton!
    var searchTracker: UITextField!
    var slider: UIView!
    var listTrackers: ListTrackers!
    var sortContainer: SortContainer!
    var nameSortContainer: UILabel!
    var list:ListTrackers!
    var direction:[CGFloat]  = [0,0,0]
    private var i = 0;
    override init(frame:CGRect) {
        super.init(frame: CGRect(x: 0, y: frame.height * 90, width: frame.width, height: frame.height * 0.0865 ))
        
        backgroundColor = UIColor.systemGray6.withAlphaComponent(0.60)
        layer.cornerRadius = 20

        setSetingsButton();
        setSearchTracker();
        setPanGesture();
        
        self.frame = CGRect(x: 0, y: frame.height * 0.88, width: frame.width, height: frame.height)
        setSortContainer()
        setNameSortContainer()
        setList();
        
        setSlider()
        //setSwipeGesture()
        mainView.view.addSubview(self)

    }
    func setSlider() {
        slider = UIView(frame: CGRect(x: frame.width * 0.45, y: frame.height * 0.005, width: frame.width * 0.10, height: frame.height * 0.004))
        slider.backgroundColor = .white.withAlphaComponent(0.95)
        slider.layer.cornerRadius = 2
        self.addSubview(slider)
    }
    func setSetingsButton() {
        setingsButton = UIButton(frame: CGRect(x: frame.width * 0.85, y: frame.height * 0.20, width: frame.height * 0.45, height: frame.height * 0.45))
        setingsButton.setImage(resizeImage(image: UIImage(named: "settings-icon.png")!,targetSize: CGSize(width: frame.width ,height: frame.width )), for: .normal)
        self.addSubview(setingsButton)
    }
    
    
    func setSearchTracker() {
        searchTracker = UITextField(frame: CGRect(x: frame.width * borderTB[2], y: frame.height * 0.20, width: frame.width * borderTB[3], height: frame.height * 0.45))
        self.addSubview(searchTracker)
        searchTracker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        searchTracker.layer.cornerRadius = 10
        searchTracker.placeholder = "Search GPS tracker"
        searchTracker.delegate = self
        
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width:  searchTracker.frame.width * 0.1, height:  searchTracker.frame.height * 1))
        let image = UIImageView(image: UIImage(named:"lupa.png"))
        image.contentMode = .scaleAspectFit
        
        searchTracker.addSubview(image)
        
        image.frame = CGRect(x: searchTracker.frame.width * 0.01, y: searchTracker.frame.height * 0.20, width:  searchTracker.frame.width * 0.08, height:  searchTracker.frame.height * 0.6)
//        NSLayoutConstraint.activate([
//            image.widthAnchor.constraint(equalTo: searchTracker.widthAnchor, multiplier: 0.03),
//            image.heightAnchor.constraint(equalTo: searchTracker.heightAnchor, multiplier: 0.3),
//            image.centerYAnchor.constraint(equalTo: searchTracker.centerYAnchor),
//            //image.centerXAnchor.constraint(equalTo: searchTracker.centerXAnchor)
//        ])


        searchTracker.leftView = container
        
        searchTracker.leftViewMode = .always
    }
//    func setListTrackers() {
//
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panGesture)
    }
    func setSwipeGesture() {
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureUp.direction = .up
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureDown.direction = .down

        self.addGestureRecognizer(swipeGestureUp)
        self.addGestureRecognizer(swipeGestureDown)
    }
    func setSortContainer() {
        sortContainer = SortContainer(frame: self.frame)
        self.addSubview(sortContainer)
    }
    func setNameSortContainer() {
        nameSortContainer = UILabel(frame: CGRect(x: frame.width * borderTB[2], y: frame.height * 0.0950 , width: frame.width * 0.80, height: frame.height * 0.02))
        nameSortContainer.text = "Filter by:"
        nameSortContainer.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.addSubview(nameSortContainer)
    }
    func setList() {
        listTrackers = ListTrackers(frame: CGRect(x: frame.width * borderTB[2], y: frame.height * 0.180, width: frame.width * borderTB[3], height: frame.height * 0.385))
        listTrackers.delegate = self
        listTrackers.dataSource = self
        //listTrackers.register(TrackerInfoCell.self, forCellReuseIdentifier: "CustomCell")

        self.addSubview(listTrackers)
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
                mainView.blurView.frame.origin.y += translation.y
                i += 1
                direction[i%3] = translation.y
            }
            
        case .ended:
            if (self.frame.origin.y > self.frame.height * 0.80) {
                UIView.animate(withDuration: 0.2,animations: {
                    self.frame.origin.y = self.frame.height * 0.930
                    mainView.blurView.frame.origin.y = self.frame.height * 0.930
                }){ _ in
                    UIView.animate(withDuration: 0.2) {
                        self.frame.origin.y = self.frame.height * 0.88
                        mainView.blurView.frame.origin.y = self.frame.height * 0.88
                    }
                }
            }
            else if (checkDirectory() == 1) {
                UIView.animate(withDuration: 0.2,animations: {
                    self.frame.origin.y = self.frame.height * 0.930
                    mainView.blurView.frame.origin.y = self.frame.height * 0.930
                }){ _ in
                    UIView.animate(withDuration: 0.2) {
                        self.frame.origin.y = self.frame.height * 0.88
                        mainView.blurView.frame.origin.y = self.frame.height * 0.88
                    }
                }
                }
            else {
                UIView.animate(withDuration: 0.2){
                    self.frame.origin.y = self.frame.height * 0.40
                    mainView.blurView.frame.origin.y = self.frame.height * 0.40
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
                mainView.blurView.frame.origin.y = self.frame.height * 0.35
            }
            print("Swipe Up")
        case .down:
            UIView.animate(withDuration: 0.2,animations: {
                self.frame.origin.y = self.frame.height * 0.930
                mainView.blurView.frame.origin.y = self.frame.height * 0.930
            }){ _ in
                UIView.animate(withDuration: 0.2) {
                    self.frame.origin.y = self.frame.height * 0.88
                    mainView.blurView.frame.origin.y = self.frame.height * 0.88
                }
            }
            print("Swipe Down")

        default:
            break
        }
    }
    
    func checkDirectory() -> Int {
        print(direction[0],direction[1],direction[2])
        if ( direction[0] > 0  && direction[1] > 0 && direction[2] > 0 ) {
            return 1
        }
        if ( direction[0] < 0  && direction[1] < 0 && direction[2] < 0 ) {
            return -1
        }
        return 0
        
    }
}

extension ToolBarSlide: UITextFieldDelegate {
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
        if (string.isEmpty) {
            if (textField.text?.count == 1){
                STServer.filterByTextField(inString:"")
            }
            else {
                STServer.filterByTextField(inString:str)
            }
        }
        else {
            STServer.filterByTextField(inString:str + string)
        }
//        for i in STServer.filteredTrackers {
//            print(i.name!)
//        }
        self.listTrackers.reloadData()
        
        return true
    }
}



func setPosXTollBar(duration:Double, y: CGFloat) {
    UIView.animate(withDuration: duration){
        mainView.toolBarSlide.frame.origin.y = mainView.view.frame.height * y
        mainView.blurView.frame.origin.y = mainView.view.frame.height * y
        
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
