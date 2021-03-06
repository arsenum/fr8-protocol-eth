pragma solidity ^0.4.24;

/**
 * @title HoldsSensorData
 * @dev v0.0.1
 * @notice The HoldsSensorData holds an array of data collection pairs containing an off-chain reference
 *      and a 256 bit hash.
 */

contract HoldsSensorData {
  struct SensorDataPair {
    string dataCollectionRef;
    bytes32 dataCollectionHash;
  }

  mapping (address => bool) public sensorDataUploaders;
  SensorDataPair[] public dataCollections;
  uint32 public numDataCollections = 0;

  /**
   * @notice Event emitted after any calls that modify data uploaders.
   */
  event DataUploadersChanged(bytes32 _action, address[] _addresses);

  /**
   * @notice Event emitted after a new data collection has been added to this smart contract.
   */
  event DataCollectionAdded(string _dataCollectionRef, bytes32 _dataCollectionHash);

  /**
   * @notice Throws if called by an unauthorized uploader.
   */
  modifier onlySensorDataUploader() {
    require(sensorDataUploaders[msg.sender]);
    _;
  }

  /**
   * @notice Adds uploaders to the sensorDataUploaders mapping.
   * @param _uploaders Array of addresses to add to the sensorDataUploaders mapping.
   */
  function addSensorDataUploaders(address[] _uploaders) public {
    for (uint i = 0; i < _uploaders.length; i++) {
      sensorDataUploaders[_uploaders[i]] = true;
    }
    emit DataUploadersChanged("ADDED", _uploaders);
  }

  /**
   * @notice Removes uploaders from the sensorDataUploaders mapping.
   * @param _uploaders Array of addresses to remove from the sensorDataUploaders mapping.
   */
  function removeSensorDataUploaders(address[] _uploaders) public {
    for (uint i = 0; i < _uploaders.length; i++) {
      sensorDataUploaders[_uploaders[i]] = false;
    }
    emit DataUploadersChanged("REMOVED", _uploaders);
  }

  /**
   * @notice Adds the hash of a sensor data collection to this smart contract.
   * @param _dataCollectionRef Off-chain reference to the sensor data collection.
   * @param _dataCollectionHash 256 bit hash of the sensor data collection.
   */
  function addDataCollection(string _dataCollectionRef, bytes32 _dataCollectionHash) public onlySensorDataUploader {
    dataCollections.push(SensorDataPair(_dataCollectionRef, _dataCollectionHash));
    numDataCollections++;
    emit DataCollectionAdded(_dataCollectionRef, _dataCollectionHash);
  }
}
