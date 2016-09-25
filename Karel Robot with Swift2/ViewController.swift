
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

class ViewController: NSViewController {
    
    var blocked = 0
  
    
    
//    ——————————————一堆按钮杂七杂八
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var duang: NSTextField!
    @IBOutlet weak var map: NSView!
    @IBOutlet weak var noBeeper: NSTextField!
    @IBOutlet weak var stop:NSButton!
   
 
    @IBOutlet weak var reset: NSButton!
    @IBOutlet weak var run: NSButton!
    
//    ——————————————————
    
    
 
    @IBAction func reset(_ sender: AnyObject) {
        resetWorld()  //重置 Karel 的世界
        karel.beeperNumClean()  //清理 Beeper 的堆叠数量
        karel.initBlockAndBeeper()  //初始化设定好的世界
        
        run.isEnabled = true
        isPaused = false
        duang.isHidden = true
        stop.title = "暂停"
        reset.isEnabled = false
        slider.isEnabled = true
        stop.isEnabled = false
        error.setError(nil)
        backgroundQueue.isSuspended = true
        observerQueue.isSuspended = true
        backgroundQueue.waitUntilAllOperationsAreFinished()
        observerQueue.waitUntilAllOperationsAreFinished()
        karel.initKarel() //重新初始化 Karel ，放到开始的位置当中去。
        
    }
    
    
    
    @IBAction func run(_ sender: NSButton) {
        backgroundQueue.isSuspended = false
        observerQueue.isSuspended = false
        gogogo()
        reset.isEnabled = true
        stop.isEnabled = true
        slider.isEnabled = false
        run.isEnabled = false
    }
    
 
    @IBAction func stop(_ sender: NSButton) {
        
        if !isPaused {     //如果没有暂停则暂停计时器
            stop.title = "继续"
            isPaused = true
            slider.isEnabled = true
        } else {        //如果暂停了计时器那么就恢复之
            stop.title = "暂停"
            isPaused = false
            slider.isEnabled = false
        }
    }
    
    
    
    @IBAction func speedController(_ sender: NSSlider) {
//        取出滑动条的值
        let a = sender.doubleValue
        slowTime = a
    }
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        karel.initKarel()     ///直接初始化Karel
        genWorld()      //初始化beeper、堆叠以及block位置
        karel.initBlockAndBeeper() //根据设定配置Beeper和block
        map.addSubview(karel)       //把 Karel 塞进世界里
        // Do any additional setup after loading the view.
    }
    
   
    
    override func viewDidAppear() {
    }

    
    
    /**
     起了这么个傲娇的名字是因为我懒得起名了😁
     */
    func gogogo() {
        backgroundQueue.addOperation { () -> Void in
            karel.run()
        }
        observerQueue.addOperation(){
            while (true){
                if observerQueue.isSuspended {
                    return
                }
                if let e = error.getError() {
                    switch e {
                    case KarelError.noBeeper:
                        self.noBeeperH()
                    case KarelError.duang:
                        self.duangH()
                    default: break
                        
                    }
                    break
                }
                
            }
        }
    }
    func duangH() {
        mainQueue.addOperation(){
            self.duang.isHidden = false
            self.run.isEnabled = false
            self.stop.isEnabled = false
        }
    }
    func noBeeperH() {
        mainQueue.addOperation(){
            self.noBeeper.isHidden = false
            self.run.isEnabled = false
            self.stop.isEnabled = false
        }
    }

    /**
     初始化世界元素
     */
    func genWorld() {
        for i in 0...99 {
            beeper[i] = NSImageView()
            beeper[i].frame = CGRect(x: CGFloat( Int(i / 10) * 60 + 5), y: CGFloat((i % 10) * 50), width:50 , height: 50)
           
            beeper[i].image = NSImage(named: "beeper")
            beeper[i].isHidden = true
            map.addSubview(beeper[i])
            
        }
        
        for i in 0...99 {
            beeperCount[i] = NSTextField()
            beeperCount[i].frame = CGRect(x: CGFloat( Int(i / 10) * 60 + 18), y: CGFloat((i % 10) * 50 + 15), width: 24, height: 20)
            beeperCount[i].stringValue = ""
            beeperCount[i].isHidden = true
            beeperCount[i].isEditable = false
            map.addSubview(beeperCount[i])
            
        }
        
        for i in 0...99 {
            block[i] = NSImageView()
            block[i].frame = CGRect(x: CGFloat( Int(i / 10) * 60 ), y: CGFloat((i % 10) * 50 ), width: 60, height: 50)
            block[i].image = NSImage(named: "block")
            block[i].isHidden = true
            map.addSubview(block[i])
        }
    }
    
    
    /**
    上帝啊~~让一切重新来过吧！
    */
    func resetWorld() {
        
        for i in 0...99 { beeper[i].isHidden = true }
        
        for i in 0...99 {
            beeperCount[i].stringValue = ""
            beeperCount[i].isHidden = true
            
        }
        
        for i in 0...99 {  block[i].isHidden = true }
    }
}

