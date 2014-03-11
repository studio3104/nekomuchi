require 'spec_helper'
require 'nekomuchi/plugin/system'

describe NekoMuchi::Plugin::System do
  let(:hostname) { 'test.host' }
  let(:config) { {} }
  let(:instance) { NekoMuchi::Plugin::System.new(hostname, config) }

  describe '#memory' do
    let(:command_result) do
      "MemTotal:         608476 kB\nMemFree:           24892 kB\nBuffers:          168264 kB\nCached:           222996 kB\nSwapCached:            0 kB\nActive:           302924 kB\nInactive:         186552 kB\nActive(anon):      98256 kB\nInactive(anon):       16 kB\nActive(file):     204668 kB\nInactive(file):   186536 kB\nUnevictable:           0 kB\nMlocked:               0 kB\nSwapTotal:             0 kB\nSwapFree:              0 kB\nDirty:               108 kB\nWriteback:             0 kB\nAnonPages:         98268 kB\nMapped:            12708 kB\nShmem:                56 kB\nSlab:              81012 kB\nSReclaimable:      75048 kB\nSUnreclaim:         5964 kB\nKernelStack:         560 kB\nPageTables:         4136 kB\nNFS_Unstable:          0 kB\nBounce:                0 kB\nWritebackTmp:          0 kB\nCommitLimit:      304236 kB\nCommitted_AS:     150104 kB\nVmallocTotal:   34359738367 kB\nVmallocUsed:        5056 kB\nVmallocChunk:   34359733103 kB\nAnonHugePages:         0 kB\nHugePages_Total:       0\nHugePages_Free:        0\nHugePages_Rsvd:        0\nHugePages_Surp:        0\nHugepagesize:       2048 kB\nDirectMap4k:      637952 kB\nDirectMap2M:           0 kB\n"
    end

    it do
      expect(instance.memory(command_result: command_result)).to eq({
        MemTotal: 608476.0, MemFree: 24892.0, Buffers: 168264.0, Cached: 222996.0, SwapCached: 0.0,
        Active: 302924.0, Inactive: 186552.0,
        :'Active(anon)' => 98256.0, :'Inactive(anon)' => 16.0, :'Active(file)' => 204668.0, :'Inactive(file)' => 186536.0,
        Unevictable: 0.0, Mlocked: 0.0, SwapTotal: 0.0, SwapFree: 0.0, Dirty: 108.0, Writeback: 0.0, AnonPages: 98268.0,
        Mapped: 12708.0, Shmem: 56.0, Slab: 81012.0, SReclaimable: 75048.0, SUnreclaim: 5964.0, KernelStack: 560.0,
        PageTables: 4136.0, NFS_Unstable: 0.0, Bounce: 0.0, WritebackTmp: 0.0, CommitLimit: 304236.0, Committed_AS: 150104.0,
        VmallocTotal: 34359738367.0, VmallocUsed: 5056.0, VmallocChunk: 34359733103.0, AnonHugePages: 0.0,
        HugePages_Total: 0.0, HugePages_Free: 0.0, HugePages_Rsvd: 0.0, HugePages_Surp: 0.0, Hugepagesize: 2048.0,
        DirectMap4k: 637952.0, DirectMap2M: 0.0
      })
    end
  end

  describe '#mdstat' do
    context 'no software raid aray' do
      let(:command_result) { "Personalities : \nunused devices: <none>\n" }

      it do
        expect(instance.mdstat(command_result: command_result)).to eq({
          Personalities: '', unused_devices: '<none>'
        })
      end
    end

    context 'bloken raid aray' do
      let(:command_result) do
        <<-EOF
Personalities : [raid1] [raid5]
md0 : active raid1 hdb1[0] hdd1[2]
      58604992 blocks [2/1] [U_]
      [===>.................]　recovery = 15.4% (9061568/58604992) finish=24.3min speed=33956K/sec
md1 : active raid5 hdb2[0] hdd2[2]
      194450560 blocks level 5, 64k chunk, algorithm 2 [3/2] [U_U]

unused devices: <none> 
        EOF
      end

      it do
        expect(instance.mdstat(command_result: command_result.lstrip)).to eq({
          Personalities: '[raid1] [raid5]',
          md0: 'active raid1 hdb1[0] hdd1[2] 58604992 blocks [2/1] [U_] [===>.................]　recovery = 15.4% (9061568/58604992) finish=24.3min speed=33956K/sec',
          md1: 'active raid5 hdb2[0] hdd2[2] 194450560 blocks level 5, 64k chunk, algorithm 2 [3/2] [U_U]',
          unused_devices: '<none>'
        })
      end
    end
  end
end
