import { TESTNET_NETWORK_URL, Provider, Contract, Wallet, WalletUnlocked } from 'fuels';
import { describe, expect, beforeAll, vi, it } from 'vitest'
import { limit_pool_abi } from './limit_pool-abi';
import { MintRangeParams } from './types';

/**
 * @group node
 * @group browser
 */
describe('Getting started', () => {
  beforeAll(async () => {
    // Avoids using the actual network.
    const mockProvider = await Provider.create(TESTNET_NETWORK_URL);
    vi.spyOn(Provider, 'create').mockResolvedValue(mockProvider);
  });

  it('can connect to a local network', async () => {
    // #region connecting-to-the-local-node
    // #import { Provider, Wallet };

    // Create a provider.
    const provider = await Provider.create(TESTNET_NETWORK_URL);

    // Create our wallet (with a private key).
    const PRIVATE_KEY = 'a1447cd75accc6b71a976fd3401a1f6ce318d27ba660b0315ee6ac347bf39568';
    const wallet = Wallet.fromPrivateKey(PRIVATE_KEY, provider);
    // #endregion connecting-to-the-local-node

    expect(provider).toBeTruthy();
    expect(provider).toBeInstanceOf(Provider);
    expect(wallet).toBeTruthy();
    expect(wallet).toBeInstanceOf(WalletUnlocked);
  });

  it('can connect to testnet', async () => {
    // #region connecting-to-the-testnet
    // #import { Provider, Wallet, TESTNET_NETWORK_URL };

    // Create a provider, with the Latest Testnet URL.
    const provider = await Provider.create(TESTNET_NETWORK_URL);

    // Create our wallet (with a private key).
    const PRIVATE_KEY = '830499a7b3ed234ab617ad6c402c623d0b4318cc4737059c28169e239a25101d';
    const wallet = Wallet.fromPrivateKey(PRIVATE_KEY, provider);

    // Perform a balance check.
    const balances = await wallet.getBalances();
    // [{ assetId: '0x..', amount: bn(..) }, ..]
    // #endregion connecting-to-the-testnet

    expect(balances).toBeTruthy();
    expect(balances).toBeInstanceOf(Array);
  });

  it('can query the chain', async () => {
    // #region connecting-to-the-testnet
    // #import { Provider, Wallet, TESTNET_NETWORK_URL };

    // Create a provider, with the Latest Testnet URL.
    const provider = await Provider.create(TESTNET_NETWORK_URL);

    // Create our wallet (with a private key).
    const PRIVATE_KEY = '830499a7b3ed234ab617ad6c402c623d0b4318cc4737059c28169e239a25101d';
    const wallet = Wallet.fromPrivateKey(PRIVATE_KEY, provider);

    // Perform a balance check.
    const contract = new Contract("0x15ba5d06b9190c72b401f95bfac3522d0ddbb636db35542dfe4f07975f760fca", limit_pool_abi, provider);

    const params: MintRangeParams = {
      to: "fuel18pffspwjaweckzkmqlldrxxncavc2xsjeuqdl495u5pwqy06e6us6lrfvm"
    };

    console.log(await contract.functions.mint_range(params));
  });
});