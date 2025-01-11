pragma solidity ^0.8.22;
// SPDX-License-Identifier: UNLICENSED

contract Person {
    uint age;
    bool isMarried;
    address spouse; // Reference to spouse if married, address(0) otherwise
    address mother;
    address father;
    uint constant DEFAULT_SUBSIDY = 500; // Default welfare subsidy
    uint state_subsidy;

    constructor(address ma, address fa) {
        age = 0;
        isMarried = false;
        mother = ma;
        father = fa;
        spouse = address(0);
        state_subsidy = DEFAULT_SUBSIDY;
    }

    // Enforce non-null spouse, self-marriage prevention, and marriage symmetry
    function marry(address new_spouse) public {
        require(new_spouse != address(0), "Invalid spouse address");
        require(new_spouse != address(this), "Cannot marry yourself");
        require(spouse == address(0), "Already married");
        require(!isMarried, "Already married");

        Person sp = Person(new_spouse);
        require(sp.getSpouse() == address(0), "New spouse already married");

        sp.setSpouse(address(this)); // Symmetry enforced
        spouse = new_spouse;
        isMarried = true;
    }

    // Properly nullify the marriage relationship
    function divorce() public {
        require(isMarried, "Not married");
        require(spouse != address(0), "No spouse to divorce");

        Person sp = Person(spouse);
        sp.setSpouse(address(0)); // Nullify spouse's reference

        spouse = address(0);
        isMarried = false;
    }

    function haveBirthday() public {
        age++;
        if (age >= 65) {
            if (isMarried) {
                state_subsidy = (DEFAULT_SUBSIDY * 2) / 3; // Reduce subsidy by 30% if married
            } else {
                state_subsidy = 600; // Increase subsidy to 600 if unmarried
            }
        } else {
            state_subsidy = DEFAULT_SUBSIDY; // Default subsidy before 65
        }
    }

    function setSpouse(address sp) public {
        // Ensure symmetry logic only when setting a spouse
        require(sp == address(0) || Person(sp).getSpouse() == address(this), "Symmetry violation");
        spouse = sp;
    }

    function getSpouse() public view returns (address) {
        return spouse;
    }

    // Additional invariant checks for Echidna
    function echidna_invariant_marriage_symmetry() public view returns (bool) {
        if (spouse != address(0)) {
            Person sp = Person(spouse);
            return sp.getSpouse() == address(this);
        }
        return true;
    }

    function echidna_invariant_valid_marriage() public view returns (bool) {
        return spouse != address(0) || !isMarried;
    }

    function echidna_invariant_no_self_marriage() public view returns (bool) {
        return spouse != address(this);
    }

    function echidna_invariant_no_multiple_marriages() public view returns (bool) {
        if (spouse != address(0)) {
            Person sp = Person(spouse);
            return sp.getSpouse() == address(this);
        }
        return true;
    }

    function echidna_invariant_subsidy() public view returns (bool) {
        if (age >= 65) {
            if (isMarried) {
                return state_subsidy == DEFAULT_SUBSIDY * 2 / 3; // Subsidy reduced by 30% for married people
            } else {
                return state_subsidy == 600; // Subsidy increases to 600 for unmarried people
            }
        } else {
            return state_subsidy == DEFAULT_SUBSIDY; // Default subsidy before 65
        }
    }
}
