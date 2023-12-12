use http::{Response, StatusCode};
use spin_sdk::{
    http::{IntoResponse, Method, Request},
    http_component,
    key_value::Store,
};

/// Fermyon advent-of-spin 2023, challenge 1
#[http_component]
fn handle_aos_chal_one(req: Request) -> anyhow::Result<impl IntoResponse> {
    let store = Store::open_default()?;

    Ok(match *req.method() {
        Method::Get => match store.get(req.uri())? {
            Some(value) => Response::builder()
                .status(StatusCode::OK)
                .header("content-type", "application/json")
                .body(Some(value))?,
            None => Response::builder()
                .status(StatusCode::NOT_FOUND)
                .body(None)?,
        },
        Method::Post => {
            store.set(req.uri(), req.body())?;
            Response::builder().status(StatusCode::CREATED).body(None)?
        }
        _ => Response::builder()
            .status(StatusCode::NOT_FOUND)
            .body(None)?,
    })
}
