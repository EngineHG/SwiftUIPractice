//
//  PageViewController.swift
//  Landmarks
//
//  Created by huangguojian on 2022/5/16.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]],
            direction: .forward,
            animated: true)
    }
    
    /// 详见https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit#Create-a-View-to-Represent-a-UIPageViewController
    ///  - Declare a nested Coordinator class inside PageViewController.
    ///  -  SwiftUI manages your UIViewControllerRepresentable type’s coordinator, and provides it as part of the context when calling the methods you created above.
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers: [UIViewController]
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }
        
        // UIPageViewControllerDataSource
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
        // UIPageViewControllerDelegate
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}
