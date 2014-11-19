Herdic
======

**Herdic is a command line HTTP client intended to create and test API documentation with ease.**


Installation
------------

```sh
$ gem install herdic
```

Or add the gem to your Gemfile.

```ruby
gem 'herdic'
```


Synopsis
--------

```
herdic [-e] [-c config.yaml] [--use-ssl] path/to/spec.yaml
```

| Option           | Description                                   |
| ---------------- | --------------------------------------------- |
| `-e`             | Edit request file in vim (default) before run |
| `-c config.yaml` | Specify absolute path of herdic.yaml          |
| `--use-ssl`      | Use `Net::HTTP` with flag `use_ssl = true`    |


Sample
------

### Config

```yaml
# herdic.yaml
api_base: http://localhost:3000/user_v1

user_account:
  email:    user+1@example.com
  password: password
```

### Specs

```yaml
# sessions/create.yaml

- title:    Signin as user
  method:   post
  endpoint: <%= config['api_base'] %>/user_account/session

  body:
    user_account:
      email:    <%= config['user_account']['email'] %>
      password: <%= config['user_account']['password'] %>

  register:
    user_account_access_token: user_account.access_token
```

```yaml
# user_bases/show.yaml

- include: ../sessions/create.yaml

- title:    Show user basis
  method:   get
  endpoint: <%= config['api_base'] %>/user_basis

  header:
    X-Access-Token: <%= registry['user_account_access_token'] %>
```

### Run

```sh
$ herdic user_bases/show.yaml
```

![](./preview.gif)


License
-------

This project is copyright by [Creasty](http://www.creasty.com), released under the MIT lisence.  
See `LICENSE` file for details.
