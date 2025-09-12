// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
// INTERNAL IMPORT FOR NFT OPENZIPLINE
//import "@openzeppelin/contracts/utils/counters.sol";
import "@openzeppelin/contracts/utils/counters.sol";//how many nft token created and tracked about nft
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";//import token contract
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";//package build to  NFT 
import "hardhat/console.sol";
contract NFTMarketplace is ERC721URIStorage
{
  using Counters for Counters.Counter;
  Counters.Counter private _itmesSold;
  uint256 listingPrice = 0.015 ether;
  address payable owner;
  mapping(uint256=>MarketItem)private idMarketItem;
  struct MarketItem{
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }
  event idMarketItemcreated(
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );
  modifier onlyOwner(){
    require(msg.sender == owner,"only owner of the marketplace can change the listing price");
    _; //when codition ix true then continew
  }
  constructor() ERC721("NFT Metavarse Token", "MYNFT"){
    owner == payable(msg.sender);
  }
  function updateListingPrice(uint256 _ListiingPrice) public payable onlyOwner{
    listingPrice = _listingPrice;
  }
  function getListingPrice() public view returns (uint256){
    return listingPrice;
  }
  //Let creat "CREATE NFT TOKEN FUNCTION"
  function createToken(string memory tkenURI,uint256 price) public payable returns(uint256)
  {
    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();
    _mint(msg.sender,newTokenId);
    _setTokenURI(newTokenId,price);
    creatMarketItem(newTOkenId,price);
    return newTokenId;
  }
  //CREATING MARKET ITEMS
  function createMarketItem(uint256 tokenId,uint256 price) private require(price>0,"pricemust at least 1");
  require(msg.value ==listingPrice,"Price must be listing price");
  idMarketItem[tokenId] =MarketItem (tokenId,payable(msg.sender),payable(address(this)),price,false);
  _tranfer(msg.sender,address(this),tokenId);
  emit idMarketItemcreated (tokenId,msg.sender,address(this),price,sold);
}
//FUNCTION FOR RESALE TOKEN
function reSellToken(uint256 tokenId,uint256 price) public payable {
  require(idmarketItem[tokenId].owner==msg.sender,"only item owner can perform this operation");
  require(msg.value==listingPrice,"price must be equal to listing price" );
  idMarketItem[tokenId].sold=falsse;
  idMarketItem[tokenId].price=price;
  idMarketItem[tokemId].seller=payable(msg.sender);
  idMarketItem[tokenId].oqner=payable(address(this));
  _itemsSold.decrement();
  _transfer(msg.sender,addresss(this),tokenId);
  //FUNCTION FOR CREATE MARKET SALE
  function createMarketSale(uint256 tokenId) public payable{
    uint256 price=idMarketItem[tokenId].price;
    require(msg.vslue==price,"please subbmit the asking price in order to complete the purchase");
    idMarketItem[tokenId].owner=payable(msg.sender);
    idMarketItem[tokenId].sold=true;
    idMarketItem[tokenId].owner=payable(address(0));
    _itemsSold.increment();
    _transfer(address(this),msg.sender,tokenId) ;
    payable(owner)._transfer(listingPrice);

    }
    //GETTING UNSOLD NFT DATA
    function fetchMarketItems() public view returns=(MarketItem[]memory){
      uint256 itemCount = _tokenIds.current();
      uint256 unsoldItemCount = _tokenIds.current() - _itemsSold.current();
      uint256 currentIndex = 0;

      MarketItem[] memory items = new MarketItem[](unsoldItemCount);
      for (uint256 i = 0; i < itemCount; i++) {
        if (idMarketItem[i + 1].owner == address(this)) {
          uint256 currentId = i + 1;
          MarketItem storage currentItem = idMarketItem[currentId];
          items[currentIndex] = currentItem;
          currentIndex += 1;
        }
      }
      return items;
    }
    //PURCHASE ITEM
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
      uint256 totalItemCount = _tokenIds.current();
      uint256 itemCount = 0;
      uint256 currentIndex = 0;

      for (uint256 i = 0; i < totalItemCount; i++) {
        if (idMarketItem[i + 1].owner == msg.sender) {
          itemCount += 1;
        }
      }

      MarketItem[] memory items = new MarketItem[](itemCount);
      for (uint256 i = 0; i < totalItemCount; i++) {
        if (idMarketItem[i + 1].owner == msg.sender) {
          uint256 currentId = i + 1;
          MarketItem storage currentItem = idMarketItem[currentId];
          items[currentIndex] = currentItem;
          currentIndex += 1;
        }
      }
      return items;
    }
    //SINGULAR NFT ITEM
    function fetchItemsCreated() public view returns (MarketItem[] memory) {
      uint256 totalItemCount = _tokenIds.current();
      uint256 itemCount = 0;
      uint256 currentIndex = 0;

      for (uint256 i = 0; i < totalItemCount; i++) {
        if (idMarketItem[i + 1].seller == msg.sender) {
          itemCount += 1;
        }
      }

      MarketItem[] memory items = new MarketItem[](itemCount);
      for (uint256 i = 0; i < totalItemCount; i++) {
        if (idMarketItem[i + 1].seller == msg.sender) {
          uint256 currentId = i + 1;
          MarketItem storage currentItem = idMarketItem[currentId];
          items[currentIndex] = currentItem;
          currentIndex += 1;
        }
      }
      return items;
    }
  }
