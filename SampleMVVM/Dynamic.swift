//
//  Dynamic.swift
//  SampleMVVM
//
//  Created by 신규찬 on 2018. 3. 3..
//  Copyright © 2018년 신규찬. All rights reserved.
//

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?){
        self.listener = listener
    }
    
    func createBind(_ listener: Listener?){
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    
    init(_ v: T){
        value = v
    }
}
