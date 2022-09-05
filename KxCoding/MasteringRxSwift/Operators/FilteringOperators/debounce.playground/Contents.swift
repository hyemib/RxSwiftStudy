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
 # debounce
 */
// 짧은 시간동안 반복적으로 방출되는 이벤트를 제어
// debounce(_ dueTime: RxTimeInterval, scheduler: SchedulerType)
// dueTime 파라미터에는 시간을 전달. 이 시간은 연산자가 next 이벤트를 방출할지 결정하는 조건으로 사용됨. Observer가 next 이벤트를 방출한 다음 지정된 시간동안 다른 next 이벤트를 방출하지 않는다면 해당 시점에 가장 마지막으로 방출된 next 이벤트를 구독자에게 전달. 지정된 시간 이내에 또다른 next 이벤트를 방출했다면 타이머를 초기화. 타이머를 초기화 후 다시 지정된 시간동안 대기. 이 시간 이내에 다른 이벤트가 방출되지 않는다면 마지막 이벤트를 방출하고 이벤트가 방출된다면 타이머를 다시 초기화

let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
   DispatchQueue.global().async {
      for i in 1...10 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.3)
      }
      
      Thread.sleep(forTimeInterval: 1)
      
      for i in 11...20 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.5)
      }
      
      observer.onCompleted()
   }
   
   return Disposables.create {
      
   }
}
/*
buttonTap
   .subscribe { print($0) }
   .disposed(by: disposeBag)

// 0.3초마다 next 이벤트가 방출되고 1초 쉬었다가 0.5초 마다 next 이벤트가 방출됨
/*
 next(Tap 1)
 next(Tap 2)
 next(Tap 3)
 next(Tap 4)
 next(Tap 5)
 next(Tap 6)
 next(Tap 7)
 next(Tap 8)
 next(Tap 9)
 next(Tap 10)
 next(Tap 11)
 next(Tap 12)
 next(Tap 13)
 next(Tap 14)
 next(Tap 15)
 next(Tap 16)
 next(Tap 17)
 next(Tap 18)
 next(Tap 19)
 next(Tap 20)
 completed
 */
*/

buttonTap
    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
   .subscribe { print($0) }
   .disposed(by: disposeBag)

// 지정된 시간동안 새로운 이벤트가 방출되지 않으면 가장 마지막으로 방출된 이벤트를 구독자에게 전달
/*
 next(Tap 10)
 next(Tap 20)
 completed
 */
