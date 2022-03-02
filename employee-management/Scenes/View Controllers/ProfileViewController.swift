//
//  ProfileViewController.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 5/2/22.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var params: [String: Any]?
    var response: Response?
    let picker = UIImagePickerController()
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var salaryLabel: UILabel!
    @IBOutlet var biographyText: UITextView!
    @IBOutlet var closeSessionBtn: UIButton!
    @IBOutlet var spinnerView: UIView!
    @IBOutlet var profileImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerView.isHidden = false
        profileImageView.layer.borderColor = UIColor(named: "border")?.cgColor
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
        
        let params : [String: Any] = [
            "api_token": AppData.shared.api_token
        ]
        
        print(params)
        DataMapper.shared.seeProfile(params: params) {
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
                        
                    } else if response!.status == AppData.Error.correct.rawValue {
                        print(AppData.shared.api_token)
                        print("Perfil de empleado")
                        
                        self.nameLabel.text = self.response?.empleado?.name
                        self.positionLabel.text = self.response?.empleado?.position?.capitalized
                        self.biographyText.text = self.response?.empleado?.biography
                        self.salaryLabel.text = "\(self.response?.empleado?.salary ?? 0) €"
                        
                    } else if response?.status == AppData.Error.dontFindUserToken.rawValue {
                        self.alert(message: response!.msg)
                        print("Usuario no existente")
                        
                    }else if response?.status == AppData.Error.incorrectToken.rawValue {
                        self.alert(message: response!.msg)
                        print("Token no introducido")
                    }
                }
            }
        }
    }
    
    @IBAction func toLoginTapped(_ sender: Any) {
        if let login = storyboard?.instantiateViewController(withIdentifier: "loginVCID"){
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeProfileImage() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Cámara", style: .default, handler: {(action) in
            self.picker.sourceType = .camera
            self.picker.cameraCaptureMode = .photo
            self.picker.allowsEditing = true
            self.picker.delegate = self
            self.present(self.picker, animated: true)
        })
        
        let gallery = UIAlertAction(title: "Galería", style: .default, handler: {(action) in
            self.picker.sourceType = .photoLibrary
            self.picker.delegate = self
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true)
        })
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel  , handler: {(action) in
        })
        
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        profileImageView.image = image
        profileImageView.layer.borderColor = UIColor(named: "border")?.cgColor
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /* PARÁMETROS INTRODUCIDOS Y RESPUESTA OBTENIDA.
     Una vez se ha obtenido el api token del login, se mostrará el perfil de la persona que estaba realizando el login.
     Si por casualidad, no se pudiese conectar el login, por problemas de decodificación o por no encender el Xampp, me responde que hay error de conexión y que lo intente de nuevo más tarde.
     */
}
