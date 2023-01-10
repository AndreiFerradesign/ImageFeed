//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrei on 02.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    @objc private func didTapLogoutButton() {
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
    
        let nameLabel = UILabel()
            nameLabel.text = "Екатерина Новикова"
            nameLabel.textColor = .ypWhite
            nameLabel.font = UIFont.systemFont(ofSize: 23)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nameLabel)

        let loginNameLabel = UILabel()
            loginNameLabel.text = "@ekaterina_nov"
            loginNameLabel.textColor = .ypGray
            loginNameLabel.font = UIFont.systemFont(ofSize: 13)
            loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loginNameLabel)
            
        let descriptionLabel = UILabel()
            descriptionLabel.text = "Hello, world!"
            descriptionLabel.textColor = .ypWhite
            descriptionLabel.font = UIFont.systemFont(ofSize: 13)
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionLabel)

        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
            button.tintColor = .ypRed
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
}

