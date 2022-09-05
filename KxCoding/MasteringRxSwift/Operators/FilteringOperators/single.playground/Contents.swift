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
 # single
 */

// 원본 Observable에서 첫번째 요소만 방출하거나 조건과 일치하는 첫번째 요소만 방출
// 두개 이상의 요소가 방출되는 경우에는 에러 발생

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

Observable.just(1)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(1)
 completed
 */


// # 파라미터가 없는 single 연산자
Observable.from(numbers)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(1)
 error(Sequence contains more than one element.)
 */


// # predicate를 받는 single 연산자
Observable.from(numbers)
    .single { $0 == 3 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(3)
 completed
 */



let subject = PublishSubject<Int>()

subject.single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(100)

// 새로운 요소를 방출하면 구독자에게 바로 전달됨
// 하나의 요소가 방출되었다고 바로 completed 이벤트가 전달되먄 안됨. 다른 요소가 방출될 수도 있기 때문
// 그래서 single 연산자가 리턴하는 Observable은 원본 Observable에서 completed 이벤트를 전달할 때까지 대기. completed 이벤트가 전달된 시점에 하나의 요소만 방출된 상태라면 구독자에게 completed 이벤트가 전달되고 그사이에 다른 요소가 방출되었으면 구독자에게 error가 전달됨
/*
 next(100)
 */
