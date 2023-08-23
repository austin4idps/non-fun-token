// contracts/NonFunToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
// import package
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Moe is ERC721A, Ownable {
    // import util
    using Strings for uint256;

    // global var or const
    uint256 public mintPrice = 0.0001 ether;
    uint256 public maxSupply;
    uint256 public mintLimit;
    bool public isMintEnabled;
    // default json ipfs
    string internal _baseUri =
        "ipfs://QmWhpLwoAQ8dJB3Zw81rDBmnbnyCHhhdwtzmLgbBTUHGjE/";

    // mapping
    mapping(address => uint256) public holdingAmount;
    mapping(address => uint256) public whitelist;

    // event
    event TokenMinted(uint256 supply);

    // Constructor will be called on contract creation
    constructor() payable ERC721A("LoriMoeX", "LMX") {
        maxSupply = 20;
        mintLimit = 5;
    }

    // single-mint
    function mint() external payable {
        // checker
        require(isMintEnabled, "minting not enabled");
        require(
            holdingAmount[msg.sender] < mintLimit,
            "exceeds max per wallet"
        );
        require(msg.value == mintPrice, "insuffient amount");
        // checking totalSupply add currently mint amount is less than max-supply
        require(totalSupply() + 1 <= maxSupply, "sold out");

        // increase the ntf count of owner
        holdingAmount[msg.sender] += 1;
        _safeMint(msg.sender, 1);
        // increase total supply by emit token-minted function
        emit TokenMinted(totalSupply());
    }

    // multi-mint
    function multiMint(uint256 quantity_) external payable {
        // checker
        require(isMintEnabled, "minting not enabled");
        // checking totalSupply add currently mint amount is less than max-supply
        require(totalSupply() + quantity_ <= maxSupply, "sold out");
        require(
            holdingAmount[msg.sender] + quantity_ <= mintLimit,
            "exceeds max per wallet"
        );
        require(quantity_ * mintPrice == msg.value, "insuffient amount");
        // checking totalSupply add currently mint amount is less than max-supply
        require(totalSupply() + quantity_ <= maxSupply, "sold out");

        // increase the ntf count of owner
        holdingAmount[msg.sender] += quantity_;
        _safeMint(msg.sender, quantity_);
        // increase total supply by emit token-minted function
        emit TokenMinted(totalSupply());
    }

    // internal method

    function tokenURI(
        uint256 tokenId_
    ) public view override returns (string memory) {
        require(
            _exists(tokenId_),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length != 0
                ? string(
                    abi.encodePacked(baseURI, tokenId_.toString(), ".json")
                )
                : "";
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }

    // admin method

    // turn on/off of the sales
    function toggleIsMintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    // change qty of supply
    function setMaxSupply(uint256 maxSupply_) external onlyOwner {
        maxSupply = maxSupply_;
    }

    // change mint Limit
    function setMintLimit(uint256 mintLimit_) external onlyOwner {
        mintLimit = mintLimit_;
    }

    // set ipfs hash to base uri
    function setBaseURI(string memory newBaseUri) external onlyOwner {
        _baseUri = newBaseUri;
    }

    // set whitelist
    function setWhitelist(
        address[] memory addresses,
        uint256[] memory mintAmount
    ) external onlyOwner {
        require(
            addresses.length == mintAmount.length,
            "addresses does not match mintAmount length"
        );
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = mintAmount[i];
        }
    }

    // set whitelist mint amount
    function setWhitelistMintAmount(
        address _address,
        uint256 amount
    ) external onlyOwner {
        whitelist[_address] = amount;
    }
}
