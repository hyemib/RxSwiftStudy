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


let disposeBag = DisposeBag()

//Observable.just(1) // ObservableType을 파라미터로 받음. 해당 Observable이 next 이벤트를 방출하기 전까지 원본 Observable이 전달하는 이벤트를 무시. 이러한 특징 때문에 파라미터로 전달하는 Observable을 트리거라고 하기도 함.


let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.skip(until: trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1) // 아직 trigger가 이벤트를 방출한적이 없기 때문에 subject가 방출한 이벤트는 구독자로 전달되지 않음

trigger.onNext(0) // subject가 이전에 방출한 1은 여전히 구독자로 전달되지 않은 상태. skipUntil은 trigger가 이벤트를 방출한 이후에 새롭게 방출되는 이벤트만 구독자로 전달

subject.onNext(2)

/*
 next(2)
 */
