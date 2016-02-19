
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
    @IBOutlet weak var coorY: NSTextField!
    @IBOutlet weak var coorX: NSTextField!
    @IBOutlet weak var direcSelect: NSPopUpButton!
    @IBOutlet weak var beeperConfig: NSTextField!
    @IBOutlet weak var blockConfig: NSTextField!
    @IBOutlet weak var configBox: NSBox!
    @IBOutlet weak var configTab: NSTabView!
    @IBOutlet weak var codeButton: NSButton!
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var duang: NSTextField!
    @IBOutlet weak var map: NSView!
    @IBOutlet weak var noBeeper: NSTextField!
    @IBOutlet weak var stop:NSButton!
   
 
    @IBOutlet weak var reset: NSButton!
    @IBOutlet weak var run: NSButton!
    
//    ——————————————————
    
    
 
    @IBAction func reset(sender: AnyObject) {
        resetWorld()  //重置 Karel 的世界
        karel.beeperNumClean()  //清理 Beeper 的堆叠数量
        karel.initBlockAndBeeper()  //初始化设定好的世界
        
        
        error.setError(nil)
        backgroundQueue.suspended = true
        observerQueue.suspended = true
        backgroundQueue.waitUntilAllOperationsAreFinished()
        observerQueue.waitUntilAllOperationsAreFinished()
        karel.initKarel() //重新初始化 Karel ，放到开始的位置当中去。
        
        run.enabled = true
        isPaused = false
        duang.hidden = true
        stop.title = "暂停"
        reset.enabled = false
        slider.enabled = true
        stop.enabled = false
        codeButton.enabled = true
        
    }
    
    
    
    @IBAction func run(sender: NSButton) {
        backgroundQueue.suspended = false
        observerQueue.suspended = false
        gogogo()
       
        reset.enabled = true
        stop.enabled = true
        slider.enabled = false
        run.enabled = false
        codeButton.enabled = false
    }
    
 
    @IBAction func stop(sender: NSButton) {
        
        if !isPaused {     //如果没有暂停则暂停计时器
            stop.title = "继续"
            isPaused = true
            slider.enabled = true
            
        } else {        //如果暂停了计时器那么就恢复之
            stop.title = "暂停"
            isPaused = false
            slider.enabled = false
            
        }
    }
    
    
    
    @IBAction func speedController(sender: NSSlider) {
//        取出滑动条的值
        let a = sender.doubleValue
        slowTime = a
    }
    
    /**
     切换代码配置界面按钮，用来显示代码编辑和世界配置
     */
    @IBAction func coding(sender: NSButton) {
        let config = Config.getConfig()
        
        if configBox.hidden {//如果界面是隐藏的就打开
            let configData = config.getConfigData()[0]
            configBox.hidden = false
            reset.enabled = false
            sender.title = "完成"
            run.enabled = false
            configTab.selectTabViewItem(configTab.tabViewItemAtIndex(0))
            
            
            let blockSetContent = configData.blockSet
            let beeperSetContent = configData.beeperSet
            blockConfig.stringValue = blockSetContent!
            beeperConfig.stringValue = beeperSetContent!
            
            let coo = configData.pointCoordinate
            coorX.stringValue = String(Int(Double(coo.x)))
            coorY.stringValue = String(Int(Double(coo.y)))
            
            direcSelect.selectItem(direcSelect.itemWithTitle(configData.chDirection))

            
        } else {//如果界面是打开的就隐藏
            
            let blockSetContent = blockConfig.stringValue
            let beeperSetContent = beeperConfig.stringValue
            let direc = direcSelect.selectedCell()?.title
            let coor = "\(coorX.stringValue),\(coorY.stringValue)"
            config.updateConfigData(direction: direc!, coordinate:coor, blockSet: blockSetContent, beeperSet: beeperSetContent)
            
            config.readConfig()//重新读取配置
            
//            reset(self)//自动点击一下重置按钮
            reset.enabled = true
            configBox.hidden = true
            sender.title = "写代码"
//            run.enabled = true
  
        }
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

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    /**
     起了这么个傲娇的名字是因为我懒得起名了😁
     */
    func gogogo() {
        backgroundQueue.addOperationWithBlock {
            karel.run()
        }
        observerQueue.addOperationWithBlock {
            while (true){
                if observerQueue.suspended {
                    return
                }
                if let e = error.getError() {
                    switch e {
                    case Error.noBeeper:
                        self.noBeeperH()
                    case Error.duang:
                        self.duangH()
                    
                    }
                    break
                }
                
            }
        }
    }
    func duangH() {
        mainQueue.addOperationWithBlock(){
            self.duang.hidden = false
            self.run.enabled = false
            self.stop.enabled = false
        }
    }
    func noBeeperH() {
        mainQueue.addOperationWithBlock(){
            self.noBeeper.hidden = false
            self.run.enabled = false
            self.stop.enabled = false
        }
    }

    /**
     初始化世界元素
     */
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
    
    
    /**
    上帝啊~~让一切重新来过吧！
    */
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

