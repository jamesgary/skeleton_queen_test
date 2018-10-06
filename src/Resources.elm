module Resources
    exposing
        ( Cost
        , Inventory
        , Resource(..)
        , ResourcesHandler
        , add
        , canAfford
        , deduct
        , init
        , map
        , map2
        )


type Resource
    = Mana
    | Iron
    | Lumber
    | Water


allResources =
    [ Mana, Iron, Lumber, Water ]


type alias Inventory =
    ResourcesHandler Float


type alias Cost =
    List ( Resource, Float )


resourceInfo : Resource -> (Inventory -> Float)
resourceInfo resource =
    case resource of
        Mana ->
            .mana

        Iron ->
            .iron

        Lumber ->
            .lumber

        Water ->
            .water


canAfford : Inventory -> Cost -> Bool
canAfford inv cost =
    let
        deductedInv =
            deduct inv cost
    in
    (deductedInv.mana >= 0)
        && (deductedInv.lumber >= 0)
        && (deductedInv.iron >= 0)
        && (deductedInv.water >= 0)


add : Inventory -> Cost -> Inventory
add inv cost =
    cost
        |> List.map (\( r, amt ) -> ( r, -amt ))
        |> deduct inv


deduct : Inventory -> Cost -> Inventory
deduct inv cost =
    List.foldl foldlDeductHelper inv cost


foldlDeductHelper : ( Resource, Float ) -> Inventory -> Inventory
foldlDeductHelper ( resource, amt ) inv =
    case resource of
        Mana ->
            { inv | mana = inv.mana - amt }

        Iron ->
            { inv | iron = inv.iron - amt }

        Lumber ->
            { inv | lumber = inv.lumber - amt }

        Water ->
            { inv | water = inv.water - amt }


type alias ResourcesHandler a =
    { mana : a
    , iron : a
    , lumber : a
    , water : a
    }


init : a -> ResourcesHandler a
init val =
    { mana = val
    , iron = val
    , lumber = val
    , water = val
    }


map : (Resource -> a -> b) -> ResourcesHandler a -> ResourcesHandler b
map func resources =
    { mana = func Mana resources.mana
    , iron = func Iron resources.iron
    , lumber = func Lumber resources.lumber
    , water = func Water resources.water
    }


map2 : (Resource -> a -> b -> c) -> ResourcesHandler a -> ResourcesHandler b -> ResourcesHandler c
map2 func resA resB =
    { mana = func Mana resA.mana resB.mana
    , iron = func Iron resA.iron resB.iron
    , lumber = func Lumber resA.lumber resB.lumber
    , water = func Water resA.water resB.water
    }
