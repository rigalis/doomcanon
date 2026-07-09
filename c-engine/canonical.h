#ifndef CANONICAL_H
#define CANONICAL_H
#include <stdint.h>
#include <stddef.h>
// Maximum size for a serialized game state.
// Player state (4 fields) + Mobj state (6 fields each) * max mobjs.
// 64 mobjs is generous for shareware E1M1.
#define CANONICAL_MAX_SIZE 4096
// Serialize the current game state into buf.
// Writes bytes in little-endian order (matching x86 and ARM64).
// Fields to capture per tic:
//   - player.x, player.y, player.z (fixed_t)
//   - player.angle (angle_t)
//   - player.health (int)
//   - for each mobj: id, x, y, z, angle, state
// Mobjs MUST be sorted ascending by thinker.id before serialization.
//
// Returns number of bytes written, or 0 on error.
size_t canonical_serialize(uint8_t *buf, size_t buf_size);
#endif
