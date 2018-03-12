//
//  ViewController.swift
//  Timer
//
//  Created by Calvin Chang on 12/03/2018.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit

let TIME_FORMAT = "mm : ss : SS"
let CELL_IDENTIFIER = "recordCellIdentifier"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- Properties
    @IBOutlet fileprivate weak var timeLabel: UILabel!

    @IBOutlet fileprivate weak var recordButton: UIButton!

    @IBOutlet fileprivate weak var actionButton: UIButton!

    @IBOutlet fileprivate weak var recordTableView: UITableView!

    fileprivate var time = Date() {
        didSet {
            self.timeLabel.text = timeFormatter.string(from: time)
        }
    }

    fileprivate lazy var timeFormatter : DateFormatter = {
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = TIME_FORMAT
        return timeFormatter
    }()

    fileprivate var timer : Timer?

    fileprivate var records = Array<String>()

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureViewController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "START", style: .plain, target: self, action: #selector(ViewController.rightBarButtonTouchUp(sender:)))

        recordTableView.dataSource = self
        recordTableView.delegate = self
        recordTableView.register(UINib.init(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)

        recordButton.addTarget(self, action: #selector(ViewController.recordButtonTouchUp(sender:)), for: .touchUpInside)
        recordButton.isEnabled = false

        actionButton.addTarget(self, action: #selector(ViewController.actionButtonTouchUp(sender:)), for: .touchUpInside)
        actionButton.setTitle("Resume", for: .selected)
        actionButton.setTitle("Pause", for: .normal)

        time = Calendar(identifier: .gregorian).startOfDay(for: Date())

        setInitialState()
    }

    func setInitialState() {
        timer?.invalidate()
        timer = nil
        
        // Set start at 00:00:00
        time = Calendar(identifier: .gregorian).startOfDay(for: Date())

        recordButton.isEnabled = false
        actionButton.isSelected = false
        actionButton.isEnabled = false

        records.removeAll()
    }

    //MARK:- Selecors
    @objc func rightBarButtonTouchUp(sender : UIBarButtonItem?) {
        if timer == nil {
            sender?.title = "STOP"

            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.timerActionPerform), userInfo: nil, repeats: true)
            timer?.fire()

            recordButton.isEnabled = true
            actionButton.isEnabled = true
        }
        else {
            sender?.title = "START"

            setInitialState()
            recordTableView.reloadData()
        }
    }

    @objc func recordButtonTouchUp(sender : UIButton?) {
        records.append(timeFormatter.string(from: time))
        recordTableView.insertRows(at: [IndexPath.init(row: records.count - 1, section: 0)], with: .automatic)
    }

    @objc func actionButtonTouchUp(sender : UIButton?) {
        if actionButton.isSelected == false {
            actionButton.isSelected = true
            timer?.invalidate()
            recordButton.isEnabled = false
        }
        else {
            actionButton.isSelected = false
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.timerActionPerform), userInfo: nil, repeats: true)
            timer?.fire()
            recordButton.isEnabled = true
        }
    }

    @objc func timerActionPerform() {
        time.addTimeInterval(0.01);
    }

    // MARK:- Table View Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recordCell = recordTableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as! RecordCell
        recordCell.cellTitle = records[indexPath.row]
        recordCell.cellCount = indexPath.row + 1

        return recordCell
    }
}

