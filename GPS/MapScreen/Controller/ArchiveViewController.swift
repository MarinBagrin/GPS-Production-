import UIKit

class ArchiveViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var selectionLabel = UILabel()
    var initialLabel = UILabel()
    var initialDatePicker = UIDatePicker()
    var endLabel = UILabel()
    var endDatePicker =  UIDatePicker()
    var drawRouteButton = UIButton()
    var containerView = UIView()
    var initialContainer = UIView()
    var endContainer = UIView()
    var trackPicker = UIPickerView()
    var trackContainer = UIView()
    var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var viewModel: MapViewModel
    var coordinator:ArchieveCoordinator?
    init(_ viewModel:MapViewModel,coordinator:ArchieveCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
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
    }
    private func setupUI() {
        self.view.addSubview(blurEffect)
        self.view.addSubview(containerView)
        containerView.addSubview(selectionLabel)
        containerView.addSubview(trackContainer)
        containerView.addSubview(trackPicker)
        containerView.addSubview(initialLabel)
        containerView.addSubview(initialContainer)
        containerView.addSubview(endContainer)
        containerView.addSubview(initialDatePicker)
        containerView.addSubview(endLabel)
        containerView.addSubview(endDatePicker)
        containerView.addSubview(drawRouteButton)
        
        
        
        selectionLabel.translatesAutoresizingMaskIntoConstraints = false
        trackContainer.translatesAutoresizingMaskIntoConstraints = false
        trackPicker.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        initialLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        initialContainer.translatesAutoresizingMaskIntoConstraints = false
        endContainer.translatesAutoresizingMaskIntoConstraints = false
        initialDatePicker.translatesAutoresizingMaskIntoConstraints = false
        drawRouteButton.translatesAutoresizingMaskIntoConstraints = false
        
        trackPicker.delegate = self
        trackPicker.dataSource = self
        
        selectionLabel.text = "Select the tracker:"
        initialLabel.text = "Initial date:"
        endLabel.text = "Final date:"
        drawRouteButton.setTitle("Show rute", for: .normal)
        
        selectionLabel.font = UIFont.systemFont(ofSize: 24)
        initialLabel.font = UIFont.systemFont(ofSize: 24)
        endLabel.font = UIFont.systemFont(ofSize: 24)
        
        initialLabel.textAlignment = .left
        endLabel.textAlignment = .left
        
        initialDatePicker.datePickerMode = .dateAndTime
        endDatePicker.datePickerMode = .dateAndTime
        
        initialDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.preferredDatePickerStyle = .wheels
        
        
        
        
        containerView.backgroundColor = .black .withAlphaComponent(0.35)
        trackContainer.backgroundColor = .black .withAlphaComponent(0.35)
        initialContainer.backgroundColor = .black .withAlphaComponent(0.35)
        endContainer.backgroundColor = .black .withAlphaComponent(0.35)
        drawRouteButton.backgroundColor = .black .withAlphaComponent(0.5)
        
        drawRouteButton.layer.cornerRadius = 5
        trackContainer.layer.cornerRadius = 10
        containerView.layer.cornerRadius = 10
        endContainer.layer.cornerRadius = 10
        trackPicker.layer.cornerRadius = 10
        initialContainer.layer.cornerRadius = 10
        
        blurEffect.frame = self.view.frame
        blurEffect.alpha = 0.99
        let sizeContainer = CGSize(width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.60)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: self.view.frame.height * 0.1),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: self.view.frame.width * 0.025),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -(self.view.frame.width * 0.025)),
            containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor,multiplier: 0.60),
            
            selectionLabel.bottomAnchor.constraint(equalTo: trackPicker.topAnchor),
            selectionLabel.leadingAnchor.constraint(equalTo: initialLabel.leadingAnchor),
            selectionLabel.trailingAnchor.constraint(equalTo: initialLabel.trailingAnchor),
            
            trackPicker.topAnchor.constraint(equalTo: containerView.topAnchor, constant: sizeContainer.height * 0.075),
            trackPicker.bottomAnchor.constraint(equalTo: initialDatePicker.topAnchor, constant: sizeContainer.height * -0.1),
            trackPicker.leadingAnchor.constraint(equalTo: initialLabel.leadingAnchor),
            trackPicker.trailingAnchor.constraint(equalTo: initialLabel.trailingAnchor),
            
            trackContainer.topAnchor.constraint(equalTo: trackPicker.topAnchor),
            trackContainer.leadingAnchor.constraint(equalTo: trackPicker.leadingAnchor),
            trackContainer.trailingAnchor.constraint(equalTo: trackPicker.trailingAnchor),
            trackContainer.bottomAnchor.constraint(equalTo: trackPicker.bottomAnchor),
            
            initialLabel.bottomAnchor.constraint(equalTo: initialDatePicker.topAnchor),
            initialLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: sizeContainer.width * 0.10),
            initialLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: sizeContainer.width * -0.10),
            
            
            initialDatePicker.bottomAnchor.constraint(equalTo: endDatePicker.topAnchor,constant: sizeContainer.height * -0.1),
            initialDatePicker.leadingAnchor.constraint(equalTo: initialLabel.leadingAnchor),
            initialDatePicker.trailingAnchor.constraint(equalTo: initialLabel.trailingAnchor),
            initialDatePicker.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2),
            
            endLabel.bottomAnchor.constraint(equalTo: endDatePicker.topAnchor),
            endLabel.leadingAnchor.constraint(equalTo: initialLabel.leadingAnchor),
            endLabel.trailingAnchor.constraint(equalTo: initialLabel.trailingAnchor),
            
            endDatePicker.topAnchor.constraint(equalTo: endLabel.bottomAnchor),
            endDatePicker.leadingAnchor.constraint(equalTo: endLabel.leadingAnchor),
            endDatePicker.trailingAnchor.constraint(equalTo: endLabel.trailingAnchor),
            endDatePicker.heightAnchor.constraint(equalTo: containerView.heightAnchor,multiplier: 0.2),
            
            
            
            drawRouteButton.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor,constant: sizeContainer.height * 0.05),
            drawRouteButton.leadingAnchor.constraint(equalTo: initialLabel.leadingAnchor),
            drawRouteButton.trailingAnchor.constraint(equalTo: initialLabel.trailingAnchor),
            drawRouteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: sizeContainer.height * -0.05),
            
            initialContainer.topAnchor.constraint(equalTo: initialLabel.bottomAnchor),
            initialContainer.leadingAnchor.constraint(equalTo: initialLabel.leadingAnchor),
            initialContainer.trailingAnchor.constraint(equalTo: initialLabel.trailingAnchor),
            initialContainer.heightAnchor.constraint(equalTo: initialDatePicker.heightAnchor),
            
            endContainer.topAnchor.constraint(equalTo: endLabel.bottomAnchor),
            endContainer.leadingAnchor.constraint(equalTo: initialLabel.leadingAnchor),
            endContainer.trailingAnchor.constraint(equalTo: initialLabel.trailingAnchor),
            endContainer.heightAnchor.constraint(equalTo: endDatePicker.heightAnchor),
        ])
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
            print("Выбрано: \(viewModel.trackers.value[row].value.name)")
        }
    }
}

