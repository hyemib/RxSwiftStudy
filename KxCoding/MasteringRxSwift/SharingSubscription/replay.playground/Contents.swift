//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift


/*:
 # replay, replayAll
 */
// connectable observable에 버퍼를 추가하고 새로운 구독자에게 최근 이벤트를 전달.
// publish 연산자와 마찬가지로 multicast 연산자를 호출. replay subject를 만들어서 파라미터로 전달. multicast 연산자로 publish subject를 전달하면 publish 연산자를 사용하고 replay subject를 전달하면 replay 연산자를 사용. 두 연산자 모두 multicast를 조금더 쉽게 사용하도록 도와주는 utility 연산자.
// 파라미터를 통해서 버퍼의 크기를 지정. 버퍼 크기에 제한이 없는 replayAll도 있지만 구현에 따라서 메모리 사용량이 급격하게 증가하는 문제 때문에 특별한 이유가 없다면 사용x
// replay 연산자를 사용할때는 버퍼 크기를 신중하게 지정해야함. 필요이상으로 크게 지정하면 필연적으로 메모리 문제가 발생하기 때문에 필요한 선에서 가장 작은 크기로 지정해야함.

let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).replay(5)

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect()

// 두번째 구독자의 0과 1이 저장된 next이벤트도 함께 전달
/*
 🔵 next(0)
 🔵 next(1)
 🔴 next(0)
 🔴 next(1)
 🔵 next(2)
 🔴 next(2)
 🔵 next(3)
 🔴 next(3)
 🔵 next(4)
 🔴 next(4)
 🔵 completed
 🔴 completed
 */















