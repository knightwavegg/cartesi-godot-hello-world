import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.11.0/ethers.min.js";

async function connect_wallet() {
    ethersGD.provider = new ethers.BrowserProvider(window.ethereum);
    ethersGD.signer = await ethersGD.provider.getSigner();
}

function get_contract(address, abistr) {
    let abi = JSON.parse(abistr)
    return new ethers.Contract(address, abi, ethersGD.signer);
}

const ethersGD = { connect_wallet, get_contract, provider:null, signer:null, ethers };

export default ethersGD;