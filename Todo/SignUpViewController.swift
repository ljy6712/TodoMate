import UIKit

class SignUpViewController: UIViewController {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let signUpButton = UIButton(type: .system)
    let loginButton = UIButton(type: .system)

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

        // 회원가입 버튼 설정
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = logoBlueColor
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        view.addSubview(signUpButton)

        // 로그인 버튼 설정
        loginButton.setTitle("Already have an account? Log In", for: .normal)
        loginButton.setTitleColor(mediumGrayColor, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        // 제약 조건 설정
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false

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

            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // 알림 표시
            return
        }

        AuthManager.shared.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let authResult):
                print("User signed up: \(authResult.user.email ?? "")")
                // 메인 화면으로 전환
                self?.transitionToMainScreen()
            case .failure(let error):
                print("Error signing up: \(error.localizedDescription)")
                // 알림 표시
            }
        }
    }

    func transitionToMainScreen() {
        let todoListVC = TodoListViewController()
        let navigationController = UINavigationController(rootViewController: todoListVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }


    @objc func loginButtonTapped() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
