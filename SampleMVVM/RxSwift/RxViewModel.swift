//
//  RxViewModel.swift
//  SampleMVVM
//
//  Created by 신규찬 on 2018. 5. 10..
//  Copyright © 2018년 신규찬. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxViewModel {
    var count = Variable<Int>(0)
    let model = Model()
    
    init() {
        
    }
    
    func autoPlus(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let cnt = self.count.value
            if cnt < 3{
                print("count = \(cnt)")
                self.count.value = self.model.AddCount(value: cnt)
                self.autoPlus()
            }else{
                self.count.value = 0
            }
        }
    }
}
