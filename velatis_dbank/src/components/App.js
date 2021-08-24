import { Tabs, Tab } from 'react-bootstrap'
import dBank from '../abis/dBank.json'
import React, { Component } from 'react';
import Token from '../abis/Token.json'
import dbank from '../dbank.png';
import Web3 from 'web3';
import './App.css';

//h0m3w0rk - add new tab to check accrued interest

class App extends Component {

  async componentWillMount() {
    await this.loadBlockchainData(this.props.dispatch)
  }

  async loadBlockchainData(dispatch) {
    //check if MetaMask exists
    if(typeof window.ethereum != 'undefined') {
      //assign to values to variables: web3, netId, accounts
      const web3 = new Web3(window.ethereum)
      const netId = await web3.eth.net.getId()
      const accounts = await web3.eth.requestAccounts()

      //check if account is detected, then load balance&setStates, elsepush alert
      if (typeof accounts[0] != 'undefined') {
        const balance = await web3.eth.getBalance(accounts[0])
        this.setState({account: accounts[0], balance: balance, web3: web3})

    } else {
      window.alert('Please login with MetaMask')
    }
    // load contracts
    try {
    const token = new web3.eth.Contract(Token.abi, Token.networks[netId].address)
    const dbank = new web3.eth.Contract(dBank.abi, dBank.networks[netId].address)
    const dBankAddress = dBank.networks[netId].address
    this.setState({token: token, dbank: dbank, dBankAddress: dBankAddress})
    console.log(dBankAddress)
    } catch (e) {
    console.log('Error', e)
    window.alert('Contracts not deployed to the current network')
    }
  } else {
    window.alert('Please install MetaMask')
  }
}

  async deposit(amount) {
    //check if this.state.dbank is ok
    if(this.state.dbank != 'undefined') {
      try{
        //in try block call dBank deposit();
        await this.state.dbank.methods.deposit().send({value: amount.toString(), from: this.state.account})
      } catch (e) {
        console.log('Error, deposit: ', e)
      }
    }

  }

  async withdraw(e) {
    //prevent button from default click
    e.preventDefault()
    //check if this.state.dbank is ok
    if(this.state.dbank != 'undefined'){
      try{
        //in try block call dBank withdraw();
        await this.state.dbank.methods.withdraw().send({from: this.state.account})
      } catch(e) {
        console.log('Error, borrow: ', e)
      }
    }
  }

  async borrow(amount) {
    if(this.state.dbank!=='undefined'){
      try{
        await this.state.dbank.methods.borrow().send({value: amount.toString(), from: this.state.account})
      } catch (e) {
        console.log('Error, borrow: ', e)
      }
    }
  }

  async payOff(e) {
    e.preventDefault()
    if(this.state.dbank!=='undefined'){
      try{
        const collateralEther = await this.state.dbank.methods.collateralEther(this.state.account).call({from: this.state.account})
        const tokenBorrowed = collateralEther/2
        await this.state.token.methods.approve(this.state.dBankAddress, tokenBorrowed.toString()).send({from: this.state.account})
        await this.state.dbank.methods.payOff().send({from: this.state.account})
      } catch(e) {
        console.log('Error, pay off: ', e)
      }
    }
  }

  constructor(props) {
    super(props)
    this.state = {
      web3: 'undefined',
      account: '',
      token: null,
      dbank: null,
      balance: 0,
      dBankAddress: null
    }
  }

  render() {
    return (
      <div className='text-monospace'>
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
          <a
            className="navbar-brand col-sm-3 col-md-2 mr-0"
            // href="http://www.dappuniversity.com/bootcamp"
            target="_blank"
            rel="noopener noreferrer"
          >
        <img src={dbank} className="App-logo" alt="logo" height="32"/>
          <b>dBank</b>
        </a>
        </nav>
        <div className="container-fluid mt-5 text-center">
        <br></br>
          <h1>Velatis, a Decentralized Banking System</h1>
          <h2>{this.state.account}</h2>
          <br></br>
          <div className="row">
            <main role="main" className="col-lg-12 d-flex text-center">
              <div className="content mr-auto ml-auto">
              <Tabs defaultActiveKey="profile" id="uncontrolled-tab-example">
                <Tab eventKey="deposit" title="Deposit">
                  <div>
                  <br></br>
                    How much do you want to deposit?
                    <br></br>
                    (min. amount is 0.01 ETH)
                    <br></br>
                    (1 deposit is possible at the time)
                    <br></br>
                    <form onSubmit={(e) => {
                      e.preventDefault() //prevent refresh
                      let amount = this.depositAmount.value //catching depositAmount value saved
                      amount = amount * 10**18 //convert to wei
                      this.deposit(amount)
                    }}>
                      <div className='form-group mr-sm-2'>
                      <br></br>
                        <input
                          id='depositAmount'
                          step="0.01"
                          type='number'
                          ref={(input) => {this.depositAmount = input}} //catching depositAmount value saved
                          className="form-control form-control-md"
                          placeholder='amount...'
                          required />
                      </div>
                      <button type='submit' className='btn btn-primary'>DEPOSIT</button>
                    </form>
                  </div>
                </Tab>
                <Tab eventKey="withdraw" title="Withdraw">
                <br></br>
                  Do you want to withdraw + take interest?
                  <br></br>
                  <br></br>
                <div>
                  <button type='submit' className='btn btn-primary' onClick={(e) => this.withdraw(e)}>WITHDRAW</button>
                </div>
              </Tab>
              <Tab eventKey="borrow" title="Borrow">
                <div>

                <br></br>
                  Do you want to borrow tokens?
                  <br></br>
                  (You'll get 50% of collateral, in Tokens)
                  <br></br>
                  Type collateral amount (in ETH)
                  <br></br>
                  <br></br>
                  <form onSubmit={(e) => {

                    e.preventDefault()
                    let amount = this.borrowAmount.value
                    amount = amount * 10 **18 //convert to wei
                    this.borrow(amount)
                  }}>
                    <div className='form-group mr-sm-2'>
                      <input
                        id='borrowAmount'
                        step="0.01"
                        type='number'
                        ref={(input) => { this.borrowAmount = input }}
                        className="form-control form-control-md"
                        placeholder='amount...'
                        required />
                    </div>
                    <button type='submit' className='btn btn-primary'>BORROW</button>
                  </form>
                </div>
              </Tab>
              <Tab eventKey="payOff" title="Payoff">
                <div>

                <br></br>
                  Do you want to payoff the loan?
                  <br></br>
                  (You'll receive your collateral - fee)
                  <br></br>
                  <br></br>
                  <button type='submit' className='btn btn-primary' onClick={(e) => this.payOff(e)}>PAYOFF</button>
                </div>
              </Tab>
            </Tabs>
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}
}

export default App;
