//
//  PostData.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2022/09/24.
//

import UIKit
import Firebase

class PostData: NSObject {

    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    //課題追加
    var commentname: String?
    var comment: String?
    var com: [String] = []
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        //辞書形式のデータを取り出す
        let postDic = document.data()
        //辞書形式から値を取り出す
        self.name = postDic["name"] as? String
        
        self.caption = postDic["caption"] as? String
        
        //課題追加
        self.commentname = postDic["commentname"] as? String
        self.comment = postDic["comment"] as? String
        if let com = postDic["com"] as? [String] {
            self.com = com
        }
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        //likesはいいねボタンの時に使う
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかをチェックすることで自分がいいねを押したか判断する
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあればいいねを押していると認識する
                self.isLiked = true
                
            }
        }
    }
}
