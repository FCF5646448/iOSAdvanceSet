//
//  TPPageScrollView.swift
//  Chat
//
//  Created by fengcaifan on 2023/11/10.
//  Copyright © 2023 Baidu. All rights reserved.
//

import SwiftUI

enum DirectionX {
    case horizontal
    case vertical
}

struct TPPageScrollViewConfig {
    var axis: DirectionX = .horizontal
    var pagingEnabled: Bool = true
    var hidePageControl: Bool = true
    var hideScrollIndicators: Bool = true
    var currentPageIndicatorTintColor: UIColor = .white
    var pageIndicatorTintColor: UIColor = .gray
}

// 按页滚动视图，iOS14可使用系统组件
struct TPPageScrollView<Content: View>: UIViewControllerRepresentable {
    private let numOfPages: Int
    private var content: () -> Content
    private let config: TPPageScrollViewConfig
    @Binding private var selectedPageNum: Int // 当前选中的页面
    
    init(numOfPages: Int,
         config: TPPageScrollViewConfig = TPPageScrollViewConfig(),
         selectedPageNum: Binding<Int> = .constant(0),
         @ViewBuilder content: @escaping () -> Content) {
        self.numOfPages = numOfPages
        self.config = config
        self._selectedPageNum = selectedPageNum
        self.content = content
    }

    func makeUIViewController(context: Context) -> UIScrollViewController<Content> {
        let vc = UIScrollViewController(rootView: self.content())
        vc.numOfPages = numOfPages
        vc.config = config
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
    var numOfPages: Int = 0
    var config: TPPageScrollViewConfig = TPPageScrollViewConfig()
    var selectedPageIndex: Int = 0
    var switchPageCompletion: ((_ currPageIndex: Int) -> Void)?

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = config.pagingEnabled
        view.showsVerticalScrollIndicator = !config.hideScrollIndicators
        view.showsHorizontalScrollIndicator = !config.hideScrollIndicators
        return view
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numOfPages
        pageControl.currentPage = selectedPageIndex
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = config.pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = config.currentPageIndicatorTintColor
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isHidden = config.hidePageControl
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
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultSelectedPage()
    }
    
    private func setupViews() {
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

    private func makefullScreen(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
                              viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
                              viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
                              viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor)])
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndexHorizontal = round(scrollView.contentOffset.x / self.view.frame.size.width)
        let currentIndexVertical = round(scrollView.contentOffset.y / self.view.frame.size.height)
        switch config.axis {
        case .horizontal:
            self.pageControl.currentPage = Int(currentIndexHorizontal)
        case .vertical:
            self.pageControl.currentPage = Int(currentIndexVertical)
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
        switch config.axis {
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
