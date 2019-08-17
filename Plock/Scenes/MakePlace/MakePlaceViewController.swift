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

extension MakePlaceViewController: ViewControllable { }

class MakePlaceViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotifications()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.setupViews()
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupViews() {
       
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
}

class MemoryPlace {
    
    var title: String = ""
    var content: String = ""
    var date: Date = Date()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var image: Data = Data()
}
