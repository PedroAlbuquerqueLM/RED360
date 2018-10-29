//
//  CardsScrollView.swift
//  Motivi
//
//  Created by Pedro Albuquerque on 17/10/18.
//  Copyright © 2018 Argo Soluções. All rights reserved.
//

import UIKit
import SnapKit

protocol CardsScrollViewDelegate: class {
    func changedPage(currentPage: Int)
}

enum CardsScrollMovementType: Int {
    case leftAndRight=0, left, right, none
}

enum CardsType {
    case horizontal, combinated
}

class CardsScrollView: UIView {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var movementType: CardsScrollMovementType!
    var delegate: CardsScrollViewDelegate!
    
    init(frame: CGRect, qntViews: Int, movementType: CardsScrollMovementType) {
        super.init(frame: frame)
        
        self.movementType = movementType
        
        self.scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:frame.width, height:frame.height))
        self.scrollView.isPagingEnabled = true
        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0..<qntViews {
            let view = UIView(frame: CGRect(x: 0, y: (Int(frame.height)*i), width: Int(frame.width), height: Int(frame.height)))
            view.setNeedsLayout()
            view.layoutIfNeeded()
            view.backgroundColor = UIColor.white
            view.clipsToBounds = true
            view.layer.cornerRadius = 0
            self.scrollView.addSubview(view)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:self.scrollView.frame.height * CGFloat(scrollView.subviews.count))
        self.scrollView.delegate = self
        
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.height - 35, width: frame.width, height: 35))
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = scrollView.subviews.count
        self.pageControl.isHidden = true
        
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    func insertObjectOn(view: Int, object: UIView){
        object.frame = CGRect(x: 0, y: 0, width: Int(self.frame.width), height: Int(self.frame.height))
        scrollView.subviews[view].addSubview(object)
    }
    
    func insertI(type: CardsType, array: [NotaPilarModel]) {
        
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.frame.width), height: Int(self.frame.height)))
        let view = ChartsLandscapeView(frame: CGRect(x: 0, y: 0, width: Int(self.frame.height), height: Int(self.frame.width)))
        view.notaPilar = array
        
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
//        
//        view.snp.makeConstraints({ (make) in
//            make.center.equalTo(CGPoint(x: self.frame.width, y: 0))
//        })
        self.insertObjectOn(view: 0, object: aView)
        
    }
    
    func moveToPrevPage(){
        
        let pageWidth:CGFloat = self.scrollView.frame.height
        let contentOffset:CGFloat = self.scrollView.contentOffset.y
        
        var slideToX = contentOffset - pageWidth
        
        if  contentOffset - pageWidth == pageWidth {
            slideToX = 0
        }
        
        self.pageControl.currentPage -= 1
        self.scrollView.scrollRectToVisible(CGRect(x:0, y:slideToX, width:self.scrollView.frame.width, height:pageWidth), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate.changedPage(currentPage: self.pageControl.currentPage)
        }
    }
    
    func moveToNextPage(){
        
        let pageWidth:CGFloat = self.scrollView.frame.height
        let maxWidth:CGFloat = pageWidth * CGFloat(scrollView.subviews.count)
        let contentOffset:CGFloat = self.scrollView.contentOffset.y
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = maxWidth
            
        }
        
        self.pageControl.currentPage += 1
        self.scrollView.scrollRectToVisible(CGRect(x:0, y:slideToX, width:self.scrollView.frame.width, height:pageWidth), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate.changedPage(currentPage: self.pageControl.currentPage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardsScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageOffset = scrollView.frame.height * CGFloat(pageControl.currentPage)
        switch movementType! {
        case .left:
            if (scrollView.contentOffset.x > pageOffset) {
                scrollView.setContentOffset(CGPoint(x: pageOffset, y: 0), animated: false)
            }
        case .right:
            if (scrollView.contentOffset.x < pageOffset) {
                scrollView.setContentOffset(CGPoint(x: pageOffset, y: 0), animated: false)
            }
        case .leftAndRight:
            return
        default:
            if (scrollView.contentOffset.y < pageOffset) || (scrollView.contentOffset.y > pageOffset) {
                scrollView.setContentOffset(CGPoint(x: 0, y: pageOffset), animated: false)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.height
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        
        delegate.changedPage(currentPage: Int(currentPage))
    }
}

extension UIImage {
    func rotate(angle:CGFloat = .pi/2, flipVertical:CGFloat = 0, flipHorizontal:CGFloat = 0) -> UIImage? {
        let ciImage = CIImage(image: self)
        
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setDefaults()
        
        let newAngle = angle * CGFloat(-1)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipVertical) * M_PI), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipHorizontal) * M_PI), 1, 0, 0)
        
        let affineTransform = CATransform3DGetAffineTransform(transform)
        
        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")
        
        let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        
        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
        
        let result = UIImage(cgImage: cgImage!)
        return result
    }
}
