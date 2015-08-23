
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

var karel = Run()   //生成 Karel 的实例
var beeper = [NSImageView](count: 100, repeatedValue: NSImageView()) //虽然很2，但我用这个 Beeper 数组储存 Beeper ……
var beeperCount = [NSTextField](count: 100, repeatedValue: NSTextField()) //这个是用来显示 Beeper 堆叠数量的 Feild ……
var block = [NSImageView](count: 100, repeatedValue: NSImageView() ) //同样的，用它来储存 Block ……
var karelStat:[Stat] = [] //这个很重要，用来储存 Karel 机器人整个的每一步状态哟
//为了所有的类都能访问到，我用了一堆的全局变量，不要骂我，么么哒。

class ViewController: NSViewController {
    var step = 0 //储存遍历的进度
    var timer:NSTimer! //来一个计时器，用于 Karel 自动运行时的速度
    var slowTime = 0.0 //调整 Karel 速度， 给计时器用
    var pause = false  //储存是否暂停了自动运行
    
    
//    ——————————————一堆按钮杂七杂八
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var duang: NSTextField!
    @IBOutlet weak var map: NSView!
    @IBOutlet weak var stop:NSButton!
    @IBOutlet weak var programEnd: NSTextField!
    @IBOutlet weak var stepButton: NSButton!
    @IBOutlet weak var reset: NSButton!
    @IBOutlet weak var run: NSButton!
    
//    ——————————————————
    
    
    @IBAction func step(sender: AnyObject) {
        reset.enabled = true
        
//        以下算法按照每按一次就手动挡遍历一下 Karel 状态数组
        if step < karelStat.count {
            let stat = karelStat[step]
            do {  try karel.checkStat(stat) } catch {duang.hidden = false}
            ++step
        } else {
            stepButton.enabled = false
            programEnd.hidden = false
        }
        
        
        
        
    }
    @IBAction func reset(sender: AnyObject) {
        resetWorld()  //重置 Karel 的世界
        karel.beeperNumClean()  //清理 Beeper 的堆叠数量
        karel.initKarel() //重新初始化 Karel ，放到开始的位置当中去。
        karel.initBlockAndBeeper()  //初始化设定好的世界
        step = 0    //手动挡回到 0 ，重新开始遍历。
        run.enabled = true
        stepButton.enabled = true
        duang.hidden = true
        programEnd.hidden = true
        pause = false
        stop.title = "暂停"
        stepButton.enabled = true
        reset.enabled = false
        slider.enabled = true
        stop.enabled = false
        guard (timer != nil) else { return } //来个守门员，确保如果没有“运行”的话就不需要释放。
        timer = nil //释放timer实例
        
    }
    
    
    
    @IBAction func run(sender: NSButton) {
        timer = NSTimer.scheduledTimerWithTimeInterval(slowTime, target: self, selector: "gogogo", userInfo: nil, repeats: true)
        timer.fireDate = NSDate.distantPast() as NSDate
//        以上创建了计时器并且启动之
        reset.enabled = true
        stop.enabled = true
        stepButton.enabled = false
        slider.enabled = false
        stepButton.enabled = false
        run.enabled = false
    }
    
    
    
   
    @IBAction func stop(sender: NSButton) {
        
        if !pause {     //如果没有暂停则暂停计时器
            stop.title = "继续"
            stepButton.enabled = true
            timer.fireDate = NSDate.distantFuture() as NSDate
            pause = true
            
        } else {        //如果暂停了计时器那么就恢复之
            stepButton.enabled = false
            stop.title = "暂停"
            timer.fireDate = NSDate.distantPast() as NSDate
            pause = false
        }
        
    }
    
    
    
    @IBAction func speedController(sender: NSSlider) {
//        取出滑动条的值
      let a = sender.doubleValue
        slowTime = a
    }
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        karel.initKarel()     //直接初始化Karel
        genWorld()      //初始化beeper、堆叠以及block位置
        karel.initBlockAndBeeper() //根据设定配置Beeper和block
        map.addSubview(karel)       //把 Karel 塞进世界里
        karel.run()     //先根据你的代码把 Karel 的一系列状态撸出来备用
       
        // Do any additional setup after loading the view.
    }
    
   
    
    override func viewDidAppear() {
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func gogogo() {     //起了这么个傲娇的名字是因为我懒得起名了😁
//        主要还是手动挡遍历，按照计时器间隔调用
        if step < karelStat.count {
            let stat = karelStat[step]
            do {  try karel.checkStat(stat) } catch {duang.hidden = false}
            ++step
        } else {
            timer.invalidate()
            programEnd.hidden = false
            stepButton.enabled = false
            stop.enabled = false
        }
       
    }
    
    
    func genWorld() {       //初始化世界元素
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
//        重新将世界元素恢复如初
        
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

