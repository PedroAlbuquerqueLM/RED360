//
//  RotineQuestionCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 31/01/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class RotineOptionCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var checkButton: UIButton?
    
    override func awakeFromNib() {
        self.isCheck = false
        self.checkButton?.isUserInteractionEnabled = false
    }
    
    var isCheck: Bool? {
        didSet{
            if isCheck ?? false {
                self.checkButton?.setImage(#imageLiteral(resourceName: "quizCheck"), for: .normal)
            }else{
                self.checkButton?.setImage(#imageLiteral(resourceName: "quizUncheck"), for: .normal)
            }
        }
    }
    
}

class RotineQuestionCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var alternativesTableView: UITableView!
    var superViewController: RotineViewController?
    
    var quizzIndex = -1
    var answer: AnswerModel? {
        didSet{
            guard let answer = answer else {return}
            self.title.text = answer.pergunta
            self.alternativesTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        alternativesTableView.delegate = self
        alternativesTableView.dataSource = self
    }
}

extension RotineQuestionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let resps = self.answer?.respostas else {return 0}
        return resps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RotineOptionCell", for: indexPath) as! RotineOptionCell
        cell.title?.text = self.answer?.respostas?[indexPath.row].resposta
        cell.isCheck = (indexPath.row == self.answer?.respostaIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.answer?.respostaIndex = indexPath.row
        self.answer?.respostaId = self.answer?.respostas?[indexPath.row].id ?? -1
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((self.answer?.respostas?[indexPath.row].resposta ?? "").qntHeight * 20 + 12)
    }
}
