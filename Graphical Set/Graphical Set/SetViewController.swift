//
//  Set2ViewController.swift
//  Graphical Set
//
//  Created by Mouhamed Sourang on 1/30/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, didTouchCard {
    
    lazy var ViewBound  = self.view.bounds
    private var backgroundView = UIView()
    private var drawView = UIView()
    private var set = Set()
    let newGamebutton = UIButton()
    let dealbutton = UIButton()
    private var cardViews = [CardView]()
    private var selectedCards = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        configureGestureRecognizer()
    }
    
    private func configureGestureRecognizer() {
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
        view.addGestureRecognizer(rotate)
        let tap =  UISwipeGestureRecognizer(target: self, action: #selector(dealMoreCards))
        tap.direction = [.up, .down ,.left , .right]
        view.addGestureRecognizer(tap)
    }
    
    @objc func shuffleCards() {
        set.shuffleCards()
        configureView()
    }
    
    private func configureContainingViews() {
        view.backgroundColor = .orange
        backgroundView = UIView(frame: self.view.frame.insetBy(dx: firstViewInsetX, dy: firstViewInsetY))
        drawView = UIView(frame: self.view.frame.insetBy(dx: SecondViewInsetX, dy: SecondViewInsetY))
        self.view.addSubview(backgroundView)
        self.view.addSubview(drawView)
    }
    
    override func viewWillLayoutSubviews() {
        view.subviews.forEach({$0.removeFromSuperview()})
        configureContainingViews()
        configureButtonsAndLables()
        configureView()
    }
    
    private func configureButtonsAndLables() {
        let scorelabel = UILabel()
        scorelabel.text = "Score \(set.score)"
        scorelabel.frame.origin = backgroundView.frame.origin
        scorelabel.frame.size = CGSize.zero
        scorelabel.sizeToFit()
        self.view.addSubview(scorelabel)
        
        newGamebutton.setTitle("New Game", for: .normal)
        newGamebutton.layer.cornerRadius = 6.0
        newGamebutton.frame.origin = CGPoint(x: drawView.frame.minX, y: drawView.frame.maxY)
        newGamebutton.frame.size = CGSize.zero
        newGamebutton.sizeToFit()
        newGamebutton.backgroundColor = .gray
        self.view.addSubview(newGamebutton)
        newGamebutton.addTarget(self, action: #selector(animateNewGameButton), for: .touchUpInside)
        
        dealbutton.setTitle("Deal Card", for: .normal)
        dealbutton.layer.cornerRadius = 6.0
        dealbutton.frame.origin = CGPoint(x: drawView.frame.maxX - (newGamebutton.frame.width + 10.0), y: drawView.frame.maxY)
        dealbutton.frame.size = CGSize.zero
        dealbutton.sizeToFit()
        dealbutton.backgroundColor = .gray
        self.view.addSubview(dealbutton)
        dealbutton.addTarget(self, action: #selector(animateDealMoreButton), for: .touchUpInside)
    }
    
    @objc private func configureView() {
        var grid = Grid(layout: .aspectRatio(CGFloat(0.8)), frame: drawView.frame)
        grid.cellCount = set.cardsInPlay.count
        if cardViews.count > 0 {cardViews.removeAll()}
        for card in set.cardsInPlay.indices {
            guard let cardFrame = grid[card]?.insetBy(dx: insetby, dy: insetby) else {return}
            let cardView = CardView(frame: cardFrame)
            cardView.card = set.cardsInPlay[card]
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 8.0
            cardView.backgroundColor = .white
            if set.selectedCards.contains(card) {cardView.layer.borderWidth = 3.0 ; cardView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)}
            cardView.numberOfShape = set.cardsInPlay[card].number
            cardView.typeOfShape = set.cardsInPlay[card].shape
            cardView.fillcolor = set.cardsInPlay[card].color
            cardView.strokeColor = set.cardsInPlay[card].shadding
            cardView.buttonIndex = card
            cardView.cardViewDelegate = self
            self.view.addSubview(cardView)
            cardViews.append(cardView)
        }
    }
    
    func cardWasSelected(at cardindex: Int) {
        if set.selectedCards.contains(cardindex) {
            // card was already selected and i need to clear it out 
            guard let index = selectedCards.firstIndex(of: cardindex) else {return}
            selectedCards.remove(at: index)
            set.removeCard(at: cardindex)
            cardViews[cardindex].layer.borderWidth = 0.0
        } else {
            cardViews[cardindex].layer.borderWidth = 4.0
            cardViews[cardindex].layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            selectedCards.append(cardindex)
            set.chooseCard(at: cardindex)
            if selectedCards.count == 3 {
                if !set.ismatched  {
                    for card  in selectedCards {
                        cardViews[card].layer.borderWidth = 4.0
                        cardViews[card].layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(configureView), userInfo: nil, repeats: false)
                    }
                } else if set.ismatched {
                    for card in selectedCards {
                        cardViews[card].layer.borderWidth = 4.0
                        cardViews[card].layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(configureView), userInfo: nil, repeats: false)
                    }
                }
                selectedCards.removeAll()
            }
        }
    }
    
    @objc func animateButton(_ button: UIButton) {
        button.animate()
    }
    
    @objc func animateDealMoreButton() {
        animateButton(dealbutton)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(dealMoreCards), userInfo: dealbutton, repeats: false)
    }
    
    @objc func animateNewGameButton() {
        animateButton(newGamebutton)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startNewGame), userInfo: nil, repeats: false)
    }
    
    @objc func dealMoreCards() {
        set.dealMoreCard()
        configureView()
    }
    
    @objc func startNewGame() {
        configureContainingViews()
        configureButtonsAndLables()
        set.setUpGame()
        configureView()
    }
}

extension SetViewController {
    
    struct SizeRatio {
        static let firstViewWidthSizeRatio =  CGFloat(0.03)
        static let firstViewHeightSizeRatio = CGFloat(0.06)
        static let SecondViewWidthSizeRatio = CGFloat(0.06)
        static let SecondViewHeightSizeRatio = CGFloat(0.08)
        static let insetRatio: CGFloat = 0.01
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


extension UIButton {
    @objc func animate () {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .blue
        }) { (done) in
            if done {
                self.backgroundColor = .gray
            }
        }
    }
}
