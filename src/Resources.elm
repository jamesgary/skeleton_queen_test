module Resources exposing (Cost, Inventory, Resource(..), add, canAfford, deduct)


type Resource
    = Mana
    | Iron
    | Lumber
    | Water


allResources =
    [ Mana, Iron, Lumber, Water ]


type alias Inventory =
    { mana : Float
    , iron : Float
    , lumber : Float
    , water : Float
    }


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
