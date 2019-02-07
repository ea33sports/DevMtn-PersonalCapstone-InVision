//
//  MyInboxTableViewCell.swift
//  InCourage
//
//  Created by Eric Andersen on 11/5/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import FirebaseStorage

class MyReminderGramsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var messagePicImageView: UIImageView!
    @IBOutlet weak var messageSubjectLabel: UILabel!
    @IBOutlet weak var messageLoveRatingLabel: UILabel!
    
    
    // MARK: - Properties
    var reminderGram: ReminderGram? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - Functions
    func setUpUI() {
        messagePicImageView.layer.borderWidth = 1
        messagePicImageView.layer.masksToBounds = false
        messagePicImageView.layer.borderColor = UIColor.black.cgColor
        messagePicImageView.layer.cornerRadius = messagePicImageView.frame.height / 2
        messagePicImageView.clipsToBounds = true
    }
    
    
    func updateViews() {
        
        setUpUI()
        
        guard let reminderGram = reminderGram else { return }
        downloadReminderGramImage(folderPath: "reminderGramImages", uid: reminderGram.uid, success: { (image) in
            self.messagePicImageView.image = image
        }) { (error) in
            print(error, error.localizedDescription)
        }
        
        messageSubjectLabel.text = reminderGram.subject
        messageLoveRatingLabel.text = "❤️\(reminderGram.loveRating)"
    }
    
    
    func downloadReminderGramImage(folderPath: String, uid: String, success: @escaping (_ image: UIImage) -> (),failure: @escaping (_ error: Error) -> ()) {
        
        guard let currentProfile = ProfileController.shared.currentProfile else { return }
        
        // Create a reference with an initial file path and name
        let reference = Storage.storage().reference(withPath: folderPath).child(currentProfile.uid).child("\(uid).png")
        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let myImage:UIImage! = UIImage(data: _data)
                    success(myImage)
                }
            }
        }
    }
    
    
//    func fetchSender(completion: @escaping (User) -> Void) {
//
//        guard let reminderGram = reminderGram else { return }
//        Endpoint.database.collection("users").document(reminderGram.sender).getDocument { (snapshot, error) in
//
//            if let error = error {
//                print("😤 Error getting user \(error) \(error.localizedDescription)")
//            }
//
//            if let document = snapshot {
//                guard let userDictionary = document.data(),
//                    let sender = User(userDictionary: userDictionary) else { fatalError() }
//                completion(sender)
//            }
//        }
//    }
    
    
    
    // MARK: - UI Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}