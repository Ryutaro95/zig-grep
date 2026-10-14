# zig-grep

Zigで作るシンプルなgrep風CLIツールです。現在は開発途中で、指定したファイルを行ごとに読み込み、全行を表示します。パターンによる絞り込みは未実装です。

## 必要環境

- Zig 0.17.0以上（`build.zig.zon`の指定）

## ビルド・実行

```sh
zig build
./zig-out/bin/zig_grep "hello" sample.txt
```

ビルドと実行をまとめて行う場合:

```sh
zig build run -- "hello" sample.txt
```

引数は検索パターンとファイルパスの2つです。現在の出力は標準エラーに書き込まれ、パターン・パスに続いて各行が `line: ...` の形式で表示されます。改行を除く1行が4096バイト以上の場合は `LineTooLong` エラーになります。

## テスト

```sh
zig build test
```
