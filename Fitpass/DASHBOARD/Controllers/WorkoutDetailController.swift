//
//  WorkoutDetailController.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

protocol workoutScheduleDelegate {
    func addNewScheduleToList(scheduleBean: WorkoutSchedulesObject)
}


class WorkoutDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource, workoutScheduleDelegate {
        
        var workoutObj : Workouts?
    var schedulesArray : Array<WorkoutSchedulesObject> = []
        
        @IBOutlet weak var workoutDetailTableView: UITableView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var workStatusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addWorkoutScheduleButton: UIButton!
    
        var keyLabelNameArray : NSArray = ["Created By", "Workout Status", "Description"]
    
    var delegate : workoutDelegate?
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.nameLabel.text = workoutObj?.workout_name
            self.createdByLabel.text = workoutObj?.created_by
            self.workStatusLabel.text = workoutObj?.is_active
            self.descriptionLabel.text = workoutObj?.workout_description
            self.profileImageView.image = UIImage(named: "workout_detail")
            
            if let tempArray = workoutObj?.workout_schedules{
                self.schedulesArray = tempArray
            }
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            
            addWorkoutScheduleButton.addTarget(self, action: #selector(moveToAddSchedule), for: UIControlEvents.touchUpInside)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Workout Detail"
        }
    
        func moveToAddSchedule(){
//            self.performSegue(withIdentifier: "add_schedule", sender: self)
            let workoutScheduleController:WorkoutScheduleController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"workoutaddschedule") as! WorkoutScheduleController
            workoutScheduleController.isFromWorkoutDetail = true
            workoutScheduleController.delegate = self
            workoutScheduleController.selectedWorkoutName = (workoutObj?.workout_name!)!
            let tempDict:NSDictionary = [workoutObj!.workout_name!:workoutObj!.workout_id!]
            workoutScheduleController.workoutIdsDict = NSMutableDictionary.init(dictionary: tempDict)
            self.navigationController?.pushViewController(workoutScheduleController, animated: true)
//            self.present(workoutScheduleController, animated: true) {
//
//            }
            
        }
    
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            tableView.tableFooterView = UIView(frame: .zero)

            if(self.schedulesArray.count > 0){
                addWorkoutScheduleButton.isHidden = true
                return 1
            }
            addWorkoutScheduleButton.isHidden = false
            return 0
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.schedulesArray.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
        
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            let view : UIView = UIView()
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30)
            view.backgroundColor = UIColor.lightGray
            
            let idLabel : UILabel = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
            idLabel.textAlignment = .left
            idLabel.text = " Schedule Id"
            idLabel.font = UIFont.boldSystemFont(ofSize: 14)
            idLabel.textColor = UIColor.black
            view.addSubview(idLabel)

            let daysLabel : UILabel = UILabel(frame: CGRect(x: idLabel.frame.size.width+idLabel.frame.origin.x, y: 0, width: (view.frame.size.width/3)-10, height: view.frame.size.height))
            daysLabel.textAlignment = .center
            daysLabel.text = "Days"
            daysLabel.font = UIFont.boldSystemFont(ofSize: 14)
            daysLabel.textColor = UIColor.black
            view.addSubview(daysLabel)

            let timeLabel : UILabel = UILabel(frame: CGRect(x: daysLabel.frame.size.width+daysLabel.frame.origin.x, y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
            timeLabel.textAlignment = .right
            timeLabel.text = "Time "
            timeLabel.font = UIFont.boldSystemFont(ofSize: 14)
            timeLabel.textColor = UIColor.black
            view.addSubview(timeLabel)

            return view
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : WorkoutDetailCell = tableView.dequeueReusableCell(withIdentifier: "WorkoutDetailCell") as! WorkoutDetailCell
            
            
            let schedulebean = schedulesArray[indexPath.row]
            cell.updateWorkoutDetails(scheduleBean: schedulebean )
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
    
    func addNewScheduleToList(scheduleBean: WorkoutSchedulesObject) {
        self.schedulesArray = NSMutableArray.init(array: [scheduleBean]) as! Array<WorkoutSchedulesObject>
        workoutDetailTableView.reloadData()
        self.delegate?.updateSchdeulesArray(scheduleObj: scheduleBean)
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}
