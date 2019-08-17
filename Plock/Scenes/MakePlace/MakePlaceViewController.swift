//
//  MakePlaceViewController.swift
//  Plock
//
//  Created by Zedd on 17/08/2019.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import RIBs
import CoreData
extension UIViewController {
    
    func updateNavigationBarAsTransparent() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.getImage(color: .clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.getImage(color: .clear)
    }
}
extension UIImage {
    
    class func getImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension MakePlaceViewController: ViewControllable { }

class MakePlaceViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var isInfoView: Bool = true
    
    @IBOutlet weak var selectDateContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotifications()
        self.setupNavigation()
        self.setupImageView()
        self.setupInfoView()
        self.setupDatePicker()
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = .white
        //        let leftNavigationItem = UIBarButtonItem(image: UIImage(named: "backoff"), style: .plain, target: self, action: #selector(backButtonDidTap))
        //        self.navigationController?.navigationItem.leftBarButtonItem = leftNavigationItem
        //
        //        let rightNavigationItem = UIBarButtonItem(image: UIImage(named: "backoff"), style: .plain, target: self, action: #selector(flipTriggered))
        //
        //        self.navigationController?.navigationItem.rightBarButtonItem =  rightNavigationItem
    }
    
    @objc
    func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func flipTriggered() {
        UIView.transition(with: self.backgroundImageView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
            self.isInfoView.toggle()
            if self.isInfoView {
                self.contentTextView.isHidden = true
            }
        }, completion: { (_) in
            if self.isInfoView {
                self.contentTextView.isHidden = true
            } else {
                self.contentTextView.isHidden = false
            }
        })
    }
    
    func setupImageView() {
        UIApplication.shared.delegate?.window??.backgroundColor = UIColor.white
        
        self.mainImageView.isUserInteractionEnabled = true
        self.mainImageView.clipsToBounds = true
        self.mainImageView.contentMode = .scaleAspectFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mainImageViewDidTap))
        self.mainImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc
    func mainImageViewDidTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func setupInfoView() {
        self.placeTextField.tintColor = UIColor(hex: "#030303")
        
    }
    
    func setupDatePicker() {
        let dateTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectDateContainerViewDidTap))
        self.selectDateContainerView.addGestureRecognizer(dateTapGestureRecognizer)
        self.datePicker.datePickerMode = .date
    }
    
    @objc
    func selectDateContainerViewDidTap() {
        UIView.animate(withDuration: 0.25) {
            self.datePickerHeight.constant = 200
            self.view.layoutIfNeeded()
        }
    }
    
    func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func viewDidTap() {
        self.view.endEditing(true)
        self.datePickerHeight.constant = 0
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let height = self.view.convert(keyboardFrame, from: nil).height
        let rate = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: rate ?? 0.25, animations: {
            self.view.frame.origin.y -= height
        })
    }
    
    @objc
    func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.mainImageView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

class MemoryPlace {
    
    var title: String = ""
    var address: String = ""
    var content: String = ""
    var date: Date = Date()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var image: Data = Data()
}

public extension UIColor {
    
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "%02x%02x%02x", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
    
    convenience init?(hex: String?, alpha: CGFloat = 1) {
        guard let hex = hex?.replacingOccurrences(of: "#", with: ""), hex.count == 6 else {
            return nil
        }
        var rgb: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.scanHexInt32(&rgb)
        self.init(red: CGFloat((rgb & 0xff0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00ff00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000ff) / 255.0, alpha: alpha)
    }
}
