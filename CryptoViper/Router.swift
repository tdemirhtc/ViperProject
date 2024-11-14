//
//  Router.swift
//  CryptoViper
//
//  Created by Hatice Taşdemir on 7.11.2024.
//

import Foundation
import UIKit
// bütün ögeleri barındırıyor ve koordine ediyor.
//storyboardu sildik diye uygulama ilk açıldığında ne olacak nere açılacak nereye giecek burada yazılıyor.
//class, protocol
//entrypoint belirtilecek storyboarddaki başlatma oku hem scenedelegatteda hem de burada belirtmemiz gerekiyor. entrypointimiz uıviewcontroller

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    //bir func yazılacaksa,değişkken oluşturulacaksa protocolün içinde kullanıp bunu birden fazla sınıf içeriisne verebiliyoruz. protocol metotların içerisinde bodye(yani curly brackets) gerek yok. ne döndüreceğiniş veririz. interface inherit gibi içindeki funcı uygulamaya zorlar.
    var entry: EntryPoint? {get}
    
    static func startExecution() -> AnyRouter
    
}

class CryptoRouter : AnyRouter {
    
    var entry : EntryPoint?
    //bu funcda her şeyi birbirine bağlayıp çalıştıracağız.
    static func startExecution() -> any AnyRouter {
        
        let router = CryptoRouter()
        //bağlama işlemi:
        var view : AnyView = CryptoViewController()
        var presenter : AnyPresenter = CryptoPresenter()
        var interactor : AnyInteractor = CryptoInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        //giriş noktası yani o başlama oku
        router.entry = view as? EntryPoint
        //scenedelegatea bu kodları ekleriz
       /* let routerInstance = CryptoRouter.startExecution()
        let initialViewController = routerInstance.entry
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = initialViewController
        self.window = window
        window.makeKeyAndVisible()
        */
        return router
    }
    
    
}

