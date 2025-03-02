# flutter_templify

![Pub Version](https://img.shields.io/pub/v/flutter_templify) ![Publisher](https://img.shields.io/pub/publisher/flutter_templify) ![Pub Points](https://img.shields.io/pub/points/flutter_templify) ![License](https://img.shields.io/github/license/micazi/flutter_templify)

**`flutter_templify`** is a customizable CLI tool for managing Flutter app templates with YAML-based project definitions.

See how to get started [here](https://medium.com/@micazi/youre-starting-your-new-flutter-project-wrong-there-s-an-easier-way-59900c79d327).

## Table of Contents

1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Developer Experience](#developer-experience)
5. [Features / Requests](#features-and-requests)
6. [Powered by darted_cli](#powered-by-darted_cli)
7. [License](#license)

---

## Features

- **Template Management**: Easily define and reuse Flutter project templates with YAML configurations.
- **Platform-Specific Generation**: Specify platforms like Android, iOS, or Web during project creation.
- **Organized Directory Structures**: Generate projects with predefined folder and file layouts.
- **Customizable Metadata**: Support for custom project names, package identifiers, and organization domains.
- **Interactive CLI**: User-friendly prompts for dynamic project customization.
- **Cross-Platform Support**: Works seamlessly on Windows, macOS, and Linux.
- **Template Sharing**: Easily import/export your template for quick sharing.
- **Dynamic Prompting**: Customize templates by defining additional variables that are prompted at runtime.
- **Custom post-creation commands**: Specify custom commands to run after the project creation.

---

## Installation

1. Activate the package globally via Dart's pub tool:

```bash
dart pub global activate flutter_templify
```

2. Update your env variables with a `FLUTTER_TEMPLIFY_PATH` variable that has the path to your saved templates. for how to do that, you can [check this link](https://www3.ntu.edu.sg/home/ehchua/programming/howto/Environment_Variables.html).

Once activated, you can use the flutter_templify command directly in your terminal.

## Usage

#### 1. Define your Template

Define your template with an easy YAML file configuration:

```yaml
name: "awesome-template"
description: "A basic template for MVP Flutter apps"
domain: micazi.dev
platforms:
  - ios
  - android
  - web
isPackage: false

structure:
   main.env:
   anotherFile.MD:
   pubspec.yaml: "src/templates/pubspec.yaml"
   lib/:
       screens/:
       models/:
       widgets/:
   assets/:
       images/:
       fonts/:
           someFont/:
```

it's super easy, **just hear me out!**
Metadata goes up there (These are the ones supported right now, more to come), and structure goes in like this:

- If it's a **folder**, suffix it with a `/`.
- If it's a **nested folder**, just indent it under its parent folder.
- If it's a **file**, leave it as an entry.
- Even better, you can add a path value to a **reference file** that will be cloned to your new structure!
- Reference paths can be **relative** (e.g., `src/templates/file.txt`) or **absolute** (e.g., `abs:/absolute/path/to/file.txt`). Absolute paths must start with the prefix `abs:`.

**And voila!**, You got yourself an easy way to get started with your new project without the hassle of doing all of that boilerplate process.

And now, you can check all your newly defined templates with:

```bash
flutter_templify templates ls
```

#### 2. Create a new Flutter project

Now for the cool part, Here is how you quickly get up and running with a new project:

```bash
flutter_templify create awesome-template
```

wherever your terminal location is, the new project folder will be created, structured, validated, and ready for you to dive in!

#### 3. Customize Your Prompts

Templates support **dynamic prompting**. Use the `extra_prompted_vars` section in your YAML file to define additional variables that will be prompted during project creation.

**Important Notes:**
- Both `project_name` and `domain_name` are already included by default, so DO NOT redefine them.
- Each variable MUST have a `title` and `description`.
- Optional parameters include a `default` value and a validation `pattern` (using RegEx).

Example:

```yaml
extra_prompted_vars:
  api_url:
    title: API URL
    description: Enter the base API URL for the project.
    default: https://api.example.com
    pattern: ^(https?:\/\/).+
  enable_analytics:
    title: Enable Analytics?
    description: Would you like to enable analytics in your app? (yes/no)
    default: yes
```

At runtime, you'll be prompted to fill in these variables, which can then be dynamically injected into your project files.

---

## Developer Experience

flutter_templify is built with developers in mind, providing:

- **Streamlined Setup**: Spend less time configuring and more time building.
- **Minimal Boilerplate**: Start new projects with a fully structured template.
- **Extensibility**: Easily extend or modify templates to suit your workflow.

## Features and Requests

- [x] YAML-based project creation.
- [X] Dynamic placeholders inside of your reference files to substitute with metadata _(e.g., project name, version, etc.)_
- [x] Runtime prompts for additional variables using `extra_prompted_vars`.
- [x] Custom commands to run after the project creation.
- [ ] You tell me!

## Powered by darted_cli

**flutter_templify** is built on top of the robust and flexible `darted_cli` framework.

darted_cli makes it easy to create structured, feature-rich command-line interfaces in Dart with minimal effort.

**Why darted_cli?**

- Provides a strong foundation for parsing commands, arguments, and flags.
- Simplifies CLI development with tools like interactive prompts, formatted console outputs, and custom error handling.
- Focused on developer experience, ensuring easy scalability and customization.

Explore [darted_cli](https://pub.dev/packages/darted_cli) to learn how you can build your own powerful CLI tools with Dart!

## License

Licensed under the MIT License. You are free to use, modify, and distribute this package.
