//
//  TimelaneTestAppTests.swift
//  TimelaneTestAppTests
//
//  Created by Marin Todorov on 2/7/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import XCTest
import Combine
import TimelaneCombine
import os

@testable import TimelaneTestApp

class TimelaneTestAppTests: XCTestCase {
    var subscription: AnyCancellable?
    
    /// Right-click on run test button on the left hand side and choose:
    /// Profile "testSubscription()". This unfortunately fails and is tracked
    /// here: http://timelane.tools/faq.html#Timelane_to_profile_tests
    func testSubscription() {
        let subscriptionCompleted = expectation(description: "Subscription completed")
        enum MyError: Error { case test }
        
        os_log(.error, "TEST LOG")
        
        subscription = Publishers.Worker(duration: 3.0, error: MyError.test)
            .lane("Unit test subscription", filter: [.subscription])
            .sink(receiveCompletion: { _ in
                subscriptionCompleted.fulfill()
            }) { value in
                NSLog("output: \(value)")
            }
        
        wait(for: [subscriptionCompleted], timeout: 10.0)

        subscription = nil
    }
}
