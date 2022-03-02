//
//  EmployeeCell.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 6/2/22.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    static let identifierFav = "ListEmployeeCellId"
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var salaryLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var employee: Employee? {
        didSet { renderUI() }
    }
    
    private func renderUI() {
        guard let employee = employee else { return }
        nameLabel.text = employee.name?.capitalized
        positionLabel.text = employee.position?.capitalized
        salaryLabel.text = "Salario: \(employee.salary!) €"
    }
}

