![](https://travis-ci.org/Reed-Bigelow/FindMyFace.svg?branch=master)
# FindMyFace
## Instagram remake that implements auto face detection
An Instagram remake that implements face detection for:
* User authentication
* Tagging a user
* Searching for a user

### Overview
The application uses a python backend that implements the dlib software page with [ageitgey](https://github.com/ageitgey) wonderful Python wrapper [face_detection](https://github.com/ageitgey/face_recognition).
The application does not store any user credentials but rather when a user wants to login they must take a image of themselves which compared to a face points that are stored in a MySQL database. With this approach the user is not bound to a phone. They are able to log into any device quickly. 

### Some considerations
This application is a proof of concept on using a face recognition for all authenticaiton. While using just an image of a person is not secure, this model could be adapted to a more secure form of face detection.

### Future development
Some of the future development that could develop this application into a more realistic application is looking into devices that have a more secure face scanning or using retinal scanning. This could mean that with the development of the iPhone X and Samsungs Note line having retinal scanning it could be adapted to those devices with a more secure footing.

### Credits
* [Swiftlint](https://github.com/realm/SwiftLint)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
* [FCUUID](https://github.com/fabiocaccamo/FCUUID)
