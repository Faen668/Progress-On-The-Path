
exec function SU_MapPinTests() {
  SU_MapPinTest_0();
}

function SU_MapPinTest_0() {
  (new SU_MapPinsBuilder in thePlayer)
    .tag_prefix("SU_PinTest")
    // first pin
    .pin()
      .tag("first")
      .position(thePlayer.GetWorldPosition())
      .radius(20)
      .label("SU_PinTest label")
      .description("SU_PinTest description")
      .type("QuestAvailableBaW")
      .filtered_type("QuestAvailableBaW")
      .add()
    // second pin
    .pin()
      .tag("second")
      .position(thePlayer.GetWorldPosition() + Vector(10, 10, 0))
      .radius(5)
      .label("SU_PinTest label 2")
      .description("SU_PinTest description 2")
      .type("MonsterQuest")
      .filtered_type("MonsterQuest")
      .add()
    // update buffer
    .build();
}