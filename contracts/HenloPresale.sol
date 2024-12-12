// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // Prevents warning for unused variable
        return msg.data;
    }
}

contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    mapping(address => bool) internal authorizations;

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * This will leave the contract without an owner, thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     * @param newOwner The address of the new owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract HENLOPresale is Ownable {
    using SafeMath for uint256;

    IERC20 public token; // The token being sold in the presale
    uint256 public presaleRate; // Rate at which tokens are sold (tokens per Ether)
    uint256 public presaleMinContribution; // Minimum contribution amount in Ether
    uint256 public presaleMaxContribution; // Maximum contribution amount in Ether
    bool public presaleStatus; // Status of the presale (active or inactive)
    uint256 public presaleEndTime; // Timestamp indicating when the presale ends

    mapping(address => uint256) public contributions; // Tracks contributions per address

    event TokensPurchased(address indexed purchaser, uint256 amount); // Emitted when tokens are purchased
    event PresaleStatusChanged(bool newStatus); // Emitted when presale status changes

    /**
     * @dev Constructor to initialize the presale contract with token details and contribution limits.
     * @param _tokenAddress Address of the token contract.
     * @param _presaleRate Rate at which tokens are sold during the presale.
     * @param _presaleMinContribution Minimum contribution allowed per transaction.
     * @param _presaleMaxContribution Maximum contribution allowed per transaction.
     * @param _presaleDuration Duration of the presale in seconds.
     */
    constructor(
        address _tokenAddress,
        uint256 _presaleRate,
        uint256 _presaleMinContribution,
        uint256 _presaleMaxContribution,
        uint256 _presaleDuration
    ) {
        token = IERC20(_tokenAddress);
        presaleRate = _presaleRate;
        presaleMinContribution = _presaleMinContribution;
        presaleMaxContribution = _presaleMaxContribution;
        presaleEndTime = block.timestamp + _presaleDuration; // Set end time based on duration
        presaleStatus = true; // Activate presale by default
    }

    /**
     * @dev Allows users to buy tokens during the presale by sending Ether.
     */
    function buyTokens() public payable {
        require(presaleStatus, "Presale is not active"); // Check if presale is active
        require(block.timestamp < presaleEndTime, "Presale has ended"); // Ensure presale hasn't ended
        require(
            msg.value >= presaleMinContribution,
            "Contribution below minimum"
        ); // Validate minimum contribution
        require(
            contributions[msg.sender].add(msg.value) <= presaleMaxContribution,
            "Exceeds maximum contribution" // Validate maximum contribution limit
        );

        uint256 tokenAmount = msg.value.mul(presaleRate); // Calculate number of tokens to purchase
        require(
            token.balanceOf(address(this)) >= tokenAmount,
            "Insufficient tokens in contract" // Check if enough tokens are available for sale
        );

        contributions[msg.sender] = contributions[msg.sender].add(msg.value); // Update user's contribution record
        require(
            token.transfer(msg.sender, tokenAmount),
            "Token transfer failed" // Transfer tokens to user
        );

        emit TokensPurchased(msg.sender, tokenAmount); // Emit purchase event
    }

    /**
     * @dev Change the status of the presale. Only callable by the contract owner.
     * @param _status New status for the presale (true for active, false for inactive).
     */
    function setPresaleStatus(bool _status) public onlyOwner {
        presaleStatus = _status; // Update presale status
        emit PresaleStatusChanged(_status); // Emit status change event
    }

    /**
     * @dev Withdraw specified amount of tokens from this contract. Only callable by the contract owner.
     * @param amount Amount of tokens to withdraw.
     */
    function withdrawTokens(uint256 amount) public onlyOwner {
        require(token.transfer(owner(), amount), "Token transfer failed"); // Transfer tokens to owner
    }

    /**
     * @dev Withdraw all Ether from this contract. Only callable by the contract owner.
     */
    function withdrawFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance); // Transfer all Ether balance to owner
    }

    /**
     * @dev Extend the duration of the presale period. Only callable by the contract owner.
     * @param _additionalTime Additional time to add to the current presale duration in seconds.
     */
    function extendPresale(uint256 _additionalTime) public onlyOwner {
        presaleEndTime = presaleEndTime.add(_additionalTime); // Update end time with additional duration
    }

    /**
     * @dev Receive function that allows users to buy tokens by sending Ether directly to this contract.
     */
    receive() external payable {
        buyTokens(); // Call buyTokens when Ether is sent to this contract
    }
}
