//
//  BarDetailViewController.swift
//  Bebelo
//
//  Created by Buzzware Tech on 08/07/2021.
//

import UIKit

class BarDetailViewController: UIViewController, AnnouncementProtocol {
    
    //IBOUTLET'S
    @IBOutlet weak var BarDetailTableView: UITableView!
    
    //ARRAY'S
    let headers_Array = [
        "",
        "",
        "",
        "Cerveza"
    ]
    
    var announcementAndTerreceArray = [
        "Announce Someting!",
        "Free table on terrace"
    ]
    
    let announcementAndTerraceImages = [
        "Ellipse 7",
        "Ellipse 7-1"
    ]
    
    let announcementAndTerreceDetailArray = [
        "Active during 4 hours, or until deleted",
        "Active during 5 minutes"
    ]
    
    let MainCategoryImages = ["Bombay-1",
                              "Bombay","image 4"
    ]
    
    let MainCategoryTitle = [
        "Bombay Sapphire",
        "Havanna Club",
        "Jameson"
    ]
    
    //VARIABLE'S
    let barImage = UIImage(named: "image 18")
    let AnnouncementPopupIdentifier = "AnnouncementPopupViewController"
    let headerHeight: CGFloat = 65
    let buttonBackColor = "Button Bacground 2"
    let buttonBackColor2 = "Button Background 3"
    let anunciarBtnTitle = "Anunciar"
    let segmentOnBackColor = "SegmentOn"
    let editBarProfileIdentifier = "EditBarProfileViewController"
    var isTerraceSelected = false
    var isAnnounceAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func EditBtnAction(_ sender: Any) {
        let announcementPopupVC = self.getViewController(identifier: editBarProfileIdentifier) as! EditBarProfileViewController
        self.navigationController?.pushViewController(announcementPopupVC, animated: true)
    }
    
    //DELEGATE'S
    func AnnouncementDeletegate(announce: String) {
        self.announcementAndTerreceArray[0] = announce
        self.BarDetailTableView.reloadSections(IndexSet(integer: 0), with: .none)
        self.isAnnounceAdded = true
    }
}

//MARK:- HELPING METHOD'S
extension BarDetailViewController{
    
    func setupNavigationBar() {
        let yourBackImage = UIImage(named: Constant.exitIcon)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
    func getViewController(identifier:String)-> UIViewController {
        let vc = UIStoryboard.init(name: Constant.mainStoryboard, bundle: Bundle.main).instantiateViewController(identifier: identifier)
        return vc
    }
    
    func headerForTableView(tableView:UITableView)->UIView {
        let headerView = UIView.init(frame: CGRect.init(x: Constant.tableviewHeaderXY, y: Constant.tableviewHeaderXY, width: tableView.frame.width, height: Constant.tableviewHeaderHeight))
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func labelForTableViewHeader(headerView:UIView) -> UILabel {
        let headerTitle = UILabel()
        let x: CGFloat = 21
        let y: CGFloat = 25.33
        let width: CGFloat = headerView.frame.width-20
        let height: CGFloat = headerView.frame.height-20
        
        headerTitle.frame = CGRect.init(x: x, y: y, width: width, height: height)
        headerTitle.textColor = UIColor(named: Constant.labelColor)
        headerTitle.backgroundColor = .clear
        headerTitle.font = UIFont(name: Constant.openSansFont, size: Constant.fontSize)
        return headerTitle
    }
}


//MARK:- UITABLEVIEW DELEGATES AND DATASOURCE
extension BarDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headers_Array.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = headerForTableView(tableView: tableView)
        let headerTitle = labelForTableViewHeader(headerView: headerView)
        headerTitle.text = self.headers_Array[section]
        headerView.addSubview(headerTitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.announcementAndTerreceArray.count
        }else if section == 1{
            return 1
        }else if section == 2{
            return self.MainCategoryImages.count
        }else{
            return self.MainCategoryImages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.announcementTableViewCell) as! AnnouncementTableViewCell
            cell.SideImage.image = UIImage(named: self.announcementAndTerraceImages[indexPath.row])
            cell.DeailLabel.text = announcementAndTerreceDetailArray[indexPath.row]
            cell.Title.text = announcementAndTerreceArray[indexPath.row]
            cell.BackView.shadowColor = .clear
            if indexPath.row == 0{
                //Hide or show component according cell
                cell.AnunciaBtn.isHidden = false
                cell.TarraceAsegment.isHidden = true
                //Add tap guesture on title textview
                let titleGusture = UITapGestureRecognizer(target: self, action: #selector(self.announcementEditable(sender:)))
                cell.Title.tag = indexPath.row
                cell.Title.addGestureRecognizer(titleGusture)
                //Change textview in editable mode
                cell.Title.isEditable = true
                cell.Title.isSelectable = true
                //Add target on anunciar
                cell.AnunciaBtn.addTarget(self, action: #selector(self.announcementButtonAction(_:)), for: .touchUpInside)
                cell.AnunciaBtn.tag = indexPath.row
            }else{
                cell.AnunciaBtn.isHidden = true
                cell.TarraceAsegment.isHidden = false
                cell.Title.isEditable = false
                cell.Title.isSelectable = false
                cell.TarraceAsegment.addTarget(self, action: #selector(self.terraceSwitchButtonAction(_:)), for: .touchUpInside)
                cell.TarraceAsegment.tag = indexPath.row
                //Add target on segment control
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.barGalleryTableViewCell) as! BarGalleryTableViewCell
            cell.BarImage.image = self.barImage
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.mainCategoryTableViewCell) as! MainCategoryTableViewCell
            cell.ProductImage.image = UIImage(named: self.MainCategoryImages[indexPath.row])
            cell.ProductNameLabel.text = self.MainCategoryTitle[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.otherCategoryTableViewCell) as! OtherCategoryTableViewCell
            cell.ProductImage.image = UIImage(named: self.MainCategoryImages[indexPath.row])
            cell.ProductNameLabel.text = self.MainCategoryTitle[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func announcementEditable(sender:UITapGestureRecognizer) {
        let announcementPopupVC = self.getViewController(identifier: AnnouncementPopupIdentifier) as! AnnouncementPopupViewController
        announcementPopupVC.delegate = self
        self.present(announcementPopupVC, animated: true, completion: nil)
    }
    
    @objc func announcementButtonAction( _ sender:UIButton) {
        let cell = self.BarDetailTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AnnouncementTableViewCell
        if isAnnounceAdded{
            self.isAnnounceAdded = false
            cell.BackView.shadowColor = UIColor(named: buttonBackColor)
            cell.AnunciaBtn.setImage(#imageLiteral(resourceName: "image 62"), for: .normal)
            cell.AnunciaBtn.setTitle("", for: .normal)
            cell.AnunciaBtn.backgroundColor = .clear
        }else{
            self.isAnnounceAdded = true
            cell.BackView.shadowColor = .clear
            cell.AnunciaBtn.setImage(UIImage(named: ""), for: .normal)
            cell.AnunciaBtn.setTitle(anunciarBtnTitle, for: .normal)
            cell.AnunciaBtn.backgroundColor = UIColor(named: buttonBackColor2)
        }
    }
    
    @objc func terraceSwitchButtonAction( _ sender:UISegmentedControl) {
        let cell = self.BarDetailTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AnnouncementTableViewCell
        if self.isTerraceSelected{
            self.isTerraceSelected = false
            cell.BackView.shadowColor = .clear
        }else{
            self.isTerraceSelected = true
            cell.BackView.shadowColor = UIColor(named: segmentOnBackColor)
        }
    }
}
