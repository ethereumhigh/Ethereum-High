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
pragma solidity ^\cf4 \cb1 0.4\cf2 \cb3 .16;\
\
\pard\pardeftab720\sl340\partightenfactor0

\f1\b \cf2 \cb1 interface
\f0\b0  
\f1\b \cf5 tokenRecipient
\f0\b0 \cf2  \cb3 \{ 
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 receiveApproval
\f0\b0 \cf2 (address _from, uint256 _value, address _token, bytes _extraData) 
\f1\b \cf5 public
\f0\b0 \cf2 \cb3 ; \}\
\
contract TokenERC20 \{\
    string 
\f1\b \cb1 public
\f0\b0 \cb3  name;\
    string 
\f1\b \cb1 public
\f0\b0 \cb3  symbol;\
    uint8 
\f1\b \cb1 public
\f0\b0 \cb3  decimals = \cf4 \cb1 18\cf2 \cb3 ;\
    uint256 
\f1\b \cb1 public
\f0\b0 \cb3  totalSupply;\
\
    mapping (address => uint256) 
\f1\b \cb1 public
\f0\b0 \cb3  balanceOf;\
    mapping (address => mapping (address => uint256)) 
\f1\b \cb1 public
\f0\b0 \cb3  allowance;\
\
    event Transfer(address indexed from, address indexed to, uint256 value);\
\
    event Burn(address indexed from, uint256 value);\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 TokenERC20
\f0\b0 \cf2 (\
        uint256 initialSupply,\
        string tokenName,\
        string tokenSymbol\
    ) 
\f1\b \cf5 public
\f0\b0 \cf2  \cb3 \{\
        totalSupply = initialSupply * \cf4 \cb1 10\cf2 \cb3  ** uint256(decimals);  \
        balanceOf[msg.sender] = totalSupply;                \
        name = tokenName;                                  \
        symbol = tokenSymbol;                               \
    \}\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 _transfer
\f0\b0 \cf2 (address _from, address _to, uint _value) 
\f1\b \cf5 internal
\f0\b0 \cf2  \cb3 \{\
        
\f1\b \cb1 require
\f0\b0 \cb3 (_to != \cf4 \cb1 0x0\cf2 \cb3 );\
        
\f1\b \cb1 require
\f0\b0 \cb3 (balanceOf[_from] >= _value);\
        
\f1\b \cb1 require
\f0\b0 \cb3 (balanceOf[_to] + _value > balanceOf[_to]);\
        uint previousBalances = balanceOf[_from] + balanceOf[_to];\
        balanceOf[_from] -= _value;\
        balanceOf[_to] += _value;\
        Transfer(_from, _to, _value);\
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\
    \}\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 transfer
\f0\b0 \cf2 (address _to, uint256 _value) 
\f1\b \cf5 public
\f0\b0 \cf2  \cb3 \{\
        _transfer(msg.sender, _to, _value);\
    \}\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 transferFrom
\f0\b0 \cf2 (address _from, address _to, uint256 _value) 
\f1\b \cf5 public
\f0\b0 \cf2  
\f1\b \cf5 returns
\f0\b0 \cf2  (bool success) \cb3 \{\
        
\f1\b \cb1 require
\f0\b0 \cb3 (_value <= allowance[_from][msg.sender]);     \
        allowance[_from][msg.sender] -= _value;\
        _transfer(_from, _to, _value);\
        
\f1\b \cb1 return
\f0\b0 \cb3  
\f1\b \cb1 true
\f0\b0 \cb3 ;\
    \}\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 approve
\f0\b0 \cf2 (address _spender, uint256 _value) 
\f1\b \cf5 public
\f0\b0 \cf2 \
        
\f1\b \cf5 returns
\f0\b0 \cf2  (bool success) \cb3 \{\
        allowance[msg.sender][_spender] = _value;\
        
\f1\b \cb1 return
\f0\b0 \cb3  
\f1\b \cb1 true
\f0\b0 \cb3 ;\
    \}\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 approveAndCall
\f0\b0 \cf2 (address _spender, uint256 _value, bytes _extraData)\
        
\f1\b \cf5 public
\f0\b0 \cf2 \
        
\f1\b \cf5 returns
\f0\b0 \cf2  (bool success) \cb3 \{\
        tokenRecipient spender = tokenRecipient(_spender);\
        
\f1\b \cb1 if
\f0\b0 \cb3  (approve(_spender, _value)) \{\
            spender.receiveApproval(msg.sender, _value, this, _extraData);\
            
\f1\b \cb1 return
\f0\b0 \cb3  
\f1\b \cb1 true
\f0\b0 \cb3 ;\
        \}\
    \}\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 burn
\f0\b0 \cf2 (uint256 _value) 
\f1\b \cf5 public
\f0\b0 \cf2  
\f1\b \cf5 returns
\f0\b0 \cf2  (bool success) \cb3 \{\
        
\f1\b \cb1 require
\f0\b0 \cb3 (balanceOf[msg.sender] >= _value);   \
        balanceOf[msg.sender] -= _value;            \
        totalSupply -= _value;                     \
        Burn(msg.sender, _value);\
        
\f1\b \cb1 return
\f0\b0 \cb3  
\f1\b \cb1 true
\f0\b0 \cb3 ;\
    \}\
\
    
\f1\b \cb1 function
\f0\b0  
\f1\b \cf5 burnFrom
\f0\b0 \cf2 (address _from, uint256 _value) 
\f1\b \cf5 public
\f0\b0 \cf2  
\f1\b \cf5 returns
\f0\b0 \cf2  (bool success) \cb3 \{\
        
\f1\b \cb1 require
\f0\b0 \cb3 (balanceOf[_from] >= _value);              \
        
\f1\b \cb1 require
\f0\b0 \cb3 (_value <= allowance[_from][msg.sender]);   \
        balanceOf[_from] -= _value;                        \
        allowance[_from][msg.sender] -= _value;             \
        totalSupply -= _value;                              \
        Burn(_from, _value);\
        
\f1\b \cb1 return
\f0\b0 \cb3  
\f1\b \cb1 true
\f0\b0 \cb3 ;\
    \}\
\}\
}