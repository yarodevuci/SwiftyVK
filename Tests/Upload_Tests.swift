import XCTest
@testable import SwiftyVK



class Upload_Tests: VKTestCase {
  
  func test_photo_to_message() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "testImage", ofType: "jpg")!)) else {
      XCTFail("Image path is empty")
      return
    }
    
    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false
    
    let req = VK.API.Upload.Photo.toMessage(Media(imageData: data, type: .JPG))
    req.asynchronous = true
    req.progressBlock = {done, total in}
    req.successBlock = {response in
      XCTAssertNotNil(response[0,"id"].int)
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
  
  
  
  func test_photo_to_group_wall() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:"testImage", ofType: "jpg")!)) else {
      XCTFail("Image path is empty")
      return
    }
    
    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false
    
    
    let req = VK.API.Upload.Photo.toWall.toGroup(
      Media(imageData: data, type: .JPG),
      groupId: "60479154")
    req.asynchronous = true
    req.progressBlock = {done, total in}
    req.successBlock = {response in
      XCTAssertNotNil(response[0,"id"].int)
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
  
  
  
  func test_photo_to_album() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:"testImage", ofType: "jpg")!)) else {
      XCTFail("Image path is empty")
      return
    }
    
    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false

    let req = VK.API.Upload.Photo.toAlbum(
      [Media(imageData: data, type: .JPG)],
      albumId: "181808365",
      groupId: "60479154",
      caption: "test")
    req.successBlock = {response in
      XCTAssertNotNil(response[0,"id"].int)
      let deleteReq = VK.API.Photos.delete([VK.Arg.photoId : response[0]["id"].stringValue])
      deleteReq.asynchronous = true
      deleteReq.send()
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
  
  
  
  func test_photo_to_market() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:"testImage", ofType: "jpg")!)) else {
      XCTFail("Image path is empty")
      return
    }

    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false
    
    let req = VK.API.Upload.Photo.toMarket(
      Media(imageData: data, type: .JPG),
      groupId: "98197515"
    )
    req.successBlock = {response in
      XCTAssertNotNil(response[0,"id"].int)
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
  
  
  
  func test_photo_to_market_album() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:"testImage", ofType: "jpg")!)) else {
      XCTFail("Image path is empty")
      return
    }
    
    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false

    let req = VK.API.Upload.Photo.toMarketAlbum(
      Media(imageData: data, type: .JPG),
      groupId: "98197515"
    )
    req.successBlock = {response in
      print(response)
      XCTAssertNotNil(response["gid"].int)
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
  
  
  
  func test_audio() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:"testAudio", ofType: "mp3")!)) else {
      XCTFail("Audio path is empty")
      return
    }
        
    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false

    let req = VK.API.Upload.audio(Media(audioData: data))
    req.asynchronous = true
    req.progressBlock = {done, total in}
    req.successBlock = {response in
      XCTAssertNotNil(response["id"].int)
      let deleteReq = VK.API.Audio.delete([
        VK.Arg.audioId : response["id"].stringValue,
        VK.Arg.ownerId : response["owner_id"].stringValue
        ])
      deleteReq.asynchronous = false
      deleteReq.send()
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
  
  
  
  func test_video_file() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:"testVideo", ofType: "mp4")!)) else {
      XCTFail("Video path is empty")
      return
    }
    
    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false

    let req = VK.API.Upload.Video.fromFile(
      Media(videoData: data),
      name: "test video",
      description: "test",
      isPrivate: true,
      isWallPost: false,
      isRepeat: false)
    req.asynchronous = true
    req.progressBlock = {done, total in}
    req.successBlock = {response in
      XCTAssertNotNil(response["video_id"].int)
      let deleteReq = VK.API.Audio.delete([
        VK.Arg.audioId : response["video_id"].stringValue,
        VK.Arg.ownerId : response["owner_id"].stringValue
        ])
      deleteReq.asynchronous = false
      deleteReq.send()
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
  
  
  
  
  func test_video_link() {
    let readyExpectation = expectation(description: "ready")

    let req = VK.API.Upload.Video.fromUrl(
      "http://www.youtube.com/watch?v=w7VD1681jV8",
      name: "test video",
      description: "test",
      isPrivate: true,
      isWallPost: false,
      isRepeat: false)
    req.asynchronous = true
    req.successBlock = {response in
      XCTAssertNotNil(response["video_id"].int)
      let deleteReq = VK.API.Audio.delete([
        VK.Arg.audioId : response["video_id"].stringValue,
        VK.Arg.ownerId : response["owner_id"].stringValue
        ])
      deleteReq.asynchronous = false
      deleteReq.send()
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
    }
  }
  
  
  
  
  func test_document() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:"testDoc", ofType: "rtf")!)) else {
      XCTFail("Document path is empty")
      return
    }
    
    let readyExpectation = expectation(description: "ready")
    var progressIsExecuted = false
    
    let req = VK.API.Upload.document(Media(documentData: data, type: "rtf"))
    req.asynchronous = true
    req.progressBlock = {done, total in}
    req.successBlock = {response in
      XCTAssertNotNil(response[0,"id"].int)
      let deleteReq = VK.API.Audio.delete([
        VK.Arg.audioId : response["id"].stringValue,
        VK.Arg.ownerId : response["owner_id"].stringValue
        ])
      deleteReq.asynchronous = false
      deleteReq.send()
      readyExpectation.fulfill()
    }
    req.errorBlock = {error in
      XCTFail("Unexpected error in request: \(error)")
      readyExpectation.fulfill()
    }
    req.progressBlock = {done, total in progressIsExecuted = true}
    req.send()
    
    waitForExpectations(timeout: reqTimeout*10) {_ in
      XCTAssertTrue(progressIsExecuted)
    }
  }
}
