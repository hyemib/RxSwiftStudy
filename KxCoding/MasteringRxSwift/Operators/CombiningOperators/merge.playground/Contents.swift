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
 # merge
 */
// 여러 Observable이 방출하는 항목들을 하나의 Observable에서 방출하도록 병합
// concat 연산자는 하나의 Observable이 모든 요소를 방출하고 completed 이벤트를 전달하면 이어지는 Observable을 연결하지만 merge 연산자는 두개 이상의 Observable을 병합하고 모든 Observable에서 방출하는 요소들을 순서대로 방출

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let oddNumbers = BehaviorSubject(value: 1)
let evenNumbers = BehaviorSubject(value: 2)
let negativeNumbers = BehaviorSubject(value: -1)

let source = Observable.of(oddNumbers, evenNumbers)

source
    .merge()
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 next(1)
 next(2)
 */

oddNumbers.onNext(3)
evenNumbers.onNext(4)

/*
 next(1)
 next(2)
 next(3)
 next(4)
 */

evenNumbers.onNext(6)
oddNumbers.onNext(5)

/*
 next(1)
 next(2)
 next(3)
 next(4)
 next(6)
 next(5)
 */

/*
oddNumbers.onCompleted()
evenNumbers.onNext(8) // oddNumbers subject에서 completed 이벤트를 전달하면 더이상 새로운 이벤트를 받지 않지만 evenNumbers subject는 여전히 이벤트를 받을 수 있음

/*
 next(1)
 next(2)
 next(3)
 next(4)
 next(6)
 next(5)
 next(8)
 */

evenNumbers.onCompleted()

// evenNumbers subject에 completed 이벤트를 전달하면 최종적으로 구독자에게 completed 이벤트가 전달됨.
// merge 연산자는 병합한 모든 Observable로 부터 completed 이벤트를 받은 다음에 구독자로 completed 이벤트를 전달. 그 전까지는 계속해서 next 이벤트를 전달
/*
 next(1)
 next(2)
 next(3)
 next(4)
 next(6)
 next(5)
 next(8)
 completed
 */
*/
 

oddNumbers.onError(MyError.error)
evenNumbers.onNext(8)
evenNumbers.onCompleted()

// 병합 대상중에서 하나라도 error 이벤트를 전달하면 그 즉시 구독자에게 전달되고 더이상 다른 이벤트를 전달하지 않음.
/*
 next(1)
 next(2)
 next(3)
 next(4)
 next(6)
 next(5)
 error(error)
 */

/*
 let oddNumbers = BehaviorSubject(value: 1)
 let evenNumbers = BehaviorSubject(value: 2)
 let negativeNumbers = BehaviorSubject(value: -1)

 let source = Observable.of(oddNumbers, evenNumbers, negativeNumbers)
 
 source
     .merge(maxConcurrent: 2) // merge 연산자로 병합할 수 있는 Observable 수는 제한이 없지만 제한하고자 할 경우 maxConcurrent 사용
     .subscribe { print($0) }
     .disposed(by: bag)
 
 oddNumbers.onNext(3)
 evenNumbers.onNext(4)
 
 evenNumbers.onNext(6)
 oddNumbers.onNext(5)
 
 nagativeNumbers.onNext(-2)
 
 // nagatinveNumbers는 병합 대상에서 제외됨

 /*
  next(1)
  next(2)
  next(3)
  next(4)
  next(6)
  next(5)
  */
 
 oddNumbers.onCompleted()
 // merge 연산자는 이런 Observable을 큐에 저장해두었다가 병합 대상 중 하나가 completed 이벤트를 전달하면 순서대로 병합대상에 추가
 /*
  next(1)
  next(2)
  next(3)
  next(4)
  next(6)
  next(5)
  next(-2)
  */
 
 
*/
