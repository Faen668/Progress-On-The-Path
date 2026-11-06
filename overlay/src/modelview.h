#pragma once
#include <string>
#include <utility>
#include <vector>

struct ID3D12GraphicsCommandList;

// One item's model drawn into a picture the window can show. The files are read on a thread of their own, and it's
// put on the card a little at a time, so choosing an item never holds a frame up for long.
enum ModelState { kModelNone, kModelLoading, kModelReady, kModelMissing };

void ModelViewAnimation(int animation);   // the stance from now on, with no reloading of him
void ModelViewRequest(const std::string& templateName);   // which item: does nothing if it's that one already
ModelState ModelViewState();
// Reads these ahead, behind the one shown, so going to them is quick: creatures only, nearest first
void ModelViewPrefetch(const std::vector<std::string>& requests);
// A creature in two forms: 0 showing its first, 1 changing into its second, 2 showing that, 3 changing back; and the
// seconds until the next. False for anything else.
bool ModelViewFormClock(int& phase, float& seconds);
// Draw it this frame, at this angle, this much closer than framed whole, and moved across the picture: pan in halves of
// the picture's width and height, right and down
void ModelViewShow(float yawDegrees, float pitchDegrees, float zoom = 1.f, float panX = 0.f, float panY = 0.f);
float ModelViewAspect();   // the picture's width over its height: the model is framed in the square in its middle
unsigned long long ModelViewTexture();                    // for the window to show: 0 until there's something drawn


void ModelViewRender(ID3D12GraphicsCommandList* list);    // from the frame, before the window is drawn
