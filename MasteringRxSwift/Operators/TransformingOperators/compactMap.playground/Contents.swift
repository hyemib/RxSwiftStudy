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
 # compactMap
 */
// Observable이 방출하는 이벤트에서 값을 꺼낸 다음 옵셔널 형태로 바꾸고 원하는 변환을 실행
// 최종 변환 결과가 nil이면 해당 이벤트는 전달하지 않고 필터링함


let disposeBag = DisposeBag()

let subject = PublishSubject<String?>()

subject
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
    .take(10)
    .map { _ in Bool.random() ? "⭐️" : nil }
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: disposeBag)

/*
 next(Optional("⭐️"))
 next(nil)
 next(Optional("⭐️"))
 next(Optional("⭐️"))
 next(Optional("⭐️"))
 next(Optional("⭐️"))
 next(nil)
 next(nil)
 next(Optional("⭐️"))
 next(Optional("⭐️"))
 */



subject
    .compactMap { $0 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
    .take(10)
    .map { _ in Bool.random() ? "⭐️" : nil }
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: disposeBag)

// nil은 방출x
// nil이 아닌 경우에는 unwrapping되어 방출
/*
 next(⭐️)
 next(⭐️)
 next(⭐️)
 next(⭐️)
 */

