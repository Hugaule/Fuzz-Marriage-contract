pragma solidity ^0.8.22;

import "./Person.sol";

contract PersonWrapper is Person {
    constructor() Person(0x0000000000000000000000000000000000000001, 0x0000000000000000000000000000000000000002) {}
}
