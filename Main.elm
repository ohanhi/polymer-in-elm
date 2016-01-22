import Html exposing (..)
import Html.Attributes exposing (..)

import Signal exposing (Signal)
import Time
import Json.Encode as Json


-- MODEL

type alias Tick =
  Float

initTick : Tick
initTick = 0

type alias Coords =
  (Float, Float)

futu : Coords
futu =
  (60.1679729, 24.9350682)


-- VIEW

view : Coords -> Html
view (latitude, longitude) =
  div
    [ style
      [ ("padding", "2em") ]
    ]
    [ h2
      []
      [ text "Custom Elements with Elm" ]
    , p
      []
      [ text """This application is written in Elm, using the
      <google-map> Polymer element."""]
    , p
      []
      [ text """The longitude is updated based on a Time.every signal within
      the Elm app.""" ]
    , p
      []
      [ text ("Latitude: " ++ (toString latitude))
      , br [] []
      , text ("Longitude: " ++ (toString longitude))
      ]
    , googleMap
      [ style
        [ ("height", "400px")
        , ("width", "400px")
        ]
      , zoom 5
      , lat latitude
      , lng longitude
      ]
      [ googleMapMarker
        [ lat (fst futu)
        , lng (snd futu)
        ]
        []
      ]
    ]

-- SIGNALS

ticks : Signal Tick
ticks =
  Time.every Time.second
    |> Signal.foldp (\_ tick -> tick + 1) initTick

main : Signal Html
main =
  ticks
  |> Signal.map (coords futu)
  |> Signal.map view


-- HELPERS

coords : Coords -> Tick -> Coords
coords (initLat, initLong) tick =
  (initLat, initLong + tick)

googleMap : List Attribute -> List Html -> Html
googleMap =
  node "google-map"

googleMapMarker : List Attribute -> List Html -> Html
googleMapMarker =
  node "google-map-marker"

toProp : String -> Float -> Attribute
toProp propName num =
  num
    |> Json.float
    |> property propName

lat : Float -> Attribute
lat num =
  toProp "latitude" num

lng : Float -> Attribute
lng num =
  toProp "longitude" num

zoom : Float -> Attribute
zoom num =
  toProp "zoom" num
