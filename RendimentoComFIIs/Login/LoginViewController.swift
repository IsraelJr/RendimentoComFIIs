//
//  LoginViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 15/05/22.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import LocalAuthentication


protocol LoginDisplayLogic {
    func setTerms(_ object: LoginModel.FetchTerms.Terms)
}

class LoginViewController: UIViewController, LoginDisplayLogic {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnEntry: UIButton!
    @IBOutlet weak var lbCallTerms: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signInButtonApple: ASAuthorizationAppleIDButton!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lbVersion: UILabel!
    
    static var terms: LoginModel.FetchTerms.Terms?
    var handle: AuthStateDidChangeListenerHandle?
    var error_connection = false
    
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        if InternetConnectionManager.isConnectedToNetwork() {
            ConfigureDataBase.checkConnectionToDatabase { response in
                if response {
                    self.interactor?.getTerms()
                    if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                            authenticateUser(for: user, with: error)
                        }
                    } else {
                        UIView.animate(withDuration: 2) {
                            self.viewBack.alpha = 0
                        } completion: { _ in
                            self.isHiddenView()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertView(type: .warning, message: NSLocalizedString("msg_maintenance", comment: "")).delegate = self
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.alertView(type: .error, message: NSLocalizedString("error_connection", comment: "")).delegate = self
            }
        }
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let scene = segue.identifier {
        //            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //            if let router = router, router.responds(to: selector) {
        //                router.perform(selector, with: segue)
        //            }
        //        }
        //        router?.routeTosegueHomeWithSegue(segue: segue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupProviderLoginView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                //                let uid = user.uid
                //                let email = user.email
                //                let photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
            }
        }
        
        func performExistingAccountSetupFlows() {
            // Prepare requests for both Apple ID and password providers.
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()]
            
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            //            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    private func setupLayout() {
        viewMain.layer.cornerRadius = 8
        
        isHiddenView(false)
        
        lbTitle.text = NSLocalizedString("signin", comment: "")
        
        lbDescription.text = NSLocalizedString("login_description", comment: "")
        
        let text = NSLocalizedString("login_link_terms", comment: "")
        let position = text.firstIndex(of: "T")!.utf16Offset(in: text)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "Border")!], range: NSRange(location: position, length: attributedString.length - position))
        lbCallTerms.attributedText = attributedString
        lbCallTerms.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(respondToTapGesture))
        self.lbCallTerms.addGestureRecognizer(tap)
        
        signInButton.style = .wide
        signInButton.addTarget(self, action: #selector(sigInWithGoogleAccount), for: .touchUpInside)
        signInButton.isEnabled = false
        
        btnEntry.setTitle("  \(NSLocalizedString("login_btn_accept", comment: ""))", for: .normal)
        btnEntry.tag = UserDefaultKeys.accept_terms.getValue() as? Bool ?? false ? 0 : 1
        didTapCheckbox(btnEntry)
        
        lbVersion.textColor = .gray
        lbVersion.textAlignment = .center
        lbVersion.font = UIFont.boldSystemFont(ofSize: 14)
        lbVersion.text = "\(NSLocalizedString("version", comment: "")) \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            isErrorAuthenticateUser(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            isErrorAuthenticateUser()
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [self] (account, error) in
            if let error = error {
                isErrorAuthenticateUser(error.localizedDescription)
            } else {
                DataUser.name = account?.user.displayName ?? ""
                DataUser.email = account?.user.email ?? ""
                segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "init") as! InitializationViewController)
//                segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "report") as! ReportViewController)
            }
        }
    }
    
    private func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        self.signInButtonApple.addSubview(authorizationButton)
    }
    
    private func isHiddenView(_ hide: Bool = true) {
        DispatchQueue.main.async {
            self.viewBack.isHidden = hide
            if hide {
                self.viewBack.alpha = 0
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.viewBack.alpha = 0.6
                }
            }
            
        }
    }
    
    private func isErrorAuthenticateUser(_ msgError: String = "") {
        if msgError.contains("user canceled") {
            self.isHiddenView()
            return
        }
        let msg = "\(NSLocalizedString("error_authenticate_user", comment: "")) \(msgError.prefix(100))"
        self.alertView(type: .error, message: msg).delegate = self
        
    }
    
    @objc func respondToTapGesture(gesture: UITapGestureRecognizer) {
        if let _ = LoginViewController.terms?.title, let _ = LoginViewController.terms?.description {
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "terms") as! TermsViewController)
        } else {
            
        }
    }
    
    @objc func sigInWithGoogleAccount(_ sender: UIButton) {
        isHiddenView(false)
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                isErrorAuthenticateUser()
                return
            }
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
                if let error = error {
                    isErrorAuthenticateUser(error.localizedDescription)
                    return
                }
                authenticateUser(for: user, with: error)
            }
        }
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        //        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func setTerms(_ object: LoginModel.FetchTerms.Terms) {
        LoginViewController.terms = object
    }
    
    private func checkFaceID(complete:@escaping(responseDone)) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if context.biometryType == .faceID {
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Identifique-se para acessar suas configurações") { success, evaluateError in
                    DispatchQueue.main.async {
                        if success {
                            complete(true)
                        } else {
                            // Autenticação falhou
                            // Tratar erro, por exemplo, usando evaluateError
                            guard let error = evaluateError as? LAError else { return }

                            switch error.code {
                            case .authenticationFailed:
                                // Autenticação falhou após várias tentativas
                                complete(false)
                            case .userCancel:
                                // Usuário cancelou a solicitação de autenticação
                                complete(false)
                            case .userFallback:
                                // Usuário escolheu usar uma senha
                                complete(false)
                            default:
                                // Outros tipos de erro
                                complete(false)
                            }

                        }
                    }
                }

                
            } else {
                // Dispositivo não suporta Face ID
                complete(false)
            }
        } else {
            // Não é possível usar autenticação biométrica
            // Tratar erro
            complete(false)
        }
        
    }
    
    private func successfullyValidated(_ name: String, _ email: String) {
        DataUser.name = name
        DataUser.email = email
        segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "init") as! InitializationViewController)
    }
    
    
    @IBAction func didTapCheckbox(_ sender: UIButton) {
        btnEntry.tag = btnEntry.tag == 0 ? 1 : 0
        btnEntry.tintColor = btnEntry.tag == 0 ? UIColor().colorRadioDisabled : UIColor(named: "Border")
        btnEntry.setImage(UIImage(systemName: btnEntry.tag == 0 ? "rectangle.fill" : "checkmark.rectangle.fill"), for: .normal)
        UserDefaultKeys.accept_terms.setValue(value: btnEntry.tag == 0 ? false : true)
        signInButton.isEnabled = btnEntry.tag == 0 ? false : true
        signInButton.backgroundColor = btnEntry.tag == 0 ? UIColor().colorRadioDisabled : UIColor.clear
    }
    
}


extension LoginViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true) {
            Util.exit()
            self.isHiddenView()
        }
    }
}


extension LoginViewController: ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            //            self.saveUserInKeychain(userIdentifier)
            print("saveUserInKeychain")
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            //            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            print("showResultViewController: \(userIdentifier); \(String(describing: fullName)); \(String(describing: email))")
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            print("\(username) : \(password)")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
