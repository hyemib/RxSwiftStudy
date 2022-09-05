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
import Darwin

/*:
 # takeLast
 */

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()

subject.takeLast(2) // 정수를 파라미터로 받아서 Observable을 리턴. 리턴되는 Observable은 원본 Observable이 방출하는 next 이벤트 중에서 마지막에 방출한 next 이벤트만 지정한 수만큼 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)

(1...10).forEach { subject.onNext($0) } // 마지막에 방출한 9와10을 버퍼에 저장한 상태

subject.onNext(11) // 버퍼에 저장된 값을 10과 11로 업데이트

subject.onCompleted()

/*
 next(10)
 next(11)
 completed
 */
/*
enum MyError: Error {
    case error
}
subject.onError(MyError.error) // 에러 이벤트를 전달하면 버퍼에 저장된 이벤트는 버리고 에러 이벤트만 전달
*/
