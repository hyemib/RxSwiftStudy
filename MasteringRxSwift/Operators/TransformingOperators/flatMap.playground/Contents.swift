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
 # flatMap
 */
// 원본 Obsevable이 next 이벤트를 방출하면 FlatMap 연산자가 변환 함수를 실행. 변환 함수는 next 이벤트에 포함된 값을 원하는 형태로 바꾸거나 원하는 작업을 실행. 결과를 새로운 Obsevable을 통해 방출 => Inner Observable이라고 함. 내부적으로 유지되는 Observable. 외부에서는 존재를 알필요x.
// 최종적으로 구독자에게 이벤트를 전달할 때는 모든 Observable을 하나로 합친 새로운 Observable을 사용. 이 과정을 Flattening(평탄화)라고 하고 이 Observable을 Result Observable이라 함.

let disposeBag = DisposeBag()

let redCircle = "🔴"
let greenCircle = "🟢"
let blueCircle = "🔵"

let redHeart = "❤️"
let greenHeart = "💚"
let blueHeart = "💙"

Observable.from([redCircle, greenCircle, blueCircle])
    .flatMap { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable.repeatElement(redHeart)
                .take(5)
        case greenCircle:
            return Observable.repeatElement(greenHeart)
                .take(5)
        case blueCircle:
            return Observable.repeatElement(blueHeart)
                .take(5)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 뒤죽박죽 순서로 출력. FlatMap은 Inner Observable이 이벤트를 방출하면 Result Observable을 통해 지연 없이 방출 => => Interleaving
/*
 next(❤️)
 next(❤️)
 next(💚)
 next(❤️)
 next(💚)
 next(💙)
 next(❤️)
 next(💚)
 next(💙)
 next(❤️)
 next(💚)
 next(💙)
 next(💚)
 next(💙)
 next(💙)
 completed
 */
