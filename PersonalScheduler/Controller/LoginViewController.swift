//
//  ViewController.swift
//  PersonalScheduler
//
//  Created by kjs on 06/01/23.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

final class LoginViewController: UIViewController {

    // MARK: - Property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스케쥴케어"
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()

    private let kakaoLoginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(named: "kakao_login_medium_narrow")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let facebookLoginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.init(hex: "#5B7CF2")
        return button
    }()

    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.init(hex: "#000000")
        return button
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

// MARK: - Objc Method
private extension LoginViewController {
    @objc func touchUpKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    // 에러처리하기
                    print(error)
                    return
                }
                _ = oauthToken
                let accessToken = oauthToken?.accessToken
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { OAuthToken, error in
                if let error = error {
                    // 에러처리하기
                    print(error)
                    return
                }
                let accessToken = OAuthToken?.accessToken
                let scheduleListViewController = ScheduleListViewController()
                let navigationController = UINavigationController(rootViewController: scheduleListViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        }
    }
}

// MARK: - UIConfiguration
private extension LoginViewController {
    func configureUI() {
        [titleLabel,
         kakaoLoginImageView,
         facebookLoginButton,
         appleLoginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        settingLayouts()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpKakaoLogin))
        kakaoLoginImageView.addGestureRecognizer(tapGesture)
        kakaoLoginImageView.isUserInteractionEnabled = true
    }

    func settingLayouts() {
        let smallSpacing: CGFloat = 20
        let buttonHeight: CGFloat = 60

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 4),

            kakaoLoginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            kakaoLoginImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.frame.height / 4),

            facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            facebookLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            facebookLoginButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            facebookLoginButton.topAnchor.constraint(equalTo: kakaoLoginImageView.bottomAnchor, constant: smallSpacing),

            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            appleLoginButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            appleLoginButton.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: smallSpacing)

        ])
    }
}