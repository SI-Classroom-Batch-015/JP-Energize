//
//  ImageSheet.swift
//  JP Energize
//
//  Created by Phillip Wilke on 10.10.24.
//
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct ImageSheet: View {
    
    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    @State var retrievedImages = [UIImage]()
    
    var body: some View {
        
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
            Button {
                
                isPickerShowing = true
                
            } label: {
                Text("Wähle ein Foto aus")
                    .foregroundStyle(.black)
            }
            
            if selectedImage != nil {
                Button {
                    uploadPhoto()
                } label: {
                    Text("Foto hochladen")
                    
                }
            }
            Divider()
            
            HStack {
                
                ForEach(retrievedImages, id: \.self) { image in
                    
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                }
                
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
        .onAppear {
            retrievePhotos()
        }
    }
    
    func uploadPhoto() {
        
        guard selectedImage != nil else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        let _ = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            
            if error == nil && metadata != nil {
                
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url":path]) { error in
                    
                    if error == nil {
                        
                        DispatchQueue.main.async {
                            
                            self.retrievedImages.append(self.selectedImage!)
                            
                        }
                    }
                }
                
                
            }
        }
                                         
        
    }
    
    func retrievePhotos() {
        
        let db = Firestore.firestore()
        db.collection("images").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                
                for doc in snapshot!.documents {
                    
                    paths.append(doc["url"] as! String)
                }
                
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    
                    fileRef.getData(maxSize: 5*1024*1024) { data, error in
                        
                        if error == nil && data != nil {
                            
                            if let image = UIImage(data: data!) {
                            
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                            
                        }
                            
                    }
                }
                
                
                
            }
        }
    }
}

#Preview {
    ImageSheet()
}
