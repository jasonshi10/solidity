const MemoryToken = artifacts.require('./MemoryToken.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Memory Token', (accounts) => {
  let token
  // save token varibale using before await
  before(async() => {
    token = await MemoryToken.deployed()
  })

  describe('depolyment', async() => {
    it('deploys successfully', async() => {
      const address = token.address
      // make sure address isn't the following
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })
    // check name
    it('has a name', async() => {
      const name = await token.name()
      assert.equal(name, 'Memory Token')
    })
    // check symbol
    it('has a symbol', async() => {
      const symbol = await token.symbol()
      assert.equal(symbol, 'MEMORY')
    })
  })

  describe('token distribution', async() => {
    let result

    it('mints tokens', async() => {
      await token.mint(accounts[0], 'https://www.token-uri.com/nft')

      // it should increase the total supply by 1
      result = await token.totalSupply()
      assert.equal(result.toString(), '1', 'total supply is correct')

      // it should increments owner balance by 1
      result = await token.balanceOf(accounts[0])
      assert.equal(result.toString(), '1', 'balance of is correct')

      // token should belong to owner
      result = await token.ownerOf('1')
      assert.equal(result.toString(), accounts[0].toString(), 'ownerOf is correct')
      result = await token.tokenOfOwnerByIndex(accounts[0], 0)

      // owner can see all tokens
      // iterate thru all the tokens the owner has
      let balanceOf = await token.balanceOf(accounts[0])
      let tokenIds = []
      for (let i = 0; i < balanceOf; i++) {
        let id = await token.tokenOfOwnerByIndex(accounts[0], i)
        tokenIds.push(id.toString())
      }
      let expected = ['1']
      assert.equal(tokenIds.toString(), expected.toString(), 'tokenIds are correct')

      // make sure tokenURI is correct
      let tokenURI = await token.tokenURI('1')
      assert.equal(tokenURI, 'https://www.token-uri.com/nft')
    })
  })
})
