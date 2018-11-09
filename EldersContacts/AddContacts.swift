//
//  AddContacts.swift
//  EldersContacts
//
//  Created by HUI Lam on 8/11/2018.
//  Copyright © 2018 EE4304_kelvin_kong. All rights reserved.
//

import UIKit
import Contacts
import AudioToolbox
import AVFoundation

class AddContacts: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var FirstName: UITextField!
    @IBOutlet var FamilyName: UITextField!
    @IBOutlet var Phone: UITextField!
    @IBOutlet var viewForInput: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var viewForImage: UIView!
    @IBOutlet weak var buttonForImage: UIButton!
    
    
    
    //dismiss when touch outside of the popup view
    @IBAction func cancelAddContact(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let string = "cancel add contact"
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstName.delegate = self
        FamilyName.delegate = self
        Phone.delegate = self
        
        viewForImage.layer.cornerRadius = viewForImage.frame.width/2
        viewForImage.clipsToBounds = true
        buttonForImage.layer.cornerRadius = buttonForImage.frame.width/2
        buttonForImage.clipsToBounds = true
        viewForInput.layer.cornerRadius = viewForInput.frame.width/2.5
        viewForInput.clipsToBounds = true
        let string = "add contact"
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //Add the contact to coredata
    @IBAction func AddContact(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        vibration()
        checkAddContact()
    }
    
    @IBAction func AddPhoto(_ sender: Any) {
        FirstName.resignFirstResponder()
        FamilyName.resignFirstResponder()
        Phone.resignFirstResponder()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let string = "add photo"
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        vibration()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePic.image = image
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.clipsToBounds = true
        dismiss(animated:true, completion: nil)
        //
    }
    
    func checkAddContact() {
        guard let firstName = FirstName.text else {
            print("FirstName Error")
            return
        }
        guard let familyName = FamilyName.text else {
            print("FamilyName Error")
            return
        }
        guard let phone = Int64(Phone.text!) else {
            print("Phone Error")
            return
        }
        if firstName != "" && familyName != "" {
            print("success")
         
            let contact = CNMutableContact()
            
            contact.givenName = firstName
            contact.familyName = familyName
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: String(phone)))]
            if let imageData = profilePic.image {
                contact.imageData = UIImageJPEGRepresentation(imageData, 1)
                
            } else {
                let string = "First name and family name cannot be empty"
                let utterance = AVSpeechUtterance(string: string)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                
                let synth = AVSpeechSynthesizer()
                synth.speak(utterance)
            }
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            try! store.execute(saveRequest)
            let string = "\(contact.givenName) \(contact.familyName) is added to contact"
            let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
        }
    }
    
    func vibration () {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("vibrate")
    }
}



