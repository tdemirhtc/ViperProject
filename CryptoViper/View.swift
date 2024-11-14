//
//  View.swift
//  CryptoViper
//
//  Created by Hatice Taşdemir on 7.11.2024.
//

import Foundation
import UIKit
//talk to or reference to presenter

protocol AnyView {
    //present ile iletişime geçecek.
    var presenter : AnyPresenter? {get set}
    func update(with cryptos: [Crypto])
    func update (with error: String)
    
}
//tıklandığında o bilgileri diğer sayfaya yani performsegue yapması için detailsvc:
class DetailViewController : UIViewController{
    var currency : String = ""
    var price : String = ""
    
    private let currencyLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Currency Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Price Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(currencyLabel)
        view.addSubview(priceLabel)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currencyLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
               priceLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 + 50, width: 200, height: 50)
               currencyLabel.text = currency
               priceLabel.text = price
               currencyLabel.isHidden = false
               priceLabel.isHidden = false
    }
}
class CryptoViewController : UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource {
    var presenter: (any AnyPresenter)?
    
    //updateleri gösterebilmek için array listesi oluştururuz:
    var cryptos : [Crypto] = []
    
    //updatelerimi tableviewa vermem gerketiği için tableview oluşturacağız.:
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
        
    }()
    //mesaj label ekleme
    private let messageLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Downloading..."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    //viewdidloadu kendimiz eklememiz gerekiyor:
    override func viewDidLoad() {
     super.viewDidLoad()
        //oluşturduğumuz görünümleri bu şekilde viewdidloadda ekleriz.
        view.backgroundColor = .blue
        view?.addSubview(tableView)
        view.addSubview(messageLabel)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    //ekranda bir şey oluştururken boyutu ne olacak ekranda nerede duracak gibi func burada veririz.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds //ekran ne kadarsa tablev de o kadar olacak
        messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //içerik yani ne yazılacağını söylemek için:
        var content = cell.defaultContentConfiguration()
        content.text = cryptos[indexPath.row].currency
        content.secondaryText = cryptos[indexPath.row].price
        //cell ile contenti bağlarız:
        cell.contentConfiguration = content
        cell.backgroundColor = .blue
        return cell
    }
    
    func update(with cryptos: [Crypto]) {
        DispatchQueue.main.async{
            //self cryprosu update olmuş hali ile değiştirmek:
            self.cryptos = cryptos
            //downloading göstermesine gerek yok
            self.messageLabel.isHidden = true
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async{
            self.cryptos = []
            self.tableView.isHidden = true
            //loading yerine artık hata varsa hatayı göstersin diye değiştiriiriz.
            self.messageLabel.text = error
            self.messageLabel.isHidden = false
        }
        
    }
    //tableview func bu burada çağırırız detailvcyi
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(cryptos[indexPath.row].currency)
            let nextViewController = DetailViewController()
            nextViewController.price = cryptos[indexPath.row].price
            nextViewController.currency = cryptos[indexPath.row].currency
            self.present(nextViewController, animated: true, completion: nil)
        }
    
    
}
