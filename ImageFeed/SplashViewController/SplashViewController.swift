//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrei on 29.01.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let oAuth2Service = OAuth2Service.shared
    private let profileImageService = ProfileImageService.shared
    private let alertPresenter = AlertPresenter()
    
    private var logoImage: UIImageView = {
        let image = UIImage(named: "Vector")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        
        initSplashScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthToken()
    }
    
    private func initSplashScreen() {
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 78),
            logoImage.widthAnchor.constraint(equalToConstant: 75),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func checkAuthToken() {
        if oAuth2TokenStorage.token != nil {
            guard let token = oAuth2TokenStorage.token else { return }
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self]  in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchAuthToken(code)
            
        }
    }
    
    private func fetchAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oAuth2TokenStorage.token = token
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
                
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username, token: token) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alertModel = AlertModel(title: "Что-то пошло не так(",
                                    message: "Не удалось войти в систему",
                                    buttonText: "Ок",
                                    completion: nil)
        alertPresenter.showResult(alertModel: alertModel)
    }
}
