
import UIKit

var settingsView = SettingsViewController()

class SettingsViewController:UIViewController {
    var namePage = UILabel()
    var stacksSettings = UIStackView()
    var listSections:[UIStackView] = []
    let alert = UIAlertController(title: translate[lang]!["alert"]!, message: translate[lang]!["sure?"]!, preferredStyle: .alert)
    var ipField:UITextField!
    var portField:UITextField!
    var isSaved:UISwitch!
    var closeButton = UIButton()
    var buttonsLang:[UIButton] = []
    var languageSelect = lang
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addContent()
        alert.addAction(UIAlertAction(title: translate[lang]!["yes"]!, style: .default){ _ in
            UserDefaults.standard.set(self.ipField.text ?? "", forKey: "ip")
            UserDefaults.standard.set(self.portField.text ?? "", forKey: "port")
            UserDefaults.standard.set(self.isSaved.isOn,forKey: "isSaved")
            UserDefaults.standard.set(self.languageSelect,forKey: "language")
            lang = self.languageSelect
            self.dismiss(animated: true, completion:nil)
            if let window = UIApplication.shared.windows.first {
                // Создаем новый экземпляр ViewController
                let newViewController = ViewController()  // Замените на нужный контроллер
                // Устанавливаем новый rootViewController
                window.rootViewController = newViewController
                // Обновляем окно, чтобы отобразить новый ViewController
                window.makeKeyAndVisible()
            }
            g_server.connection.cancel()
            g_server = Socket()
            settingsView = SettingsViewController()
        })
        alert.addAction(UIAlertAction(title: translate[lang]!["no"]!, style: .default){ _ in
            self.ipField.text = UserDefaults.standard.string(forKey: "ip")
            self.portField.text = UserDefaults.standard.string(forKey: "port")
            self.languageSelect = lang
            for i in self.buttonsLang {
                if (i.titleLabel!.text! == buttonsShortLanguageDict[lang]) {
                    i.isSelected = true
                }
                else {
                    i.isSelected = false
                }
            }
            self.dismiss(animated: true, completion:nil)
        })
        alert.addAction(UIAlertAction(title: translate[lang]!["cancel"]!, style: .cancel){ _ in
            print("Cancel")
        })
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    private func setupUI() {
        namePage.translatesAutoresizingMaskIntoConstraints = false
        stacksSettings.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = .black
        self.view.addSubview(namePage)
        self.view.addSubview(stacksSettings)
        self.view.addSubview(closeButton)
        
        namePage.font = UIFont.systemFont(ofSize: 36,weight: .bold)
        namePage.textAlignment = .center

        
        stacksSettings.axis = .vertical
        stacksSettings.alignment = .fill
        stacksSettings.distribution = .fillProportionally
        stacksSettings.spacing = 45
        stacksSettings.layer.cornerRadius = 10
        stacksSettings.clipsToBounds = true
        stacksSettings.backgroundColor = .black

        closeButton.setTitle(translate[lang]!["close"]!, for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.backgroundColor = .lightGray
        closeButton.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
        

        
        NSLayoutConstraint.activate([
            namePage.topAnchor.constraint(equalTo: self.view.topAnchor),
            namePage.heightAnchor.constraint(equalTo: self.view.heightAnchor,multiplier: 0.10),
            namePage.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier: 1),
        ])
        NSLayoutConstraint.activate([
            stacksSettings.topAnchor.constraint(equalTo: namePage.bottomAnchor),
            //stacksSettings.heightAnchor.constraint(equalTo: self.view.heightAnchor,multiplier: 0.90),
            stacksSettings.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier: 0.80),
            stacksSettings.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: stacksSettings.bottomAnchor,constant: 25),
            closeButton.centerXAnchor.constraint(equalTo: stacksSettings.centerXAnchor),
//            closeButton.widthAnchor.constraint(equalTo: stacksSettings.widthAnchor,multiplier: 0.20),
            closeButton.heightAnchor.constraint(equalTo: stacksSettings.widthAnchor,multiplier: 0.15)
        ])
        
    }
    private func push_back(section:SettingsStack) {
        listSections.append(section)
        stacksSettings.addArrangedSubview(section)
    }
    private func addContent() {
        //set namePage
        namePage.text = translate[lang]!["settings"]!
        //section:IP,Port;
        let sectionServer = SettingsStack()
        var configCell = CellSettings(name: translate[lang]!["enterip"]!)
        configCell.addTextFeild()
        sectionServer.push_back(cell:configCell)
        configCell = CellSettings(name:translate[lang]!["enterport"]!)
        configCell.addTextFeild()
        sectionServer.push_back(cell: configCell )
        push_back(section: sectionServer)
        //section end;
        
        //section:Languages;
        let sectionLanguages = SettingsStack()
        configCell = CellSettings(name:translate[lang]!["sellang"]!)
        configCell.addListButtons(buttons: ["🇺🇸 English","🇷🇺 Русский","🇷🇴 Română"])
        sectionLanguages.push_back(cell: configCell)
        push_back(section: sectionLanguages)
        //section end;
        
        //section:Save password;
        let saveLoginAndPassword = SettingsStack()
        configCell = CellSettings(name:translate[lang]!["savelogpas"]!)
        configCell.addUISwitch()
        saveLoginAndPassword.push_back(cell: configCell)

        push_back(section: saveLoginAndPassword)
        //section end;
        //end_push()
        
        
    }
    func end_push() {
        let emptyView = UIView(frame: .infinite)
        emptyView.backgroundColor = .green
        stacksSettings.addArrangedSubview(emptyView)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
     @objc func presentAlert() {
         present(alert,animated: true)
    }
    
}

final class SettingsStack:UIStackView {
    var listCells:[CellSettings] = []
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .fill
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    func push_back(cell:CellSettings) {
        listCells.append(cell)
        self.addArrangedSubview(cell)

    }
    

    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CellSettings:UIView {
    var name = UILabel()
    var contentStack = UIStackView()
    var listViews:[UIView] = []
    init(name:String) {
        super.init(frame: .zero)
        self.name.text = name
        
        setupUI()
    }
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(name)
        self.addSubview(contentStack)
        
        name.textAlignment = .left
        name.font = UIFont.systemFont(ofSize: 22)
        
        contentStack.axis = .horizontal
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: self.topAnchor),
            name.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35),
            name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7.5),
            name.widthAnchor.constraint(equalTo:self.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: name.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7.5)

        ])
        
    }
    
    func addTextFeild() {
        let textField = UITextField()
        textField.placeholder = name.text
        textField.backgroundColor = .systemGray3
//        textField.borderStyle = .
        textField.textColor = .white
        textField.layer.cornerRadius = 10
//        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(.gray).cgColor
        
        contentStack.addArrangedSubview(textField)
        NSLayoutConstraint.activate([
            contentStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            //contentStack.topAnchor.constraint(equalTo: name.bottomAnchor,constant: 25),
            contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10)
        ])
        contentStack.alignment = .fill
        textField.delegate = self
        listViews.append(textField)
        if (name.text == translate[lang]!["enterip"]!) {
            settingsView.ipField = textField
            textField.text = UserDefaults.standard.string(forKey: "ip")
        }
         if (name.text == translate[lang]!["enterport"]!) {
            settingsView.portField = textField
             textField.text = UserDefaults.standard.string(forKey: "port")

        }
        
    }
    func addListButtons(buttons:[String]) {
        for str in buttons {
            let button = UIButton()
            button.setTitle(str, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.systemRed, for: .selected)
            button.addTarget(self, action: #selector(toogleButton), for: .touchUpInside)
            if (button.titleLabel!.text! == buttonsShortLanguageDict[lang]) {
                button.isSelected = true
            }
            contentStack.addArrangedSubview(button)
            
            settingsView.buttonsLang.append(button)
        }
        NSLayoutConstraint.activate([
           //contentStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            contentStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),


        ])
        
        contentStack.alignment = .center
        contentStack.distribution = .equalCentering
        //contentStack.spacing = 20
    }
    func addUISwitch() {
        let switchSaveLogPass = UISwitch()
        contentStack.addArrangedSubview(switchSaveLogPass)
        NSLayoutConstraint.activate([
            switchSaveLogPass.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.20),
            contentStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65)

        ])
        contentStack.alignment = .center
        settingsView.isSaved = switchSaveLogPass
        if (UserDefaults.standard.bool(forKey: "isSaved")) {
            switchSaveLogPass.isOn = true
        }
    }
    @objc func toogleButton(sender:UIButton) {
        for i in settingsView.buttonsLang {
            if ( i == sender) {
                i.isSelected = true
                settingsView.languageSelect = buttonsLongLanguageDict[i.titleLabel!.text!]!
            }
            else {
                i.isSelected = false
            }
            print(sender.titleLabel!.text!)
            
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CellSettings: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Скрываем клавиатуру при нажатии "Return"
            return true
        }
//    func textFieldDidBeginEditing(_ textField:UITextField) {
////        if (checkFullCharSpace(textField: textField)) {
////            textField.text = ""
////        }
//    }
//    func textFieldDidEndEditing(_ textField:UITextField) {
////        if (checkFullCharSpace(textField: textField)) {
////            textField.text = ""
////        }
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if("0123456789.".contains(string) || string.isEmpty) {
            return true
        }
        else {
           return false
        }
        
    }
}
let buttonsLongLanguageDict: [String: String] = ["🇺🇸 English" : "eng", "🇷🇺 Русский" : "ru", "🇷🇴 Română" : "ro"]

let buttonsShortLanguageDict: [String: String] = [ "eng" : "🇺🇸 English" ,"ru" : "🇷🇺 Русский" , "ro" :"🇷🇴 Română"]
