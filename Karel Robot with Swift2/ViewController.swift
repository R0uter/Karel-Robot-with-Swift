//
//  ViewController.swift
//  Karel Robot
//
//  Created by R0uter on 15/6/19.
//  Copyright (c) 2015年 R0uter. All rights reserved.
/*  
    你好，我是 十步奶一人，代码虽然写的不怎么样，但至少真的可以跑起来＝。＝
    如果你要与人分享这个代码，请保留这段文字：）
    ——————————————————————————————————————————
    我的博客是 落格博客|https://www.logcg.com
    十奶课程 的QQ群是 “4008 5151”
    ——————————————————————————————————————————
    用 Swift 2 写这个程序的目的在于帮助你快速理解编程方法
    让你尽快入门编程方法学，了解“编程的思维方式”

    这个软件的使用方法请移步 https://www.logcg.com/archives/1088.html

    Hope enjoy！
*/

import Cocoa

var karel = Run()   //karel的实例
var isStoped = false  //是否停止，此功能尚未实现
//——————————
var backgrooundQueue = NSOperationQueue()
var mainQueue = NSOperationQueue.mainQueue()
//——————————两个线程

var slowTime = 0 //调整Karel速度，此功能尚未实现

var beeper = [NSImageView](count: 100, repeatedValue: NSImageView())  //很2的储存Beeper数组的方法
var beeperCount = [NSTextField](count: 100, repeatedValue: NSTextField()) //这个用来储存Beeper堆叠
var block = [NSImageView](count: 100, repeatedValue: NSImageView() ) //储存block位置
var karelStat:[Stat] = [] //实现了Karel位置状态的静态化，为调整速度做准备
//为了所有的类都能访问到，我用了一堆的全局变量，不要骂我。

class ViewController: NSViewController {
    var step = 0
    
    
    @IBOutlet weak var duang: NSTextField!
    @IBOutlet weak var map: NSView!
    
    @IBOutlet weak var stepButton: NSButton!
    @IBOutlet weak var reset: NSButton!
    @IBOutlet weak var run: NSButton!
    @IBAction func step(sender: AnyObject) {
        run.enabled = false
        reset.enabled = true
        if step < karelStat.count {
            let stat = karelStat[step]
            do {  try karel.checkStat(stat) } catch {duang.hidden = false}
            ++step
        } else {
            stepButton.enabled = false
        }
        
        
        
        
    }
    @IBAction func reset(sender: AnyObject) {
        resetWorld()
        karel.beeperNumClean()
        karel.initKarel()
        karel.initBlockAndBeeper()
        step = 0
        run.enabled = true
        stepButton.enabled = true
        duang.hidden = true
        
    }
    @IBAction func run(sender: NSButton) {
        do {try karel.toEnd()} catch {duang.hidden = false}
        reset.enabled = true
        run.enabled = false
        stepButton.enabled = false
    }
   
    @IBAction func stop(sender: NSButton) {
        //谁能实现这个估计也没什么用的功能?
        
    }
    
    @IBAction func speedController(sender: NSSlider) {  //本来想用来调节速度，最后成了慢速模式开关。
      let a = sender.integerValue
        slowTime = a
    }
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        karel.initKarel()                               //直接初始化Karel
        
        //初始化beeper、堆叠以及block位置
        
       genWorld()
        karel.initBlockAndBeeper() //根据设定配置Beeper和block
        
        map.addSubview(karel)
        karel.run() 
        

        
        
        // Do any additional setup after loading the view.
    }
    
   
    
    
    override func viewDidAppear() {
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func genWorld() {
        for i in 0...99 {
            beeper[i] = NSImageView()
            beeper[i].frame = CGRectMake(CGFloat( Int(i / 10) * 60 + 5), CGFloat((i % 10) * 50), 50, 50)
            beeper[i].image = NSImage(named: "beeper")
            beeper[i].hidden = true
            map.addSubview(beeper[i])
            
        }
        
        for i in 0...99 {
            beeperCount[i] = NSTextField()
            beeperCount[i].frame = CGRectMake(CGFloat( Int(i / 10) * 60 + 18), CGFloat((i % 10) * 50 + 15), 24, 20)
            beeperCount[i].stringValue = ""
            beeperCount[i].hidden = true
            beeperCount[i].editable = false
            map.addSubview(beeperCount[i])
            
        }
        
        for i in 0...99 {
            block[i] = NSImageView()
            block[i].frame = CGRectMake(CGFloat( Int(i / 10) * 60 ), CGFloat((i % 10) * 50 ), 60 , 50)
            block[i].image = NSImage(named: "block")
            block[i].hidden = true
            map.addSubview(block[i])
            
        }
        

    }
    
    func resetWorld() {
        for i in 0...99 {
            beeper[i].hidden = true
            
        }
        
        for i in 0...99 {
            beeperCount[i].stringValue = ""
            beeperCount[i].hidden = true
            
        }
        
        for i in 0...99 {
            block[i].hidden = true
            
        }
        

    }
  
    
}

