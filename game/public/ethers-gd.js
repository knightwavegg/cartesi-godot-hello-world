import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.11.0/ethers.min.js";

async function connect_wallet() {
    ethersGD.provider = new ethers.BrowserProvider(window.ethereum);
    ethersGD.signer = await ethersGD.provider.getSigner();
}

function get_contract(address, abistr) {
    let abi = JSON.parse(abistr)
    return new ethers.Contract(address, abi, ethersGD.signer);
}

const OutputValidityProof = "(uint256, uint256, bytes32, bytes32, bytes32, bytes32, bytes32[], bytes32[])";
const Proof = `(${OutputValidityProof}, bytes)`;
const dapp_abi = [ `function executeVoucher(address _destination, bytes _payload, ${Proof} _proof)` ];

function get_dapp() {
    ethersGD.dapp = get_contract("0x70ac08179605AF2D9e75782b8DEcDD3c22aA4D0C", dapp_abi);
}

const ethersGD = { connect_wallet, get_contract, provider:null, signer:null, ethers, dapp:null, get_dapp, dapp_abi };

export default ethersGD;