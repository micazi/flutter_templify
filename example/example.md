# Flutter Templify - Example Template Walkthrough

### 1. Create Your Own Template  

Below is an example of how to define your Flutter app template using the `flutter_templify` configuration format.  

```yaml
# Template metadata (required fields)
name: "awesome-template" # The name of your template
description: "A basic template for MVP Flutter apps" # A brief description of the template
version: "1.0.0" # Semantic versioning for your template (e.g., 1.0.0)
platforms:
  - ios
  - android
  - web
isPackage: false # Set to true if the template is for a Dart/Flutter package

# Define the structure of your template
# Use relative paths ("./") for files within the same folder as this YAML file
# Use absolute paths prefixed with "abs:" for files elsewhere on your system
structure:
  main.env: "./ref/env/main.env.example" # A relative path to an environment file
  anotherFile.md: "./ref/docs/anotherFile.md.example" # Another example file
  pubspec.yaml: "abs:/path/to/templates/pubspec.yaml" # An absolute path to a configuration file
  lib/: # Directory structure
    screens/: # Folder for app screens
    models/: # Folder for data models
    widgets/: # Folder for reusable widgets
  assets/: # Asset folder
    images/: # Subfolder for images
    fonts/: # Subfolder for fonts
      someFont/: # Subfolder for a specific font
```



### 2. Add the Template to Your Local Repository  

After creating your template YAML file, add it to your local `flutter_templify` repository with the following command:

```bash
flutter_templify templates add path/to/template.yaml
```

- Replace `path/to/template.yaml` with the relative or absolute path to your template YAML file.



### 3. Create Your Project!  

Once your template is added, you can use it to generate a new Flutter project. Here’s an example command:  

```bash
flutter_templify create awesome-template
```

- **`<template>`**: The name of your template (as defined in the `name` field of your YAML).  

---

### Key Notes:

1. **Mandatory Fields**:  
   The `name`, `description`, and `version` fields are required in your YAML file to ensure your template is properly configured.  

2. **Paths in the `structure` Section**:  
   - Use relative paths (e.g., `./ref/...`) for files or folders in the same directory or subdirectories as your YAML file.  
   - Use absolute paths prefixed with `abs:` for files or folders located elsewhere on your system (e.g., `abs:/path/to/...`).  

3. **Variables in Your Template**:  
   - The variables `project_name` and `domain_name` are automatically included in the project creation process, so **you must not add them to the `extra_prompted_vars` section** of your YAML.  
   - For custom variables, use `extra_prompted_vars` to prompt the user during project creation. For example:  
     ```yaml
     extra_prompted_vars:
       app_title:
         title: "Application Title"
         description: "The title of the application"
         default: "My Flutter App"
     ```  

4. **Customize Post-Creation Commands**:  
   You can define commands to run after your project is created using the `custom_commands` field. For example:  
   ```yaml
   custom_commands:
     - "flutter pub get"
     - "flutter analyze"
   ```

5. **Clean Architecture Structure**:  
   The provided `structure` example demonstrates a clean architecture setup, but you can adapt it to fit your specific needs.  


---

## Now you're ready to streamline your Flutter app development workflow with custom templates! 🎉  

