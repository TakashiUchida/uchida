//
//  SearchTableVC.swift
//  MyOkashi
//
//  Created by User5 on 2018/03/12.
//  Copyright © 2018年 User5. All rights reserved.
//

import UIKit
import SafariServices

class SearchTableVC: UIViewController, UISearchBarDelegate, SFSafariViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var imageCache = NSCache<AnyObject, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //デリゲートの通知先を設定
        searchText.delegate = self
        //プレースホルダーの設定
        searchText.placeholder = "お菓子の名前を入力してください"
        //データソースを設定
        tableView.dataSource = self
        //デリゲートの設定
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //お菓子のリストをタプルをもひいて格納
    var okashiList: [(name: String, maker: String,  price: String, link: String, image: String)] = []
//    var okashiList: [(name: String, maker: String, link: String, image: String)] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            //デバック
            print(searchWord)
            //検索ワードが入力されていたら検索実行
            searchOkashi(keyword: searchWord)
        }
    }
    
    //JSONのitem内のデータ構造
    struct ItemJson: Codable {

        //お菓子の名前
        let name: String?
        //メーカー
        let maker: String?
        //価格
        let price: String?
        //掲載URL
        let url: String?
        //画像URL
        let image: String?
        
        init(from decoder: Decoder) throws {
            //
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if container.contains(.name) {
                name = try? container.decode(String.self, forKey: .name)
            } else {
                name = nil
            }

            if container.contains(.maker) {
                maker = try? container.decode(String.self, forKey: .maker)
            } else {
                maker = nil
            }

            if container.contains(.price) {
                price = try? container.decode(String.self, forKey: .price)
            } else {
                price = nil
            }
            
            if container.contains(.url) {
                url = try? container.decode(String.self, forKey: .url)
            } else {
                url = nil
            }

            if container.contains(.image) {
                image = try? container.decode(String.self, forKey: .image)
            } else {
                image = nil
            }

        }
        
        
        
    }
    //JSONのデータ構造
    struct ResultJson: Codable {
        //複数要素
        let item: [ItemJson]?
    }
    
    //お菓子を検索
    func searchOkashi(keyword: String) {
        //検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        //リクエストURLの組み立て
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=30&order=r") else {
            return
        }
        print(req_url)
        
        //リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        //セッションを作成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: { (data, response, error) in
            //セッション終了
            session.finishTasksAndInvalidate()
            //エラーハンドリング
            do {
                //JsonDecoderのインスタンスを取得
                let decoder = JSONDecoder()
                //受け取ったJSONデータを解析して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                //情報が取得できているか確認
                if let items = json.item {
                    //お菓子リストの初期化
                    self.okashiList.removeAll()
                    //取得している情報の数だけ処理
                    for item in items {
//print(item.price)
                        //アンラップ
                        if let maker = item.maker,
                            let name = item.name,
                            let price = item.price,
                            let link = item.url,
                            let imageUrl = item.image {
                            //タプルにまとめ
                            let okashi = (name, maker, price, link, imageUrl)
//                            let okashi = (name, maker, link, imageUrl)
                            //配列に追加
                            self.okashiList.append(okashi)
                            // debug
                        }

                    }
                    self.tableView.reloadData()
                }
                
            } catch {
                print("エラーが発生しました")
            }
        })
        
        //ダウンロード開始
        task.resume()
    }
    
    //テーブルビューのデータソース
    //テーブルのセクション数を取得
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //セクション内のレコード数を取得　※必須
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return okashiList.count
    }
    //テーブルセルの取得処理  ※必須
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        //名称を取得
        cell.itemTitleLabel.text = okashiList[indexPath.row].name
        //メーカーを取得
        cell.itemMakerLabel.text = okashiList[indexPath.row].maker
        //価格を取得
        cell.itemPriceLabel.text = okashiList[indexPath.row].price + "円"
        //商品のURLを取得
        cell.itemUrl = okashiList[indexPath.row].link
        
        //画像取得処理
        //すでに設定されている画像と同じかどうかチェックする
//        guard let itemImageUrl = okashiList[indexPath.row].imageUrl else {
//            return cell
//        }
        //
        let itemImageUrl = okashiList[indexPath.row].image

        //キャッシュの画像を取得する
        if let cacheImage = imageCache.object(forKey: itemImageUrl as AnyObject) {
            //キャッシュ画像の設定
            cell.itemImageView.image = cacheImage
            return cell
        }
        
        //キャッシュの画像がないためダウンロードする
        guard let url = URL(string: itemImageUrl) else {
            //URLが生成できなかった
            return cell
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                //エラーあり
                return
            }
            guard let data = data else {
                //データが存在しない
                return
            }
            guard let image = UIImage(data: data) else {
                //imageが生成できなかった
                return
            }
print("imageをキャッシュ")
            //ダウンロードした画像をキャッシュに登録しておく
            self.imageCache.setObject(image, forKey: itemImageUrl as AnyObject)
            //画像はメインスレッド上で施呈する
            DispatchQueue.main.async {
                cell.itemImageView.image = image
            }
        }
        //画像の読み込み開始
        task.resume()
        
        return cell

    }
    
    //delegate(cellがタップされたときの処理)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ハイライト解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        //URLを生成
        if let url = URL(string: okashiList[indexPath.row].link) {
            //SFSafariViewを開く
            let safariViewController = SFSafariViewController(url: url)        
            safariViewController.delegate = self
            //SafariViewを開く
            present(safariViewController, animated: true, completion: nil)
    
        }
    }
    //delegate(SafariViewを閉じたときの処理)
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        dismiss(animated: true, completion: nil)
//    }
    
}
