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
class RxCocoaCollectionViewViewController: UIViewController {
    
    let bag = DisposeBag()

     @IBOutlet weak var listCollectionView: UICollectionView!

     let colorObservable = Observable.of(MaterialBlue.allColors)// Binding할 Observable 생성
     // RxCocoa에서는 데이터소스와 델리게이트를 직접 연결x


     override func viewDidLoad() {
         super.viewDidLoad()

         colorObservable.bind(to: listCollectionView.rx.items(cellIdentifier: "colorCell", cellType: ColorCollectionViewCell.self)) { index, color, cell in

             cell.backgroundColor = color
             cell.hexLabel.text = color.rgbHexString
         }
         .disposed(by: bag)

         // 선택 이벤트를 처리할때 indexPath가 필요하면 itemSelected 속성을 사용하고 model data가 필요하면 modelSelected 속성을 사용.
         // 셀을 선택하면 컬러값을 출력하는 것이 목적이기 때문에 modelSelected 속성 사용
         listCollectionView.rx.modelSelected(UIColor.self)
             .subscribe(onNext: {color in
                 print(color.rgbHexString)
             })
             .disposed(by: bag)

         listCollectionView.rx.setDelegate(self)
             .disposed(by: bag)
     }
 }


extension RxCocoaCollectionViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
        return CGSize(width: value, height: value)
    }
}
