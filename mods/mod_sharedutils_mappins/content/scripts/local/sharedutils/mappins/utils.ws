
function SU_removeCustomPinByTagPrefix(prefix: string) {
  SU_removeCustomPinByPredicate(
    (new SU_CustomPinRemoverPredicateTagStartsWith in thePlayer)
      .init(prefix)
  );
}

function SU_removeCustomPinByTag(tag: String) {
  SU_removeCustomPinByPredicate(
    (new SU_CustomPinRemoverPredicateTagEquals in thePlayer)
      .init(tag)
  );
}

function SU_removeCustomPinByPosition(position: Vector) {
  SU_removeCustomPinByPredicate(
    (new SU_CustomPinRemoverPredicatePositionEquals in thePlayer)
      .init(position)
  );
}

function SUMP_getManager(): SUMP_Manager {
	var manager: SUMP_Manager;
	var storage: SU_Storage;

  SUMP_Logger("SUMP_getManager()");
	
	storage = SU_getStorage();
	manager = (SUMP_Manager)storage.getItem("SUMP_Manager");

	if (!manager) {
    SUMP_Logger("SUMP_getManager(), received null, instantiating instance");

		manager = new SUMP_Manager in storage;

		storage.setItem(manager);
	}

	return manager;
}

////////////////////////////////////////////////////////////////////////////////
//       A series of prebuilt predicate removers that may be useful           //
////////////////////////////////////////////////////////////////////////////////

class SU_CustomPinRemoverPredicateTagIncludesSubstring extends SU_PredicateInterfaceRemovePin {
  var substring: String;

  function predicate(pin: SU_MapPin): bool {
    return StrContains(pin.tag, this.substring);
  }
}

class SU_CustomPinRemoverPredicateTagStartsWith extends SU_PredicateInterfaceRemovePin {
  var prefix: String;

  function predicate(pin: SU_MapPin): bool {
    return StrContains(pin.tag, this.prefix);
  }

  function init(prefix: String): SU_CustomPinRemoverPredicateTagStartsWith {
    this.prefix = prefix;

    return this;
  }
}

class SU_CustomPinRemoverPredicateTagEquals extends SU_PredicateInterfaceRemovePin {
  var tag: String;

  function predicate(pin: SU_MapPin): bool {
    return pin.tag == this.tag;
  }

  function init(tag: String): SU_CustomPinRemoverPredicateTagEquals {
    this.tag = tag;

    return this;
  }
}

class SU_CustomPinRemoverPredicatePositionEquals extends SU_PredicateInterfaceRemovePin {
  var position: Vector;

  function predicate(pin: SU_MapPin): bool {
	return pin.position == this.position;
  }

  function init(position: Vector): SU_CustomPinRemoverPredicatePositionEquals {
    this.position = position;

    return this;
  }
}
