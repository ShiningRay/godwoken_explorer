defmodule GodwokenExplorerWeb.ErrorView do
  use GodwokenExplorerWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def render("404.json", _assigns) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{
      errors:  %{
        status: "404",
        title: "not found",
        detail: ""
      }
    }
  end
end
