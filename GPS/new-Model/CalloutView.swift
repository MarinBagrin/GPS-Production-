import UIKit

class CalloutView: UIView {
    //var image = UIImageView(image: UIImage(named: "bubble-speech.png"))
    var title = UILabel()
    var text = UITextView()
    static var openCallout:CalloutView?
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    private func setupUI() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)

        text.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 5
        
        text.backgroundColor = UIColor.systemGray.withAlphaComponent(0.55)
        text.font = UIFont(name: "Arial", size: 18)
        
       self.backgroundColor = UIColor.black.withAlphaComponent(0.80)
        //self.layer.borderWidth = 2
        //self.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        self.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            title.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5 ),
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        self.addSubview(text)
        NSLayoutConstraint.activate([
            text.heightAnchor.constraint(equalTo: self.heightAnchor,multiplier: 0.8),
            text.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            text.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            text.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
    }
    func updateData(tracker:Tracker) {
        title.text = tracker.name
        text.text = "Status:\(dictConnection[tracker.connectionNET]!);\nGPS Battery:\(String(tracker.battery))%\nGMS: Stable;\nActivity: Moving;\nTime:\(tracker.time!);\nAddress:\(tracker.address!)"
        print("Yes")
    }
    func showHide() {
        print("showHide")
//        CalloutView.openCallout?.showHide()
        if (CalloutView.openCallout == self) { CalloutView.openCallout = nil}
        else {
            CalloutView.openCallout?.showHide()
            CalloutView.openCallout = self
        }

        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = self.alpha == 1 ? 0 : 1
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var dictConnection:[Conection:String] = [Conection.missing:"Offline", Conection.medium:"Medium",Conection.stable:"Stable"]
