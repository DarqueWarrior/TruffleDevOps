require('dotenv').config();
const httpFunction = require('./index');
const context = require('../TestMocks/defaultContext');

afterEach(() => {
    jest.clearAllMocks();
});

// Create a .env file in the root of the api function with the follow contents
// networkAddress_4=0x7a063c7e4A0EC2fB4dC0F73103Fd45F17b46Ae52
// Install the firsttris.vscode-jest-runner extension for best jest experience
test('Should return address', async () => {
    // Arrange
    const request = {
        query: { networkId: 4 }
    };

    // Act
    await httpFunction(context, request);

    // Assert
    expect(context.log.mock.calls.length).toBe(2);
    expect(context.res.body).toEqual('0x7a063c7e4A0EC2fB4dC0F73103Fd45F17b46Ae52');
});

test('Should return 400 error', async () => {
    // Arrange
    const request = {
        query: {}
    };

    // Act
    await httpFunction(context, request);

    // Assert
    expect(context.log.mock.calls.length).toBe(1);
    expect(context.res.status).toEqual(400);
});