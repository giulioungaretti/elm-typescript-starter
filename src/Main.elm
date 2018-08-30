port module Main exposing (main)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (contenteditable)
import Html.Events exposing (onWithOptions)
import Json.Decode as Decode


port hello : String -> Cmd msg


port reply : (String -> msg) -> Sub msg


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, hello "World" )


type Msg
    = NoOp
    | KeyDown
    | MouseUp
    | MouseOver MouseEvent
    | MouseDown
    | ReplyReceived String


type alias MouseEvent =
    { target : Decode.Value
    }


mouseEventDecoder : Decode.Decoder MouseEvent
mouseEventDecoder =
    Decode.map MouseEvent
        (Decode.field "event" Decode.value)



-- keyDecoder : Decode.Decoder Msg
-- keyDecoder =
--     MouseOver
--         (Decode.map
--             MouseEvent
--             (Decode.field "event" Decode.value)
--         )


view : Model -> Html Msg
view model =
    div
        [ contenteditable True
        , onWithOptions "keydown"
            { preventDefault = True, stopPropagation = True }
            (Decode.succeed
                KeyDown
            )
        , onWithOptions "mouseover"
            { preventDefault = False, stopPropagation = True }
            (mouseEventDecoder)
        , onWithOptions "mouseup"
            { preventDefault = False, stopPropagation = True }
            (Decode.succeed
                MouseUp
            )
        , onWithOptions "mousedown"
            { preventDefault = False, stopPropagation = True }
            (Decode.succeed
                MouseDown
            )
        ]
        [ text "Some text "
        , div [] [ text "some thing else" ]
        , text "more text"
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        KeyDown ->
            ( model, Cmd.none )

        MouseOver _ ->
            ( model, Cmd.none )

        MouseUp ->
            ( model, Cmd.none )

        MouseDown ->
            ( model, Cmd.none )

        ReplyReceived message ->
            ( model, hello message )


subscriptions : Model -> Sub Msg
subscriptions model =
    reply ReplyReceived


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
