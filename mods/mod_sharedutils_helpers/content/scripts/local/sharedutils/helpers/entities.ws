function SUH_makeEntitiesTargetPlayer(entities: array<CEntity>) {
  var i: int;

  for (i = 0; i < entities.Size(); i += 1) {
    if (((CActor)entities[i]).GetTarget() != thePlayer && !((CActor)entities[i]).HasAttitudeTowards(thePlayer)) {
      ((CNewNPC)entities[i]).NoticeActor(thePlayer);
      ((CActor)entities[i]).SetAttitude(thePlayer, AIA_Hostile);
    }
  }
}

function SUH_makeEntitiesAlliedWith(entities: array<CEntity>, entity: CEntity) {
  var i: int;

  for (i = 0; i < entities.Size(); i += 1) {
    ((CActor)entities[i]).SetAttitude((CActor)entity, AIA_Friendly);
  }
}

function SUH_makeEntitiesAlliedWithEachother(entities: array<CEntity>) {
  var i: int;

  for (i = 0; i < entities.Size(); i += 1) {
    SUH_makeEntitiesAlliedWith(entities, entities[i]);
  }
}

function SUH_getEntitiesInRange(position: Vector, radius: float): array<CEntity> {
  var gameplay_entities: array<CGameplayEntity>;
  var output: array<CEntity>;
  var entity: CEntity;
  var i: int;

  FindGameplayEntitiesInCylinder(gameplay_entities, position, radius, radius, 100,, FLAG_OnlyAliveActors + FLAG_ExcludePlayer,, 'CEntity');

  for (i = 0; i < gameplay_entities.Size(); i += 1) {
    entity = (CEntity)gameplay_entities[i];
    
    if (entity) {
      output.PushBack((CEntity)gameplay_entities[i]);
    }
  }

  return output;
}

function SUH_areAllEntitiesFarFromPlayer(entities: array<CEntity>): bool {
  var player_position: Vector;
  var i: int;

  player_position = thePlayer.GetWorldPosition();

  for (i = 0; i < entities.Size(); i += 1) {
    if (VecDistanceSquared2D(entities[i].GetWorldPosition(), player_position) < 20 * 20 * ((int)((CNewNPC)entities[i]).IsFlying() * 5 + 1)) {
      return false;
    }
  }

  return true;
}

function SUH_slideEntityToPosition(entity: CEntity, position: Vector, optional duration: float) {
  var movement_adjustor: CMovementAdjustor;
  var slide_ticket: SMovementAdjustmentRequestTicket;
  var translation: Vector;

  if (duration <= 0) {
    duration = 2; // two seconds
  }

  translation = position - entity.GetWorldPosition();

  movement_adjustor = ((CActor)entity)
    .GetMovingAgentComponent()
    .GetMovementAdjustor();

  // cancel any adjustement made with the same name
  movement_adjustor.CancelByName('SharedUtilsSlideToPosition');

  // and now we create a new request
  slide_ticket = movement_adjustor.CreateNewRequest('SharedUtilsSlideToPosition');

  movement_adjustor.AdjustmentDuration(
    slide_ticket,
    duration
  );

  movement_adjustor.SlideTo(
    slide_ticket,
    position,
  );

  movement_adjustor.RotateTo(
    slide_ticket,
    VecHeading(translation)
  );
}

/**
  * this function finds any creature from the supplied list that is inside the
  * radius at the given position, and if it is, teleports it OUTSIDE the radius
  */
function SUH_keepCreaturesOutsidePoint(position: Vector, radius: float, optional entities: array<CEntity>) {
  var distance_from_point: float;
  var old_position: Vector;
  var new_position: Vector;
  var i: int;

  if (entities.Size() == 0) {
    entities = SUH_getEntitiesInRange(position, radius);
  }

  for (i = 0; i < entities.Size(); i += 1) {
    old_position = entities[i].GetWorldPosition();

    distance_from_point = VecDistanceSquared(
      old_position,
      position
    );

    if (distance_from_point <= radius) {
      new_position = VecInterpolate(
        position,
        old_position,
        1
      );

      SUH_groundPosition(new_position);

      if (new_position.Z < old_position.Z) {
        new_position.Z = old_position.Z;
      }

      SUH_slideEntityToPosition(entities[i], new_position);
    }
  }
}

/**
 * this function finds any creature from the supplied list that is outside the
 * radius at the given position, and if it is, teleports it back in the radius
 */
function SUH_keepCreaturesOnPoint(position: Vector, radius: float, entities: array<CEntity>) {
  var distance_from_point: float;
  var old_position: Vector;
  var new_position: Vector;
  var is_flying: bool;
  var i: int;

  for (i = 0; i < entities.Size(); i += 1) {
    old_position = entities[i].GetWorldPosition();

    distance_from_point = VecDistanceSquared(
      old_position,
      position
    );

    if (distance_from_point > radius) {
      new_position = VecInterpolate(
        old_position,
        position,
        1 / radius
      );

      SUH_groundPosition(new_position);

      if (new_position.Z < old_position.Z) {
        new_position.Z = old_position.Z;
      }

      is_flying = ((CNewNPC)entities[i]).IsFlying();

      SUH_slideEntityToPosition(entities[i], new_position, (int)is_flying * 6 + 1);
    }
  }
}

/**
 * this function returns if all the supplied entities are dead
 */
function SUH_areAllEntitiesDead(entities: array<CEntity>): bool {
  var i: int;

  for (i = 0; i < entities.Size(); i += 1) {
    if (((CActor)entities[i]).GetHealthPercents() >= 0.01) {
      return false;
    }
  }

  return true;
}

latent function SUH_resetEntitiesAttitudes(entities: array<CEntity>) {
  var i: int;

  for (i = 0; i < entities.Size(); i += 1) {
    ((CActor)entities[i])
      .ResetTemporaryAttitudeGroup(AGP_Default);
  }
}

/**
 * returns how many entities were removed from the array
 */
function SUH_removeDeadEntities(out entities: array<CEntity>): int {
  var i: int;
  var max: int;
  var removed_count: int;

  max = entities.Size();

  for (i = 0; i < max; i += 1) {
    if (!entities[i] || !((CActor)entities[i]).IsAlive() || ((CActor)entities[i]).GetHealthPercents() <= 0.01) {
      entities.Remove(entities[i]);

      max -= 1;
      i -= 1;
      removed_count += 1;
    }
  }

  return removed_count;
}

latent function SUH_waitUntilPlayerFinishesCombat(out entities: array<CEntity>) {
  // sleep a bit before entering the loop, to avoid a really fast loop if the
  // player runs away from the monster
  Sleep(3);

  while (SUH_waitUntilPlayerFinishesCombatStep(entities)) {
    Sleep(1);
  }
}

/**
 * this is the step function used by the function above: SUH_waitUntilPlayerFinishesCombat
 * it returns true while the player is still in combat, once the player gets out of combat
 * it returns false and so the while loop ends.
 *
 * This is done this way because in some cases you would want to run custom code in the
 * loop and so the latent function is not suited. In that case write a while loop yourself
 * where the condition is this stepper function and then you can add your custom code
 * in the loop body.
 */
function SUH_waitUntilPlayerFinishesCombatStep(out entities: array<CEntity>): bool {
  if (SUH_areAllEntitiesDead(entities) || SUH_areAllEntitiesFarFromPlayer(entities)) {
    return false;
  }

  SUH_makeEntitiesTargetPlayer(entities);
  SUH_removeDeadEntities(entities);

  return true;
}