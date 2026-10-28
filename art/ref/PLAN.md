# Blue Blood — build order from the three approved screens

The game has exactly three kinds of screen. Everything else is content inside them.

## 1. DESK — the hub
Reference: `art/ref/ref_desk.png`

One painted still of the desk, 16:9, near top-down. It is the main menu and it is a
hot-spot image, not a rebuilt scene.

Objects and what they open:
| object | opens |
| --- | --- |
| folded route map (top left) | destinations |
| open order ledger (right) | quota, delivered, short, pocket, accounts |
| sample case (bottom left) | the eight goods and their stock |
| communicator (bottom right) | who is home today / knock list |
| coins (bottom right) | cash on hand, prices |
| mug (top right) | end the day |
| glove, pencil, keys | flavour, or secondary actions later |

Hot spots are polygons over the baked image, stored next to it as `desk.json`.
If a hot spot moves, the art does not have to be regenerated.

## 2. DOOR — a destination
Reference: `art/ref/ref_door.png`

Two separate images per place:
- `bg_<place>.png` — the corridor or room, 16:9, NO PEOPLE, right third left empty.
- `por_<person>.png` — the resident, magenta ground, cropped at mid thigh, whole
  silhouette inside the frame, keyed to alpha at build time.

Composition rule: background first, portrait rises from the bottom into the right
third, dialogue panel along the bottom, options inside the panel. The same portrait
can stand in any room, so a face can never drift between scenes.

## 3. LEDGER — the book over the world
Reference: `art/ref/ref_ledger.png`

The painted notebook fills the frame; the live numbers are written on the ruled lines
in a marker hand. The scene stays dimmed behind it, and the usual corner chrome
(place name, quota strip) stays where it is.

## Assets still to generate (tomorrow)
1. `desk_hub.png` — replicate `ref_desk.png` exactly, same angle, empty of text.
2. `book_open.png` — the open ledger from `ref_ledger.png`, empty pages, 16:9.
3. `bg_hub.png`, `bg_berth_a/b/c.png`, `bg_bay.png`, `bg_lift.png`, `bg_home.png`
   — all empty of people, right third clear.
4. `por_venn.png`, `por_pratt.png`, `por_rok.png`, `por_dunn.png`, `por_halloran.png`
   — five residents, magenta ground.
5. `map_sheet.png` — the route map on its own, for the map screen opened from the desk.

## Style lock (from the approved three)
American comic: heavy uneven ink, flat saturated colour, one hard shadow per mass,
visible halftone in the shadows. Teal and mustard painted plate, orange safety
stripes, grey plated floor. Lived-in and looked after, never destitute, never photoreal,
never anime.
