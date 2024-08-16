//
//  GithubUserDetailViewController.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/15.
//

import UIKit
import Combine

class GithubUserDetailViewController: UIViewController {
    private lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.blue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save", for: .normal)
        btn.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        return btn
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var bioLabel = createLabel()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        return imageView
    }()
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginLabel = createLabel()
    
    private let staffLabel: UIPaddingLabel = {
        let label = UIPaddingLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.backgroundColor = UIColor(hex: "4A90E2")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setPadding(top: 1, left: 8, bottom: 1, right: 8)
        label.setCornerRadius(10)
        label.text = "STAFF"
        return label
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        return imageView
    }()
    
    private lazy var locationLabel = createLabel()
    
    private lazy var linkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "link.circle.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var blogButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.blue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(goToBlog), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var blogLabel = createLabel()
    
    private let viewModel: GithubUserDetailViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(login: String) {
        self.viewModel = GithubUserDetailViewModel(login: login)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDismissKeyboard()
        binding()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(saveButton)
        view.addSubview(imageView)
        view.addSubview(nameTextField)
        view.addSubview(bioLabel)
        
        view.addSubview(profileImageView)
        
        vStackView.addArrangedSubview(loginLabel)
        vStackView.addArrangedSubview(staffLabel)
        view.addSubview(vStackView)
        
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        
        view.addSubview(linkImageView)
        view.addSubview(blogButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
          
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        
        vStackView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(profileImageView)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(vStackView.snp.left)
            make.centerY.equalTo(locationImageView)
        }
        
        linkImageView.snp.makeConstraints { make in
            make.top.equalTo(locationImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        
        blogButton.snp.makeConstraints { make in
            make.left.equalTo(vStackView.snp.left)
            make.centerY.equalTo(linkImageView)
        }
    }
    
    private func setDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func binding() {
        viewModel.$imageURL
            .compactMap { $0 }
            .sink { [weak self] imageUrl in
                self?.imageView.kf.setImage(with: URL(string: imageUrl))
            }
            .store(in: &cancellables)
        
        viewModel.$name
            .assign(to: \.text, on: nameTextField)
            .store(in: &cancellables)
        
        viewModel.$bio
            .assign(to: \.text, on: bioLabel)
            .store(in: &cancellables)
        
        viewModel.$login
            .assign(to: \.text, on: loginLabel)
            .store(in: &cancellables)
        
        viewModel.$subTitleHidden
            .compactMap { $0 }
            .assign(to: \.isHidden, on: staffLabel)
            .store(in: &cancellables)
        
        viewModel.$location
            .assign(to: \.text, on: locationLabel)
            .store(in: &cancellables)
        
        viewModel.$blog
            .sink { [weak self] blog in
                self?.blogButton.setTitle(blog, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc private func savePressed() {
        view.endEditing(true)
        let name = nameTextField.text
        viewModel.saveName(name)
    }
    
    @objc private func goToBlog() {
        guard let blog = viewModel.blog,
              let url = URL(string: blog) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
}
