module Page.Slug_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerenderedRoute
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    DataSource.map2 (++) rootFilesMd nestedFilesMd


rootFilesMd : DataSource (List RouteParams)
rootFilesMd =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "../content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


nestedFilesMd : DataSource (List RouteParams)
nestedFilesMd =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "../content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal "/index.md")
        |> Glob.toDataSource


helloRoute : DataSource RouteParams
helloRoute =
    RouteParams "hello"
        |> DataSource.succeed


data : RouteParams -> DataSource Data
data routeParams =
    -- DataSource.succeed { markdown = "# Hello" }
    DataSource.File.request ("../content/blog/" ++ routeParams.slug ++ ".md") DataSource.File.body
        |> DataSource.map Data


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
    { markdown : String
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    View.placeholder ("You are on the " ++ static.routeParams.slug ++ " page (" ++ static.data.markdown ++ ")")
