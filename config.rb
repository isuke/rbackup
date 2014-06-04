#
# name: タスク名、出力ファイル名
# dest: 出力先ディレクトリ
#
task name: 'sample', dest: HOME + 'Temp' do |t|

  t.register HOME + 'Temp/memo.md'

  # 特定ファイル/ディレクトリを除く
  t.register HOME + 'Projects/', except: [%r(Projects/.*/tmp), %r(Projects/.*/vendor)]

  # 特定ファイル/ディレクトリのみ
  t.register HOME + 'Programs/', only: [%r(Programs/.*/\.rb)]
end
