//
//  LoginViewController.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 5/2/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    var response: Response?
    var params: [String: Any]?
    var eyeClick = false
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var recoverPasswordBtn: UIButton!
    @IBOutlet var eyeButton: UIButton!
    @IBOutlet var spinnerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerView.isHidden = true
        self.loginButton?.layer.cornerRadius = 6
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        self.spinnerView.isHidden = false
        if(emailTextField.text == "" || passTextField.text == "") {
            self.alert(message: "Rellena todos los campos")
            self.spinnerView.isHidden = true
        } else {
            let params : [String: Any] = [
                "email": emailTextField.text ?? "",
                "password": passTextField.text ?? ""
            ]
            
            print(params)
            DataMapper.shared.login(params: params) {
                response in
                //print(response)
                
                if response == nil {
                    self.alert(message: "Error en la conexión. Inténtelo de nuevo más tarde")
                } else {
                    DispatchQueue.main.async {
                        self.response = response
                        self.spinnerView.isHidden = true
                        
                        if response!.status == AppData.Error.badData.rawValue {
                            self.alert(message: response!.msg)
                            
                        } else if response?.status == AppData.Error.correct.rawValue {
                            AppData.shared.api_token = response!.msg //guardo el apitoken
                            print("Datos válidos")
                            
                            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarID"){
                                homeVC.modalPresentationStyle = .fullScreen
                                self.present(homeVC, animated: true, completion: nil)
                            }
                        } else if response!.status == AppData.Error.wrongPassword.rawValue {
                            self.alert(message: response!.msg)
                            
                        } else if response?.status == AppData.Error.userDontExist.rawValue {
                            self.alert(message: response!.msg)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnrecoverPassword(_ sender: Any) {
        if let forgetPass = storyboard?.instantiateViewController(withIdentifier: "forgetPassVCID"){
            forgetPass.modalPresentationStyle = .fullScreen
            self.present(forgetPass, animated: true, completion: nil)
        }
    }
    
    @IBAction func eyePassTapped(_ sender: UIButton) {
        passTextField.isSecureTextEntry = eyeClick
        eyeClick.toggle()
        eyeButton.isSelected = eyeClick
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /* PARÁMETROS INTRODUCIDOS Y RESPUESTA OBTENIDA.
     Si en el login no relleno ningún campo, me sale una alerta de rellene todos los campos, y lo misma respuesta ocurre si dejo alguna vacía.
     Si en el login introduzco un usuario que no existe (los que tengo son sophie, anya y sophie), me devuelve como respuesta que el usuario no existe.
     Si la contraseña es incorrecta, me responde que la contraseña es incorrecta (La contraseña es Hola1234)
     Si por casualidad, no se pudiese conectar el login, por problemas de decodificación o por no encender el Xampp, me responde que hay error de conexión y que lo intente de nuevo más tarde.
     */
}
