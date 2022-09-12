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
 # Scheduler
 */

// iOS 앱을 만들때 쓰레드 처리가 필요할 경우 GCD를 사용하지만 RxSwift에서는 Scheduler를 사용.
// Scheduler는 특정 코드가 실행되는 context를 추상화한것. context는 row level 쓰레드가 될수도 있고 Dispatch Queue나 Operation Queue가 될수도 있음.
// Scheduler는 추상화된 context이기 때문에 쓰레드와 1대1로 매칭되지 않음. 하나의 쓰레드에 두개 이상의 개별 Scheduler가 존재하거나 하나의 Scheduler가 두개의 쓰레드에 걸쳐있는 경우도 있음.

// UI를 업데이트하는 코드는 메인쓰레드에서 실행. GCD에서는 Main Queue에서 실행하고 RxSwift에서는 Main Scheduler에서 실행. 네트워크 요청이나 파일처리같은 작업을 메인쓰레드에서 실행하면 블로킹이 발생. 그래서 GCD에서 Global Queue에서 작업을 실행. RxSwift에서는 Background Scheduler를 사용.

// RxSwift는 GCD와 마찬가지로 다양한 기본 Scheduler를 제공. 내부적으로 GCD와 유사한 방식으로 동작하고 실행할 작업을 스케줄링. 그리고 스케줄링 방식에 따라 Serial Scheduler와 Concurrent Scheduler로 구분. 가장 기본적은 Scheduler는 CurrentThreadScheduler[Serial Scheduler]. scheduler를 별도로 지정하지 않는다면 이 Scheduler가 사용. 메인 쓰레드와 연관된 scheduler는 MainScheduler[Serial Scheduler]. Main Queue처럼 UI를 업데이트할 때 사용. 작업을 실행할 Dispatch Queue를 직접 지정하고 싶으면 SerialDispatchQueueScheduler[Serial Scheduler]와 ConcurrentDispatchQueueScheduler[Concurrent Scheduler]를 사용. MainScheduler는 SerialDispatchQueueScheduler의 일종. Background 작업을 실행할 때는 DispatchQueueScheduler를 사용. 실행 순서를 제외하거나 동시에 실행가능한 작업 수를 제한하고 싶으면 OperationQueueScheduler[Concurrent Scheduler]를 사용. 이 scheduler는 DispatchQueue가 아닌 OperationQueue를 사용해서 생성.

// 이 외에도 Unit Test에 사용하는 TestScheduler와 직접 구현할 수 있는 CustomScheduler가 제공.

let bag = DisposeBag()
/*
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        print($0)
    }
    .disposed(by: bag)

/*
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> map
 Main Thread >> map
 next(4)
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> map
 Main Thread >> map
 next(8)
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> map
 Main Thread >> map
 next(12)
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> map
 Main Thread >> map
 next(16)
 Main Thread >> filter
 Main Thread >> map
 completed
 */
*/



// RxSwift에서 scheduler를 지정할 때는 observeOn(_ :)메소드와 subscribeOn(_ :)메소드를 사용.
// observeOn(_ :)메소드는 연산자를 실행할 scheduler를 지정.
// subscribeOn(_ :)메소드는 구독을 시작하고 종료할 때 사용할 scheduler를 지정. 구독을 시작하면 Observable에서 새로운 이벤트가 방출. 이벤트를 방출할 scheduler를 지정하는 것. 그리고 create 연산자로 구현한 코드도 subscribeOn(_ :)메소드로 지정한 scheduler에서 실행. subscribeOn(_ :)메소드를 사용하지 않는다면 subscribe 메소드가 호출된 scheduler에서 새로운 시퀀스가 시작.

/*
let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observeOn(backgroundScheduler) // map 연산자를 실행할 scheduler를 Background Scheduler로 지정.
    .map { num -> Int in
        
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> Subscribe")
        print($0)
    }
    .disposed(by: bag)


// map 연산자가 background에서 실행
// observeOn 메소드는 이어지는 연산자들이 작업을 실행할 scheduler를 지정. 그래서 뒤에 있는 map은 background scheduler에서 실행되지만 앞에있는 filter에는 영향을 주지 않음.
// subsribe에 있는 코드도 background에서 실행. observeOn 메소드로 지정한 scheduler는 다른 scheduler로 변경하기 전까지 계속 사용.
/*
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> Subscribe
 next(4)
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> map
 Background Thread >> Subscribe
 next(8)
 Background Thread >> map
 Background Thread >> Subscribe
 next(12)
 Background Thread >> map
 Background Thread >> Subscribe
 next(16)
 Background Thread >> Subscribe
 completed
 */
*/

/*
let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observeOn(backgroundScheduler) // map 연산자를 실행할 scheduler를 Background Scheduler로 지정.
    .map { num -> Int in
        
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .subscribeOn(MainScheduler.instance)
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> Subscribe")
        print($0)
    }
    .disposed(by: bag)


// subscribe에서 실행되는 코드는 여전히 background에서 실행되고 있음. subscribeOn 메소드는 Observable이 시작되는 시점에 어떤 scheduler를 사용할지 지정. observeOn 메소드와 달리 호출시점이 중요하지 않음.
/*
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> map
 Background Thread >> Subscribe
 Main Thread >> filter
 next(4)
 Main Thread >> filter
 Background Thread >> map
 Background Thread >> Subscribe
 Main Thread >> filter
 next(8)
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> Subscribe
 next(12)
 Background Thread >> map
 Background Thread >> Subscribe
 next(16)
 Background Thread >> Subscribe
 completed
 */
*/



// subscribe 메소드를 메인 스레드에서 호출하고 싶은 경우
let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .subscribeOn(MainScheduler.instance)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observeOn(backgroundScheduler) // map 연산자를 실행할 scheduler를 Background Scheduler로 지정.
    .map { num -> Int in
        
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
    .observeOn(MainScheduler.instance)
    .subscribe {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> Subscribe")
        print($0)
    }
    .disposed(by: bag)

/*
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Main Thread >> filter
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> filter
 Background Thread >> map
 Main Thread >> Subscribe
 next(4)
 Main Thread >> Subscribe
 next(8)
 Main Thread >> Subscribe
 next(12)
 Main Thread >> Subscribe
 next(16)
 Main Thread >> Subscribe
 completed
 */
