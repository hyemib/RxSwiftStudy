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
 # window
 */
// 수집된 항목을 방출하는 Observable을 리턴

let disposeBag = DisposeBag()
/*
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .window(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance) // Observable을 방출. Observable이 방출하는 Observable을 Inner Observable이라 함. Inner Observable은 지정된 최대 항목 수만큼 방출하거나 지정된 시간이 경과하면 completed 이벤트를 전달하고 종료함.
    .take(5)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// AddRef가 Inner Observable에 해당함
/*
 next(RxSwift.AddRef<Swift.Int>)
 next(RxSwift.AddRef<Swift.Int>)
 next(RxSwift.AddRef<Swift.Int>)
 next(RxSwift.AddRef<Swift.Int>)
 next(RxSwift.AddRef<Swift.Int>)
 completed*/
*/


Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .window(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance) // Observable을 방출. Observable이 방출하는 Observable을 Inner Observable이라 함. Inner Observable은 지정된 최대 항목 수만큼 방출하거나 지정된 시간이 경과하면 completed 이벤트를 전달하고 종료함.
    .take(5)
    .subscribe {
        print($0)
        
        // next 이벤트가 전달되면 element 속성을 통해 Inner Observable에 접근
        if let observable = $0.element {
            observable.subscribe { print(" inner: ", $0)}
        }
    }
    .disposed(by: disposeBag)

// maxCount가 채워질 때 까지 기다리지 않고 2초동안 항목을 방출한 다음 바로 종료
// 시간의 오차가 생김
/*
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(0)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(1)
  inner:  next(2)
  inner:  next(3)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(4)
  inner:  next(5)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(6)
  inner:  next(7)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
 completed
  inner:  next(8)
  inner:  next(9)
  inner:  completed
 */


