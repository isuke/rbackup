# RBackup

Ruby製のバックアップツール。
DSL形式でバックアップ対象とバックアップ先を指定できる。

## Usege

1. *config.rb*を編集
1. 以下のコマンドを実行

```
ruby rbackup.rb
```

### config.rbの編集方法

```ruby
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
```
