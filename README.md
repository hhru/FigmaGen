# FigmaGen
[![Travis CI](https://travis-ci.com/hhru/FigmaGen.svg?branch=master)](https://travis-ci.com/hhru/FigmaGen)
[![Version](https://img.shields.io/github/v/release/hhru/FigmaGen)](https://github.com/hhru/FigmaGen/releases)
[![Xcode](https://img.shields.io/badge/Xcode-11-blue.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org)
[![License](https://img.shields.io/github/license/hhru/FigmaGen.svg?style=flat)](https://opensource.org/licenses/MIT)

FigmaGen - a command line tool to generate code for UI styles using Figma components.

It can generate:
- color styles
- text styles

[README на русском языке](README-ru.md)

#### Navigation
- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Homebrew](#homebrew)
    - [Manually](#manually)
- [Usage](#usage)
- [Configuration](#configuration)
    - [Base parameters](#base-parameters)
    - [Figma access token](#figma-access-token)
    - [Figma file](#figma-file)
    - [Generation settings](#generation-settings)
- [Colors](#color-styles)
- [Text styles](#text-styles)
- [License](#license)

## Installation
### CocoaPods
To install FigmaGen using [CocoaPods](http://cocoapods.org) add the following line to your `Podfile`: 
```ruby
pod 'FigmaGen', '~> 1.0.0'
```

Then run in Terminal:
```sh
$ pod install --repo-update
```
If FigmaGen installed using CocoaPods then one should use the relative path to `Pods/FigmaGen` folder while using `generate` command:
```sh
$ Pods/FigmaGen/figmagen generate
```

### Homebrew
To install FigmaGen using [Homebrew](https://brew.sh) run:
```sh
$ brew install hhru/tap/FigmaGen
```

### Manually
- Go to [releases page](https://github.com/hhru/FigmaGen/releases).
- Download the latest release `figmagen-x.y.z.zip`
- Unzip the archive

**Important**: in this case one should use the relative path to the archive content folder while using `generate` command:
```sh
$ MyFolder/figmagen generate
```

## Usage
To generate the code run in Terminal:
```sh
$ figmagen generate
```
The command generates source code files according to the configuration (see [Configuration](#configuration)), described in `.figmagen.yml` file.

One can use another configuration file passing its path in `--config` parameter:
```sh
$ figmagen generate --config 'Folder/figmagen.yml'
```

The generated source code can be customised using [Stencil-templates](https://github.com/stencilproject/Stencil).
If the standard templates do not fit your needs then use your own one, passing its path in the [configuration](#configuration).

FigmaGen uses [Figma API](https://www.figma.com/developers/api), thus it needs an internet connection.

## Configuration
FigmaGen can be configured using a file in [YAML](https://yaml.org) format.
This file should contain all the required parameters.

The configuration file structured into several sections:
- `base`: base parameters that being used by all the commands (см. [Base parameters](#base-parameters)).
- `colors`: color styles generation configuration (см. [Color styles](#color-styles)).
- `textStyles`: text styles generation configuration (см. [Text styles](#text-styles)).

### Base parameters
All the generation commands use the following base parameters:
- `accessToken`: access token needed to perform requests to Figma API
(see [Figma access token](#figma-access-token)).
- `fileKey`: identifier of a Figma file that will be used for code generation
(see [Figma file](#figma-file)).

Example:
```yaml
base:
  accessToken: 27482-71b3313c-0e88-481b-8c93-0e465ab8a868
  fileKey: ZvsRf99Ik11qS4PjS6MAFc
...
```

If a base parameter is missing both in `base` section and in a concrete section (`colors` or `textStyles`) then one'll receive an error after running `figmagen generate` command.

### Figma access token
In order to get access to Figma files one have to be authorized via a personal access token.
How to obtain a token:
1. Open Figma [account settings](https://www.figma.com/settings).
2. Press "Create a new personal access token" in "Personal Access Tokens" section.
3. Input the token description ("FigmaGen", for example).
4. Copy the token to the clipboard.
5. Paste the token to `accessToken` field in the configuration file

### Figma file
FigmaGen requests the Figma file by its identifier, that can be copied from the file URL:
This URL has the following format:
```
https://www.figma.com/file/<identifier>/<name>?node-id=<selected-node-identifier>
```

Once the file identifier is obtained then insert it to `fileKey` in the configuration file.

### Generation settings
For all the commands one should set the following parameters:
- `destinationPath`:  path to the resulting file.
- `templatePath`:  path to the Stencil-template.
If missing then the default template will be used.
- `includingNodes`:  array of node identifiers that should be used for code generation.
If missing then all the nodes will be used.
- `excludingNodes`:  array of node identifiers that should be ignored.
If missing then all the nodes from `includingNodes` array will be used.

---

## Color styles
Configuration example
```yaml
base:
  accessToken: 27482-71b3313c-0e88-481b-8c93-0e465ab8a868
  fileKey: ZvsRf99Ik11qS4PjS6MAFc
colors:
  destinationPath: Sources/Generated/Colors.swift
  includingNodes:
  	- 7:24
```

Usage example:
```swift
view.backgroundColor = Colors.carolina
```

## Text styles
Configuration example:
```yaml
base:
  accessToken: 27482-71b3313c-0e88-481b-8c93-0e465ab8a868
  fileKey: ZvsRf99Ik11qS4PjS6MAFc
textStyles:
  destinationPath: Sources/Generated/TextStyle.swift
  includingNodes:
    - 3:19
```

Usage example:
```swift
label.attributedText = "Hello World".styled(.title1, textColor: Colors.black)
```

## License
FigmaGen is released under the MIT License. (see [LICENSE](LICENSE)).
