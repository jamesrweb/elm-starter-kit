document.addEventListener("DOMContentLoaded", async () => {
  const { default: xhook } = await import("xhook");
  const { bootstrapElmApplication } = await import("./public/scripts/elm");

  xhook.after((_, response) => {
    const isUnauthorized = response.status === 401;
    const hasLocationHeaderSet = response.headers.hasOwnProperty("location");
    const locationHeaderValue = hasLocationHeaderSet
      ? response.headers["location"] ?? ""
      : "";
    const locationHeaderIsInternal = locationHeaderValue.startsWith("/");

    if (isUnauthorized && hasLocationHeaderSet && locationHeaderIsInternal) {
      window.location.assign(locationHeaderValue);
    }
  });

  await bootstrapElmApplication();
});
