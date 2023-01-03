//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrei on 02.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!
    
    @IBAction private func didTapLogoutButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfileStoryboard()
    }
    
    private func initProfileStoryboard() {
        let profileImage = UIImage(named: "Avatar")
        let imageView = UIImageView(image: profileImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let nameLabel = UILabel()
            nameLabel.text = "Екатерина Новикова"
            nameLabel.textColor = .ypWhite
            nameLabel.font = UIFont.systemFont(ofSize: 23)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nameLabel)
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        let loginNameLabel = UILabel()
            loginNameLabel.text = "@ekaterina_nov"
            loginNameLabel.textColor = .ypGray
            loginNameLabel.font = UIFont.systemFont(ofSize: 13)
            loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loginNameLabel)
            loginNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        let descriptionLabel = UILabel()
            descriptionLabel.text = "Hello, world!"
            descriptionLabel.textColor = .ypWhite
            descriptionLabel.font = UIFont.systemFont(ofSize: 13)
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionLabel)
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
            button.tintColor = .ypRed
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
}

