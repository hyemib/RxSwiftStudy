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
 # buffer
 */
// 특정 주기동안 Obsevable이 방출하는 항목을 수집하고 하나의 배열로 리턴 => Controlled Buffering이라고 함


let disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// Observable은 1초마다 항목을 방출하고 있고 buffer 연산자는 2초마다 3개씩 수집하고 있음. buffer 연산자는 timeSpan이 경과하면 수집된 항목들을 즉시 방출. count만큼 수집되지 않았더라도 즉시 방출.
// 방출되는 배열에는 시간상의 오차로 개수가 달라질 수 있음.
/*
 next([0])
 next([1, 2, 3])
 next([4, 5])
 next([6, 7])
 next([8, 9])
 completed
 */








