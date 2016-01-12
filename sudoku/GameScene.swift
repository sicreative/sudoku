
//
//  GameScene.swift
//  sudoku
//
//  Created by slee on 2015/12/20.
//  Copyright (c) 2015年 slee. All rights reserved.
//

import SpriteKit
import GameKit


class GameScene: SKScene {
    
    

   
    var performance = [String:AnyObject]()
    
    //var numarray:[[Int64]] = []
    
    
    let modelcontroller =  CoreController()

    
   

    override func keyDown(theEvent: NSEvent) {
        // if (!userData["editable"]){
        //  return
        //      }
        
        
        
        
        
        if (userData!["selectedbox"] as! Int == -1){
            return
        }
        

        
        
        let node = children[userData!["selectedbox"] as! Int ] as! SudokuBoxSKNode
        
        
        if (!node.changetext(theEvent)){
        
        interpretKeyEvents([theEvent])
        }
        
        if performance["auto_check"] as! Bool {
        node.checkcorrect()
        }
        
        updatehint()
        
    }
    
    override func moveUp(sender: AnyObject?) {
        
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox == -1){
            return
        }
        
        if (selectedbox  == 9){
            return
        }
        
        var minus:Int = 1
        while (!((children[selectedbox - minus] as! SudokuBoxSKNode).isEditable())){
            minus += 1
            if ((selectedbox - minus) <= 8){
              
                  return
            }
        }
        
        userData!["selectedbox"] = selectedbox - minus
        
        updateselectedbox(selectedbox)
        
        
        
    }
    
    override func moveDown(sender: AnyObject?) {
        
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox == -1){
            return
        }
        
        if (selectedbox == 89){
            return
        }
        
        var add:Int = 1
        while (!((children[selectedbox + add] as! SudokuBoxSKNode).isEditable())){
            add += 1
            if (add+selectedbox >=  90){
                return
            }
        }

        
        
        userData!["selectedbox"] = selectedbox + add
        
        updateselectedbox(selectedbox)
        
    }
    
    override func moveLeft(sender: AnyObject?) {
        
        let selectedbox = userData!["selectedbox"] as! Int
      
        
        //if (selectedbox  < 18){
            //return
        //}
        
        
        var minus:Int = 0
        
       repeat {
            minus += 9
            if (selectedbox - minus < 9){
                minus -= 82 }
        
            if (selectedbox - minus >= 90){
                return
            }

                 //return
            }while !((children[selectedbox - minus] as! SudokuBoxSKNode).isEditable())
        
        
        
        userData!["selectedbox"] = selectedbox - minus
        
        updateselectedbox(selectedbox)
        
    }
    
    override func moveRight(sender: AnyObject?) {
        
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox == -1){
            return
        }
        
       // if (selectedbox >= 81){
       //     return
       // }
        
        var add:Int = 0
        repeat{
            add += 9
           
            
            if (add+selectedbox >= 90){
                add -= 82
            }
            if (add+selectedbox <= 8){
            return
            }
        }while !((children[selectedbox + add] as! SudokuBoxSKNode).isEditable())
        
        userData!["selectedbox"] = selectedbox + add
        
        updateselectedbox(selectedbox)
        
    }
    
    
    
    
    func newsudoku(){
        
        
        
        
        if (userData!["mixedstatemenu"] != nil){
            (userData!["mixedstatemenu"] as! NSMenuItem).state = NSOffState
            
            userData!["mixedstatemenu"] = nil
        }
        
       // let level = 3
        makeanswer()
         var  fillingarray :[[Bool]] = makefilling ();
        var  numarray :[[Int]] = userData!["numarray"] as! Array
        
        for var i=0; i < 9 ; ++i {
            
            for var j=0; j < 9; ++j{
        (children[9+i*9+j] as! SudokuBoxSKNode).setNumValue(numarray[i][j], fillingarray[i][j],false)
            }
        }
        
        self.updatehint()
        
    }
    
    
    
    func changemixedstatenextgame(mixedstatemenu: NSMenuItem){
        userData!["mixedstatemenu"] = mixedstatemenu
    }


    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        

        userData = ["selectedbox":  -1]
        //userData!["allcheckcorrect"] = false
        //userData!["showhint"] = false
     
        
        
      //  userData!["showhint"] = false
       // var numarray: [[Int]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
        
      makeanswer ()
        
        
        
    //  let level = 3 + (performance["selectedgamelevel"] as! Int) * 3
       var  fillingarray :[[Bool]] = makefilling ();
        
        
        
        
        var  numarray :[[Int]] = userData!["numarray"] as! Array
       // numarray = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
        
      //  var  fillingarray :[[Int]] = userData!["fillingarray"] as! Array

        
        databasemodeltable(numarray,fillingarray)
        
        
        let offset :CGFloat = 10
        let groupgap :CGFloat = 15

        let maxX :CGFloat = self.frame.maxX
        let maxY  :CGFloat =  self.frame.maxY
        let minX  :CGFloat =  self.frame.minX
        let minY  :CGFloat = self.frame.minY
        let stepX  :CGFloat =  (maxX-minX-offset*2-groupgap*2)/9
        let stepY  :CGFloat =  (maxY-minY-offset*2*0.75-groupgap*2)/9
        
        
        for var i=0; i < 3 ; ++i {
            
            for var j=0; j < 3; ++j{
   
                
                let gapoffsetx = offset + groupgap * CGFloat (i)
                let gapoffsety = 0.75 * offset + groupgap * CGFloat(j)
                
              //  let rect = CGRectMake(gapoffsetx + (CGFloat (i) * stepX), self.frame.maxY - gapoffsety - ( CGFloat (j) * stepY + stepY), stepX, stepY)
            
            let bigrect = CGRectMake(gapoffsetx + (CGFloat (i*3) * stepX),  self.frame.maxY - gapoffsety - ( CGFloat (j*3) * stepY )-stepY*3, stepX*3, stepY*3)
            let drawpath = CGPathCreateWithRoundedRect(bigrect, offset, offset, nil)
            let bigshapenode = SKShapeNode(path: drawpath)
            bigshapenode.fillColor = SKColor.grayColor()
            self.addChild(bigshapenode)
            
                }
            
        }

        
        
        
        for var i=0; i < 9 ; ++i {
            
            for var j=0; j < 9; ++j{
                
 
        
        
       // let drawpath = CGPathCreateWithRect(drawrect, nil)
        
 
        
        //CGPathDrawingMode.Fill
     
     
        
        
    
      
       
       // CGPathCreateWithRect(<#T##rect: CGRect##CGRect#>, nil)
      //  CGPathMoveToPoint(drawpath,nil,-100,-100);
      //  CGPathAddLineToPoint(drawpath,nil,100,-100);
      //  CGPathAddLineToPoint(drawpath,nil,100,100);
      //  CGPathAddLineToPoint(drawpath,nil,-100,100);
        //CGPathAddLineToPoint(drawpath,nil,-100,-100);
        
       let shapenode = SudokuBoxSKNode()
        
        let gapoffsetx = offset + CGFloat(i / 3) * groupgap
        let gapoffsety = 0.75 * offset + CGFloat(j / 3) * groupgap
                
        let rect = CGRectMake(gapoffsetx + (CGFloat (i) * stepX), self.frame.maxY - gapoffsety - ( CGFloat (j) * stepY + stepY), stepX, stepY)
                
           
         
                
                shapenode.BuildupBox(rect,numarray[i][j],9+i*9+j,fillingarray[i][j])
      //      shapenode.name = "1"
      //      shapenode.path = drawpath;
      //  shapenode.strokeColor = SKColor .redColor()
      //  shapenode.fillColor = SKColor.blackColor()
      //  shapenode.lineWidth = 10
      //  shapenode.lineJoin = CGLineJoin.Round
        
        
       // shapenode.position = CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect))
        
       // let action = SKAction.moveByX(100.0, y: 100.0, duration: 10.0)
       //shapenode.runAction(SKAction.repeatActionForever(action))
       // shapenode.runAction(action)
       
                
                
                
         self.addChild(shapenode)
                
            }
        }
        
       //  shapenode.position = CGPointMake(800,600)
        
        
        
      
            
            
      
            
            if (Runtime.isDebug()){
                print ( "select all input check  @ GameScene" + String (performance["auto_check"]) )
            }
            
            
            
      
        
        
         self.setAllShowhint(performance["auto_hint"] as! Bool)
        self.updatehint()
        
 
        
      
    }
    
    
    func databasemodeltable(numarray : [[Int]],_ filledarray:[[Bool]])->Sudoku_table{
        
        
        
      
        
        
        
       
        
        
        
    
        let sudoku_table : Sudoku_table =  NSEntityDescription.insertNewObjectForEntityForName("Sudoku_table", inManagedObjectContext: self.modelcontroller.managedObjectContext) as! Sudoku_table
        
       
        sudoku_table.table = NSDate()
        
        var pos = 0;
        
        for i in 0...8{
            for j in 0...8{
                let sudoku_card : Sudoku_card =  NSEntityDescription.insertNewObjectForEntityForName("Sudoku_card",    inManagedObjectContext: self.modelcontroller.managedObjectContext) as! Sudoku_card
        
                sudoku_card.num = numarray[i][j] as NSNumber
                sudoku_card.editable = filledarray[i][j] as NSNumber
                sudoku_card.pos = pos++ as NSNumber
    
                sudoku_table.mutableSetValueForKey("card").addObject(sudoku_card)
            }
        }
        
        
        
       // sudoku_table.table = NSDate()
        
       
        
        //sudoku_table.mutableSetValueForKey("card").addObject(sudoku_card)
        
        
        
        

        
  /*
        
        let sudoku_tableFetch = NSFetchRequest(entityName: "Sudoku_table")
        
        do {
            let fetchedSudoku_table = try modelcontroller.managedObjectContext.executeFetchRequest(sudoku_tableFetch) as! [Sudoku_table]
           fetchedSudoku_table.endIndex
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        

       
        
       let sudoku_cardFetch = NSFetchRequest(entityName: "Sudoku_card")
   
      
        do {
            var fetchedSudoku_card = try modelcontroller.managedObjectContext.executeFetchRequest(sudoku_cardFetch) as! [Sudoku_card]
            var sudoku_card = Sudoku_card();
            sudoku_card.card = 1;
            
            
      
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        
        */
        
        
        
        do {
            try self.modelcontroller.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

        
        return sudoku_table
        
    }
    
    
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
  
        
        
    }
    
    func updateselectedbox(previous: Int){
        (children[previous] as! SudokuBoxSKNode).setDeselected()
    (children[userData!["selectedbox"] as! Int] as! SudokuBoxSKNode).setSelected()
        
        
    }
    
    private func makeanswer(){
        var buildtrycount = 0
        var lastcount = 0
        
        var numarray : [[Int]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
        
        var step : Int = 0
        
         repeat {
            start: switch step {
        case (0):
            
        while (!makeanswerfirst (&numarray)){
            if Runtime.isDebug() {buildtrycount++}
           
                }
        ++step
      
        case (1):
        
        
        while (!makeanswersecond(&numarray)){
             if Runtime.isDebug() {buildtrycount++}
            }
        ++step
        
            
            
        case (2):
            out: while (!makeanswerthird(&numarray)){
            if Runtime.isDebug() {
                if Runtime.isDebug() {buildtrycount++}
                ++lastcount
        
                        
                        step = lastcount%4 == 0 ? 0 : 1
                
                if (step == 0){
                        numarray = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
                }else if (step == 1){
                        for var i = 3;i<6;i++ {
                            for var j = 0;j<3;j++ {
                                numarray[i][j] = 0
                            }
                        }
                        for var i = 3;i<6;i++ {
                            for var j = 6;j<9;j++ {
                                numarray[i][j] = 0
                            }
                        }
                    }
        
                        break start
                        
                
                                 }
                }
    
        ++step
            
        default:
            break

            }
            
            
        }while ( step<3 )
        
          userData!["numarray"] = numarray
        
        
        
        
        if (Runtime.isDebug()){print("Try " + String ( buildtrycount ) + " times for build the Sudoku")}
    }

    
    private func makeanswerfirst(inout numarray: [[Int]])->Bool{
        
        
        
       // numarray = userData!["answerarray"] as! [[Int64]]
        
        var seq = [1,2,3,4,5,6,7,8,9]
        var shuffledcenter = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        var next : Int = 0
        for var i=3; i <  6 ; ++i {
            
            for var j=3; j < 6; ++j{
                numarray[j][i] =  shuffledcenter[next++] as! Int
            }
        }
         var shuffled = shuffledcenter
        var shuffleddown = shuffledcenter
        var shuffledmid = shuffledcenter
        shuffled.removeRange(0...2)
        shuffleddown.removeRange(6...8)
        shuffledmid.removeRange(3...5)
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffled)
        shuffleddown = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffleddown)
        shuffledmid = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffledmid)
        
        
         next=0
        numarray[0][3] = shuffled[next++] as! Int
        numarray[1][3] = shuffled[next++] as! Int
        numarray[2][3] = shuffled[next++] as! Int
        numarray[6][5] = shuffleddown[next++] as! Int
        numarray[7][5] = shuffleddown[next++] as! Int
        numarray[8][5] = shuffleddown[next] as! Int
        
        next=0
        for (var i=0;i<3;i++){
        
            var j = 0;
            while (numarray[0][3] == shuffledmid[j] as! Int || numarray[1][3] == shuffledmid[j] as! Int || numarray[2][3] == shuffledmid[j]as! Int ){
              
                if (shuffledmid.count-1 < ++j) {return false}
                }
                  numarray[i][4]=shuffledmid[j] as! Int
                shuffledmid.removeAtIndex(j)
     
            if (shuffledmid.count == 0) {return false}
            
        }
        for (var i=6;i<9;i++){
            
            var j = 0;
            while (numarray[6][5] == shuffledmid[j] as! Int || numarray[7][5] == shuffledmid[j] as! Int || numarray[8][5] == shuffledmid[j]as! Int ){
                
                
                if (shuffledmid.count-1 < ++j) {return false}
                
            }
            numarray[i][4]=shuffledmid[j] as! Int
            shuffledmid.removeAtIndex(j)
          //  if (shuffledmid.count == 0) {return false}
            
        }
        
   
   //      shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        for (var i=0;i<6;i++){
            let index = seq.indexOf(numarray[i][3])
            if (index != nil){
                    seq.removeAtIndex(index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=6;j<9;j++){
                for (var k=4;k<6;k++){
                    if (numarray[j][k]==check) {return false}
                    
                }
            }
         numarray[i+6][3] = check
            
            
        }
        
        
        
        seq = [1,2,3,4,5,6,7,8,9]
        for (var i=3;i<9;i++){
            let index = seq.indexOf(numarray[i][5])
            if (index != nil){
                seq.removeAtIndex(index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
  
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=0;j<3;j++){
                for (var k=3;k<5;k++){
                    if (numarray[j][k]==check) {return false}
                    
                }
            }
            
            numarray[i][5] = shuffled[i] as! Int
            
            
            
        }
        
        
        


        
        
        
      
        return true
    }
    
    
    private func makeanswersecond(inout numarray: [[Int]])->Bool{
        
        var seq = [1,2,3,4,5,6,7,8,9]
        
        let transposedshuffledcenter = [numarray[5][3],numarray[5][4],numarray[5][5],numarray[4][3],numarray[4][4],numarray[4][5],numarray[3][3],numarray[3][4],numarray[3][5]]
        
        var up = transposedshuffledcenter
        var down = transposedshuffledcenter
        var mid = transposedshuffledcenter
        
        
        up.removeRange(6...8)
        down.removeRange(0...2)
        mid.removeRange(3...5)
        
        
        var shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(up)
        var shuffleddown = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(down)
        var shuffledmid = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(mid)
        
        
        var next=0
        numarray[3][0] = shuffled[next++] as! Int
        numarray[3][1] = shuffled[next++] as! Int
        numarray[3][2] = shuffled[next++] as! Int
        numarray[5][6] = shuffleddown[next++] as! Int
        numarray[5][7] = shuffleddown[next++] as! Int
        numarray[5][8] = shuffleddown[next] as! Int
        
        next=0
        for (var i=0;i<3;i++){
            
            var j = 0;
            while (numarray[3][0] == shuffledmid[j] as! Int || numarray[3][1] == shuffledmid[j] as! Int || numarray[3][2] == shuffledmid[j]as! Int ){
                
                if (shuffledmid.count-1 < ++j) {return false}
            }
            numarray[4][i]=shuffledmid[j] as! Int
            shuffledmid.removeAtIndex(j)
            
            if (shuffledmid.count == 0) {return false}
            
        }
        for (var i=6;i<9;i++){
            
            var j = 0;
            while (numarray[5][6] == shuffledmid[j] as! Int || numarray[5][7] == shuffledmid[j] as! Int || numarray[5][8] == shuffledmid[j]as! Int ){
                
                
                if (shuffledmid.count-1 < ++j) {return false}
                
            }
            numarray[4][i]=shuffledmid[j] as! Int
            shuffledmid.removeAtIndex(j)
            //  if (shuffledmid.count == 0) {return false}
            
        }
        
        
        //      shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        for (var i=0;i<6;i++){
            let index = seq.indexOf(numarray[3][i])
            if (index != nil){
                seq.removeAtIndex(index!)
            }
            
            
        }
        
      
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=6;j<9;j++){
                for (var k=4;k<6;k++){
                    if (numarray[k][j]==check) {return false}
                    
                }
            }
            numarray[3][i+6] = check
            
            
        }
        
        
        
        seq = [1,2,3,4,5,6,7,8,9]
        for (var i=3;i<9;i++){
            let index = seq.indexOf(numarray[5][i])
            if (index != nil){
                seq.removeAtIndex(index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=0;j<3;j++){
                for (var k=3;k<5;k++){
                    if (numarray[k][j]==check) {return false}
                    
                }
            }
            
            numarray[5][i] = shuffled[i] as! Int
            
            
            
        }
        
        return true
    }
    
    
   
    

    
    
    private func makeanswerthird(inout numarray: [[Int]])->Bool{
        
        //var checkarray :Set<Int> = [numarray[2][3],numarray[2][4],numarray[2][5],numarray[3][2],numarray[4][2],numarray[5][2]]
        var array = [[2,2],[6,6],[2,6],[6,2],
            [1,2],[1,1],[2,1],
            [7,6],[7,7],[6,7],
            [6,1],[7,1],[7,2],
            [2,7],[1,7],[1,6],
            [2,0],[1,0],[0,0],[0,1],[0,2],
            [6,8],[7,8],[8,8],[8,7],[8,6],
            [8,2],[8,1],[8,0],[7,0],[6,0],
            [0,6],[0,7],[0,8],[1,8],[2,8]]
        
        
        
        
      //  let array = [(2,2),(6,2)]
        
  
       var trydisplaycount = 0
        
        var repeatcount = 0
        
        var max = 0
        var maxcount = 0
        
      
        
    
        
        start: for var i=0;i<array.count; {
            
   
            
            
            if ( !minuswithnum(&numarray, array[i][0],array[i][1])){
                
             
                        ++trydisplaycount
                
                var shuffleseq: [Int] = []
                for i in 1...35 {
                    shuffleseq.append(i)
                }
                

                
                           if (++repeatcount % 5 == 0){
                                        --i
                               if i>max {
                                max = i
                                maxcount = 0
                               
                               }else{
                                ++maxcount
                                i -= maxcount
                            }
                            
                            if (i < 0 || repeatcount % 120 == 0){
                                i = 0
                                
                                //shuffle array
                             
                                
                                let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffleseq)
                                
                                //shuffle 10 set
                                for i in 0...9{
                                    let tmp = array[shuffled[i*2] as! Int]
                                    array[shuffled[i*2] as! Int] = array[shuffled[i*2+1] as! Int]
                                    array[shuffled[i*2+1] as! Int] = tmp
                                }
                               
                                
                                
                            }
                            if (repeatcount >= 600){
                                maxcount = 0
                                
                                //break start
                                        return false
                            }
                        }
                
            }else{
                ++i
                
            }
            
            
        }
        
  
       if (Runtime.isDebug()){
           print ( "Try " + String(trydisplaycount) + " for outer Sudoku")
        }
       
        
        
            
        
            
            return true
        }
    
    
    func minuswithnum(inout numarray: [[Int]],_ x:Int,_ y:Int )->Bool{

        var array: Set<Int> = []
        
        numarray[x][y] = 0
        
        for var i=0;i<9;++i {
            
            if (numarray[i][y] != 0){
                array.insert(numarray[i][y])}
            
            if (numarray[x][i] != 0){
                
             array.insert(numarray[x][i])}
        }
        
        let sectionx:Int = (x / 3) * 3
      
        let sectiony:Int = (y / 3) * 3
       
        for var i = sectionx;i<sectionx+2;++i{
            for var j=sectiony;j<sectiony+2;++j{
            if numarray[i][j] != 0{
                array.insert(numarray[i][j])
                }
           
            
            }
        }
        
        
        var seq = [1,2,3,4,5,6,7,8,9]
        for n in array {
            for var i = 0 ;i < seq.count;++i{
                if (seq[i] == n){
                    seq.removeAtIndex(i)
                }
            }
        }
        
        if (seq.count == 0){
            return false
        }
        
        
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
            numarray[x][y] = shuffled[0] as! Int
            
        
        return true
    }
    
    
    func makefilling() -> [[Bool]]{
        
        
        let level = 3 + (performance["selectedgamelevel"] as! Int) * 3
        
        // var  numarray :[[Int]] = userData!["numarray"] as! Array
        
        // build array for filling information (User input)
        
        
        
         var fillingarray : [[Bool]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:false))
        
        // Dismiss
         var numofdismiss = level + 20
        
        // Add random +/-3 pcs
        
        numofdismiss += rand() % 6 - 3
        
        if (numofdismiss > 70){
            numofdismiss = 70
        }
        
       
      
        //Loop for every 3x3 section and randomly skip one 
        
        var section : Int = 4
        var x = 0
        var y = 0
        
        srandom (UInt32(NSDate().timeIntervalSinceReferenceDate))
        
        for _ in 0...numofdismiss {
            
            var tempsection = 0
            
            
            repeat{
            tempsection = random() % 9
            }while (tempsection == section)
            section = tempsection
            
            
            
            let sx : Int = section / 3 * 3
            let sy : Int = section % 3 * 3
        
            var tempx = 0
            var tempy = 0
            
            repeat{
            
               
                
                tempx = sx + random() % 3
                tempy = sy + random() % 3
     
            
            }while fillingarray[tempx][tempy] || tempx == x || tempy == y
            
            x = tempx
            y = tempy
            
            fillingarray[x][y] = true;
            
            
           
            
        }
        
       return fillingarray
        
    }
    
    
    

    func checkallboxcorrect(){
        
        for i in 9...89 {
            let node = children[i] as! SudokuBoxSKNode
            node.checkcorrect()
        }
    }
    
    
    
    
     func autocheckcorrect(sender: NSMenuItem) {
        
        
        if (sender.state == NSOffState){
            sender.state = NSOnState
              performance["auto_check"] = true
            AppDelegate.writeperformance("auto_check", true)
            
            checkallboxcorrect()
            
            
        }else{
        sender.state = NSOffState
             performance["auto_check"] = false
             AppDelegate.writeperformance("auto_check", false)
        }
        
        if (Runtime.isDebug()){
            print ( "select all input check  @ GameScene" + String (performance["auto_check"]) )
        }
        
        
        
      
    }
    
    func checkcorrectonlyselect(sender: NSMenuItem) {
        if (Runtime.isDebug()){
            print ( "select check only this  @ GameScene")
        }
        
            checkallboxcorrect()
        
        
    }
    
    
    
    
   func showhint(sender: NSMenuItem) {
        if (Runtime.isDebug()){
            print ( "select hint @ GameScene ")
        }
        if (sender.state == NSOffState){
            sender.state = NSOnState
            performance["auto_hint"] = true
            //userData!["showhint"] = true
            self.setAllShowhint(true)
            
        }else{
            sender.state = NSOffState
           performance["auto_hint"] = false

            // userData!["showhint"] = false
              self.setAllShowhint(false)
        }
    
    
     AppDelegate.writeperformance("auto_hint", performance["auto_hint"]!)
    updatehint()
    
    }
    
    func setAllShowhint(isShowhint: Bool){
        
        for i in 9...89 {
            let node = children[i] as! SudokuBoxSKNode
            node.setShowhint(isShowhint)
        }
        
    }
    
    func updatehint(){
        
        for i in 9...89 {
            let node = children[i] as! SudokuBoxSKNode
            node.updatehint()
        }
        
    }
    /*
    func writeperformance(key: String,_ value:CFPropertyList){
     CFPreferencesSetAppValue(key, value,kCFPreferencesCurrentApplication)
      CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
    }*/

}