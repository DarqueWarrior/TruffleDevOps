module.exports = async function (context, req) {
    // The purpose of this function is to return the address of the contract
    // on the current network. Moving this external to the application code
    // allows the code to be build once and deployed to each environment.
    context.log('GetContractAddress: JavaScript HTTP trigger function processed a request.');

    const networkId = (req.query.networkId || undefined);

    // fail if incoming data is required
    if (!networkId) {
        context.res = {
            status: 400
        };
        return;
    }

    const address = process.env[`networkAddress_${networkId}`]

    context.log(`Returning: ${address}`)

    // Return the address stored in the networkAddress environment variable.
    // This was set when this function was deployed. Before this function
    // is deployed the Smart Contract is migrated to the blockchain. The
    // address of the ABI on the blockchain is stored and returned by this 
    // function.
    context.res = {
        // status: 200, /* Defaults to 200 */
        body: address
    };
}