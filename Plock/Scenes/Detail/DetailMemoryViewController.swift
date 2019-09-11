//
//  DetailMemoryViewController.swift
//  Plock
//
//  Created by Zedd on 17/08/2019.
//  Copyright © 2019 Zedd. All rights reserved.
//

import UIKit
import CoreData

protocol DetailMemoryCellDelegate: class {
    
    func flipButtonDidTap(cell: UICollectionViewCell)
}

class DetailMemoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SettableUINavigationBar, DetailMemoryCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memory: [MemoryPlace] = []
    
    static func create(memory: [MemoryPlace]) -> DetailMemoryViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailMemoryViewController") as! DetailMemoryViewController
        viewController.memory = memory
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackButton()
        self.setupCollectionView()
        
        let rightNavigationItem = UIBarButtonItem(image: UIImage(named: "icDeletActive")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(deleteMemory))
        self.navigationItem.rightBarButtonItem = rightNavigationItem
    }
    
    @objc
    func deleteMemory() {
        let image = UIImage(named: "alert_image_1")
        let alert = AlertViewController.create(image: image, title: "잠시만요!", subtitle: "삭제된 일기는 되돌릴 수 없어요.\n일기를 삭제하겠습니까?", cancelText: "아니오", okText: "네", cancelType: .activate, okType: .deactivate, cancelHandler: nil, okHandler: {
            guard let memory = CoreDataHandler.fetchObject() else { return }
            for index in memory where index.id == Int64(self.memory.first?.id ?? 0) {
                CoreDataHandler.deleteObject(memory: index)
            }
            _ = CoreDataHandler.fetchObject()
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: false, completion: nil)
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailMemoryCollectionViewCell
        cell.delegate = self
        cell.configure(memory: self.memory[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width - 68, height: self.collectionView.frame.height - 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func flipButtonDidTap(cell: UICollectionViewCell) {
        
    }
}

class DetailMemoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memoryImageView: UIImageView!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: DetailMemoryCellDelegate?

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    var isInfoView: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func setupViews() {
        self.memoryImageView.clipsToBounds = true
        
        self.dateLabel.font = UIFont.regular(size: 16)
        self.dateLabel.textColor = UIColor(hex: "#495057")
        self.titleLabel.font = UIFont.bold(size: 18)
        self.titleLabel.textColor = UIColor(hex: "#495057")
        self.addressLabel.font = UIFont.light(size: 12)
        self.addressLabel.textColor = UIColor(hex: "#495057")
        
        self.contentTextView.font = UIFont.semibold(size: 18)
        self.contentTextView.textColor = UIColor(hex: "#495057")
    }
    
    @IBAction func flipButtonDidTap(_ sender: Any) {
        UIView.transition(with: self.backgroundImageView, duration: 1.0, options: [.transitionFlipFromRight], animations: {
            self.isInfoView.toggle()
            if self.isInfoView {
                self.contentTextView.isHidden = true
            } else {
                self.memoryImageView.isHidden = true
                self.infoContainerView.isHidden = true
            }
        }, completion: { (_) in
            if self.isInfoView {
                self.memoryImageView.isHidden = false
                self.infoContainerView.isHidden = false
                self.contentTextView.isHidden = true
            } else {
                self.contentTextView.isHidden = false
            }
        })
    }
    
    func configure(memory: MemoryPlace) {
        self.memoryImageView.image = UIImage(data: memory.image)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let stringDate = formatter.string(from: memory.date)
        self.dateLabel.text = stringDate
        
        self.titleLabel.text = memory.title
        self.addressLabel.text = memory.address
        self.contentTextView.text = memory.content
        
    }
}
