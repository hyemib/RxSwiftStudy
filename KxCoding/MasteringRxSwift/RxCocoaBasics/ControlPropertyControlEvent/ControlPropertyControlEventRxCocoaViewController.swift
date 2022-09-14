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
import RxCocoa

class ControlPropertyControlEventRxCocoaViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redComponentLabel: UILabel!
    @IBOutlet weak var greenComponentLabel: UILabel!
    @IBOutlet weak var blueComponentLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    private func updateComponentLabel() {
        redComponentLabel.text = "\(Int(redSlider.value))"
        greenComponentLabel.text = "\(Int(greenSlider.value))"
        blueComponentLabel.text = "\(Int(blueSlider.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: redComponentLabel.rx.text)
            .disposed(by: bag)
        
        greenSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: greenComponentLabel.rx.text)
            .disposed(by: bag)
        
        blueSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: blueComponentLabel.rx.text)
            .disposed(by: bag)
    }
}

// Traits는 UI에 특화된 Observable. 모든 작업은 메인 쓰레드에서 실행. 그래서 UI 업데이트 코드를 작성할 때 스케줄러를 직접 지정할 필요 없음
// Observable이기 때문에 UI Binding에서 데이터 생성자 역할을 함.
// RxCocoa가 제공하는 Traits : ControlProperty, ControlEvent, Driver, Signal
// Observable 시퀀스가 에러 이벤트로 종료되면 UI는 더이상 업데이트 되지 않지만 Traits는 에러 이벤트를 전달하지 않기 때문에 UI가 항상 올바른 쓰레드에서 업데이트 되는걸 보장함
// Observable을 구독하면 새로운 시퀀스가 시작됨. Traits도 Observable이지만 새로운 시퀀스가 시작되지 않음.
// Traits를 구독하는 모든 구독자는 동일한 시퀀스를 공유. 일반 Observable에서 share 연산자를 사용한 것과 동일한 방식으로 동작.



// CocoaFramework가 제공하는 뷰에는 다양한 속성이 선언되어 있음. RxCocoa는 Extension으로 뷰를 확장하고 동일한 이름을 가진 속성을 추가. 이런 속성들은 대부분 ControlProperty 형식으로 저장되어 있음. ControlProperty는 제네릭 구조체로 선언되어 있고 ControlPropertyType 프로토콜을 채용. ControlPropertyType 프로토콜은 ObservableType과 ObserverType 프로토콜을 상속. ControlProperty는 특별한 Observable이면서 동시에 특별한 Observer. ControlProperty가 읽기전용 속성을 확장했다면 Observable 역할만 수행하고 읽기쓰기가 모두 가능하다면 Observer의 역할도 함께 수행
// ControlProperty는 UI Binding에 사용되므로 에러 이벤트를 전달받지도 전달하지도 않음. completed 이벤트는 control이 제공되기 직전에 전달. 그리고 모든 이벤트는 메인 스케줄러에서 전달. ControlProperty는 시퀀스를 공유. 일반 Observable에서 share 연산자를 호출하고 replay 파라미터에서 1을 전달한 것과 동일한 방식으로 동작. 그래서 새로운 구독자가 추가되면 가장 최근에 저장된 속성 값이 바로 전달.

// UIControl을 상속한 Control들은 다양한 이벤트를 전달. RxCocoa가 확장한 Extension에는 이벤트를 Observable로 랩핑한 속성이 추가되어 있음. ControlEvent는 ControlEventType 프로토콜을 채용한 제네릭 구조체. ControlEventType 프로토콜은 ObservableType 프로토콜을 상속. Control Property와 달리 Observable 역할은 수행하지만 Observer 역할은 수행하지 못함.
// ControlEvent는 에러 이벤트를 전달하지 않고 completed 이벤트를 Control이 해지되기 직전에 전달하고 메인 스케줄러에서 이벤트를 전달.
// 가장 최근 이벤트를 replay하지 않음. 그래서 새로운 구독자는 구독 이후에 전달된 이벤트만 전달받음. 
