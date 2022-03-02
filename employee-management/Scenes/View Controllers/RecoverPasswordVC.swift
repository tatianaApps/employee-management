//
//  RecoverPasswordVC.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 5/2/22.
//

import UIKit

class RecoverPasswordVC: UIViewController {
    
    var response: Response?
    var params: [String: Any]?
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var recoverPassBtn: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var spinnerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView.isHidden = true
        self.recoverPassBtn?.layer.cornerRadius = 6
    }
    
    @IBAction func backLoginButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recoverPassword(_ sender: Any) {
        spinnerView.isHidden = false
        if(emailTextField.text == "") {
            self.alert(message: "Rellena el email")
            self.spinnerView.isHidden = true
        } else {
            let params : [String: Any] = [
                "email": emailTextField.text ?? ""
            ]
            
            print(params)
            DataMapper.shared.recoverPassword(params: params) {
                response in
                //print(response)
                self.spinnerView.isHidden = true
                if response == nil {
                    self.alert(message: "Error en la conexión. Inténtelo de nuevo más tarde")
                }else {
                    DispatchQueue.main.async {
                        self.response = response
                        
                        if response!.status == AppData.Error.badData.rawValue {
                            self.alert(message: response!.msg)
                            
                        } else if response!.status == AppData.Error.correct.rawValue {
                            AppData.shared.api_token = response!.msg
                            print("Email enviado")
                            self.alert(message: response!.msg)
                            
                        } else if response?.status == AppData.Error.userDontExist.rawValue {
                            self.alert(message: response!.msg)
                        }
                    }
                }
            }
        }
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
     Si en el campo de email no introduzco nada, me responde que tengo que rellenar el campo.
     Si introduzco un email incorrecto, me dice que el usuario no existe.
     Si está todo correcto, me responde que el email ha sido enviado y que revise mi correo. Si reviso mi correo, puedo comprobar que se me ha enviado la contraseña nueva.
     Si por casualidad, no se pudiese conectar el login, por problemas de decodificación o por no encender el Xampp, me responde que hay error de conexión y que lo intente de nuevo más tarde.
     */
}
