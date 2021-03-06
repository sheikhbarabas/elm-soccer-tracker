module Download exposing (toCsv)

import Types exposing (Event, Model)
import Pitch exposing (pitchOffset, pitchWidth, pitchLength)


csvPrefix : String
csvPrefix =
  "data:text/csv;charset=utf-8,"


csvHeader : String
csvHeader =
  "x, y, mod1, mod2, mod3"


sep : String
sep =
  ","

rowSep : String
rowSep =
  "%0A"

-- Should make this generic
toCsv : List Event -> String
toCsv events =
  events |>
    List.map convertCoords |>
    createRows |>
    rowsToCsv |>
    (++) csvPrefix


toRow : Event -> String
toRow event =  -- FIXME: find an idiomatic way to do this with FP
  (toString event.x) ++
    sep ++
    (toString event.y) ++
    sep ++
    (toString event.mod1) ++
    sep ++
    (toString event.mod2) ++
    sep ++
    (toString event.mod3)


createRows : List Event -> (List String)
createRows events =
  [ csvHeader ] ++
    (List.map toRow events)


joinRows : String -> String -> String
joinRows row1 row2 =
  row1 ++ rowSep ++ row2


rowsToCsv : (List String) -> String
rowsToCsv rows =
  List.foldr joinRows "" rows


convertCoords : Event -> Event
convertCoords rawEvent =
  { rawEvent
  | x = 100 * (rawEvent.x - pitchOffset) / pitchLength
  , y = 100 * (rawEvent.y - pitchOffset) / pitchWidth
  }
