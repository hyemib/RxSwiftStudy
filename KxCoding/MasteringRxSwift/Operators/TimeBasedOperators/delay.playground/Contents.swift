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
 # delay
 */

// next 이벤트가 구독자로 전달되는 시점을 지정한 시간만큼 지연시킴
// 에러 이벤트는 지연없어 즉시 전달

let bag = DisposeBag()

func currentTimeString() -> String {
   let f = DateFormatter()
   f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
   return f.string(from: Date())
}

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(10)
    .debug()
    .delay(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString(), $0) }
    .disposed(by: bag)

/*
 2022-09-10 16:08:45.726: delay.playground:44 (__lldb_expr_7) -> subscribed
 2022-09-10 16:08:46.729: delay.playground:44 (__lldb_expr_7) -> Event next(0)
 2022-09-10 16:08:47.728: delay.playground:44 (__lldb_expr_7) -> Event next(1)
 2022-09-10 16:08:48.728: delay.playground:44 (__lldb_expr_7) -> Event next(2)
 2022-09-10 16:08:49.728: delay.playground:44 (__lldb_expr_7) -> Event next(3)
 2022-09-10 16:08:50.728: delay.playground:44 (__lldb_expr_7) -> Event next(4)
 2022-09-10 16:08:51.728: delay.playground:44 (__lldb_expr_7) -> Event next(5)
 2022-09-10 16:08:51.730 next(0)
 2022-09-10 16:08:52.728: delay.playground:44 (__lldb_expr_7) -> Event next(6)
 2022-09-10 16:08:52.732 next(1)
 2022-09-10 16:08:53.728: delay.playground:44 (__lldb_expr_7) -> Event next(7)
 2022-09-10 16:08:53.735 next(2)
 2022-09-10 16:08:54.728: delay.playground:44 (__lldb_expr_7) -> Event next(8)
 2022-09-10 16:08:54.737 next(3)
 2022-09-10 16:08:55.728: delay.playground:44 (__lldb_expr_7) -> Event next(9)
 2022-09-10 16:08:55.728: delay.playground:44 (__lldb_expr_7) -> Event completed
 2022-09-10 16:08:55.729: delay.playground:44 (__lldb_expr_7) -> isDisposed
 2022-09-10 16:08:55.739 next(4)
 2022-09-10 16:08:56.741 next(5)
 2022-09-10 16:08:57.742 next(6)
 2022-09-10 16:08:58.745 next(7)
 2022-09-10 16:08:59.748 next(8)
 2022-09-10 16:09:00.750 next(9)
 2022-09-10 16:09:00.752 completed
 */





