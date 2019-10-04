//
//  footerView.swift
//  weather
//
//  Created by codinghands on 03/10/19.
//  Copyright © 2019 codinghands. All rights reserved.
//

import UIKit

protocol footerViewDelegate{
    
    func degreeAction()
    func farenheitAction()
    func searchAction()
}

class footerView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var farenheitbutton: UIButton!
    @IBOutlet weak var degreebutton: UIButton!
    var celldelegate: footerViewDelegate?
    
     @IBAction func searchAction(_ sender: UIButton) {
        celldelegate?.searchAction()
     }
    @IBAction func degreeAction(_ sender: UIButton) {
        celldelegate?.degreeAction()
        }
    @IBAction func farenheitAction(_ sender: UIButton) {
        celldelegate?.farenheitAction()
        }
}
