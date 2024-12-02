1. Create your own template.

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
  - main.env
  - anotherFile.MD
  - pubspec.yaml: "src/templates/pubspec.yaml"
  - lib/:
      - screens/
      - models/
      - widgets/
  - assets/:
      - images/
      - fonts/:
          - someFont/
```

2. Add the template to your local repo.

```bash
flutter_templify templates add -f path/to/template.yaml
```

3. Create your project!

```bash
flutter_templify create -t awesome-template -n awesome_project
```
