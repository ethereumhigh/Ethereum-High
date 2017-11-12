{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf830
{\fonttbl\f0\fmodern\fcharset0 CourierNewPSMT;\f1\fmodern\fcharset0 CourierNewPS-BoldMT;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red255\green255\blue255;\red16\green121\blue2;
\red115\green0\blue2;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c100000\c100000\c100000;\cssrgb\c0\c53333\c0;
\cssrgb\c53333\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww21540\viewh12140\viewkind0
\deftab720
\pard\pardeftab720\sl340\partightenfactor0

\f0\fs30 \cf2 \cb3 \expnd0\expndtw0\kerning0
\
pragma solidity ^\cf4 \cb1 0.4\cf2 \cb3 .16;\
\
\pard\pardeftab720\sl340\partightenfactor0

\f1\b \cf2 \cb1 interface
\f0\b0 \cb3  
\f1\b \cf5 \cb1 token
\f0\b0 \cf2 \cb3  \{\
    \cb1 function 
\f1\b \cf5 transfer
\f0\b0 \cf2 (address receiver, 
\f1\b uint
\f0\b0  amount)\cb3 ;\
\}\
\
contract Crowdsale \{\
    address 
\f1\b \cb1 public
\f0\b0 \cb3  beneficiary;\
    
\f1\b \cb1 uint
\f0\b0 \cb3  
\f1\b \cb1 public
\f0\b0 \cb3  fundingGoal;\
    
\f1\b \cb1 uint
\f0\b0 \cb3  
\f1\b \cb1 public
\f0\b0 \cb3  amountRaised;\
    
\f1\b \cb1 uint
\f0\b0 \cb3  
\f1\b \cb1 public
\f0\b0 \cb3  deadline;\
    
\f1\b \cb1 uint
\f0\b0 \cb3  
\f1\b \cb1 public
\f0\b0 \cb3  price;\
    token 
\f1\b \cb1 public
\f0\b0 \cb3  tokenReward;\
    mapping(address => uint256) 
\f1\b \cb1 public
\f0\b0 \cb3  balanceOf;\
    
\f1\b \cb1 bool
\f0\b0 \cb3  fundingGoalReached = 
\f1\b \cb1 false
\f0\b0 \cb3 ;\
    
\f1\b \cb1 bool
\f0\b0 \cb3  crowdsaleClosed = 
\f1\b \cb1 false
\f0\b0 \cb3 ;\
\
    
\f1\b \cb1 event
\f0\b0  
\f1\b \cf5 GoalReached
\f0\b0 \cf2 (address recipient, 
\f1\b uint
\f0\b0  totalAmountRaised)\cb3 ;\
    
\f1\b \cb1 event
\f0\b0  
\f1\b \cf5 FundTransfer
\f0\b0 \cf2 (address backer, 
\f1\b uint
\f0\b0  amount, 
\f1\b bool
\f0\b0  isContribution)\cb3 ;\
\
    \cb1 function 
\f1\b \cf5 Crowdsale
\f0\b0 \cf2 (\
        address ifSuccessfulSendTo,\
        
\f1\b uint
\f0\b0  fundingGoalInEthers,\
        
\f1\b uint
\f0\b0  durationInMinutes,\
        
\f1\b uint
\f0\b0  etherCostOfEachToken,\
        address addressOfTokenUsedAsReward\
    ) \cb3 \{\
        beneficiary = ifSuccessfulSendTo;\
        fundingGoal = fundingGoalInEthers * \cf4 \cb1 1\cf2 \cb3  ether;\
        deadline = now + durationInMinutes * \cf4 \cb1 1\cf2 \cb3  minutes;\
        price = etherCostOfEachToken * \cf4 \cb1 1\cf2 \cb3  ether;\
        tokenReward = token(addressOfTokenUsedAsReward);\
    \}\
\
    function () payable \{\
        require(!crowdsaleClosed);\
        
\f1\b \cb1 uint
\f0\b0 \cb3  amount = msg.
\f1\b \cb1 value
\f0\b0 \cb3 ;\
        balanceOf[msg.sender] += amount;\
        amountRaised += amount;\
        tokenReward.transfer(msg.sender, amount / price);\
        FundTransfer(msg.sender, amount, 
\f1\b \cb1 true
\f0\b0 \cb3 );\
    \}\
\
    \cb1 modifier 
\f1\b \cf5 afterDeadline
\f0\b0 \cf2 () \cb3 \{ 
\f1\b \cb1 if
\f0\b0 \cb3  (now >= deadline) _; \}\
\
    \cb1 function 
\f1\b \cf5 checkGoalReached
\f0\b0 \cf2 () afterDeadline \cb3 \{\
        
\f1\b \cb1 if
\f0\b0 \cb3  (amountRaised >= fundingGoal)\{\
            fundingGoalReached = 
\f1\b \cb1 true
\f0\b0 \cb3 ;\
            GoalReached(beneficiary, amountRaised);\
        \}\
        crowdsaleClosed = 
\f1\b \cb1 true
\f0\b0 \cb3 ;\
    \}\
\
    \cb1 function 
\f1\b \cf5 safeWithdrawal
\f0\b0 \cf2 () afterDeadline \cb3 \{\
        
\f1\b \cb1 if
\f0\b0 \cb3  (!fundingGoalReached) \{\
            
\f1\b \cb1 uint
\f0\b0 \cb3  amount = balanceOf[msg.sender];\
            balanceOf[msg.sender] = \cf4 \cb1 0\cf2 \cb3 ;\
            
\f1\b \cb1 if
\f0\b0 \cb3  (amount > \cf4 \cb1 0\cf2 \cb3 ) \{\
                
\f1\b \cb1 if
\f0\b0 \cb3  (msg.sender.send(amount)) \{\
                    FundTransfer(msg.sender, amount, 
\f1\b \cb1 false
\f0\b0 \cb3 );\
                \} 
\f1\b \cb1 else
\f0\b0 \cb3  \{\
                    balanceOf[msg.sender] = amount;\
                \}\
            \}\
        \}\
\
        
\f1\b \cb1 if
\f0\b0 \cb3  (fundingGoalReached && beneficiary == msg.sender) \{\
            
\f1\b \cb1 if
\f0\b0 \cb3  (beneficiary.send(amountRaised)) \{\
                FundTransfer(beneficiary, amountRaised, 
\f1\b \cb1 false
\f0\b0 \cb3 );\
            \} 
\f1\b \cb1 else
\f0\b0 \cb3  \{\
                fundingGoalReached = 
\f1\b \cb1 false
\f0\b0 \cb3 ;\
            \}\
        \}\
    \}\
\}\
}