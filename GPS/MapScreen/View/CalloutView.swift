import UIKit
class CalloutView:UIView {
    let text = UILabel()
    let name = UILabel()
    init(trackerVM:Observable<TrackerViewModel>) {
        super.init(frame: .zero)
        setupUI()
        trackerVM.bind { [weak self] trackerVM in
            self?.text.text = "\(translate[lang]!["network"]!) \(trackerVM.networkBTS)% \n\(translate[lang]!["gps"]!) \(trackerVM.networkBTS) %  \n\(translate[lang]!["speed"]!) \(trackerVM.speed)km/h \n\(translate[lang]!["time_updated"]!) \(trackerVM.time)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        self.backgroundColor = .black.withAlphaComponent(0.35)

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.translatesAutoresizingMaskIntoConstraints = false
        blur.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        self.addSubview(blur)
        self.addSubview(name)
        self.addSubview(text)
        text.font = UIFont.systemFont(ofSize: 20) 
        NSLayoutConstraint.activate([
            blur.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            blur.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            blur.heightAnchor.constraint(equalTo: self.heightAnchor),
            blur.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            name.topAnchor.constraint(equalTo: self.topAnchor),
            name.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            text.topAnchor.constraint(equalTo: name.bottomAnchor),
            text.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            text.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            text.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        text.text = "\(translate[lang]!["network"]!) \n\(translate[lang]!["gps"]!)\n\(translate[lang]!["speed"]!)\n\(translate[lang]!["time_updated"] ?? "1")"
        
    }

}
