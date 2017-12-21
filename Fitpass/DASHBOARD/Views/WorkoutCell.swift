//
//  WorkoutCell.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {

    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var workoutCategoryIdLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var ccreateTimeLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    
    func updateWorkoutDetails (workoutBean : Workouts) {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0

        if let name = workoutBean.workout_category_name {
            self.workoutNameLabel.text = name
        }
        
        if let categoryname = workoutBean.workout_name{
            self.categoryName.text = categoryname
        }
        
        if let categoryId = workoutBean.workout_id {
            self.workoutCategoryIdLabel.text = "# "+categoryId
        }
        
        if let createdBy = workoutBean.created_by {
            let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.black]
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.lightGray]
            let valueString = NSMutableAttributedString(string: createdBy, attributes: myAttribute )
            let myString = NSMutableAttributedString(string: "Created By ", attributes: myAttribute1 )
            myString.append(valueString)
            self.createdByLabel.attributedText = myString
        }
        
        if let createdTime = workoutBean.create_time {
            self.ccreateTimeLabel.text = Utility().getDateString(dateStr: createdTime)
        }
    
        if let remarks = workoutBean.workout_description{
            let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)]
            let valueString = NSMutableAttributedString(string: remarks, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0)]
            let myString = NSMutableAttributedString(string: "Remarks : ", attributes: myAttribute1 )
            myString.append(valueString)
            self.remarksLabel.attributedText = myString
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
