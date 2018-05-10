//
//  RxViewController.swift
//  SampleMVVM
//
//  Created by 신규찬 on 2018. 5. 10..
//  Copyright © 2018년 신규찬. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxViewController : UIViewController{
    let viewModel = RxViewModel()
    
    @IBAction func actionPlay(_ sender: Any) {
        viewModel.autoPlus()
    }
    @IBOutlet weak var txtCountValue: UILabel!
    @IBOutlet weak var viewTarget: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _ = viewModel.count.asObservable().subscribe(onNext: { (count) in
            if count < 1 { self.viewTarget.backgroundColor = UIColor.gray
            }else if count < 2 { self.viewTarget.backgroundColor = UIColor.red
            }else if count < 3 { self.viewTarget.backgroundColor = UIColor.yellow
            }else {
                self.viewTarget.backgroundColor = UIColor.green
            }
            self.txtCountValue.text = "\(count)"
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
    }
    
    @objc func checkData( _  data : Notification){
        //        print("\(data as! String)")
        let test = data.object as! TestDTO
        print("recevie data name : \(test.name) / age \(test.age)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
