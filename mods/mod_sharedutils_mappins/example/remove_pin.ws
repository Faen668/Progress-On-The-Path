/**
 * This is an example showing how to remove pins based on a predicate. A
 * predicate is a function that returns `true` or `false` based on your its
 * own conditions.
 *
 * A return value of `true` means that the action implied by the function name
 * will happen for the current element.
 * A good example of this is the
 *  SU_removeCustomPinByPredicate
 * function. This function will remove any pin where the predicate returned true
 *
 * The following exec function removes any pin whose tag contains the supplied
 * substring.
 */
exec function SU_CustomMapPins_removeWhenTagIncludes(substring: String) {
  /**
   * This predicate class comes pre built with the utility.
   */
  var predicate_class: SU_CustomPinRemoverPredicateTagIncludesSubstring;

  predicate_class = new SU_CustomPinRemoverPredicateTagIncludesSubstring in thePlayer;
  predicate_class.substring = substring;

  SU_removeCustomPinByPredicate(predicate_class);
}