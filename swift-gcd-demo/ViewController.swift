//
//  ViewController.swift
//  swift-gcd-demo
//
//  Created by runlin on 2020/10/9.
//  Copyright © 2020 gavin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var ticketSurplusCount:Int = 0
    
    let semaphoreLock = DispatchSemaphore(value: 1)


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //    同步执行 + 并发队列
//        self.syncConcurrent()
            
        //    异步执行 + 并发队列
//        self.asyncConcurrent()
        
        //    同步执行 + 串行队列
//        self.syncSerial()
        
        //    异步执行 + 串行队列
//        self.asyncSerial()
        
        //    同步执行 + 主队列（主线程调用）
//        self.syncMain()
        
        //    同步执行 + 主队列（其他线程调用）
//        Thread.detachNewThreadSelector(#selector(syncMain), toTarget: self, with: nil)
        
        //    异步执行 + 主队列
//        self.asyncMain()
        
        /* GCD 线程间通信 */
//        self.communication()
        
        //    栅栏方法 dispatch_barrier_async
//        self.barrier()
        
        //    延时执行方法 dispatch_after
//        self.after()
        
        /* 队列组 gropu 三种实现方式 */
        //    队列组 dispatch_group_notify
//        self.groupNotify()
        
//        self.groupNotify_wait()
        
//        self.groupNotify_enter()
        
        
        /* 信号量 dispatch_semaphore */
        //    semaphore 线程同步
//        self.semaphoreSync()
        
        
        //    semaphore 线程安全
        //    非线程安全：不使用 semaphore
//        self.initTicketStatusNotSave()
        
        
        //    线程安全：使用 semaphore 加锁
        self.initTicketStatusSave()
        
    }


    /**
        队列优先级
        按照优先级从高到低依次是：
        .userInteractive: 一般用于用户交互，需要快速响应的情况。
        .userInitiated: 一般用户用户交互之后，需要迅速异步操作的情况，比如用户需要读取数据库，需要快速响应，读取数据。
        .default： 系统默认优先级。不要直接使用，否则会出现不必要的错误
        .utility :一般用于进度条，IO，网络请求等情况。系统会根据电池情况，平衡响应频率
        .background: 一般用户用户不需要感知的情况。
        .unspecified： 不建议使用。
     */
    
    
    /**
     * 同步执行 + 并发队列
     * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
     */
    func syncConcurrent() -> Void {
        
        print("currentThread---\(Thread.current)")
        print("syncConcurrent---begin")
        
        let queue = DispatchQueue(label: "com.runlin", qos: .utility, attributes: .concurrent)
        
        queue.sync {
            //追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.sync {
            //追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.sync {
            //追加任务3
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
        }
    
        print("syncConcurrent---end")
    }
    
    
    /**
     * 异步执行 + 并发队列
     * 特点：可以开启多个线程，任务交替（同时）执行。
     */
    func asyncConcurrent() -> Void {
    
        print("currentThread---\(Thread.current)")
        print("asyncConcurrent---begin")
        //创建并发队列
        let queue = DispatchQueue(label: "com.runlin", qos: .utility, attributes: .concurrent)
        queue.async {
         //追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async {
         //追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async {
         //追加任务3
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
        }
        
        print("asyncConcurrent---end")
    }
    
    
    /**
     * 同步执行 + 串行队列
     * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
     */
    func syncSerial() -> Void {
        
        print("currentThread---\(Thread.current)")
        print("syncSerial---begin")
        
        let queue = DispatchQueue(label: "com.runlin", qos: .utility)

        queue.sync {
         //追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.sync {
         //追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.sync {
         //追加任务3
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
        }
        
        print("syncSerial---end")
        
    }
    
    
    /**
     * 异步执行 + 串行队列
     * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
     */
    func asyncSerial() -> Void {
        print("currentThread---\(Thread.current)")
        print("asyncSerial---begin")
        let queue = DispatchQueue(label: "com.runlin", qos: .utility)
        queue.async {
         //追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async {
         //追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async {
         //追加任务3
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
        }
        
        print("asyncSerial---end")
    }
    
    
    /**
     * 同步执行 + 主队列
     * 特点(主线程调用)：互等卡主不执行。
     * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
     */
    @objc func syncMain() -> Void {
        print("currentThread---\(Thread.current)")
        print("syncMain---begin")
        let mainQueue = DispatchQueue.main
        mainQueue.sync {
            // 追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        mainQueue.sync {
            // 追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        mainQueue.sync {
            // 追加任务3
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
        }
        
        print("syncMain---end")
    }
    
    
    
    /**
     * 异步执行 + 主队列
     * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
     */
    func asyncMain() -> Void {
        
        print("currentThread---\(Thread.current)")
        print("asyncMain---begin")
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            // 追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        mainQueue.async {
            // 追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        mainQueue.async {
            // 追加任务3
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
        }
        
        print("asyncMain---end")
    }
    
    
    
    
    /**
     * 线程间通信
     */
    func communication() -> Void {
        
        // 获取全局并发队列
        let queue = DispatchQueue.global()
        // 获取主队列
        let mainQueue = DispatchQueue.main
        queue.async {
            // 异步追加任务
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
            
            // 回到主线程
            mainQueue.async {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
    }
    
    
    
    /**
     * 栅栏方法 dispatch_barrier_async
     */
    func barrier() -> Void {
        //创建并发队列
        let queue = DispatchQueue(label: "com.runlin", qos: .utility, attributes: .concurrent)
        queue.async {
            // 追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async {
            // 追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async(flags: .barrier){
            // 追加任务 barrier
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("barrier------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async {
            // 追加任务3
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async {
            // 追加任务4
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("4------\(Thread.current)")       // 打印当前线程
            }
        }
        
    }

    
    /**
     * 延时执行方法 dispatch_after
     */
    func after() -> Void {
        print("currentThread---\(Thread.current)")
        print("after---begin")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0){
            // 2.0秒后异步追加任务代码到主队列，并开始执行
            print("after---\(Thread.current)")
        }
        
        print("after---end")
        
    }
    
    
    
    /**
     * 队列组 dispatch_group_notify
     */
    func groupNotify() -> Void {
        
        print("currentThread---\(Thread.current)") // 打印当前线程
        print("group---begin")
        
        let group = DispatchGroup()
        
        let queue = DispatchQueue(label: "com.runlin", qos: .utility, attributes: .concurrent)

        queue.async(group: group, qos: .utility){
            // 追加任务1
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("1------\(Thread.current)")       // 打印当前线程
            }
        }
        
        queue.async(group: group, qos: .utility){
            // 追加任务2
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("2------\(Thread.current)")       // 打印当前线程
            }
        }
        
        group.notify(queue: DispatchQueue.main){
            // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
//            任务3会在任务1，2，都执行完之后再执行，如果任务1，2中有一直执行不完，那么任务3是不会执行的。
            for _ in 1...2 {
                Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                print("3------\(Thread.current)")       // 打印当前线程
            }
            
            print("group---end")
        }
        
    }
    
    
    /**
    * 队列组
    */
    func groupNotify_wait() -> Void {
            print("currentThread---\(Thread.current)") // 打印当前线程
            print("group---begin")
            
            let group = DispatchGroup()
            
            let queue = DispatchQueue(label: "com.runlin", qos: .utility, attributes: .concurrent)

            queue.async(group: group){
                // 追加任务1
                for _ in 1...2 {
                    Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                    print("1------\(Thread.current)")       // 打印当前线程
                }
            }
            
            queue.async(group: group){
                // 追加任务2
                for _ in 1...2 {
                    Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
                    print("2------\(Thread.current)")       // 打印当前线程
                }
            }
            
            //切记不要在主线程调用group.wait方法.
           if group.wait(timeout: .now() + 3) == .timedOut {
             print("所有的任务没有在3秒内完成")
           } else {
             print ("所有任务都完成")
           }
            
    }
    
    
    /**
    * 队列组
    */
    func groupNotify_enter() -> Void {
        let group = DispatchGroup()
        
        group.enter()
        // 追加任务1
        for index in 1...2 {
            Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
            print("1------\(Thread.current)")       // 打印当前线程
            if index >= 2 {
                group.leave()
            }
        }
        
        group.enter()
        // 追加任务2
        for index in 1...2 {
            Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
            print("2------\(Thread.current)")       // 打印当前线程
            if index >= 2 {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("所有任务均完成")
        }
    }
    
    
    /**
     * semaphore 线程同步
     */
    func semaphoreSync() -> Void {
        print("currentThread---\(Thread.current)") // 打印当前线程
        print("semaphoreSync---begin")
        
        // 获取全局并发队列
        let queue = DispatchQueue.global()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var number:Int = 0
        
        queue.async {
            Thread.sleep(forTimeInterval: 2)        // 模拟耗时操作
            print("2------\(Thread.current)")       // 打印当前线程
            number = 100
            semaphore.signal()
        }
        
        semaphore.wait()
        print("semaphore---end,number =\(number)")
        
    }

    
    /**
     * 非线程安全：不使用 semaphore
     * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
     */
    func initTicketStatusNotSave() -> Void {
        print("currentThread---\(Thread.current)") // 打印当前线程
        print("semaphore---begin")
        
        self.ticketSurplusCount = 50;
        
        // queue1 代表北京火车票售卖窗口
        let queue1 = DispatchQueue(label: "com.runlin1")
        // queue2 代表上海火车票售卖窗口
        let queue2 = DispatchQueue(label: "com.runlin2")

        queue1.async { [weak self] in
            self?.saleTicketNotSafe()
        }
        
        queue2.async {[weak self] in
            self?.saleTicketNotSafe()
        }
    }
    
    
    /**
     * 售卖火车票(非线程安全)
     */
    func saleTicketNotSafe() -> Void {

        while (true) {
            if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
                self.ticketSurplusCount -= 1
                print("剩余票数：\(self.ticketSurplusCount)***** 窗口：\(Thread.current)")
                Thread.sleep(forTimeInterval: 0.2)        // 模拟耗时操作
            } else {
                //如果已卖完，关闭售票窗口
                print("所有火车票均已售完")
                break;
            }
            
        }
    }
    
    
    /**
     * 线程安全：使用 semaphore 加锁
     * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
     */
    func initTicketStatusSave() -> Void {
        print("currentThread---\(Thread.current)") // 打印当前线程
        print("semaphore---begin")
        
        self.ticketSurplusCount = 50;
        
        // queue1 代表北京火车票售卖窗口
        let queue1 = DispatchQueue(label: "com.runlin1")
        // queue2 代表上海火车票售卖窗口
        let queue2 = DispatchQueue(label: "com.runlin2")
        
        queue1.async { [weak self] in
            self?.saleTicketSafe()
        }
        
        queue2.async {[weak self] in
            self?.saleTicketSafe()
        }
    }

    
    /**
     * 售卖火车票(线程安全)
     */
    func saleTicketSafe() -> Void {
        while (true) {
            // 相当于加锁
            semaphoreLock.wait()
            if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
                self.ticketSurplusCount -= 1
                print("剩余票数：\(self.ticketSurplusCount)***** 窗口：\(Thread.current)")
                Thread.sleep(forTimeInterval: 0.2)
            } else { //如果已卖完，关闭售票窗口
                print("所有火车票均已售完")
                
                // 相当于解锁
                semaphoreLock.signal()
                break;
            }
            
            // 相当于解锁
            semaphoreLock.signal()
        }
    }

    
}

