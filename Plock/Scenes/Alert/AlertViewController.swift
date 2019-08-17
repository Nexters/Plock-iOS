//
//  AlertViewController.swift
//  Plock
//
//  Created by Zedd on 17/08/2019.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    enum AlertButtonType {
        
        case activate
        case deactivate
        
        var attribute: [NSAttributedString.Key: Any] {
            switch self {
            case .activate:
                return [
                    .font: UIFont.bold(size: 18),
                    .foregroundColor: UIColor(hex: "#4dadf7")!
                ]
            case .deactivate:
                return [
                    .font: UIFont.bold(size: 18),
                    .foregroundColor: UIColor(hex: "#adb5bd")!
                ]
            }
        }
    }
    
    enum Source {
        
        case delete
        case complete
    }
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertImageView: UIImageView!
    
    var image: UIImage?
    var titleText: String = ""
    var subtitleText: String = ""
    var cancelText: String = "아니오"
    var okText: String = "네"
    var cancelType: AlertButtonType = .activate
    var okType: AlertButtonType = .deactivate
    
    var cancelHandler: (() -> Void)?
    var okHandler: (() -> Void)?
    
    static func create(image: UIImage?, title: String, subtitle: String, cancelText: String, okText: String, cancelType: AlertButtonType, okType: AlertButtonType, cancelHandler: (() -> Void)?, okHandler: (() -> Void)?) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        viewController.modalPresentationStyle = .overCurrentContext
        
        viewController.image = image
        viewController.titleText = title
        viewController.subtitleText = subtitle
        viewController.cancelText = cancelText
        viewController.okText = okText
        viewController.cancelType = cancelType
        viewController.okType = okType
        viewController.cancelHandler = cancelHandler
        viewController.okHandler = okHandler
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews() {
        self.alertView.layer.cornerRadius = 10
        
        self.alertImageView.image = self.image
        self.titleLabel.font = UIFont.bold(size: 14)
        self.titleLabel.textColor = UIColor.charcoalGrey()
        self.titleLabel.text = self.titleText
        
        self.subtitleLabel.font = UIFont.medium(size: 12)
        self.subtitleLabel.textColor = UIColor(hex: "#494949")
        self.subtitleLabel.text = self.subtitleText
        
        self.cancelButton.setAttributedTitle(NSAttributedString(string: self.cancelText, attributes: self.cancelType.attribute), for: .normal)
        self.okButton.setAttributedTitle(NSAttributedString(string: self.okText, attributes: self.okType.attribute), for: .normal)
    }
    
    func updateView() {
        
    }
    
    @IBAction func didCancelTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }, completion: { (finished) in
            self.dismiss(animated: false, completion: {
                self.cancelHandler?()
            })
        })
    }
    
    @IBAction func didOkTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }, completion: { (finished) in
            self.dismiss(animated: false, completion: {
                self.okHandler?()
            })
        })
    }

}
