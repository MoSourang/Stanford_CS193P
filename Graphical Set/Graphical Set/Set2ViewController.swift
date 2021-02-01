//
//  Set2ViewController.swift
//  Graphical Set
//
//  Created by Mouhamed Sourang on 1/30/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    
    lazy var ViewBound  = self.view.bounds
    var backgroundView = UIView()
    var drawView = UIView()
    var set = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainingViews()
        configureButtonsAndLables()
        set.setUpGame()
        SetUpView()
        
    }
    
    func configureContainingViews() {
        view.backgroundColor = .orange
        backgroundView = UIView(frame: self.view.frame.insetBy(dx: firstViewInsetX, dy: firstViewInsetY))
        backgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        drawView = UIView(frame: self.view.frame.insetBy(dx: SecondViewInsetX, dy: SecondViewInsetY))
        drawView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        self.view.addSubview(backgroundView)
        self.view.addSubview(drawView)
    }
    
    override func viewWillLayoutSubviews() {
        view.subviews.forEach({$0.removeFromSuperview()})
        configureContainingViews()
        configureButtonsAndLables()
        SetUpView()
    }
    
    func configureButtonsAndLables() {
        let scorelabel = UILabel()
        scorelabel.text = "Score \(1)"
        scorelabel.frame.origin = backgroundView.frame.origin
        scorelabel.frame.size = CGSize.zero
        scorelabel.sizeToFit()
        self.view.addSubview(scorelabel)
        
        let firstbutton = UIButton()
        firstbutton.setTitle("Deal Card", for: .normal)
        firstbutton.layer.cornerRadius = 6.0
        firstbutton.frame.origin = CGPoint(x: drawView.frame.minX, y: drawView.frame.maxY)
        firstbutton.frame.size = CGSize.zero
        firstbutton.sizeToFit()
        firstbutton.backgroundColor = .gray
        self.view.addSubview(firstbutton)
        
        let Secondbutton = UIButton()
        Secondbutton.setTitle("New Game", for: .normal)
        Secondbutton.layer.cornerRadius = 6.0
        Secondbutton.frame.origin = CGPoint(x: drawView.frame.maxX - (firstbutton.frame.width + 10.0), y: drawView.frame.maxY)
        Secondbutton.frame.size = CGSize.zero
        Secondbutton.sizeToFit()
        Secondbutton.backgroundColor = .gray
        self.view.addSubview(Secondbutton)
    }
    
    private func SetUpView() {
        var grid = Grid(layout: .aspectRatio(CGFloat(0.8)), frame: drawView.frame)
        grid.cellCount = set.cardsInPlay.count
        for card in set.cardsInPlay.indices {
            guard let cardFrame = grid[card]?.insetBy(dx: insetby, dy: insetby) else {return}
            let cardView = CardView(frame: cardFrame)
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 8.0
            cardView.backgroundColor = .white
            cardView.numberOfShape = set.cardsInPlay[card].number
            cardView.typeOfShape = set.cardsInPlay[card].shape
            cardView.fillcolor = set.cardsInPlay[card].color
            cardView.strokeColor = set.cardsInPlay[card].shadding
            self.view.addSubview(cardView)
        }
    }

    
}


extension SetViewController {
    
    struct SizeRatio {
        static let firstViewWidthSizeRatio =  CGFloat(0.03)
        static let firstViewHeightSizeRatio = CGFloat(0.06)
        static let SecondViewWidthSizeRatio = CGFloat(0.06)
        static let SecondViewHeightSizeRatio = CGFloat(0.08)
        static let insetRatio: CGFloat = 0.02
    }
    
    private var firstViewInsetX: CGFloat {
        return ViewBound.width * SizeRatio.firstViewWidthSizeRatio
    }
    
    private var firstViewInsetY: CGFloat {
        return ViewBound.height * SizeRatio.firstViewHeightSizeRatio
    }
    
    private var SecondViewInsetX: CGFloat {
        return ViewBound.width * SizeRatio.SecondViewWidthSizeRatio
    }
    
    private var SecondViewInsetY: CGFloat {
        return ViewBound.height * SizeRatio.SecondViewHeightSizeRatio
    }
    
    private var insetby: CGFloat {
        return drawView.bounds.width * SizeRatio.insetRatio
    }
}


