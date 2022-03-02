//
//  DetailEmployeeVC.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 5/2/22.
//

import UIKit

class DetailEmployeeVC: UIViewController {
    
    @IBOutlet var nameEmployeeLabel: UILabel!
    @IBOutlet var positionEmployeeLabel: UILabel!
    @IBOutlet var biographyText: UITextView!
    @IBOutlet var salaryEmployeeLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    
    var response: Response?
    var employee: Employee?
    var params: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params : [String: Any] = [
            "api_token": AppData.shared.api_token
        ]
        
        print(params)
        DataMapper.shared.detailEmployee(params: params) {
            response in
            //print(response)
            if response == nil {
                print("Error en la conexión")
            }else {
                DispatchQueue.main.async {
                    self.response = response
                    
                    if response!.status == AppData.Error.badData.rawValue {
                        print("Error desconocido")
                        
                    }else if response!.status == AppData.Error.correct.rawValue {
                        print(AppData.shared.api_token)
                        print("Detalle de empleado")
                        
                    }else if response?.status == AppData.Error.unauthorized.rawValue {
                        self.alert(message: response!.msg)
                        
                    }else if response?.status == AppData.Error.dontFindUserToken.rawValue {
                        self.alert(message: response!.msg)
                        
                    }else if response?.status == AppData.Error.incorrectToken.rawValue {
                        self.alert(message: response!.msg)
                    }
                }
            }
        }
        
        nameEmployeeLabel.text = employee?.name
        positionEmployeeLabel.text = employee?.position?.capitalized
        biographyText.text = employee?.biography
        salaryEmployeeLabel.text = "Salario: \(employee?.salary ?? 0) €"
    }
    
    @IBAction func closeViewButton(_sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
     Esta vista solo se mostrará si se ha mostrado con anterioridad la del listado de empleados.
     
     Si por casualidad, no se pudiese conectar el login, por problemas de decodificación o por no encender el Xampp, me responde que hay error de conexión y que lo intente de nuevo más tarde.
     */
}
