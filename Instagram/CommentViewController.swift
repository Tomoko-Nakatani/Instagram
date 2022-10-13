//
//  CommentViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2022/10/01.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var Comment: UITextField!
    
    var commentname: String!
    var comment: String!
    var com: String!
    var docid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //コメント送信した時に呼ばれるメソッド
    @IBAction func CommentSend(_ sender: Any) {
        
        //HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
    
        //更新データを作成する
        var updateValue: FieldValue
        
        commentname = Auth.auth().currentUser?.displayName
        comment = self.Comment.text
        com = commentname + ":" + comment + "\n"
        
        print(docid)
        print(commentname)
        print(comment)
        print(com)
        //今回新たにコメント投稿した場合は、コメントとコメント投稿者を追加する更新データを作成
        updateValue = FieldValue.arrayUnion([com])
        print(docid)
        print(updateValue)
        
        //firebase更新データを書き込む
        let updateRef = Firestore.firestore().collection(Const.PostPath).document(docid)
        updateRef.updateData(["com": com])
        
        
        //HDDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        //投稿処理が完了したので先頭画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func CommentCancle(_ sender: Any) {
        //加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
