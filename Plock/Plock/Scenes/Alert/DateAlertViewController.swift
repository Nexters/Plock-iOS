//
//  DateAlertViewController.swift
//  Plock
//
//  Created by Zedd on 17/08/2019.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

class DateAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var completionHandler: ((Date) -> Void)?
    var selectedDate: Date = Date()
    
    static func create(date: Date, completionHandler: ((Date) -> Void)?) -> DateAlertViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DateAlertViewController") as! DateAlertViewController
        viewController.completionHandler = completionHandler
        viewController.selectedDate = date
        viewController.modalPresentationStyle = .overCurrentContext
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

    }
    
    func setupView() {
        self.alertView.layer.cornerRadius = 10
        self.datePicker.date = self.selectedDate
        
        self.containerView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containerViewDidTap))
        self.containerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func containerViewDidTap() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }, completion: { (finished) in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @IBAction func dateDidChanged(_ sender: UIDatePicker) {
        self.completionHandler?(sender.date)
    }
}
