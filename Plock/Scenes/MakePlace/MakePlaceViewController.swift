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
    
    func updateNavigationBarAsDefault() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.getImage(color: .white), for: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage.navigationShadow
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

class MakePlaceViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var infoContainerView: UIView!

    @IBOutlet var datePickerContainerView: UIView!
    
    @IBOutlet weak var selectDateContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var flipButton: UIButton!
    
    var isInfoView: Bool = true
    var memory: MemoryPlace = MemoryPlace()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotifications()
        self.setupNavigation()
        self.setupImageView()
        self.setupInfoView()
        self.setupDatePicker()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateNavigationBarAsDefault()
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backOff")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonDidTap))
        
        let rightNavigationItem = UIBarButtonItem(image: UIImage(named: "icDoneActive")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(saveMemory))
        self.navigationItem.rightBarButtonItem = rightNavigationItem
    }
    
    @objc
    func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func saveMemory() {
        let image = UIImage(named: "alert_image_1")
        let alert = AlertViewController.create(image: image, title: "기억해주세요!", subtitle: "현재 작성한 일기는 설정한\n위치에서만 확인, 삭제가 가능해요!\n계속하시겠습니까?", cancelText: "아니오", okText: "네", cancelType: .activate, okType: .deactivate, cancelHandler: nil, okHandler: {
            
        })
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func flipButtonDidTap(_ sender: UIButton) {
        UIView.transition(with: self.backgroundImageView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
            self.isInfoView.toggle()
            if self.isInfoView {
                self.contentTextView.isHidden = true
            } else {
                self.infoContainerView.isHidden = true
            }
        }, completion: { (_) in
            if self.isInfoView {
                self.infoContainerView.isHidden = false
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
        self.placeTextField.delegate = self
        self.placeLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(placeSelectDidTap))
        self.placeLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupContentTextView() {
        self.contentTextView.delegate = self
    }
    
    @objc
    func placeSelectDidTap() {
        let viewController = SetPlaceViewController { memory in
            self.memory.address = memory.address
            self.memory.latitude = memory.latitude
            self.memory.longitude = memory.longitude
            self.updateViews()
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateViews() {
        self.placeLabel.text = self.memory.address
    }
    
    func setupDatePicker() {
        let dateTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectDateContainerViewDidTap))
        self.selectDateContainerView.addGestureRecognizer(dateTapGestureRecognizer)
        self.dateButton.setTitle(Date().currentDate, for: .normal)
    }
    
    @objc
    func selectDateContainerViewDidTap() {
        self.view.endEditing(true)
        let datePicker = DateAlertViewController.create(date: Date()) { (date) in
            self.dateButton.setTitle(date.currentDate, for: .normal)
        }
        self.present(datePicker, animated: false, completion: nil)
        
    }
    
    func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func viewDidTap() {
        self.view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let height = self.view.convert(keyboardFrame, from: nil).height
        let rate = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: rate ?? 0.25, animations: {
            if self.isInfoView {
                self.view.frame.origin.y -= height
            }
        })
    }
    
    @objc
    func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.emptyImageView.isHidden = true
            self.mainImageView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

final class MemoryPlace {
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
private extension Date {
    
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
}
