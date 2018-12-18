////
////  ChatViewController.swift
////  Atencion Corilla iOS
////
////  Created by Maria del Carmen Ramos Alamo on 12/2/18.
////  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
////
//
//import UIKit
//import JSQMessagesViewController
//import Firebase
//import FirebaseDatabase
//
//class ChatViewController: JSQMessagesViewController {
//
//    var messages = [JSQMessage]()
//    var to = ""
//
//
//    lazy var outgoingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
//    }()
//
//    lazy var incomingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
//    }()
//
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//        if let currentUser = Auth.auth().currentUser{
//            let from = currentUser.displayName
//        }
//
//
//        title = "Chat: \(to)"
//
//        let query = Constants.refs.databaseChats//.queryLimited(toLast: 10)
//
//        _ = query.observe(.childAdded, with: { [weak self] snapshot in
//
//            if  let data        = snapshot.value as? [String: String],
//                let from          = data["from"],
//                let to        = data["to"],
//                let text        = data["text"],
//                !text.isEmpty
//            {
//                if let message = JSQMessage(senderId: from, displayName: to, text: text)
//                {
//                    self?.messages.append(message)
//
//                    self?.finishReceivingMessage()
//                }
//            }
//        })
//    }
//
////    @objc func showDisplayNameDialog()
////    {
////        let defaults = UserDefaults.standard
////
////        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)
////
////        alert.addTextField { textField in
////
////            if let name = defaults.string(forKey: "jsq_name")
////            {
////                textField.text = name
////            }
////            else
////            {
////                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
////                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
////            }
////        }
////
////        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
////
////            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
////
////                self?.senderDisplayName = textField.text
////
////                self?.title = "Chat: \(self!.senderDisplayName!)"
////
////                defaults.set(textField.text, forKey: "jsq_name")
////                defaults.synchronize()
////            }
////        }))
////
////        present(alert, animated: true, completion: nil)
////    }
//
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
//    {
//        return messages[indexPath.item]
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return messages.count
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
//    {
//        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
//    {
//        return nil
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
//    {
//        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
//    {
//        return messages[indexPath.item].senderId == senderId ? 0 : 15
//    }
//
//    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
//    {
//        let ref = Constants.refs.databaseChats.childByAutoId()
//
//        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
//
//        ref.setValue(message)
//
//        finishSendingMessage()
//    }
//
//}
