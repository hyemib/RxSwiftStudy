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
 # flatMapLatest
 */
// flatMapLatest는 원본 Observable이 방출하는 이벤트를 Inner Oberservable로 변환한다는 점에서는 flatMap과 동일
// 하지만 모든 Inner Observable이 방출하는 이벤트를 하나로 병합하지는 않음
// 원본 Observable이 이벤트를 방출하고 새로운 Inner Observable이 생성되면 기존에 있던 Inner Observable은 이벤트 방출을 중단하고 종료됨. 이 때부터 새로운 Inner Observable이 이벤트 방출을 시작하고 Result Observable은 이 Observable이 방출하는 이벤트를 구독자로 전달.


let disposeBag = DisposeBag()

let redCircle = "🔴"
let greenCircle = "🟢"
let blueCircle = "🔵"

let redHeart = "❤️"
let greenHeart = "💚"
let blueHeart = "💙"

let sourceObservable = PublishSubject<String>()
let trigger = PublishSubject<Void>()

sourceObservable
    .flatMapLatest { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in redHeart}
                .take(until: trigger)
        case greenCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in greenHeart}
                .take(until: trigger)
        case blueCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in blueHeart}
                .take(until: trigger)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

sourceObservable.onNext(redCircle)

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    sourceObservable.onNext(greenCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    sourceObservable.onNext(blueCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    trigger.onNext(())
}

// 가장 최근에 생성된 Inner Observable을 의미함. 새로운 Inner Observable이 생성되면 기존 Observable은 바로 종료됨.
/*
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(💚)
 next(💚)
 next(💚)
 next(💚)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 */
