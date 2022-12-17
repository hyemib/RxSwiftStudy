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
 # Sharing Subscriptions
 */
// 불필요한 작업을 방지

let bag = DisposeBag()
/*
let source = Observable<String>.create { observer in
    let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/string")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data, let html = String(data: data, encoding: .utf8) {
            observer.onNext(html)
        }
        
        observer.onCompleted()
    }
    task.resume()
    
    return Disposables.create {
        task.cancel()
    }
}
.debug()


source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)
*/

/*
 2022-09-10 16:30:09.340: overveiw.playground:49 (__lldb_expr_11) -> subscribed
 2022-09-10 16:30:09.351: overveiw.playground:49 (__lldb_expr_11) -> subscribed
 2022-09-10 16:30:09.359: overveiw.playground:49 (__lldb_expr_11) -> subscribed
 2022-09-10 16:30:14.506: overveiw.playground:49 (__lldb_expr_11) -> Event next(Hello)
 2022-09-10 16:30:14.508: overveiw.playground:49 (__lldb_expr_11) -> Event completed
 2022-09-10 16:30:14.508: overveiw.playground:49 (__lldb_expr_11) -> isDisposed
 2022-09-10 16:30:14.509: overveiw.playground:49 (__lldb_expr_11) -> Event next(Hello)
 2022-09-10 16:30:14.509: overveiw.playground:49 (__lldb_expr_11) -> Event completed
 2022-09-10 16:30:14.510: overveiw.playground:49 (__lldb_expr_11) -> isDisposed
 2022-09-10 16:30:14.510: overveiw.playground:49 (__lldb_expr_11) -> Event next(Hello)
 2022-09-10 16:30:14.510: overveiw.playground:49 (__lldb_expr_11) -> Event completed
 2022-09-10 16:30:14.510: overveiw.playground:49 (__lldb_expr_11) -> isDisposed
 */


// 모든 구독자가 하나의 구독을 공유하도록 구현
let source = Observable<String>.create { observer in
    let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/string")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data, let html = String(data: data, encoding: .utf8) {
            observer.onNext(html)
        }
        
        observer.onCompleted()
    }
    task.resume()
    
    return Disposables.create {
        task.cancel()
    }
}
.debug()
.share()

source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)

/*
 2022-09-10 16:32:48.717: overveiw.playground:89 (__lldb_expr_13) -> subscribed
 2022-09-10 16:32:48.777: overveiw.playground:89 (__lldb_expr_13) -> Event next(Hello)
 2022-09-10 16:32:48.777: overveiw.playground:89 (__lldb_expr_13) -> Event completed
 2022-09-10 16:32:48.778: overveiw.playground:89 (__lldb_expr_13) -> isDisposed
 */
