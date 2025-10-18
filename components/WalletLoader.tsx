import { Popover, Transition } from '@headlessui/react'
import clsx from 'clsx'
import { useWallet } from 'hooks/useWallet'
import { Fragment } from 'react'
import { FaCopy, FaPowerOff } from 'react-icons/fa'
import { copy } from 'utils/clipboard'
import { truncateMiddle } from 'utils/text'

import { WalletButton } from './WalletButton'
import { WalletPanelButton } from './WalletPanelButton'

export const WalletLoader = () => {
  const { address, isConnected, balance, connect, disconnect } = useWallet()

  return (
    <Popover className="mt-4 mb-2">
      {({ close }) => (
        <>
          <div className="grid -mx-4">
            {isConnected && address ? (
              <Popover.Button as={WalletButton} className="w-full">
                {truncateMiddle(address, 16)}
              </Popover.Button>
            ) : (
              <WalletButton className="w-full" onClick={connect}>
                Connect Wallet
              </WalletButton>
            )}
          </div>

          <Transition
            as={Fragment}
            enter="transition ease-out duration-200"
            enterFrom="opacity-0 -translate-y-1"
            enterTo="opacity-100 translate-y-0"
            leave="transition ease-in duration-150"
            leaveFrom="opacity-100 translate-y-0"
            leaveTo="opacity-0 -translate-y-1"
          >
            <Popover.Panel
              className={clsx(
                'absolute inset-x-4 z-50 mt-2',
                'bg-stone-800/80 rounded shadow-lg shadow-black/90 backdrop-blur-sm',
                'flex flex-col items-stretch text-sm divide-y divide-white/10',
              )}
            >
              <div className="flex flex-col items-center py-2 px-4 space-y-1 text-center">
                <span className="py-px px-2 mb-2 font-mono text-xs text-white/50 rounded-full border border-white/25">
                  {truncateMiddle(address || '', 16)}
                </span>
                <div className="font-bold">Your Balance</div>
                <span>
                  {parseFloat(balance).toFixed(4)} tPLQ
                </span>
              </div>
              <WalletPanelButton Icon={FaCopy} onClick={() => void copy(address || '')}>
                Copy wallet address
              </WalletPanelButton>
              <WalletPanelButton Icon={FaPowerOff} onClick={() => [disconnect(), close()]}>
                Disconnect
              </WalletPanelButton>
            </Popover.Panel>
          </Transition>
        </>
      )}
    </Popover>
  )
}
