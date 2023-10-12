// contracts/NonFunToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
// import package
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TimberlandJacket is ERC721A, Ownable {
    // import util
    using Strings for uint256;

    // global var or const
    uint256 public mintPrice;
    uint256 public maxSupply;
    // default json ipfs
    string internal _baseUri;
    // mapping
    mapping(address => uint256) public holdingAmount;

    // event
    event TokenMinted(uint256 supply);
    // Event to be emitted upon a successful transfer
    event TokenTransferred(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    // constructor will be called on contract creation
    constructor(
        uint256 supplyAmount,
        uint256 price,
        string memory baseUri
    ) ERC721A("TimberlandJacket", "TJ") {
        maxSupply = supplyAmount;
        mintPrice = price * 10 ** 18;
        _baseUri = baseUri;
        // init minting all token
        _safeMint(owner(), maxSupply);
        holdingAmount[owner()] = maxSupply;
    }

    // safe transfer mint
    function transferNFT(address to, uint256 tokenId) external onlyOwner {
        require(holdingAmount[to] == 0, "sold out");
        safeTransferFrom(msg.sender, to, tokenId);
        holdingAmount[to] += 1;
        holdingAmount[msg.sender] -= 1;
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

    // change mint price
    function setMintPrice(uint256 mintPrice_) external onlyOwner {
        mintPrice = mintPrice_;
    }
}
