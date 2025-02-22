// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
struct ItemMaster
{
  string itemName;
  uint initBidValue;  
  bool auctionResult;
}

struct BiddersMaster
{
    string bidderName;
    address payable bidderAddress;
    //uint bidValue; 
}

struct AuctionRegister
{
   address payable userAddress;
   uint bidValue;
}