//
//  Lecture01ViewController.swift
//  PFXRxSwift
//
//  Created by succorer on 2019. 1. 23..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Lecture01ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    let timer = Observable<Int>.interval(3.0, scheduler: MainScheduler.instance)
    var index = 0
    let dispaseBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timer.bind { (_) in
            print("timer onNext")
            }.disposed(by: self.dispaseBag)

        
        self.button!.rx.tap.subscribe(onNext: { [weak self] in
            print("tap tap")
            
            let ob = Observable.of(1, 2, 3)
            ob.subscribe(onNext: { (value) in
                print(value)
            }, onError: { (error) in
                print(error)
            }, onCompleted: {
                print("onCompleted")
            })
        }, onError: { (error) in
            print("onError")
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        })
        
        
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
