//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrei on 02.01.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileImageServiceNotification = ProfileImageService.didChangeNotification
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var profileImage: UIImageView = {
        let profileImage = UIImage(named: "Avatar")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypGray
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        return nameLabel
    }()
    
    private var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        return loginNameLabel
    }()
    
    private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        return descriptionLabel
    }()
    
    private var button: UIButton = {
        let buttonImage = UIImage(systemName: "ipad.and.arrow.forward")
        let button = UIButton.systemButton(with: buttonImage!,
                                           target: nil,
                                           action: #selector(didTapLogoutButton))
        button.tintColor = UIColor(named: "YP Red (iOS)")
        return button
    }()
    
    @objc private func didTapLogoutButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAvatar()
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
        initProfileStoryboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: profileImageServiceNotification,
                         object: nil,
                         queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: profileImageServiceObserver as? NSNotification.Name, object: nil)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImage.kf.setImage(with: url,
                                 placeholder: UIImage(named: "person.crop.circle.fill"),
                                 options: [.processor(processor)])
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    
    private func initProfileStoryboard() {
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            button.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
}

