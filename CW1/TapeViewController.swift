//
//  TapeViewController.swift
//  
//
//  Created by Mark O'Grady on 07/02/2016.
//
//

import UIKit

class TapeViewController: UIViewController {

    @IBOutlet weak var tapeViewLbl: UITextView!
  
    
    var tapeStr = String()
    
    @IBAction func clearTapeDisplay(sender: UIButton) {
     
        tapeViewLbl.text = "0.0 ⏎"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\ntapeViewLoaded\n", terminator: "")
        tapeViewLbl.text = tapeStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
