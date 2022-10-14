//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2022/09/24.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    //課題追加
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var comment: UILabel!
    
    var arraycomment: [PostData] = []
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
    
    //PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        //画像の表示
        //CloudStorageから画像をダウンロードしている間、ダウンロード中であることを示す
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //CloudStorageの画像保存場所を指定
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        print("キャプションの表示")
        
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        //いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        print("いいねの表示")
        
        //いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        //コメントの表示
        
        let arraycomment = postData.com.joined(separator: "\n")
        //let arraycomment = postData.com.joined(separator: ",")
        self.comment.text = "\(arraycomment)"
        print(arraycomment)
        
        print("コメントの表示")
        
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        //コメントする入力欄の表示・非表示
        
        
    }
    
}
