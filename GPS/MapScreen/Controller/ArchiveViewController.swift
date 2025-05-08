import UIKit
import Combine
class ArchiveViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var mainStack:UIStackView!
    var initialDatePicker:UIDatePicker!
    var endDatePicker:UIDatePicker!

    
    
    var selectionLabel = UILabel()
    var initialLabel = UILabel()
    var endLabel = UILabel()
    var drawRouteButton = UIButton()
    var containerView = UIView()
    var initialContainer = UIView()
    var endContainer = UIView()
    var trackPicker = UIPickerView()
    var trackContainer = UIView()
    var showRouteButton:UIButton!
    var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var viewModel: MapViewModel
    private var pickedTrackerName:String?
    var coordinator:ArchieveCoordinator?
    private var cancellabels = Set<AnyCancellable>()
    init(_ viewModel:MapViewModel,coordinator:ArchieveCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
    }
    deinit {
        coordinator?.removeFromParrentCoordinator()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    private func bindViewModel() {
        viewModel.trackers.bind{[weak self] trackers in
            self?.trackPicker.reloadAllComponents()
        }
        viewModel.getShowingRouteFlag()
            .sink { [weak self] isShowingRoute in
                self?.showRouteButton.isSelected = isShowingRoute
            }
            .store(in: &cancellabels)
    }
    private func setupUI() {
        func getStackDatePicker(with name:String) ->UIStackView{
            var title = UILabel()
            title.setContentCompressionResistancePriority(.required, for: .horizontal)
            title.text = name
            title.translatesAutoresizingMaskIntoConstraints = false
            title.textAlignment = .justified
            title.font = .systemFont(ofSize: 18)
        
            var date = UIDatePicker()
            date.datePickerMode = .dateAndTime
            date.preferredDatePickerStyle = .compact

            if (name == "Initial date") {
                self.initialDatePicker = date
            }
            else if (name == "End date") {
                self.endDatePicker = date
            }
            date.minimumDate = Date.now.addingTimeInterval(-24*60*60)
            date.maximumDate = Date.now
            date.translatesAutoresizingMaskIntoConstraints = false
            var dateStack = UIStackView(arrangedSubviews: [title,date])
            dateStack.distribution = .fill
            dateStack.spacing = 32
            title.textAlignment = .natural
            dateStack.axis = .horizontal
            //dateStack.backgroundColor = .gray.withAlphaComponent(40)
            dateStack.layer.cornerRadius = 4
            date.layer.borderColor = UIColor.gray.cgColor
            //dateStack.distribution =
            //date.contentHorizontalAlignment = .center
            //dateStack.spacing = 1
            dateStack.translatesAutoresizingMaskIntoConstraints = false
            return dateStack
        }
        func getSeparator() -> UIView {
        var separator = UIView()
            separator.backgroundColor = .separator
            separator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                separator.heightAnchor.constraint(equalToConstant: 1)
            ])
            return separator
        }
        var blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.layer.cornerRadius = 12
        var title = UILabel()
        
        // пусть label «любит» свой контент сильнее, чем растягиваться
        //title.setContentHuggingPriority(.required, for: .vertical)

        // и пусть он «цепляется» за свой размер сильнее, чем сжиматься
        //title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.text = "Choice route"
        title.font = .systemFont(ofSize: 24)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton()
        
        let routeButton = UIButton()
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.red, for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 20)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        closeButton.layer.cornerRadius = 8
        
        routeButton.setTitle("Show route", for: .normal)
        routeButton.setTitle("Hide route", for: .selected)

        routeButton.titleLabel?.font = .systemFont(ofSize: 20)

        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        routeButton.layer.cornerRadius = 8
        routeButton.titleLabel?.textColor = .white
        
        routeButton.addTarget(self, action: #selector(showRouteButtonTapped), for: .touchUpInside)
        
        showRouteButton = routeButton
        let buttonStack = UIStackView(arrangedSubviews: [closeButton,routeButton])
        //buttonStack.alignment =
        //buttonStack.alignment =
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        // Задаём отступы для всего стека
        buttonStack.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        // Говорим, что при распределении места нужно учитывать эти отступы
        buttonStack.isLayoutMarginsRelativeArrangement = true
        trackPicker.delegate = self
        trackPicker.dataSource = self
        trackPicker.translatesAutoresizingMaskIntoConstraints = false
        mainStack = UIStackView(arrangedSubviews: [
            title,
            trackPicker,
            getStackDatePicker(with: "Initial date"),
            getSeparator(),
            getStackDatePicker(with: "End date"),
            buttonStack,
        ])
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        //mainStack.alignment = .center
        mainStack.layer.cornerRadius = 12
        mainStack.spacing = 4
        mainStack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        mainStack.isLayoutMarginsRelativeArrangement = true
        // Говорим, что при распределении места нужно учитывать эти отст
        mainStack.distribution = .fill
        self.view.addSubview(blur)

        self.view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            //title.heightAnchor.constraint(equalToConstant: 12*3),
            mainStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            blur.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            blur.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            blur.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            blur.heightAnchor.constraint(equalTo: mainStack.heightAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 48),
            mainStack.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4),
            mainStack.widthAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4)
        ])
    }
    @objc func closeButtonTapped() {
        coordinator?.closeArchiveVC()
    }
    @objc func showRouteButtonTapped(sender:UIButton) {
        viewModel.toogleShowingRouteFlag()

        if sender.isSelected {
            let selectInitialDate = initialDatePicker.date
            let selectEndDate = endDatePicker.date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let strInitialDate = formatter.string(from: selectInitialDate)
            let strEndDate = formatter.string(from: selectEndDate)
            print(strInitialDate, strEndDate)
            guard let pickedName = pickedTrackerName else {print("archive error picked name");return }
            viewModel.setArchiveShowing(initial:strInitialDate, end:strEndDate, for:pickedName)
            print("dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss","dismiss")
            coordinator?.closeArchiveVC()
        }
        else {
            viewModel.setOnlineShowing()
            coordinator?.closeArchiveVC()

        }

    }
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Кол-во колонок
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.trackers.value.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.trackers.value[row].value.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (!(viewModel.trackers.value.isEmpty)) {
            pickedTrackerName = viewModel.trackers.value[row].value.name
            print("Выбрано: \(viewModel.trackers.value[row].value.name)")
        }
    }
}

//self.view.addSubview(blurEffect)
//        self.view.addSubview(containerView)
//        containerView.addSubview(selectionLabel)
//        containerView.addSubview(trackContainer)
//        trackContainer.addSubview(trackPicker)
//        containerView.addSubview(initialLabel)
//        containerView.addSubview(initialContainer)
//        initialContainer.addSubview(initialDatePicker)
//        containerView.addSubview(endLabel)
//        containerView.addSubview(endContainer)
//        endContainer.addSubview(endDatePicker)
//        containerView.addSubview(drawRouteButton)
//
//        selectionLabel.translatesAutoresizingMaskIntoConstraints = false
//        trackContainer.translatesAutoresizingMaskIntoConstraints = false
//        trackPicker.translatesAutoresizingMaskIntoConstraints = false
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        initialLabel.translatesAutoresizingMaskIntoConstraints = false
//        endLabel.translatesAutoresizingMaskIntoConstraints = false
//        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
//        initialContainer.translatesAutoresizingMaskIntoConstraints = false
//        endContainer.translatesAutoresizingMaskIntoConstraints = false
//        initialDatePicker.translatesAutoresizingMaskIntoConstraints = false
//        drawRouteButton.translatesAutoresizingMaskIntoConstraints = false
//
//        trackPicker.delegate = self
//        trackPicker.dataSource = self
//
//        selectionLabel.text = "Select the tracker:"
//        initialLabel.text = "Initial date:"
//        endLabel.text = "Final date:"
//        drawRouteButton.setTitle("Show rute", for: .normal)
//
//        selectionLabel.font = UIFont.systemFont(ofSize: 24)
//        initialLabel.font = UIFont.systemFont(ofSize: 24)
//        endLabel.font = UIFont.systemFont(ofSize: 24)
//
//        initialLabel.textAlignment = .left
//        endLabel.textAlignment = .left
//
//        initialDatePicker.datePickerMode = .dateAndTime
//        endDatePicker.datePickerMode = .dateAndTime
//
//        initialDatePicker.preferredDatePickerStyle = .compact
//        endDatePicker.preferredDatePickerStyle = .compact
//
//
//
//
//        containerView.backgroundColor = .systemGray6
//        trackContainer.backgroundColor = .black .withAlphaComponent(0.5)
//        initialContainer.backgroundColor = .black .withAlphaComponent(0.5)
//        endContainer.backgroundColor = .black .withAlphaComponent(0.5)
//        drawRouteButton.backgroundColor = .black.withAlphaComponent(0.5)
//
//        drawRouteButton.layer.cornerRadius = 5
//        trackContainer.layer.cornerRadius = 10
//        containerView.layer.cornerRadius = 10
//        endContainer.layer.cornerRadius = 10
//        trackPicker.layer.cornerRadius = 10
//        initialContainer.layer.cornerRadius = 10
//
//        blurEffect.frame = self.view.frame
//        blurEffect.alpha = 0.99
//
//        drawRouteButton.addTarget(self, action: #selector(showRouteButtonTapped), for: .touchUpInside)
//
//        let sizeContainer = CGSize(width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.60)
//        NSLayoutConstraint.activate([
//            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: self.view.frame.width * 0.025),
//            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -(self.view.frame.width * 0.025)),
//            containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor,multiplier: 0.50),
//
//
//            selectionLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
//            selectionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: sizeContainer.width * 0.10),
//            selectionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: sizeContainer.width * -0.10),
//
//            trackContainer.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor),
//            trackContainer.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            trackContainer.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//            trackContainer.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.1),
//
//            trackPicker.topAnchor.constraint(equalTo: trackContainer.topAnchor),
//            trackPicker.leadingAnchor.constraint(equalTo: trackContainer.leadingAnchor),
//            trackPicker.trailingAnchor.constraint(equalTo: trackContainer.trailingAnchor),
//            trackPicker.bottomAnchor.constraint(equalTo: trackContainer.bottomAnchor),
//
//            initialLabel.topAnchor.constraint(equalTo: trackContainer.bottomAnchor,constant: 8),
//            initialLabel.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            initialLabel.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//
//            initialContainer.topAnchor.constraint(equalTo: initialLabel.bottomAnchor),
//            initialContainer.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            initialContainer.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//            initialContainer.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.1),
//
//            initialDatePicker.topAnchor.constraint(equalTo: initialContainer.topAnchor),
//            initialDatePicker.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            initialDatePicker.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//            initialDatePicker.heightAnchor.constraint(equalTo: initialContainer.heightAnchor),
//
//            endLabel.topAnchor.constraint(equalTo: initialContainer.bottomAnchor,constant: 8),
//            endLabel.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            endLabel.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//
//            endContainer.topAnchor.constraint(equalTo: endLabel.bottomAnchor),
//            endContainer.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            endContainer.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//            endContainer.heightAnchor.constraint(equalTo: containerView.heightAnchor,multiplier: 0.1),
//
//            endDatePicker.topAnchor.constraint(equalTo: endContainer.topAnchor),
//            endDatePicker.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            endDatePicker.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//            endDatePicker.heightAnchor.constraint(equalTo: endContainer.heightAnchor),
//
//            drawRouteButton.leadingAnchor.constraint(equalTo: selectionLabel.leadingAnchor),
//            drawRouteButton.trailingAnchor.constraint(equalTo: selectionLabel.trailingAnchor),
//            drawRouteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: sizeContainer.height * -0.05),
//        ])
