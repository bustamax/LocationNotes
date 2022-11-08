//
//  NoteController.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 06.10.2022.
//

import UIKit

class NoteController: UITableViewController {
    var note:Note?
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var labelFolder: UILabel!
    @IBOutlet weak var labelFolderName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textName.text = note?.name
        textField.text = note?.textDescription
        imageView.image = note?.imageActual
        navigationItem.title = note?.name
    }

    override func viewWillAppear(_ animated: Bool) {
        if let folder = note?.folder {
            labelFolderName.text = folder.name
        }else{
            labelFolderName.text = ""
        }
    }
    // MARK: - Table view data source

    @IBAction func pushDoneAction(_ sender: Any) {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    func saveNote(){
        if textName.text == "" && textField.text == "" && imageView.image == nil{
            CoreDataManager.sharedInstance.managedContext.delete(note!)
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        
        if note?.name != textName.text || note?.textDescription != textField.text{
            note?.dateUpdate = Date()
        }
        note?.name = textName.text
        note?.textDescription = textField.text
        note?.imageActual = imageView.image

        CoreDataManager.sharedInstance.saveContext()
    }
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 && indexPath.section == 0{
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            let a1Camera = UIAlertAction(title: "Make a photo", style: .default) { (alert) in
                print("делаем фото")
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            let a2Photo = UIAlertAction(title: "Select photo", style: .default) { (alert) in
                print("библиотека фотографий")
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            if self.imageView.image != nil{
                let a3Delete = UIAlertAction(title: "Delete", style: .default) { (alert) in
                    self.imageView.image = nil
                }
                alertController.addAction(a3Delete)
                
            }
            let a4Cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
                
            }
            alertController.addAction(a1Camera)
            alertController.addAction(a2Photo)
            
            alertController.addAction(a4Cancel)
            present(alertController, animated: true, completion: nil)
        }
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
           
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectFolder"{
            (segue.destination as! SelectFolderController).note = note
        }
        if segue.identifier == "goToMap"{
            (segue.destination as! NoteMapController).note = note
        }
        // Pass the selected object to the new view controller.
    }
    

}
extension NoteController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true)
    }

    @available(iOS 2.0, *)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true)
    }
}
