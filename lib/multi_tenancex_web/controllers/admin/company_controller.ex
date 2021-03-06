defmodule MultiTenancexWeb.Admin.CompanyController do
  use MultiTenancexWeb, :controller

  alias MultiTenancex.Companies
  alias MultiTenancex.Companies.Company

  def index(conn, _params) do
    companies = Companies.list_companies(conn.assigns.current_tenant)
    render(conn, "index.html", companies: companies)
  end

  def new(conn, _params) do
    changeset = Companies.change_company(%Company{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"company" => company_params}) do
    case Companies.create_company(company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: admin_company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get_company!(id, conn.assigns.current_tenant)
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Companies.get_company!(id, conn.assigns.current_tenant)
    changeset = Companies.change_company(company)
    render(conn, "edit.html", company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Companies.get_company!(id, conn.assigns.current_tenant)

    case Companies.update_company(
           company,
           company_params,
           conn.assigns.current_tenant
         ) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: admin_company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Companies.get_company!(id, conn.assigns.current_tenant)

    {:ok, _company} =
      Companies.delete_company(company, conn.assigns.current_tenant)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: admin_company_path(conn, :index))
  end
end
