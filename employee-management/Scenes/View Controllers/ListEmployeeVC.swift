//
//  ListEmployeeVC.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 5/2/22.
//

import UIKit

class ListEmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var response: Response?
    var params: [String: Any]?
    
    @IBOutlet var tableViewEmployee: UITableView!
    @IBOutlet var unauthorizedView: UIView!
    @IBOutlet var spinnerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "unselected_tabBar")
        tableViewEmployee.dataSource = self
        tableViewEmployee.delegate = self
        spinnerView.isHidden = false
        unauthorizedView.isHidden = true
        
        let params : [String: Any] = [
            "api_token": AppData.shared.api_token
        ]
        
        print(params)
        DataMapper.shared.listEmployee(params: params) {
            response in
            //print(response)
            
            if response == nil {
                self.alert(message: "Error en la conexión. Inténtelo de nuevo más tarde")
            } else {
                DispatchQueue.main.async {
                    self.response = response
                    self.spinnerView.isHidden = true
                    self.tableViewEmployee.reloadData()
                    
                    if response!.status == AppData.Error.badData.rawValue {
                        self.alert(message: response!.msg)
                        
                    } else if response!.status == AppData.Error.correct.rawValue {
                        print(AppData.shared.api_token)
                        print("Listado de empleados")
                        
                    } else if response?.status == AppData.Error.unauthorized.rawValue {
                        self.unauthorizedView.isHidden = false
                        
                    }else if response?.status == AppData.Error.dontFindUserToken.rawValue {
                        self.alert(message: response!.msg)
                        
                    }else if response?.status == AppData.Error.incorrectToken.rawValue {
                        self.alert(message: response!.msg)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.empleados?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListEmployeeCellId", for: indexPath) as? EmployeeCell{
            cell.employee = response?.empleados?[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let detailVC = storyboard?.instantiateViewController(identifier: "DetailVCId") as? DetailEmployeeVC {
            detailVC.employee = response?.empleados?[indexPath.row]
            detailVC.modalPresentationStyle = .automatic
            self.present(detailVC, animated: true, completion: nil)
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
     Una vez se ha obtenido el api token del login, se comprobará la posición de la persona y si es director o RRHH, se mostrará la lista de empleados (si es RRHH solo de empleados y si es director de ambos), y si no, se monstrará una view que nos diga que no tenemos permisos.
     Si por casualidad, no se pudiese conectar el login, por problemas de decodificación o por no encender el Xampp, me responde que hay error de conexión y que lo intente de nuevo más tarde.
     */
}
