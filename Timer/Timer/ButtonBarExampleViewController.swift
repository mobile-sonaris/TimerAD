//  ButtonBarExampleViewController.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2016 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import XLPagerTabStrip
import UIKit

class ButtonBarExampleViewController: ButtonBarPagerTabStripViewController {
    
    var isReload = false
    let currentColor = UIColor(red: 68/255.0, green: 177/255.0, blue: 220/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
//        settings.style.buttonBarItemTitleColor = UIColor.blackColor()
//        buttonBarView.selectedBar.backgroundColor = UIColor.init(red: 68/255, green: 177/255, blue: 220/255, alpha: 1.0)
        
        buttonBarView.selectedBar.backgroundColor = self.currentColor
        settings.style.buttonBarBackgroundColor = .whiteColor()
        settings.style.buttonBarItemBackgroundColor = .whiteColor()
        settings.style.selectedBarBackgroundColor = currentColor
        settings.style.buttonBarItemFont = .boldSystemFontOfSize(14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .blackColor()
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .blackColor()
            newCell?.label.textColor = self?.currentColor
        }
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = RestaurantViewController(itemInfo: "Restaurants")
        let child_2 = ShoppingViewController(itemInfo: "Shopping")
        let child_3 = FashionViewController(itemInfo: "Fashion")
        let child_4 = SpaViewController(itemInfo: "Spa & Beauty")
        let child_5 = FavouritesViewController(itemInfo: "My Favourites")
        let child_6 = ChildExampleViewController(itemInfo: "All")
        
        guard isReload else {
            return [child_1, child_2, child_3, child_4, child_5, child_6]
        }
        
        var childViewControllers = [child_1, child_2, child_3, child_4, child_6]
        
        for (index, _) in childViewControllers.enumerate(){
            
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index{
                swap(&childViewControllers[index], &childViewControllers[n])
            }
        }
        let nItems = 1 + (rand() % 6)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if rand() % 2 == 0 {
            pagerBehaviour = .Progressive(skipIntermediateViewControllers: rand() % 2 == 0 , elasticIndicatorLimit: rand() % 2 == 0 )
        }
        else {
            pagerBehaviour = .Common(skipIntermediateViewControllers: rand() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
}
