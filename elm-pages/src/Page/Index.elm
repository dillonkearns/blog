module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html exposing (Html)
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Posts
import Route exposing (Route)
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    Posts.all
        |> DataSource.andThen
            (List.map
                (\{ slug, filePath } ->
                    DataSource.File.bodyWithFrontmatter
                        blogPostDecoder
                        filePath
                        |> DataSource.map
                            (\{ title, body } ->
                                { title = title
                                , route = Route.Slug_ { slug = slug }
                                , date = "Yesterday"
                                , excerpt = String.left 80 body ++ "..."
                                }
                            )
                )
                >> DataSource.combine
            )


blogPostDecoder : String -> Decoder { title : String, body : String }
blogPostDecoder body =
    Decode.map (\title -> { title = title, body = body })
        (Decode.field "title" Decode.string)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    List BlogEntry


type alias BlogEntry =
    { title : String
    , route : Route
    , date : String
    , excerpt : String
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Placeholder"
    , body = List.map viewBlogEntry static.data
    }


viewBlogEntry : BlogEntry -> Html msg
viewBlogEntry blogEntry =
    Html.article []
        [ Route.link blogEntry.route [] [ Html.text blogEntry.title ]
        , Html.span [] [ Html.text blogEntry.date ]
        , Html.p [] [ Html.text blogEntry.excerpt ]
        ]
