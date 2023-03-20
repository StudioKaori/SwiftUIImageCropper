//
//  ContentView.swift
//  SwiftUIImageCropper
//
//  Created by Kaori Persson on 2023-03-20.
//

import SwiftUI
import CropViewController

struct ContentView: View {
@State var showImagePicker = false
@State var image: UIImage?
@State var showCropper = false
  
  var body: some View {
      VStack {
          if let image = image {
              Image(uiImage: image)
                  .resizable()
                  .scaledToFit()
                  .padding()
          } else {
              Text("No image selected")
                  .foregroundColor(.gray)
          }
          
          Button("Select Image") {
              showImagePicker = true
          }
      }
      .sheet(isPresented: $showImagePicker) {
          ImagePicker(sourceType: .photoLibrary, image: $image, showImagePicker: $showImagePicker, showCropper: $showCropper)
      }
//      .sheet(isPresented: $showCropper) {
//          if let image = image {
//              Cropper(image: image, showCropper: $showCropper, croppedImage: $image)
//          }
//      }
  }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
  var sourceType: UIImagePickerController.SourceType
  @Binding var image: UIImage?
  @Binding var showImagePicker: Bool
  @Binding var showCropper: Bool
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = sourceType
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let image = info[.originalImage] as? UIImage else {
        return
      }
      print("image picked")
      parent.image = image
      picker.dismiss(animated: true)
    }
    
  }
}
