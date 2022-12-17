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
 # switchLatest
 */
// 가장 최근 Observable이 방출하는 이벤트를 구독자에게 전달

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()

source
    .switchLatest() // 파라미터x. Observable을 방출하는 Observable에서 사용
    .subscribe { print($0) }
    .disposed(by: bag)

a.onNext("1")
b.onNext("b")

source.onNext(a) // source에서 방출한 Observable이 없기 때문에 구독자로 전달되는 것도 없음

a.onNext("2")

/*
 next(2)
 */

b.onNext("b")

// b subject는 최신 Observable이 아니기 때문에 구독자에게 전달x
/*
 next(2)
 */

source.onNext(b) // b를 구독하기 시작

a.onNext("3")
b.onNext("c")

/*
 next(2)
 next(c)
 */

a.onCompleted()

// 구독자로 전달x
/*
 next(2)
 next(c)
 */

b.onCompleted()

/*
 next(2)
 next(c)
 */

source.onCompleted()

/*
 next(2)
 next(c)
 completed

 */


// 에러 이벤트
/*
 a.onError(MyError.error) // 구독자에게 전달x
 b.onError(MyError.error) // 최신 Observable인 b는 에러 이벤트를 받으면 즉시 구독자에게 전달
 
 /*
  next(2)
  next(c)
  error(error)
  */
 */
