//
//  ViewController.swift
//  sdkTest
//
//  Created by Onur on 13.09.2023.
//

import OpenAI
import SnapKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var buttonContainerHeightConstraint: Constraint?
    let viewModel = ViewModel()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Cevabınız yükleniyor..."
        return label
        
    }()
    
    
    
    lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        return tableView
        
    }()
    
    lazy var messageTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Message"
        textField.backgroundColor = UIColor(named: "specialColor")
        textField.alpha = 0.75
        textField.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 54))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 25
        textField.delegate = self
        return textField
    }()
    
    lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        var arrowImage = UIImage(systemName: "arrow.up.circle.fill")
        button.setImage(arrowImage, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 27
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        messageTableView.dataSource = self
        messageTableView.delegate = self
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        setupViews()
    }
    
    public func setupViews(){
        view.addSubview(messageTableView)
        view.addSubview(messageTextField)
        view.addSubview(generateButton)
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(messageTextField.snp.top).offset(-5)
        }

        messageTextField.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalTo(170)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
        }
        
        generateButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalTo(54)
            make.left.equalTo(messageTextField.snp.right).offset(5)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-15)

        }
        
        
    }
    
    @objc func generateButtonTapped(){
        addTextandReloadTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.chatArray[indexPath.row].text
        cell.textLabel?.numberOfLines = 0
        if viewModel.chatArray[indexPath.row].owner == 0 {
            cell.textLabel?.textAlignment = .right
            cell.backgroundColor = UIColor(named: "promptColor")
        }
        else{
            cell.backgroundColor = UIColor(named: "answerColor")
            cell.textLabel?.textAlignment = .left
        }
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTextandReloadTableView()
        return true
    }
    
 
    func addTextandReloadTableView(){
        if let text = messageTextField.text{
            viewModel.chatArray.append(ChatData(text: text, owner: 0))
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
                self.messageTableView.scrollToBottom(animated: true)
            }
            addFooter()
            messageTextField.text = nil
            viewModel.getDataFromAPI(prompt: text){ result in
                switch result{
                case .success(let answer):
                    var newText: String = answer
                    if newText.hasPrefix("\n"){
                        newText = String(newText.dropFirst())
                        newText = String(newText.dropFirst())
                    }
                    self.viewModel.chatArray.append(ChatData(text: newText, owner: 1))
                    DispatchQueue.main.async {
                        self.messageTableView.reloadData()
                        self.messageTableView.scrollToBottom(animated: true)
                        self.removeFooter()
                    }
                case .failure(let error):
                    print("error = \(error)")
                }
                
            }
            
        }
    }
    func addFooter(){
        let loadingView = UIView()
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        loadingView.frame = CGRect(x: 0, y: 0, width: messageTableView.bounds.size.width, height: 60)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.snp.makeConstraints { make in
            make.leading.equalTo(loadingLabel.snp.trailing).offset(15)
            make.centerY.equalTo(loadingView.snp.centerY)
        }
        
        loadingLabel.snp.makeConstraints { make in
            make.leading.equalTo(loadingView.snp.leading).offset(15)
            make.centerY.equalTo(loadingView.snp.centerY)
        }
        
        activityIndicator.startAnimating()
        messageTableView.tableFooterView = loadingView
        self.messageTableView.scrollToBottom(animated: true)
        
    }
    
    func removeFooter(){
        self.activityIndicator.stopAnimating()
        self.messageTableView.tableFooterView = nil
    }

}

