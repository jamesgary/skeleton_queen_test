module Locations exposing (Location(..), LocationsHandler, init, map, sum)


type alias LocationsHandler a =
    { graveyard : a
    , forest : a
    , mine : a
    , river : a
    }


type Location
    = Graveyard
    | Forest
    | Mine
    | River


sum : LocationsHandler number -> number
sum handler =
    handler.graveyard + handler.forest + handler.mine + handler.river


map : (Location -> a -> b) -> LocationsHandler a -> LocationsHandler b
map func handler =
    { graveyard = func Graveyard handler.graveyard
    , forest = func Forest handler.forest
    , mine = func Mine handler.mine
    , river = func River handler.river
    }


init : a -> LocationsHandler a
init val =
    { graveyard = val
    , forest = val
    , mine = val
    , river = val
    }
