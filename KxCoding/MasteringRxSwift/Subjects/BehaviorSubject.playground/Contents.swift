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
 # BehaviorSubject
 */
// BehaviorSubject는 PublishSubject와 유사한 방식으로 동작
// subject로 전달된 이벤트를 구독자로 전달하는 것은 동일
// 차이점은 1.subject를 생성하는 방식

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let p = PublishSubject<Int>()

// BehaviorSubject를 생성할 때는 하나의 값을 전달
let b = BehaviorSubject<Int>(value: 0)

// 차이점 2. subject를 구독할 때

// PublishSubject는 내부에 이벤트가 저장되지 않은 상태에서 생성 -> subject로 이벤트가 전달되기 전까지 구독자로 이벤트가 전달되지 않음
p.subscribe { print("PublishSubject >>", $0) }
.disposed(by: disposeBag)

// BehaviorSubject를 구독하고 있는 observer로 next 이벤트가 전달됨
b.subscribe { print("BehaviorSubject >>", $0) }
.disposed(by: disposeBag)

// BehaviorSubject를 생성하면 내부에 next 이벤트가 만들어짐
/*
 BehaviorSubject >> next(0)
 */

// 새로운 구독자가 추가되면 저장되어 있는 next 이벤트가 바로 전달됨
b.onNext(1)

/*
 BehaviorSubject >> next(0)
 BehaviorSubject >> next(1)
 */

// BehaviorSubject는 생성시점에 만들어진 next 이벤트를 저장하고 있다가 새로운 observer에게 전달
// 이후에 subject로 새로운 next 이벤트가 전달되면 기존에 저장되어있든 이벤트를 교체 -> 최신 next 이벤트를 observer에게 전달
b.subscribe { print("BehaviorSubject2 >>", $0) }
.disposed(by: disposeBag)

/*
 BehaviorSubject >> next(0)
 BehaviorSubject >> next(1)
 BehaviorSubject2 >> next(1)
 */

b.onCompleted()

// 모든 구독자에게 completed 이벤트가 바로 전달됨
/*
 BehaviorSubject >> next(0)
 BehaviorSubject >> next(1)
 BehaviorSubject2 >> next(1)
 BehaviorSubject >> completed
 BehaviorSubject2 >> completed
 */

b.subscribe { print("BehaviorSubject3 >>", $0) }
.disposed(by: disposeBag)

// subject로 completed 이벤트가 전달되었기 때문에 next이벤트는 다른 observer로 더이상 전달되지 않음
// error 이벤트도 동일한 결과가 나타남
/*
 BehaviorSubject >> next(0)
 BehaviorSubject >> next(1)
 BehaviorSubject2 >> next(1)
 BehaviorSubject >> completed
 BehaviorSubject2 >> completed
 BehaviorSubject3 >> completed
 */
