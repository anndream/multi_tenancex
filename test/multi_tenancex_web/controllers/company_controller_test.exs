defmodule MultiTenancexWeb.CompanyControllerTest do
  use MultiTenancexWeb.ConnCase

  alias MultiTenancex.Companies

  @create_attrs %{
    description: "some description",
    image: "some image",
    name: "some name",
    slug: "some slug"
  }
  @update_attrs %{
    description: "some updated description",
    image: "some updated image",
    name: "some updated name",
    slug: "some updated slug"
  }
  @invalid_attrs %{description: nil, image: nil, name: nil, slug: nil}

  def fixture(:company) do
    {:ok, company} = Companies.create_company(@create_attrs)
    company
  end

  describe "index" do
    test "lists all companies", %{conn: conn} do
      conn = get(conn, admin_company_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Companies"
    end
  end

  describe "new company" do
    test "renders form", %{conn: conn} do
      conn = get(conn, admin_company_path(conn, :new))
      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "create company" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post(conn, admin_company_path(conn, :create), company: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_company_path(conn, :show, id)

      conn = get(conn, admin_company_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Company"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, admin_company_path(conn, :create), company: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "edit company" do
    setup [:create_company]

    test "renders form for editing chosen company", %{
      conn: conn,
      company: company
    } do
      conn = get(conn, admin_company_path(conn, :edit, company))
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "update company" do
    setup [:create_company]

    test "redirects when data is valid", %{conn: conn, company: company} do
      conn =
        put(
          conn,
          admin_company_path(conn, :update, company),
          company: @update_attrs
        )

      assert redirected_to(conn) == admin_company_path(conn, :show, company)

      conn = get(conn, admin_company_path(conn, :show, company))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn =
        put(
          conn,
          admin_company_path(conn, :update, company),
          company: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{conn: conn, company: company} do
      conn = delete(conn, admin_company_path(conn, :delete, company))
      assert redirected_to(conn) == admin_company_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, admin_company_path(conn, :show, company))
      end)
    end
  end

  defp create_company(_) do
    company = fixture(:company)
    {:ok, company: company}
  end
end
