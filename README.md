<!-- MarkdownTOC -->

- [1. init](#1-init)
- [2. pry](#2-pry)
  - [即席実行](#即席実行)
  - [ブレークポイント](#ブレークポイント)
    - [1. 適当にrails generateでcontrollerを生成する](#1-適当にrails-generateでcontrollerを生成する)
    - [2. rails sを実行](#2-rails-sを実行)
    - [3. binding.pry を任意の位置に書き込む](#3-bindingpry-を任意の位置に書き込む)
    - [4. 該当ページにアクセスしてみる](#4-該当ページにアクセスしてみる)
    - [5. binding.pryをコメントアウトして無効にしてみる](#5-bindingpryをコメントアウトして無効にしてみる)
  - [pry-rails](#pry-rails)
    - [1. consoleを起動](#1-consoleを起動)
    - [2. consoleからscaffoldする](#2-consoleからscaffoldする)
    - [3. scaffold後のschemeを簡単に確認する](#3-scaffold後のschemeを簡単に確認する)
    - [4. rails s を再起動する](#4-rails-s-を再起動する)
  - [pry-byebug](#pry-byebug)
    - [1. ItemsControllerを再度修正](#1-itemscontrollerを再度修正)
    - [2. rails s を起動](#2-rails-s-を起動)
    - [3. items/listに接続](#3-itemslistに接続)
    - [4. pryコンソールでnextを入力](#4-pryコンソールでnextを入力)
    - [5. pryコンソールでcontinueを入力](#5-pryコンソールでcontinueを入力)
    - [6. その他も主要なコマンド](#6-その他も主要なコマンド)
  - [pry-doc](#pry-doc)
    - [ItemsController#listのソースを見る](#itemscontrollerlistのソースを見る)
    - [他のライブラリなど](#他のライブラリなど)

<!-- /MarkdownTOC -->

<a name="1-init"></a>
# 1. init

```
$ gem install bundler
$ mkdir apc_rails_ws_gems
$ cd apc_rails_ws_gems
$ bundle init
$ vi Gemfile # gem 'rails' のコメントアウトを外す
$ bundle install --path=vendor/bundle
$ bundle exec rails new .
$ echo '/vendor/bundle' >> .gitignore
$ bundle exec rails s
```

```
# Gemfile
source 'https://rubygems.org'

gem 'rails'
```

他のshellから下記を実施後、`<title>Ruby on Rails: Welcome aboard</title>` が出ていれば疎通確認完了。

```
$ curl -X GET 'http://localhost:3000/'
```

<a name="2-pry"></a>
# 2. pry

pryは、Ruby標準付属のirbの上位版のようなコンソール用ツール。

```
$ vi Gemfile
```

```ruby
# Gemfile
source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-byebug'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
```

```
$ bundle install
$ bundle update
```

rails c経由でpryを起動して、プロンプトが `>`になったら正常。


```
$ bundle exec rails c
```

<a name="即席実行"></a>
## 即席実行

pryを起動した状態で下記を改行しながら入力

```ruby
class Hoge
    def say
        puts 'hoge'
    end
end
a = Hoge.new
a.say
```

<a name="ブレークポイント"></a>
## ブレークポイント

<a name="1-適当にrails-generateでcontrollerを生成する"></a>
### 1. 適当にrails generateでcontrollerを生成する

```
$  bundle exec rails g controller items list
```

<a name="2-rails-sを実行"></a>
### 2. rails sを実行

```
$ bundle exec rails s
```

<a name="3-bindingpry-を任意の位置に書き込む"></a>
### 3. binding.pry を任意の位置に書き込む

- `binding.pry` をブレークしたい位置に書き込む
- ブレーク前後が分かるようにログ出力を入れておく

```ruby
# ItemsController
class ItemsController < ApplicationController
  def list
    Rails.logger.debug('before')
    a = 'hoge'
    binding.pry
    Rails.logger.debug('after')
  end
end
```

<a name="4-該当ページにアクセスしてみる"></a>
### 4. 該当ページにアクセスしてみる

http://localhost:3000/items/list へアクセスすると`bundle exec rails s`したコンソールが流れて、pryのプロンプトが出て止まると正常。

```
Started GET "/items/list" for ::1 at 2015-05-29 17:02:03 +0900
Processing by ItemsController#list as HTML
before

From: /Users/ito/work/rails_app/apc_rails_ws_3/app/controllers/items_controller.rb @ line 5 ItemsController#list:

    2: def list
    3:   Rails.logger.debug("before")
    4:   a = 'hoge'
 => 5:   binding.pry
    6:   Rails.logger.debug("after")
    7: end

[1] pry(#<ItemsController>)>
```

pryのプロンプトに`> exit`と入れて一旦抜けると、``after``とログが出ると正常。

```
[1] pry(#<ItemsController>)> exit
after
```

<a name="5-bindingpryをコメントアウトして無効にしてみる"></a>
### 5. binding.pryをコメントアウトして無効にしてみる

ソースを下記に書き換えて該当URLにアクセスするとブレークポイントが無効になり、pryのプロンプトが出てこないのが正常。

```ruby
class ItemsController < ApplicationController
  def list
    Rails.logger.debug("before")
    a = 'hoge'
    #binding.pry
    Rails.logger.debug("after")
  end
end
```

<a name="pry-rails"></a>
## pry-rails

pry-railsはrailsアプリのクラスローダーなどの情報を維持しつつ、pryを起動するので、railsアプリの検証がし易い。

<a name="1-consoleを起動"></a>
### 1. consoleを起動

rails cを実行すると、pryが起動するようになる。

```
$ bundle exec rails c
Loading development environment (Rails 4.2.1)
[1] pry(main)>
```

rails c は、railsのクラスローダーなどを維持しつつ、ちょっとしたスニペットを試したりできるコンソール。本来の用途は知らない。

<a name="2-consoleからscaffoldする"></a>
### 2. consoleからscaffoldする

```
$ .bundle exec rails g scaffold person name:string
```
<a name="3-scaffold後のschemeを簡単に確認する"></a>
### 3. scaffold後のschemeを簡単に確認する


これで、 `db/migrate/**.rb`の中身をがんばって確認しなくていい

```
[1] pry(main)> .bundle exec rake db:create
[1] pry(main)> .bundle exec rake db:migrate
[1] pry(main)> show-models
Person
  id: integer
  name: string
  created_at: datetime
  updated_at: datetime
```

<a name="4-rails-s-を再起動する"></a>
### 4. rails s を再起動する

```
[1] pry(main)> reload!
Reloading...
=> true
```

<a name="pry-byebug"></a>
## pry-byebug

railsで標準でついてくるbyebugだけではpryに十分に対応していない。専用の拡張を使うとpry-railsとの組み合わせで、railsアプリのステップ実行ができるようになる。

- [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug)

<a name="1-itemscontrollerを再度修正"></a>
### 1. ItemsControllerを再度修正

```ruby
class ItemsController < ApplicationController
  def list
    Rails.logger.debug("before")
    a = 'hoge'
    binding.pry
    Rails.logger.debug("after")
  end
end
```

<a name="2-rails-s-を起動"></a>
### 2. rails s を起動

```
$ bundle exec rails s
```

<a name="3-itemslistに接続"></a>
### 3. items/listに接続

- http://localhost:3000/items/list


```
Processing by ItemsController#list as HTML
before

Frame number: 0/72

From: /Users/ito/work/rails_app/apc_rails_ws_3/app/controllers/items_controller.rb @ line 6 ItemsController#list:

    2: def list
    3:   Rails.logger.debug("before")
    4:   a = 'hoge'
    5:   binding.pry
 => 6:   Rails.logger.debug("after")
    7: end
```

<a name="4-pryコンソールでnextを入力"></a>
### 4. pryコンソールでnextを入力

次のステップまで処理を流す

```
[2] pry(#<ItemsController>)> next
after

From: /Users/ito/work/rails_app/apc_rails_ws_3/vendor/bundle/ruby/2.2.0/gems/actionpack-4.2.1/lib/action_controller/metal/implicit_render.rb @ line 5 ActionController::ImplicitRender#send_action:

    3: def send_action(method, *args)
    4:   ret = super
 => 5:   default_render unless performed?
    6:   ret
    7: end

[2] pry(#<ItemsController>):1>
```

<a name="5-pryコンソールでcontinueを入力"></a>
### 5. pryコンソールでcontinueを入力

デバッグを終了する

```
[5] pry(#<ItemsController>)> continue
after
  Rendered items/list.html.erb within layouts/application (0.5ms)
Completed 200 OK in 26029ms (Views: 504.8ms | ActiveRecord: 0.0ms)
```

<a name="6-その他も主要なコマンド"></a>
### 6. その他も主要なコマンド

- step メソッドに入る
- finish メソッドから抜ける

<a name="pry-doc"></a>
## pry-doc

pry-docは色々なソースを明らかにしてくれる。ruby自体のソースや、gemの中身、自身が書いたクラスを開くなど。

<a name="itemscontrollerlistのソースを見る"></a>
### ItemsController#listのソースを見る

```
[1] pry(main)> show-source ItemsController#list

From: /Users/ito/work/rails_app/apc_rails_ws_3/app/controllers/items_controller.rb @ line 2:
Owner: ItemsController
Visibility: public
Number of lines: 7

  def list
    Rails.logger.debug("before")
    a = 'hoge'
        raise 'ahhh!'
    binding.pry
    Rails.logger.debug("after")
  end
[1] pry(main)>
```
<a name="他のライブラリなど"></a>
### 他のライブラリなど

- `require 'date'`などとしてソースに書くように読み込みをしなければいけない
- 標準オブジェクトはすぐに見える。


```
[3] pry(main)> show-source Array

From: /Users/ito/work/rails_app/apc_rails_ws_hoge/vendor/bundle/ruby/2.2.0/gems/activesupport-4.2.1/lib/active_support/core_ext/array/access.rb @ line 1:
Class name: Array
Number of monkeypatches: 12. Use the `-a` option to display all available monkeypatches
Number of lines: 64

class Array
  # Returns the tail of the array from +position+.
  #
  #   %w( a b c d ).from(0)  # => ["a", "b", "c", "d"]
  #   %w( a b c d ).from(2)  # => ["c", "d"]
  #   %w( a b c d ).from(10) # => []
  #   %w().from(0)           # => []
  #   %w( a b c d ).from(-2) # => ["c", "d"]
  #   %w( a b c ).from(-10)  # => []
  def from(position)
    self[position, length] || []
  end

  # Returns the beginning of the array up to +position+.
  #
  #   %w( a b c d ).to(0)  # => ["a"]
  #   %w( a b c d ).to(2)  # => ["a", "b", "c"]
  #   %w( a b c d ).to(10) # => ["a", "b", "c", "d"]
  #   %w().to(0)           # => []
  #   %w( a b c d ).to(-2) # => ["a", "b", "c"]
  #   %w( a b c ).to(-10)  # => []
  def to(position)
    if position >= 0
      first position + 1
    else
      self[0..position]
    end
  end

  # Equal to <tt>self[1]</tt>.
  #
  #   %w( a b c d e ).second # => "b"
  def second
    self[1]
  end
  ```
