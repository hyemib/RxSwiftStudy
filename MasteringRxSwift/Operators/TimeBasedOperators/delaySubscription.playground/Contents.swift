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
 # delaySubscription
 */

let bag = DisposeBag()

func currentTimeString() -> String {
   let f = DateFormatter()
   f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
   return f.string(from: Date())
}

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(10)
    .debug()
    .delaySubscription(.seconds(7), scheduler: MainScheduler.instance) // delay 시간 지연
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: bag)

/*
 2022-09-10 16:16:55.820: delaySubscription.playground:41 (__lldb_expr_9) -> subscribed
 2022-09-10 16:16:56.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(0)
 2022-09-10 16:16:56.825 next(0)
 2022-09-10 16:16:57.825: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(1)
 2022-09-10 16:16:57.826 next(1)
 2022-09-10 16:16:58.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(2)
 2022-09-10 16:16:58.824 next(2)
 2022-09-10 16:16:59.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(3)
 2022-09-10 16:16:59.824 next(3)
 2022-09-10 16:17:00.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(4)
 2022-09-10 16:17:00.824 next(4)
 2022-09-10 16:17:01.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(5)
 2022-09-10 16:17:01.825 next(5)
 2022-09-10 16:17:02.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(6)
 2022-09-10 16:17:02.825 next(6)
 2022-09-10 16:17:03.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(7)
 2022-09-10 16:17:03.824 next(7)
 2022-09-10 16:17:04.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(8)
 2022-09-10 16:17:04.824 next(8)
 2022-09-10 16:17:05.824: delaySubscription.playground:41 (__lldb_expr_9) -> Event next(9)
 2022-09-10 16:17:05.825 next(9)
 2022-09-10 16:17:05.826: delaySubscription.playground:41 (__lldb_expr_9) -> Event completed
 2022-09-10 16:17:05.826 completed
 2022-09-10 16:17:05.827: delaySubscription.playground:41 (__lldb_expr_9) -> isDisposed
 */


