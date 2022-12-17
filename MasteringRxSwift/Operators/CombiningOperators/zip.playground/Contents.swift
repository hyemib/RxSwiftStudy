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
 # zip
 */
// Source Observables이 방출하는 요소를 결합
// combineLatest는 Source Observables 중에서 하나라도 요소를 방출하면 가장 최근 요소를 대상으로 클로저를 실행
//  combineLatest와 동일하게 Observable을 결합하고 클로저를 실행한 다음 이 결과를 방출하는 Result Observable을 리턴. 하지만 zip 연산자는 클로저에게 중복된 요소를 전달하지 않음. 반드시 인덱스를 기준으로 짝을 일치시켜서 전달. => Indexed Sequencing

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let numbers = PublishSubject<Int>()
let strings = PublishSubject<String>()

Observable.zip(numbers, strings) { "\($0) - \($1)" }
    .subscribe { print($0) }
    .disposed(by: bag)
numbers.onNext(1)
strings.onNext("one")

numbers.onNext(2)
strings.onNext("two")

numbers.onCompleted()
strings.onNext("three")
strings.onCompleted()

// combineLatest와 다르게 Source Observables 중에서 하나라도 completed 이벤트를 전달하면 이후에는 next 이벤트가 구독자에게 전달되지 않음
// 구독자로 completed 이벤트가 전달되는 시점은 모든 Source Observables이 completed 이벤트를 전달한 시점
/*
 next(1 - one)
 next(2 - two)
 completed
 */

/*
 numbers.onError(MyError.error)
 strings.onNext("three")
 strings.onCompleted()
 
 /*
  next(1 - one)
  next(2 - two)
  error(error)
 */
 */



