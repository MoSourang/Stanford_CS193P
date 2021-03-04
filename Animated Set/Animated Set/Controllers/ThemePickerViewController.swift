//
//  ThemePickerViewController.swift
//  Concentration
//
//  Created by Mouhamed Sourang on 2/24/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class ThemePickerViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var themes =   [["Faces": ["😭","😇","🥰","🥳","😂","🤓"]],
                            ["Animals": ["🐱","🦋","🐽","🐔","🐻","🐙"]],
                            ["Sports" : ["🏀","🏈", "🎾","🏐","⚽️","🏓"]]]
    
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let gameVC = secondaryViewController as? ConcentrationViewController , gameVC.theme == nil {
            return true
        }
        return false
    }
    
    private var concentrationDetailViewController: ConcentrationViewController?  {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var seguedWaytoConcentrationViewController: ConcentrationViewController?
    @IBOutlet var ChooseGameButtons: [UIButton]! {
        didSet {
            ChooseGameButtons.forEach {$0.layer.cornerRadius = 6.0 }
        }
    }
    
    // Trigger seguing
    @IBAction func pickGame(_ sender: Any) {
        guard let ChosenThemeIndex = ChooseGameButtons.firstIndex(of: sender as! UIButton) else {return}
        guard let theme = themes[ChosenThemeIndex].values.first else {return}
        
        if let cvc = concentrationDetailViewController {
            cvc.chossenTheme = theme
        } else if seguedWaytoConcentrationViewController != nil {
            seguedWaytoConcentrationViewController?.chossenTheme = theme
            navigationController?.pushViewController(seguedWaytoConcentrationViewController!, animated: true)
        } else {
            performSegue(withIdentifier: "ShowGame", sender: theme)
        }
        
    }
    
    // prepare fo seguing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let theme = sender as? [String] else {return}
        if segue.identifier == "ShowGame" {
            if let gameVC = segue.destination as? ConcentrationViewController {
                gameVC.theme = theme
                seguedWaytoConcentrationViewController = gameVC
            }
        }
    }
    
}
