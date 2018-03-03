//
//  ViewModel.swift
//  SampleMVVM
//  Type : View Model
//
//  Created by 신규찬 on 2018. 3. 3..
//  Copyright © 2018년 신규찬. All rights reserved.
//

import Foundation

class ViewModel {
    var count: Dynamic<Int>?
    let model = Model()
    
    init() {
         count = Dynamic(0)
    }
    
    func autoPlus(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let cnt = self.count?.value, cnt < 3{
                print("count = \(cnt)")
                self.count?.value = self.model.AddCount(value: cnt)
                self.autoPlus()
            }else{
                self.count?.value = 0
            }
        }
    }
}
