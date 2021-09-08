import React, { Component } from 'react';
import DVideo from '../abis/DVideo.json'
import Navbar from './Navbar'
import Main from './Main'
import Web3 from 'web3';
import './App.css';

//Connect to IPFS
const ipfsClient = require('ipfs-http-client')
const ipfs = ipfsClient({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' }) // leaving out the arguments will default to these values

class App extends Component {
  // lifecycle call back in react to call loadweb3 and loadBlockchainData
  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    //Load accounts
    const accounts = await web3.eth.getAccounts()

    //Add first account to the the state
    this.setState({ account: accounts[0] })

    //Get network ID
    const networkID = await web3.eth.net.getId()

    //Get network data
    const networkData = DVideo.networks[networkID]

    //Check if net data exists, then load the contract
    if (networkData) {
      //Assign dvideo contract to a variable
      const dvideo = new web3.eth.Contract(DVideo.abi, networkData.address)
      //Add dvideo to the state
      this.setState({ dvideo })
      //Check videosCount
      const videosCount = await dvideo.methods.videoCount().call()
      //Add videosCount to the state
      this.setState({ videosCount })

      // load videos, sort by newest
      // iterate throught videos and add them to the state (by newest)
      for (var i=videosCount; i>=1; i--) {
        const video = await dvideo.methods.videos(i).call()
        this.setState({
          videos: [...this.state.videos, video]
        })
      }
      const latest = await dvideo.methods.videos(videosCount).call()
      //Set latest video and it's title to view as default
      this.setState({
        currentHash: latest.hash,
        currentTitle: latest.title
      })
      //Set loading state to false
      this.setState({ loading: false})
    } else { //If network data doesn't exisits, log error
      window.alert('DVideo contract is not deployed to detected network.')
    }
  }

  //Get video
  captureFile = event => {
    event.preventDefault()
    const file = event.target.files[0]
    const reader = new window.FileReader()
    reader.readAsArrayBuffer(file)

    reader.onloadend = () => {
      this.setState({ buffer: Buffer(reader.result) })
      console.log('buffer', this.state.buffer)
    }
  }

  //Upload video
  uploadVideo = title => {
    console.log('Submitting file to IPFS...')

    // add file to IPFS
    ipfs.add(this.state.buffer, (error, result) => {
      console.log('IPFS result', result)
      if(error) {
        console.error(error)
        return
      }
      this.setState({ loading: true})
      this.state.dvideo.methods.uploadVideo(result[0].hash, title).send({ from: this.state.account }).on('transactionHash', (hash) => {this.setState({ loading: false})
      })
    })

  }

  //Change Video
  changeVideo = (hash, title) => {
    this.setState({'currentHash': hash});
    this.setState({'currentTitle': title});
  }

  constructor(props) {
    super(props)
    this.state = {
      buffer: null,
      account: '',
      dvideo: null,
      videos: [],
      loading: true,
      currentHash: null,
      currentTitle: null
    }

    this.uploadVideo = this.uploadVideo.bind(this)
    this.captureFile = this.captureFile.bind(this)
    this.changeVideo = this.changeVideo.bind(this)
  }

  render() {
    return (
      <div>
        <Navbar
          //fetch account
          account = {this.state.account}
        />
        { this.state.loading
          ? <div id="loader" className="text-center mt-5"><p>Loading...</p></div>
          : <Main
              //states&functions
              videos={this.state.videos}
              uploadVideo={this.uploadVideo}
              captureFile={this.captureFile}
              changeVideo={this.changeVideo}
              currentHash={this.state.currentHash}
              currentTitle={this.state.currentTitle}
            />
        }
      </div>
    );
  }
}

export default App;
