# Complication guide.

Clone the repository along with it's submodules.
```
git clone --recursive https://github.com/darthLeviN/Auidio-godot.git
```

Cd into Auidio-godot then run scons. the resulting binaries will be copied to godot-project/bin/Auidio
```
Auidio-godot>scons
```

Finally you can import godot-project/project.godot into godot 4. **Then make sure you reload the default bus before you save anything.**

Notes : 
- godot-cpp is in alpha stage and you might want to checkout a specific commit of it.
- Godot engine is still in beta stage so the compiles might not be compatible with all engine versions.
