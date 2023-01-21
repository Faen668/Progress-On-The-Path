
/**
 *
 */
class SU_MapPinsBuilder {
  private var tag_prefix: string;
  private var tag: string;
  private var pins: array<SU_MapPin>;

  public function tag_prefix(prefix: string): SU_MapPinsBuilder {
    this.tag_prefix = prefix;

    return this;
  }

  public function tag(tag: string): SU_MapPinsBuilder {
    this.tag = tag;

    return this;
  }

  public function pin(): SU_MapPinBuilder {
    // If a specific tag was supplied to the builder, all child pins inherit
    // that specific tag.
    if (this.tag != "") {
      return (new SU_MapPinBuilder in this).consume_pins_builder(this)
        .tag(this.tag);
    }

    return (new SU_MapPinBuilder in this).consume_pins_builder(this);
  }

  /**
   * Internal function, do not use it.
   */
  public function consume_pin_builder(builder: SU_MapPinBuilder): SU_MapPinsBuilder {
    this.pins.PushBack(
      builder
        // if we have a tag_prefix, any tag that is added to the internal buffer is
        // given the prefix:
        .tag_prefix(this.tag_prefix)
        .build()
    );

    return this;
  }

  /**
   * Consume `this` to add all the inner SU_MapPins there were build using the
   * builder function.
   *
   * Before adding the pins, it removes all pins with the supplied prefix
   */
  public function build() {
    var i: int;

    // 1.
    // remove all pins that start with the supplied prefix if it exists
    if (this.tag_prefix != "") {
      SU_removeCustomPinByTagPrefix(this.tag_prefix);
    }

    // 1.1
    // remove all pins that have the exact same tag than the supplied one if it
    // exists
    if (this.tag != "") {
      SU_removeCustomPinByTag(this.tag);
    }

    // 2.
    // add the pins to the custom pins buffer
    for (i = 0; i < this.pins.Size(); i += 1) {
      SULOG("Adding pin, "+ this.pins[i].tag + " - " + VecToString(this.pins[i].position));

      SUMP_addCustomPin(this.pins[i]);
    }

    // 3.
    // update the minimap pins with the new updated buffer
    SU_updateMinimapPins();
  }
}

/**
 * A builder
 */
class SU_MapPinBuilder {
  private var pins_builder: SU_MapPinsBuilder;
  private var pin: SU_MapPin;

  /**
   * Used to properly initialize the PinBuilder to safely construct a single pin
   */
  public function init(): SU_MapPinBuilder {
    this.pin = new SU_MapPin in thePlayer;

    return this
      .region(SUH_getCurrentRegion());
  }

  /**
   * Internal function, do not use it.
   */
  public function consume_pins_builder(pins_builder: SU_MapPinsBuilder): SU_MapPinBuilder {
    this.pins_builder = pins_builder;
    
    return this.init();
  }

  public function tag(tag: string): SU_MapPinBuilder {
    this.pin.tag = tag;

    return this;
  }

  public function tag_prefix(prefix: string): SU_MapPinBuilder {
    this.pin.tag = prefix + this.pin.tag;

    return this;
  }

  public function is_quest(is_quest: bool): SU_MapPinBuilder {
    this.pin.is_quest = is_quest;

    return this;
  }

  public function position(position: Vector): SU_MapPinBuilder {
    this.pin.position = position;

    return this;
  }

  public function description(description: string): SU_MapPinBuilder {
    this.pin.description = description;

    return this;
  }

  public function label(label: string): SU_MapPinBuilder {
    this.pin.label = label;

    return this;
  }

  public function type(type: string): SU_MapPinBuilder {
    this.pin.type = type;
    
    return this;
  }

  public function filtered_type(filtered_type: string): SU_MapPinBuilder {
    this.pin.filtered_type = filtered_type;

    return this;
  }

  public function radius(radius: float): SU_MapPinBuilder {
    this.pin.radius = radius;

    return this;
  }

  public function region(region: string): SU_MapPinBuilder {
    this.pin.region = region;

    return this;
  }

  public function appears_on_minimap(appears_on_minimap: bool): SU_MapPinBuilder {
    this.pin.appears_on_minimap = appears_on_minimap;

    return this;
  }

  public function pointed_by_arrow(pointed_by_arrow: bool): SU_MapPinBuilder {
    this.pin.pointed_by_arrow = pointed_by_arrow;

    return this;
  }
 
  public function highlighted(highlighted: bool): SU_MapPinBuilder {
    this.pin.highlighted = highlighted;

    return this;
  }
  
  /**
   * Internal function, do not use it.
   * Consume `this` to add the inner SU_MapPin to the current SU_MapPinsBuilder.
   */
  public function add(): SU_MapPinsBuilder {
    return this.pins_builder.consume_pin_builder(this);
  }

  /**
   * Unwraps into the inner SU_MapPin
   */
  public function build(): SU_MapPin {
    return this.pin;
  }
}