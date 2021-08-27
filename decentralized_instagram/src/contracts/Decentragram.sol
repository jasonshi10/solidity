pragma solidity ^0.5.0;

contract Decentragram {
  string public name = 'Decentragram';

  // store images, uint is an UID, image is the actual images
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  // use struct to assign any arbitrary variables/value, we struct Image here
  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // create images
  function uploadImage(string memory _imgHash, string memory _description) public {
    // require needs to be true to execute the rest of the function, here we make sure description exists
    require(bytes(_description).length > 0);
    // make sure image hash exsists
    require(bytes(_imgHash).length > 0);
    // make sure the uploader is valid
    require(msg.sender != address(0x0));

    // increment image id, use ++ shortcut in solidity meaning increment by 1
    imageCount ++;

    // add image to contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);

    // trigger an event when an image is uploaded
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // tip images
  function tipImageOwner(uint _id) public payable {
    // require id between 0 and largest number of image count
    require(_id > 0 && _id <= imageCount);

    // fetch the image
    Image memory _image = images[_id];

    // fetch the author
    address payable _author = _image.author;

    // send the tip to the author
    address(_author).transfer(msg.value);

    // increment the tip
    _image.tipAmount = _image.tipAmount + msg.value;

    // update the image
    images[_id] = _image;

    // emit event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }

}
