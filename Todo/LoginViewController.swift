import UIKit
import Firebase

class LoginViewController: UIViewController {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)
    let signUpButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .white

        // 로고 이미지 추가
        let logoImageView = UIImageView(image: UIImage(named: "Todo_Mate_logo_transparent-2"))
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        // 이메일 텍스트 필드 설정
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = lightGrayColor
        emailTextField.textColor = logoBlueColor
        emailTextField.setLeftPaddingPoints(10)
        view.addSubview(emailTextField)

        // 비밀번호 텍스트 필드 설정
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = lightGrayColor
        passwordTextField.textColor = logoBlueColor
        passwordTextField.setLeftPaddingPoints(10)
        view.addSubview(passwordTextField)

        // 로그인 버튼 설정
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = logoBlueColor
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        // 회원가입 버튼 설정
        signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpButton.setTitleColor(mediumGrayColor, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        view.addSubview(signUpButton)

        // 제약 조건 설정
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),

            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func loginButtonTapped() {
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                // 알림 표시
                return
            }

            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    print("Error logging in: \(error.localizedDescription)")
                    // 알림 표시
                    return
                }

                print("User logged in: \(authResult?.user.email ?? "")")
                // 메인 화면으로 전환
                DispatchQueue.main.async {
                    self?.transitionToMainScreen()
                }
            }
        }

        func transitionToMainScreen() {
            guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
            sceneDelegate.switchToMainScreen()
        }

    @objc func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
}
