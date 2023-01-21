# Custom map pins

Easily add map pins to the game with custom coordinates, icons, description and labels. Entirely through code without any bundling

## Using it
### Adding a pin
_[example file](example/add_pin.ws)_

Adding a custom pin is really easy, the utility comes with its own type [`SU_MapPin`](content/scripts/local/sharedutils/mappins.ws) that you must instanciate and initialize its attributes.

The [example file](example/main.ws) should show everything you need to know about the utility. If this is not enough then the [commented code](content/scripts/local/sharedutils/mappins.ws
) should guide you even more.

Basically, you create your new pin from the class `SU_MapPin` and set its information, then you call `thePlayer.addCustomPin(pin);` and you're done.

There are two functions to remove pins from the list of custom pins:
 - [SU_removeCustomPinByTag](content/scripts/local/sharedutils/mappins.ws) to remove all pins with the same tag as the supplied tag.
 - [SU_removeCustomPinByPosition](content/scripts/local/sharedutils/mappins.ws) to remove all pins with the same X:Y coordinates as the supplied coordinates.