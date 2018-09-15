import UIKit
import GameplayKit

class ViewController: UIViewController {

    var hpOfEnemy = 100
    var hpOfHero = 100
    let maxHpOfEnemy = 100
    let maxHpOfHero = 100
    var atackDamage=0
    var onBattle=true
    var win=0
    var enemyLevel=0
    
    @IBOutlet var hpOfEnemyLabel: UILabel!
    @IBOutlet var hpOfHeroLabel: UILabel!
    @IBOutlet var skillFirstEnemy: UILabel!
    @IBOutlet var skillSecondEnemy: UILabel!
    @IBOutlet var skillThirdEnemy: UILabel!
    @IBOutlet var skillFirstHero: UILabel!
    @IBOutlet var skillSecondHero: UILabel!
    @IBOutlet var skillThirdHero: UILabel!
    @IBOutlet var battleMessage: UILabel!
    @IBOutlet var nameOfEnemy: UILabel!
    @IBOutlet var enemyImage: UIImageView!
    @IBOutlet var buttonDice: UIButton!
    @IBOutlet var buttonReset: UIButton!
    @IBOutlet var name: UILabel!
    //aamamam
    //aっっっj
    let zukan:Dictionary=["勇者":1,"魔法使い":2,"スライム":3,"ドラゴン":4,"魔王":5]
    let skillListOfHero=["パンチ","キック","ヒーローアタック"]
    let skillListOfMage=["炎魔法","光魔法","ホーリースピア"]
    let skillListOfEnemy1=["くっつく","飲み込む","溶解液"]
    let skillListOfEnemy2=["爪攻撃","体当たり","炎"]
    let skillListOfEnemy3=["杖攻撃","黒魔法","ブラックホール"]
    let skillDamageList:Dictionary=["パンチ":20,"キック":30,"ヒーローアタック":50,"チョップ":10,"踏みつける":10,"ビーム":20,"炎魔法":10,"光魔法":30,"ホーリースピア":60,"くっつく":10,"飲み込む":20,"溶解液":30,"爪攻撃":20,"体当たり":20,"炎":30,"杖攻撃":10,"黒魔法":30,"ブラックホール":70]

    
    var cReset = 1
    var atacker = 0
    
    var imageView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "HPゲージ.jpg"))
    var HPgaugeWidthOfEnemy:CGFloat = 0.0
    var HPgaugeHeightOfEnemy:CGFloat = 0.0
    var HPgaugeXOfEnemy:CGFloat = 0.0
    var HPgaugeYOfEnemy:CGFloat = 0.0
    var HPgaugeXYOfEnemy:CGRect = CGRect(x:0,y:0,width:0,height:0)
    
    var imageView2:UIImageView = UIImageView(image: #imageLiteral(resourceName: "HPゲージ.jpg"))
    var HPgaugeWidthOfHero:CGFloat = 0.0
    var HPgaugeHeightOfHero:CGFloat = 0.0
    var HPgaugeXOfHero:CGFloat = 0.0
    var HPgaugeYOfHero:CGFloat = 0.0
    var HPgaugeXYOfHero:CGRect = CGRect(x:0,y:0,width:0,height:0)
    var myBoundSize: CGSize = CGSize(width:0,height:0)
 
    @IBAction func changeCharacter(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "キャラクターの変更", message: "キャラクターを変えるとはじめからやり直します", preferredStyle:  UIAlertControllerStyle.alert)

        let HeroAction: UIAlertAction = UIAlertAction(title: "勇者", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.atacker=0
            if self.name.text=="勇者"{
            }else{
                var Hero:hero = hero(name:"勇者")
                self.name.text = Hero.name
                self.skillFirstHero.text = Hero.skill1
                self.skillSecondHero.text = Hero.skill2
                self.skillThirdHero.text = Hero.skill3
                self.reset(level:0)
            }
        })
        let MageAction: UIAlertAction = UIAlertAction(title: "魔法使い", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.atacker=1
            if self.name.text=="魔法使い"{
            }else{
                self.name.text="魔法使い"
                self.skillFirstHero.text=self.skillListOfMage[0]
                self.skillSecondHero.text=self.skillListOfMage[1]
                self.skillThirdHero.text=self.skillListOfMage[2]
                self.reset(level:0)
            }
        })
        alert.addAction(HeroAction)
        alert.addAction(MageAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = self.initViewLayout
    }
    
    private lazy var initViewLayout : Void = {
        HPgaugeWidthOfEnemy = hpOfEnemyLabel.frame.size.width
        HPgaugeHeightOfEnemy = hpOfEnemyLabel.frame.size.height
        HPgaugeXOfEnemy = hpOfEnemyLabel.frame.origin.x
        HPgaugeYOfEnemy = hpOfEnemyLabel.frame.origin.y
        HPgaugeXYOfEnemy = CGRect(x:Int(HPgaugeXOfEnemy),y:Int(HPgaugeYOfEnemy),width:Int( Float(Float(hpOfEnemy)/Float(maxHpOfEnemy))*Float(myBoundSize.width*0.7)),height:Int(HPgaugeHeightOfEnemy))
        imageView.frame = HPgaugeXYOfEnemy
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
        
        HPgaugeWidthOfHero = hpOfHeroLabel.frame.size.width
        HPgaugeHeightOfHero = hpOfHeroLabel.frame.size.height
        HPgaugeXOfHero = hpOfHeroLabel.frame.origin.x
        HPgaugeYOfHero = hpOfHeroLabel.frame.origin.y
        HPgaugeXYOfHero = CGRect(x:Int(HPgaugeXOfHero),y:Int(HPgaugeYOfHero),width:Int( Float(Float(hpOfHero)/Float(maxHpOfHero))*Float(myBoundSize.width*0.7)),height:Int(HPgaugeHeightOfHero))
        imageView2.frame = HPgaugeXYOfHero
        view.addSubview(imageView2)
        view.sendSubview(toBack: imageView2)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skillFirstHero.text=self.skillListOfHero[0]
        skillSecondHero.text=self.skillListOfHero[1]
        skillThirdHero.text=self.skillListOfHero[2]
        reset(level: 0)
        
        myBoundSize = UIScreen.main.bounds.size
        imageView = UIImageView(image:#imageLiteral(resourceName: "HPゲージ.jpg"))
        imageView2 = UIImageView(image:#imageLiteral(resourceName: "HPゲージ.jpg"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dice(_ sender: Any) {
        buttonReset.isEnabled=false
        buttonDice.isEnabled=false
        atackOfHero()
        checkHp()
        if onBattle==true{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1.0))
            atackOfEnemy()
            checkHp()
        }
        buttonDice.isEnabled=true
        if cReset == 0{
            buttonReset.isEnabled=true
        }
    }

    @IBAction func resetButton(_ sender: Any) {
        reset(level:0)
    }
    
    func reset(level:Int) {
        buttonReset.isEnabled=false
        hpOfEnemy=maxHpOfEnemy
        hpOfHero=maxHpOfHero
        hpOfEnemyLabel.text=String(hpOfEnemy)
        hpOfHeroLabel.text=String(hpOfHero)
        onBattle=false
        switch level {
            case 0:
                enemyImage.image = #imageLiteral(resourceName: "スライム.jpg")
                win=0
                enemyLevel=0
                nameOfEnemy.text="スライム"
                battleMessage.text="スライムと戦闘開始！"
                self.skillFirstEnemy.text=skillListOfEnemy1[0]
                self.skillSecondEnemy.text=skillListOfEnemy1[1]
                self.skillThirdEnemy.text=skillListOfEnemy1[2]
                break
            case 1:
                enemyImage.image = #imageLiteral(resourceName: "ドラゴン.jpg")
                nameOfEnemy.text="ドラゴン"
                battleMessage.text="ドラゴンと戦闘開始！"
                self.skillFirstEnemy.text=skillListOfEnemy2[0]
                self.skillSecondEnemy.text=skillListOfEnemy2[1]
                self.skillThirdEnemy.text=skillListOfEnemy2[2]
                break
            case 2:
                enemyImage.image = #imageLiteral(resourceName: "魔王.jpeg")
                nameOfEnemy.text="魔王"
                battleMessage.text="魔王と戦闘開始！"
                self.skillFirstEnemy.text=skillListOfEnemy3[0]
                self.skillSecondEnemy.text=skillListOfEnemy3[1]
                self.skillThirdEnemy.text=skillListOfEnemy3[2]
                break
            default:
                break
        }

        HPgaugeXYOfEnemy = CGRect(x:Int(HPgaugeXOfEnemy),y:Int(HPgaugeYOfEnemy),width:Int( Float(Float(hpOfEnemy)/Float(maxHpOfEnemy))*Float(myBoundSize.width*0.7)),height:Int(HPgaugeHeightOfEnemy))
        imageView.frame = HPgaugeXYOfEnemy
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)

        HPgaugeXYOfHero = CGRect(x:Int(HPgaugeXOfHero),y:Int(HPgaugeYOfHero),width:Int( Float(Float(hpOfHero)/Float(maxHpOfHero))*Float(myBoundSize.width*0.7)),height:Int(HPgaugeHeightOfHero))
        imageView2.frame = HPgaugeXYOfHero
        view.addSubview(imageView2)
        view.sendSubview(toBack: imageView2)
    }
    
    func atackOfHero(){
        onBattle=true
        let comp:Int = atack(atacker: atacker)
        hpOfEnemyLabel.text = String(hpOfEnemy)
        HPgaugeXYOfEnemy = CGRect(x:Int(HPgaugeXOfEnemy),y:Int(HPgaugeYOfEnemy),width:Int( Float(Float(hpOfEnemy)/Float(maxHpOfEnemy))*Float(myBoundSize.width*0.7)),height:Int(HPgaugeHeightOfEnemy))
        imageView.frame = HPgaugeXYOfEnemy
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)

        var SkillName = ""
        if atacker==0{
            SkillName = skillListOfHero[comp]
        }else if atacker==1{
            SkillName = skillListOfMage[comp]
        }
        let SkillDamage:Int = skillDamageList[SkillName]!
        battleMessage.text = "\(name.text!)は\(SkillName)を使った！\n\(nameOfEnemy.text!)に\(String(SkillDamage))のダメージを与えた。"
    }
    
    func atackOfEnemy(){
        let comp = atack(atacker:2)

        hpOfHeroLabel.text = String(hpOfHero)
        HPgaugeXYOfHero = CGRect(x:Int(HPgaugeXOfHero),y:Int(HPgaugeYOfHero),width:Int( Float(Float(hpOfHero)/Float(maxHpOfHero))*Float(myBoundSize.width*0.7)),height:Int(HPgaugeHeightOfHero))
        imageView2.frame = HPgaugeXYOfHero
        view.addSubview(imageView2)
        view.sendSubview(toBack: imageView2)
        var SkillName = ""
        if enemyLevel==0{
            SkillName = skillListOfEnemy1[comp]
        }else if enemyLevel==1{
            SkillName = skillListOfEnemy2[comp]
        }else if enemyLevel==2{
            SkillName = skillListOfEnemy3[comp]
        }
        let SkillDamage:Int = skillDamageList[SkillName]!
        battleMessage.text = "\(nameOfEnemy.text!)は\(SkillName)を使った！\n\(name.text!)は\(String(SkillDamage))のダメージを受けた。"
    }
    
    func checkHp(){
        cReset=0
        if hpOfHero<=0{
            hpOfHeroLabel.text="0"
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1.0))
            battleMessage.text="\(nameOfEnemy.text!)に敗れました。最初からやり直します。";
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 2.0))
            cReset=1
            reset(level: 0)
        }
        if hpOfEnemy<=0{
            hpOfEnemyLabel.text="0"
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1.0))
            battleMessage.text = "\(nameOfEnemy.text!)を倒しました。";
            enemyImage.image=#imageLiteral(resourceName: "爆発.jpg")
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 2.0))
            win+=1
            goNextStage(winnum: win)
        }
    }
    
    func goNextStage(winnum:Int){
        switch winnum {
        case 1:
            reset(level: 1)
            enemyLevel=1
            break
        case 2:
            reset(level: 2)
            enemyLevel=2
            break
        case 3:
            battleMessage.text="全ての敵を倒しました。\n最初に戻ります。"
            enemyImage.image = #imageLiteral(resourceName: "クリア画面.jpg")
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 4.0))
            reset(level: 0)
            buttonReset.isEnabled = false
            cReset=1
            break
        default:
            break
        }
    }
    
    func atack(atacker:Int)->Int{
        let comp:Int = (Int)(arc4random() % 3)
        if atacker==0{
            atackDamage = skillDamageList[skillListOfHero[comp]]!
            hpOfEnemy -= atackDamage
            if hpOfEnemy<0 {hpOfEnemy=0}
        }else if atacker==1{
            atackDamage = skillDamageList[skillListOfMage[comp]]!
            hpOfEnemy -= atackDamage
            if hpOfEnemy<0 {hpOfEnemy=0}
        }else if atacker==2{
            if enemyLevel==0{
                atackDamage = skillDamageList[skillListOfEnemy1[comp]]!
            }else if enemyLevel==1{
                atackDamage = skillDamageList[skillListOfEnemy2[comp]]!
            }else if enemyLevel==2{
                atackDamage = skillDamageList[skillListOfEnemy3[comp]]!
            }
            hpOfHero -= atackDamage
            if hpOfHero<0 {hpOfHero=0}
        }
        return comp
    }


    class character {
        var name:String!
        var maxHp:Int!
        var currentHp:Int!
        var skill1:String!
        var skill2:String!
        var skill3:String!
        var charaImage:UIImageView!
        init(name:String) {
            self.name = name;
            maxHp = 100
            skill1=""
            skill2=""
            skill3=""
            //let vc = ViewController()
            //vc.hpOfHero=100
            //vc.enemyImage.image = #imageLiteral(resourceName: "勇者.jpg")
        }
    }
    
    class hero:character{
        override init(name:String) {
            super.init(name: name)
            skill1="パンチ"
            skill2="キック"
            skill3="ヒーローアタック"
        }
    }
    
    class mage:character{
        override init(name:String) {
            super.init(name: name)
            skill1="炎魔法"
            skill2="光魔法"
            skill3="ホーリースピア"
        }
    }
    
/*    class hero :character{
        var name:String = ""
        var hp:Int = 0
        init(name:String) {
            self.name = name;
            self.hp = 100;
        }
    }
 */
    class enemy:character{
        
    }
}

