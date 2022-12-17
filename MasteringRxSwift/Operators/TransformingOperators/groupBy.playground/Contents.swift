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
 # groupBy
 */
// Observable이 방출하는 요소를 원하는 기준으로 그루핑 할 때 사용

let disposeBag = DisposeBag()
let words = ["Apple", "Banana", "Orange", "Book", "City", "Axe"]
/*
Observable.from(words)
    .groupBy { $0.count }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 문자열 길이를 기준으로 그루핑
/*
 next(GroupedObservable<Int, String>(key: 5, source: RxSwift.(unknown context at $106c41e68).GroupedObservableImpl<Swift.String>))
 next(GroupedObservable<Int, String>(key: 6, source: RxSwift.(unknown context at $106c41e68).GroupedObservableImpl<Swift.String>))
 next(GroupedObservable<Int, String>(key: 4, source: RxSwift.(unknown context at $106c41e68).GroupedObservableImpl<Swift.String>))
 next(GroupedObservable<Int, String>(key: 3, source: RxSwift.(unknown context at $106c41e68).GroupedObservableImpl<Swift.String>))
 completed
 */
*/

/*
Observable.from(words)
    .groupBy { $0.count }
    .subscribe(onNext: { groupedObservable in
        print("==\(groupedObservable.key)")
        groupedObservable.subscribe { print(" \($0)") }
    })
    .disposed(by: disposeBag)

/*
 ==5
  next(Apple)
 ==6
  next(Banana)
  next(Orange)
 ==4
  next(Book)
  next(City)
 ==3
  next(Axe)
  completed
  completed
  completed
  completed
 */
*/



// groupBy 연산자를 사용할 때는 flatMap 연산자와 toArray 연산자를 활용해서 그루핑된 최종 결과를 하나의 배열로 방출하도록 구현

Observable.from(words)
    .groupBy { $0.count }
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(["Book", "City"])
 next(["Apple"])
 next(["Axe"])
 next(["Banana", "Orange"])
 completed

 */
