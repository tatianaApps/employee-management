//
//  RegisterViewController.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 5/2/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var params: [String: Any]?
    var response: Response?
    var position = ""
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var rePassTextField: UITextField!
    @IBOutlet var salaryTextField: UITextField!
    @IBOutlet var biographyTextField: UITextField!
    @IBOutlet var positionSC: UISegmentedControl!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var spinnerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerBtn?.layer.cornerRadius = 6
        spinnerView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func registerButtonTapped(_sender: Any) {
        spinnerView.isHidden = false
        if(nameTextField.text == "" || emailTextField.text == "" || passTextField.text == "" || rePassTextField.text == "" || salaryTextField.text == "" || biographyTextField.text == "") {
            self.alert(message: "Rellena todos los campos")
            self.spinnerView.isHidden = true
            
        } else if passTextField.text != rePassTextField.text! {
            self.alert(message: "Las contraseñas no coinciden")
            self.spinnerView.isHidden = true
            
        } else if (positionSC.selectedSegmentIndex == 3) {
            self.alert(message: "Selecciona un puesto de trabajo")
            self.spinnerView.isHidden = true
            
        } else {
            let params : [String: Any] = [
                "name": nameTextField.text ?? "",
                "email": emailTextField.text ?? "",
                "password": passTextField.text ?? "",
                "repeatPass": rePassTextField.text ?? "",
                "salary": salaryTextField.text ?? "",
                "biography": biographyTextField.text ?? "",
                "position": position,
                "api_token": AppData.shared.api_token
            ]
            
            print(params)
            DataMapper.shared.registerEmployee(params: params) {
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
                            print(AppData.shared.api_token)
                            print("Registro completado")
                            self.alert(message: response!.msg)
                            
                        } else if response!.status == AppData.Error.dontFindUserToken.rawValue {
                            self.alert(message: response!.msg)
                            
                        } else if response?.status == AppData.Error.incorrectToken.rawValue {
                            self.alert(message: response!.msg)
                            
                        } else if response?.status == AppData.Error.unauthorized.rawValue {
                            self.alert(message: response!.msg)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        switch positionSC.selectedSegmentIndex
        {
        case 0:
            position = "empleado"
        case 1:
            position = "RRHH"
        case 2:
            position = "director"
        default:
            break
        }
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    /* PARÁMETROS INTRODUCIDOS Y RESPUESTA OBTENIDA.
     Si en el registro no relleno ningún campo, me sale una alerta de rellene todos los campos, y lo misma respuesta ocurre si dejo alguna vacía.
     Si las contraseñas no coinciden, mostrará una alerta que dice que las contraseñas no coinciden.
     Si no selecciono ningún puesto de trabajo en el segmented control, me avisará de que tengo que seleccionar al menos 1.
     Si hay algún campo que esté incorrecto respecto a la validación del API, mostrará cómo tienes que corregirlo.
     Si por casualidad, no se pudiese conectar el login, por problemas de decodificación o por no encender el Xampp, me responde que hay error de conexión y que lo intente de nuevo más tarde.
     */
}
