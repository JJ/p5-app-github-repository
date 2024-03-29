# App::GitHub::Repository version 0.0.4 [![Test distro](https://github.com/JJ/p5-app-github-repository/actions/workflows/test.yml/badge.svg)](https://github.com/JJ/p5-app-github-repository/actions/workflows/test.yml)


Checks things from repositories which are hosted in GitHub. Uses scraping for extracting information, so you don't have to use an API.


## INSTALLATION

It uses Module::Build for installation, so it goes like this

	perl Build.PL
	./Build
	./Build test
	./Build install

Run

```shell
./Build installdeps
```

If you're developing and installing dependencies locally.

## DEPENDENCIES

It uses:

- `Test::More`
- `version`
- `File::Slurper`
- `JSON`
- `Git`
- `Test::Perl::Critic`


## COPYRIGHT AND LICENCE

Copyright (C) 2018, 2024 JJ Merelo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
