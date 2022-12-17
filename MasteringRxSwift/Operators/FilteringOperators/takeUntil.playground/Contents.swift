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
 # take(until:)
 */

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

// # subject.take(until: <#T##ObservableType#>)
subject.take(until: trigger) // Observable을 파라미터로 받음. 파라미터로 전달한 Observable에서 next 이벤트를 전달하기 전까지 원본 Observable에서 next 이벤트를 전달.
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
// trigger가 next 이벤트를 방출하지 않았기 때문에 원본 이벤트를 구독자에게 전달
/*
 next(1)
 */
subject.onNext(2)
/*
 next(1)
 next(2)
 */
trigger.onNext(0)
// trigger에서 next 이벤트를 방출하면 completed 이벤트를 전달하고 종료
/*
 next(1)
 next(2)
 completed
 */
subject.onNext(3) // 새로운 이벤트를 방출해도 실행은 되지만 더이상 이벤트를 방출하지 않음



// # subject.take(until: <#T##(Int) throws -> Bool#>, behavior: <#T##TakeBehavior#>)
// 클로저에서 false를 리턴하는 동안 이벤트를 방출하고 true를 리턴하면 이벤트 방출을 중단하고 Observable을 종료
subject.take(until: { $0 > 5 }) // Observable이 방출하는 요소를 받아서 Bool을 리턴하는 클로저. false를 리턴하는 동안 이벤트를 방출하고 true를 리턴하면 이벤트 방출을 준단하고 Observable을 종료
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)
subject.onNext(3)
// 5보다 작은 값이므로 모두 방출됨
/*
 next(1)
 next(2)
 next(3)
 */
// 5를 초과하는 값을 방출하면 true를 리턴하고 구독자로 전달되지 않음. completed 이벤트가 전달되고 종료됨
subject.onNext(6)
/*
 next(1)
 next(2)
 next(3)
 completed
 */





