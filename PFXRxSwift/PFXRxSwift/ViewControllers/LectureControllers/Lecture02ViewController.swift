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

class Lecture02ViewController: UIViewController {

    let timer = Observable<Int>.interval(3.0, scheduler: MainScheduler.instance)
    let dispaseBag = DisposeBag()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timer.bind { (_) in
            print("onNext")
        }.disposed(by: self.dispaseBag)
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
