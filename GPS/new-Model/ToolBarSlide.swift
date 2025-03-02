import UIKit

class ToolBarSlide:UIView {
    var setingsButton: UIButton!
    var searchTracker: UITextField!
    var listTrackers: ListTrackers!
    var sortContainer: SortContainer!
    var nameSortContainer: UILabel!
    var list:ListTrackers!
    override init(frame:CGRect) {
        super.init(frame: CGRect(x: 0, y: frame.height * 0.915, width: frame.width, height: frame.height * 0.0865 ))
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7) // Красный с 50% прозрачностью
        layer.cornerRadius = 20
        mainView.view.addSubview(self)

        setSetingsButton();
        setSearchTracker();
        setPanGesture();
        
        self.frame = CGRect(x: 0, y: frame.height * 0.915, width: frame.width, height: frame.height)
        setSortContainer()
        setNameSortContainer()
        setListTrackers();


    }
    
    func setSetingsButton() {
        setingsButton = UIButton(frame: CGRect(x: frame.width * 0.85, y: frame.height * 0.20, width: frame.height * 0.45, height: frame.height * 0.45))
        setingsButton.setImage(resizeImage(image: UIImage(named: "settings-icon.png")!,targetSize: CGSize(width: frame.width ,height: frame.width )), for: .normal)
        self.addSubview(setingsButton)
    }
    
    
    func setSearchTracker() {
        searchTracker = UITextField(frame: CGRect(x: frame.width * 0.025, y: frame.height * 0.20, width: frame.width * 0.8, height: frame.height * 0.45))
        self.addSubview(searchTracker)
        searchTracker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        searchTracker.layer.cornerRadius = 10
        
        let image = UIImageView(image: UIImage(named:"lupa.png"))
        let frameS = searchTracker.frame
        image.frame = CGRect(x:frameS.width * 0.05 , y: frameS.height * 0.2, width: frameS.height * 0.6, height: frameS.height * 0.6)
        image.contentMode = .scaleAspectFit
        searchTracker.addSubview(image)

        //searchTracker.leftView = image
        //searchTracker.leftViewMode = .always

        
        self.addSubview(searchTracker)
        
    }
    func setListTrackers() {
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panGesture)
    }
    func setSortContainer() {
        sortContainer = SortContainer(frame: self.frame)
        self.addSubview(sortContainer)
    }
    func setNameSortContainer() {
        nameSortContainer = UILabel(frame: CGRect(x: frame.width * 0.025, y: frame.height * 0.0950 , width: frame.width * 0.80, height: frame.height * 0.02))
        nameSortContainer.text = "Sort container by:"
        nameSortContainer.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.addSubview(nameSortContainer)
    }
    func setList() {
        listTrackers = ListTrackers(frame: CGRect(x: frame.width * 0.025, y: frame.height * 0.130, width: frame.width * 0.80, height: frame.height * 0.87))
        self.addSubview(listTrackers)
    }
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        if ( self.frame.origin.y <= self.superview!.frame.height * 0.935 || translation.y < 0) {
            frame.origin.y += translation.y
            mainView.blurView.frame.origin.y += translation.y
            print(translation.y)
        }
        gesture.setTranslation(.zero, in: self.superview)
    }
}
