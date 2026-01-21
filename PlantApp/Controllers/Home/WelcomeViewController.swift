//
//  WelcomeViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit
import AuthenticationServices


class WelcomeViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = credential.user
            print("Signed in with Apple, user id:", userId)
            goToHome()
        }
    }

    func signInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    @IBAction func appleTapped(_ sender: UIButton) {
        signInWithApple()
    }
    @IBOutlet weak var Apple: UIButton!
    @IBOutlet weak var Google: UIButton!
    @IBOutlet weak var ConfirmTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextField(emailTextField, systemImageName: "envelope")
        styleTextField(passwordTextField, systemImageName: "lock")

        stylePrimaryButton(Google)
        stylePrimaryButton(Apple)

        stylePrimaryButton(signInButton)
        styleTextField(ConfirmTextField, systemImageName: "lock")

        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        ConfirmTextField.isSecureTextEntry = true
    }

    private func styleTextField(_ textField: UITextField, systemImageName: String) {
        textField.backgroundColor = UIColor(white: 0.96, alpha: 1)
        textField.layer.cornerRadius = 22
        textField.layer.masksToBounds = true
        textField.borderStyle = .none

        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let icon = UIImageView(image: UIImage(systemName: systemImageName, withConfiguration: config))
        icon.tintColor = UIColor.systemGray

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 52))
        icon.center = container.center
        container.addSubview(icon)

        textField.leftView = container
        textField.leftViewMode = .always
    }

    private func stylePrimaryButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 26
        button.layer.masksToBounds = true
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        print("sign in button tapped")
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        let confirm = ConfirmTextField.text ?? ""

        // 1. Basic checks
        guard !email.isEmpty, !password.isEmpty, !confirm.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        guard isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address.")
            return
        }

        guard password.count >= 6 else {
            showAlert(message: "Password must be at least 6 characters long.")
            return
        }

        guard password == confirm else {
            showAlert(message: "Passwords do not match.")
            return
        }

        //  If you had real auth, call it here.
        // For now, on success go to the main tab bar:
        goToHome()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: email)
    }

    private func showAlert(title: String = "Oops", message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let tabBar = storyboard.instantiateViewController(
            withIdentifier: "MainTabBarController"
        ) as? UITabBarController else {
            assertionFailure("MainTabBarController not found in storyboard")
            return
        }

        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}
