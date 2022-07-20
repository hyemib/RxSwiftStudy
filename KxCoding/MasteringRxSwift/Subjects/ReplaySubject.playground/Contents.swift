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
 # ReplaySubject
 */
// ReplaySubject는 두개이상의 이벤트를 저장하고 새로운 구독자에게 전달

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// create 메소드로 생성, 버퍼 크기 지정, 지정한 수만큼 이벤트를 저장하는 버퍼가 생성
let rs = ReplaySubject<Int>.create(bufferSize: 3)

(1...10).forEach { rs.onNext($0) }

rs.subscribe { print("Observer 1 >>", $0) }
.disposed(by: disposeBag)

// 버퍼에는 마지막에 전달된 3개가 저장됨.
/*
 Observer 1 >> next(8)
 Observer 1 >> next(9)
 Observer 1 >> next(10)
 */


rs.subscribe { print("Observer 2 >>", $0) }
.disposed(by: disposeBag)

/*
 Observer 1 >> next(8)
 Observer 1 >> next(9)
 Observer 1 >> next(10)
 Observer 2 >> next(8)
 Observer 2 >> next(9)
 Observer 2 >> next(10)
 */

// subject로 새로운 이벤트를 전달하면 즉시 구독자에게 전달됨(다른 subject와 동일)
// 버퍼에서 가장 오래된 이벤트가 삭제됨
rs.onNext(11)

/*
 Observer 1 >> next(8)
 Observer 1 >> next(9)
 Observer 1 >> next(10)
 Observer 2 >> next(8)
 Observer 2 >> next(9)
 Observer 2 >> next(10)
 Observer 1 >> next(11)
 Observer 2 >> next(11)
 */

rs.subscribe { print("Observer 3 >>", $0) }
.disposed(by: disposeBag)

/*
 Observer 1 >> next(8)
 Observer 1 >> next(9)
 Observer 1 >> next(10)
 Observer 2 >> next(8)
 Observer 2 >> next(9)
 Observer 2 >> next(10)
 Observer 1 >> next(11)
 Observer 2 >> next(11)
 Observer 3 >> next(9)
 Observer 3 >> next(10)
 Observer 3 >> next(11)
 */

rs.onCompleted()

// 모든 구독자에게 completed 이벤트가 전달됨
/*
 Observer 1 >> next(8)
 Observer 1 >> next(9)
 Observer 1 >> next(10)
 Observer 2 >> next(8)
 Observer 2 >> next(9)
 Observer 2 >> next(10)
 Observer 1 >> next(11)
 Observer 2 >> next(11)
 Observer 3 >> next(9)
 Observer 3 >> next(10)
 Observer 3 >> next(11)
 Observer 1 >> completed
 Observer 2 >> completed
 Observer 3 >> completed
 */

rs.subscribe { print("Observer 4 >>", $0) }
.disposed(by: disposeBag)

// 버퍼에 저장되어 있는 이벤트가 전달된 후에 completed 이벤트가 전달됨
// error 이벤트도 동일함
/*
 Observer 1 >> next(8)
 Observer 1 >> next(9)
 Observer 1 >> next(10)
 Observer 2 >> next(8)
 Observer 2 >> next(9)
 Observer 2 >> next(10)
 Observer 1 >> next(11)
 Observer 2 >> next(11)
 Observer 3 >> next(9)
 Observer 3 >> next(10)
 Observer 3 >> next(11)
 Observer 1 >> completed
 Observer 2 >> completed
 Observer 3 >> completed
 Observer 4 >> next(9)
 Observer 4 >> next(10)
 Observer 4 >> next(11)
 Observer 4 >> completed
 */
