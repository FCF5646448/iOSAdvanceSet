//
//  ScrollViewPager.swift
//  SwiftUIiOS13Demo
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

enum DirectionX {
    case horizontal
    case vertical
}

struct ScrollViewPager<Content: View>: UIViewControllerRepresentable {
    var content: () -> Content
    private var axis: DirectionX
    private var numberOfPages = 0
    private var pagingEnabled: Bool = true
    private var pageControlHide: Bool = true
    private var hideScrollIndicators: Bool = true
    private var currentPageIndicatorTintColor: UIColor = .white // TODO: fcf 后续缓存Color
    private var pageIndicatorTintColor: UIColor = .gray
    private var switchPageCompletion: ((_ pageNum: Int) -> Void)? = nil
    @Binding private var selectedPageNum: Int // 当前选中的页面
    
    init(axis: DirectionX, 
         numberOfPages: Int,
         pagingEnabled: Bool = true,
         pageControlHide: Bool = true,
         hideScrollIndicators: Bool = true,
         selectedPageNum: Binding<Int> = .constant(0),
         currentPageIndicatorTintColor: UIColor = .white,
         pageIndicatorTintColor: UIColor = .gray,
         @ViewBuilder content: @escaping () -> Content,
         switchPageCompletion: ((_ pageNum: Int) -> Void)? = nil) {
        self.axis = axis
        self.content = content
        self.numberOfPages = numberOfPages
        self.pagingEnabled = pagingEnabled
        self.pageControlHide = pageControlHide
        self.hideScrollIndicators = hideScrollIndicators
        self._selectedPageNum = selectedPageNum
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.switchPageCompletion = switchPageCompletion
    }

    func makeUIViewController(context: Context) -> UIScrollViewController<Content> {
        let vc = UIScrollViewController(rootView: self.content())
        vc.axis = axis
        vc.numberOfPages = numberOfPages
        vc.pagingEnabled = pagingEnabled
        vc.pageControlHide = pageControlHide
        vc.hideScrollIndicators = hideScrollIndicators
        vc.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        vc.pageIndicatorTintColor = pageIndicatorTintColor
        vc.selectedPageIndex = selectedPageNum
        vc.switchPageCompletion = { selectedPageIndex in
            self.selectedPageNum = selectedPageIndex
        }
        return vc
    }

    func updateUIViewController(_ viewController: UIScrollViewController<Content>, context: Context) {
        viewController.hostingController.rootView = self.content()
        debugPrint("selectedPageNum: \(selectedPageNum)")
        viewController.setSelectedPage(selectedPageNum)
    }
}

class UIScrollViewController<Content: View>: UIViewController, UIScrollViewDelegate {
    var axis: DirectionX = .horizontal
    var numberOfPages: Int = 0
    var pagingEnabled: Bool = false
    var pageControlHide: Bool = false
    var hideScrollIndicators: Bool = false
    var currentPageIndicatorTintColor: UIColor = .white
    var pageIndicatorTintColor: UIColor = .gray
    var selectedPageIndex: Int = 0
    var switchPageCompletion: ((_ currPageIndex: Int) -> Void)?

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = pagingEnabled
        view.showsVerticalScrollIndicator = !hideScrollIndicators
        view.showsHorizontalScrollIndicator = !hideScrollIndicators
        return view
    }()

    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = selectedPageIndex
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isHidden = pageControlHide
        return pageControl
    }()

    init(rootView: Content) {
        self.hostingController = UIHostingController<Content>(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var hostingController: UIHostingController<Content>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        self.makefullScreen(of: self.scrollView, to: self.view)

        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.makefullScreen(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)

        view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultSelectedPage()
    }

    func makefullScreen(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndexHorizontal = round(scrollView.contentOffset.x / self.view.frame.size.width)
        let currentIndexVertical = round(scrollView.contentOffset.y / self.view.frame.size.height)

        switch axis {
        case .horizontal:
            self.pageControl.currentPage = Int(currentIndexHorizontal)
            break
        case .vertical:
            self.pageControl.currentPage = Int(currentIndexVertical)
            break
        }
        self.selectedPageIndex = self.pageControl.currentPage
        self.switchPageCompletion?(self.selectedPageIndex)
    }
    
    func setSelectedPage(_ index: Int) {
        scrollToPage(index)
    }
    
    private func setDefaultSelectedPage() {
        scrollToPage(selectedPageIndex, animated: false)
    }
    
    private func scrollToPage(_ index: Int, animated: Bool = true) {
        let contentOffset: CGPoint
        switch axis {
        case .horizontal:
            let x = scrollView.frame.size.width * CGFloat(index)
            contentOffset = CGPoint(x: x, y: scrollView.contentOffset.y)
        case .vertical:
            let y = scrollView.frame.size.height * CGFloat(index)
            contentOffset = CGPoint(x: scrollView.contentOffset.x, y: y)
        }
        debugPrint("scrollToPage: index:\(index); self.frame: \(self.view.frame); self.scrollView.frame: \(scrollView.frame); contentOffset: \(contentOffset)")
        scrollView.setContentOffset(contentOffset, animated: animated)
    }
}
