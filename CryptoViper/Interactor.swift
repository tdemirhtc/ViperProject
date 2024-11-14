//
//  Interactor.swift
//  CryptoViper
//
//  Created by Hatice Taşdemir on 7.11.2024.
//

import Foundation
//talks to presenter
//class, protocol
//işler yapılır
//linkler download edeceğiz
protocol AnyInteractor {
    var presenter : AnyPresenter? {get set}
    //cryptoları burada indireceğiz essas iş katmanımız burası
    func downloadCryptos()
}
class CryptoInteractor : AnyInteractor {
    var presenter: (any AnyPresenter)?
    
    
    //linkten indirme işlemi yapacağız. presenterdaki inditen sonra result view ile etkileşime geçirecek olan kodu çağıracağız.
    func downloadCryptos() {
        //linki vereceğim url değişkenini oluşturdum.
        guard let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/IA32-CryptoComposeData/main/cryptolist.json") else {
        return
        }
        //datayı indireceği func yazarım.
        //ham veri json formatında
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //datayı aldıysam ve hata yoksa
            guard let data = data, error == nil else {
                self.presenter?.interactorDidDownloadCrypto(result: .failure(NetworError.NetworkFailed))
                return
            }
            do {
                //JSON formatındaki veriyi, Crypto modeline uygun bir listeye ([Crypto]) dönüştürür cryptosa atar.
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                self.presenter?.interactorDidDownloadCrypto(result: .success(cryptos))
            }catch{
                self.presenter?.interactorDidDownloadCrypto(result: .failure(NetworError.ParsingFailed))
                
            }
            
            
        }
        task.resume()
    }
    
    //sınıfın içerisinde var presenter uygulanacak.
}
