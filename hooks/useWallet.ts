import { useAppKit, useAppKitAccount, useAppKitProvider } from '@reown/appkit/react'
import { BrowserProvider, Contract, formatEther, parseEther } from 'ethers'
import { useCallback, useEffect, useState } from 'react'

export const useWallet = () => {
  const { open } = useAppKit()
  const { address, isConnected, chainId } = useAppKitAccount()
  const { walletProvider } = useAppKitProvider('eip155')
  const [balance, setBalance] = useState<string>('0')

  const getProvider = useCallback(() => {
    if (!walletProvider) return null
    return new BrowserProvider(walletProvider)
  }, [walletProvider])

  const getSigner = useCallback(async () => {
    const provider = getProvider()
    if (!provider) return null
    return await provider.getSigner()
  }, [getProvider])

  const getBalance = useCallback(async () => {
    if (!address || !walletProvider) return '0'
    try {
      const provider = getProvider()
      if (!provider) return '0'
      const balance = await provider.getBalance(address)
      return formatEther(balance)
    } catch (error) {
      console.error('Error fetching balance:', error)
      return '0'
    }
  }, [address, walletProvider, getProvider])

  useEffect(() => {
    if (isConnected && address) {
      getBalance().then(setBalance)
    }
  }, [isConnected, address, getBalance])

  const connect = useCallback(() => {
    open()
  }, [open])

  const disconnect = useCallback(() => {
    open()
  }, [open])

  return {
    address,
    isConnected,
    chainId,
    balance,
    connect,
    disconnect,
    getProvider,
    getSigner,
    getBalance,
  }
}

export const useContract = (contractAddress: string, abi: any[]) => {
  const { getSigner } = useWallet()

  const getContract = useCallback(async () => {
    const signer = await getSigner()
    if (!signer) return null
    return new Contract(contractAddress, abi, signer)
  }, [contractAddress, abi, getSigner])

  return { getContract }
}
