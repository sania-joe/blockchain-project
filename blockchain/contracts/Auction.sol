// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./BlockMaster.sol";


contract auction {
    address payable auctionManager;
    ItemMaster public auctionItem;
    BiddersMaster auctionBidder;

    uint regNo;
    uint chainNo;
    mapping(uint => BiddersMaster) auctionBidderRegister;
    mapping(uint => AuctionRegister) auctionChain;

    AuctionRegister public winner;
    uint maxBidValue;

    constructor() {
        auctionManager = payable(msg.sender);
    }

    /*****************MODIFIERS*************/
    modifier checkAuctionManager() {
        require(msg.sender == auctionManager, "Invalid Auction Manager Account");
        _;
    }

    modifier checkUserisNotAuctionManager() {
        require(msg.sender != auctionManager, "Auction Manager can't participate as bidder");
        _;
    }

    modifier checkAuctionBidderRegister() {
        bool token = false;
        for (uint regcnt = 0; regcnt < regNo; regcnt++) {
            if (auctionBidderRegister[regcnt].bidderAddress == msg.sender) {
                token = true;
                break;
            }
        }
        require(!token, "Action Denied -> Already Registered");
        _;
    }

    modifier checkAuctionBidderExistence() {
        bool token = false;
        for (uint regcnt = 0; regcnt < regNo; regcnt++) {
            if (auctionBidderRegister[regcnt].bidderAddress == msg.sender) {
                token = true;
                break;
            }
        }
        require(token, "Action Denied -> Register for Auction process first");
        _;
    }

    modifier checkBidValue(uint bidderValue) {
        require(bidderValue > maxBidValue, "Bidding denied -> New bid value lower than max bid value");
        _;
    }

    modifier checkWinnerAddress() {
        require(msg.sender == winner.userAddress, "Action Denied -> Invalid Transaction");
        _;
    }

    modifier checkTransactionAmount() {
        uint ethtowei = winner.bidValue * 1 ether;
        require(ethtowei == msg.value, "Action Denied -> Invalid Transaction");
        _;
    }

    modifier checkItemBiddingStatus() {
        require(!auctionItem.auctionResult, "Auction over");
        _;
    }

    /*****************AUCTION FUNCTIONS*************/
    function setAuctionItem(string memory name, uint bidValue) public checkAuctionManager {
        auctionItem = ItemMaster(name, bidValue, false);
        maxBidValue = bidValue;
        chainNo = 0;
    }

    function BidderRegisterMaster(string memory name) public 
    checkUserisNotAuctionManager 
    checkAuctionBidderRegister {
        auctionBidderRegister[regNo] = BiddersMaster(name, payable(msg.sender));
        gotoNextBidder();
    }

    function gotoNextBidder() private {
        regNo++;
    }

    function MyBidding(uint myBidValue) public 
    checkUserisNotAuctionManager 
    checkAuctionBidderExistence 
    checkBidValue(myBidValue) 
    checkItemBiddingStatus {
        auctionChain[chainNo] = AuctionRegister(payable(msg.sender), myBidValue);
        maxBidValue = myBidValue;
        gotoNextBlockchain();
    }

    function gotoNextBlockchain() private {
        chainNo++;
        
    }

    function declareAuctionResult() public checkAuctionManager {
        uint winnerIndex = chainNo - 1;
        winner = auctionChain[winnerIndex];
        auctionItem=ItemMaster(auctionItem.itemName,auctionItem.initBidValue,true);

    }

    function transferBidAmount() public payable 
    checkUserisNotAuctionManager 
    checkWinnerAddress 
    checkTransactionAmount {
        auctionManager.transfer(msg.value);
    }
}
