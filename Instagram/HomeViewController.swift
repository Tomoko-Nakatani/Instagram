//
//  HomeViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2022/09/18.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //投稿するデータを格納する配列
    var postArray: [PostData] = []
    //課題追加
    //var commentArray: [PostData] = []
    
    //Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillApper")
        //ログイン済みか確認
        if Auth.auth().currentUser != nil {
            //listenerを登録して投稿データの更新を監視する
            //データベースの参照場所と取得順序を指定した問い合わせ
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            //取得する投稿データの監視
            listener = postsRef.addSnapshotListener() { (QuerySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                //取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = QuerySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    //ドキュメントの配列をPostdata(投稿データ)の配列に変換
                    let postData = PostData(document: document)
                    return postData
                    
                }
                
                //TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisapper")
        //listenerを削除して監視を停止する
        listener?.remove()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        //セル内のコメントボタンのアクションをソースコードで設定する
        cell.commentButton.addTarget(self, action: #selector(commentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    //セル内のボタンがタップされたときに呼ばれるメソッド
    //selectorで呼び出されるメソッドには@objcを書く
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        //タッチ情報を取り出す
        let touch = event.allTouches?.first
        //タッチした座標を割り出す
        let point = touch!.location(in: self.tableView)
        //タッチした座標がtableview内のどのindexpath位置になるかを取得
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    //セル内のコメントボタンがクリックされたときに呼ばれるメソッド
    @objc func commentButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: コメントボタンがタップされました")
        
        //CommentViewControllerを呼び出す
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        
        //ドキュメントIDを取得する
        let touch = event.allTouches?.first
        //タッチした座標を割り出す
        let point = touch!.location(in: self.tableView)
        //タッチした座標がtableview内のどのindexpath位置になるかを取得
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        commentViewController.docid = postData.id
        print(commentViewController.docid)
        
        self.present(commentViewController, animated: true, completion: nil)
        
        
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
