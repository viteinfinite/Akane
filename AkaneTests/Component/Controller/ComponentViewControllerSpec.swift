//
// This file is part of Akane
//
// Created by JC on 18/05/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Nimble
import Quick
@testable import Akane

class ComponentViewControllerSpec : QuickSpec {
    override func spec() {
        var viewController: ComponentViewControllerMock!

        beforeEach {
            viewController = ComponentViewControllerMock(nibName: nil, bundle: nil)
        }

        describe("set view") {
            beforeEach {
                viewController.view = ViewMock()
            }

            it("sets componentView") {
                expect(viewController.componentView).toNot(beNil())
            }
        }

        describe("makeBindings") {
            beforeEach {
                viewController.view = ViewMock()
                viewController.viewModel = ViewModelMock()
            }

            it("sets observerCollection") {
                expect(viewController.componentView?.observerCollection).toNot(beNil())
            }

            it("sets componentLifecycle") {
                expect(viewController.componentView?.componentLifecycle) === viewController
            }
        }

        describe("set viewModel") {
            beforeEach {

            }

            it("calls didLoadComponent") {
                // To make sure right method is called even if we don't have precie class type
                let unkonwnController = viewController as ComponentController

                unkonwnController.viewModel = ViewModelMock()

                expect(viewController.receivedDidLoadComponent) == true
            }

            it("calls makeBindings") {
                viewController.viewModel = ViewModelMock()

                expect(viewController.countMakeBindings) == 1
            }
        }

        describe("set viewModel multiple times") {
            let setNb: UInt = 3

            beforeEach {
                for _ in 1...setNb {
                    viewController.viewModel = ViewModelMock()
                }
            }

            it("calls makeBindings multiple times") {
                expect(viewController.countMakeBindings) == setNb
            }
        }
    }
}

extension ComponentViewControllerSpec {
    class ComponentViewControllerMock : ComponentViewController {
        var receivedDidLoadComponent: Bool = false
        var countMakeBindings: UInt = 0
        var stubIsViewLoaded: Bool? = nil

        override func didLoadComponent() {
            self.receivedDidLoadComponent = true
        }

        override func isViewLoaded() -> Bool {
            return self.stubIsViewLoaded ?? super.isViewLoaded()
        }

        // FIXME
        // can't overload makeBindings
        override func didSetViewModel() {
            self.countMakeBindings += 1
            super.didSetViewModel()
        }
    }

    class ViewMock : UIView, ComponentView {
        func bindings(observer: ViewObserver, viewModel: AnyObject) {
            
        }
    }

    class ViewModelMock : ComponentViewModel {

    }
}