defmodule CompanyChallengeWeb.ErrorView do
  use CompanyChallengeWeb, :view

  def render("400.json", %{errors: :missing_params}) do
    %{
      "message" => "Bad request",
      "errors" => "missing parameters"
    }
  end

  def render("400.json", %{errors: errors}) do
    %{
      "message" => "Bad request",
      "errors" => errors
    }
  end

  def render("401.json", %{errors: errors}) do
    %{
      "message" => "Unauthorized",
      "errors" => errors
    }
  end

  def render("404.json", %{errors: :resource_not_found}) do
    %{
      "message" => "Not found",
      "errors" => "resource not found"
    }
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
