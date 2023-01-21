# Tiny bootstrapper

## Why tiny bootstrapper
Some mods need to run code every time the player enters the game. You may solve
this problem by adding a new line in the Player class, but if every mod does it
your users would end up with many unnecessary merges. The solution is to use a
bootstrapper, this results in a single line to merge and as many mods as you want.

### Alternative
There is a known alternative to tiny bootstrapper, it is `Bootstrap`. However the
mod requires mod authors to create a `.w2ent` file and bundle it. But the tools
we have to edit w2ent file are unstable and may render the whole process frustrating.

The tiny bootstrap on the other hand only requires you to write a `.xml` file which
can be edited with basic text editors.

At the moment tiny bootstrap does not have all the features bootstrap offers. Features
like persistent storage for example. You will need another mod if you need this, a sharedutils
module is in the work and should come soon.

## Using it
If you wish to get code to run at launch, refer to the [example.ws file](./content/scripts/local/sharedutils/tiny_bootstrapper/example.ws)
to learn how to add a state to the TinyBootstrap statemachine.

Once you have added your state, create a mod/dlc bundle with an xml file, copy this content and
edit the `name="MyBoostrappedMod"` attribute so that it corresponds with your new state:
```xml
<?xml version="1.0" encoding="UTF-16"?>
<redxml>
  <definitions>
    <items>

      <!--
        the fake item whose name is the name of the state you created.
       -->
      <item name="MyBoostrappedMod">
        <!-- make sure to add this tag or else the item won't be detected -->
        <tags>SU_TinyBootstrapperManager</tags>
      </item>
      
    </items>
  </definitions>
</redxml>
```

Bundle the mod/dlc and make a script mod with your state, launch the game, load a save
and confirm the log entry in the log file.

### Persistence
If you wish to store data in between sessions or loading screens, the bootstrapped class that you create and which `extends SU_BaseBootstrappedMod` supports `saved var`iables. Meaning that you can mark any of its properties as `saved` and it will persist through reloads. This works for primitive types as well as complex ones like structs and classes. If a class is marked as saved then everything in it will be saved, no need to mark its properties as saved.
