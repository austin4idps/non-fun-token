// contracts/NonFunToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
// import package
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TimberlandClassisBoots is ERC721A, Ownable {
    // import util
    using Strings for uint256;

    // global var or const
    uint256 public mintPrice;
    uint256 public maxSupply;
    // default json ipfs
    string internal _baseUri;
    // mapping
    mapping(address => uint256) public holdingAmount;
    mapping(address => uint256) public whitelist;

    // event
    event TokenMinted(uint256 supply);

    // constructor will be called on contract creation
    constructor(
        uint256 supplyAmount,
        uint256 price,
        string memory baseUri
    ) ERC721A("TimberlandClassisBoots", "TCB") {
        maxSupply = supplyAmount;
        mintPrice = price * 10 ** 18;
        _baseUri = baseUri;
        // init minting all token
        _safeMint(owner(), maxSupply);
        holdingAmount[owner()] = maxSupply;
    }

    // safe transfer mint
    function transferMint(address to, uint256 tokenId) external onlyOwner {
        // check token ownership
        require(
            ownerOf(tokenId) == msg.sender,
            "token is not belong to request user"
        );
        // send to new onwer
        safeTransferFrom(msg.sender, to, tokenId);

        // holding amount changing
        holdingAmount[to] += 1;
        holdingAmount[msg.sender] -= 1;
    }

    // safe transfer mint to whitelist
    function transferMintToWhitelist(
        address to,
        uint256 tokenId
    ) external onlyOwner {
        // check token ownershipå
        require(
            ownerOf(tokenId) == msg.sender,
            "token is not belong to request user"
        );
        // transfer usdt from buyer
        require(whitelist[to] > 0, "toAddress is not in the whitelist");
        // send to new onwer
        safeTransferFrom(msg.sender, to, tokenId);

        // holding amount changing
        holdingAmount[to] += 1;
        holdingAmount[msg.sender] -= 1;
        // reduce amount of whitelist
        whitelist[to] -= 1;
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

    // change qty of supply
    function increaseMaxSupply(uint256 maxSupply_) external onlyOwner {
        require(
            maxSupply_ > totalSupply(),
            "can not reduce amount of the supply"
        );
        maxSupply = maxSupply_;
        _safeMint(owner(), maxSupply - totalSupply());
        holdingAmount[owner()] += maxSupply - totalSupply();
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
