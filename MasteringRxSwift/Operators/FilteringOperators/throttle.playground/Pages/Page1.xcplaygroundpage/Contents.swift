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
 # throttle
 */
// 짧은 시간동안 반복적으로 방출되는 이벤트를 제어
// throttle(_ dueTime: RxTimeInterval, latest: Bool = true, scheduler: SchedulerType)
// dueTime 파라미터에는 반복주기를 전달
// throttle은 지정된 주기동안 하나의 이벤트만 구독자에게 전달
// latest 파라미터는 보통 기본값을 사용하는데 주기를 엄격하게 지킴. false를 전달한 경우 반복주기가 경과한 다음 가장 먼저 방출된 이벤트를 구독자에게 전달

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

buttonTap
    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
   .subscribe { print($0) }
   .disposed(by: disposeBag)

// 1초마다 하나씩 전달
/*
 next(Tap 1)
 next(Tap 4)
 next(Tap 7)
 next(Tap 10)
 next(Tap 11)
 next(Tap 12)
 next(Tap 14)
 next(Tap 16)
 next(Tap 18)
 next(Tap 20)
 completed
 */


// throttle 연산자는 next 이벤트를 지정된 주기마다 하나씩 구독자에게 전달. 짧은 시간동안 반복되는 탭 이벤트나 델리게이트 이벤트를 처리할 때 사용.
// debounce 연산자는 next 이벤트가 전달된 다음 지정된 시간이 경과하기까지 다른 이벤트가 전달되지 않는다면 마지막으로 방출된 이벤트를 구독자에게 전달. 검색기능을 구현할 때 사용.

//: [Next](@next)
