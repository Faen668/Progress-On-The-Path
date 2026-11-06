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
void ModelViewShow(float yawDegrees, float pitchDegrees, float zoom = 1.f); // draw it this frame, at this angle, this much closer than framed whole
unsigned long long ModelViewTexture();                    // for the window to show: 0 until there's something drawn


void ModelViewRender(ID3D12GraphicsCommandList* list);    // from the frame, before the window is drawn
