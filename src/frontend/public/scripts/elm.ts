export async function bootstrapElmApplication() {
  // @ts-expect-error
  const { Elm } = await import("../../app/Main.elm");

  Elm.Main.init({
    node: document.getElementById("root"),
    flags: {},
  });
}
