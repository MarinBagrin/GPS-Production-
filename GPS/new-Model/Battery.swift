import UIKit

class BatteryView: UIView {
    private var fillView = UIView()
    private var procentsLabel = UILabel()
    private var procent:Int!
    var fillViewTopConstraint: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIView()
        fillView.translatesAutoresizingMaskIntoConstraints = false
        procentsLabel.translatesAutoresizingMaskIntoConstraints = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIView() {


        procentsLabel.layer.cornerRadius = 5
        procentsLabel.font = UIFont.systemFont(ofSize: 4, weight: .bold)
        
        fillView.layer.cornerRadius = 6
        //fillView.backgroundColor = UIColor.green.withAlphaComponent(0.6)
        procentsLabel.layer.borderWidth = 2
        
        
        procentsLabel.textAlignment = .center
        procentsLabel.textColor = UIColor.white
        procentsLabel.font = procentsLabel.font.withSize(11)
        
        self.addSubview(fillView)
        fillView.addSubview(procentsLabel)
        
        fillViewTopConstraint = fillView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        NSLayoutConstraint.activate([
            fillViewTopConstraint,
            fillView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.40),
            fillView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            fillView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            procentsLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: -2),
            procentsLabel.bottomAnchor.constraint(equalTo: fillView.bottomAnchor,constant: 2),
            procentsLabel.leadingAnchor.constraint(equalTo: fillView.leadingAnchor,constant: -2),
            procentsLabel.trailingAnchor.constraint(equalTo: fillView.trailingAnchor,constant: 2)
        ])

    
        
    }
    func setLevel(procentsLevel: Int){
        procent = Int(procentsLevel)
        if (procentsLevel >= 75 ) { fillView.backgroundColor = UIColor.green.withAlphaComponent(0.6)}
        else if (procentsLevel >= 25 ) { fillView.backgroundColor = UIColor.orange.withAlphaComponent(1)}
        else if (procentsLevel >= 0 ) { fillView.backgroundColor = UIColor.red.withAlphaComponent(1)}
        procentsLabel.text = String(format: "%d%%", procent)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        fillViewTopConstraint.constant = self.frame.height  - CGFloat(procent) / 100 * self.frame.height
    }
       
      

}
    
