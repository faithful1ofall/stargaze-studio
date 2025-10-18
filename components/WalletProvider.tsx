'use client'

import { createAppKit } from '@reown/appkit/react'
import { EthersAdapter } from '@reown/appkit-adapter-ethers'
import type { ReactNode } from 'react'
import { useEffect } from 'react'

// Planq Atlas Testnet configuration
const planqAtlas = {
  chainId: 7077,
  name: 'Planq Atlas Testnet',
  currency: 'tPLQ',
  explorerUrl: 'https://evm.planq.network',
  rpcUrl: 'https://evm-rpc-atlas.planq.network',
}

const projectId = 'e5fde2801258bd18130ef97a2a591d7a'

const metadata = {
  name: 'Miniutopia Hub',
  description: 'Decentralized NFT Studio and Marketplace',
  url: 'https://miniutopia.hub',
  icons: ['https://miniutopia.hub/icon.png'],
}

// Create the modal
const modal = createAppKit({
  adapters: [new EthersAdapter()],
  networks: [planqAtlas],
  metadata,
  projectId,
  features: {
    analytics: true,
  },
})

export const WalletProvider = ({ children }: { children: ReactNode }) => {
  useEffect(() => {
    // Initialize modal on mount
    if (modal) {
      console.log('Miniutopia Hub Wallet Provider initialized')
    }
  }, [])

  return <>{children}</>
}
