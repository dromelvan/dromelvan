class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :sanitize_devise_parameters, if: :devise_controller?
  before_action :authorize_administrator, only: [:new, :create, :edit, :update, :delete]

  helper_method :administrator_signed_in?

  rescue_from ActiveRecord::RecordNotFound do |exception|
    not_found
  end

  def index
    respond_to do |format|
      format.html do
        resources = controller_name.classify.constantize.all
        self.instance_variable_set "@#{controller_name.tableize}", resources
      end
      format.json do
        datatable_class_name = controller_name.classify.pluralize + "Datatable"
        render json:  datatable_class_name.constantize.new(view_context, ajax_params)
      end
    end
  end

  def show
    resource = controller_name.classify.constantize.find(params[:id])
    self.instance_variable_set "@#{controller_name.tableize.singularize}", resource
    if request.xhr?
      render layout: "../#{controller_name.tableize}/tooltip"
    end
  end

  def new
    resource = controller_name.classify.constantize.new
    self.instance_variable_set "@#{controller_name.tableize.singularize}", resource
  end

  def create
    resource = self.instance_variable_get "@#{controller_name.tableize.singularize}"
    if !resource.nil?
      resource.update_attributes(resource_params)
    else
      resource = controller_name.classify.constantize.new(resource_params)
      self.instance_variable_set "@#{controller_name.tableize.singularize}", resource
    end

    if resource.save
      flash[:success] = "#{resource.class.name.humanize} created."
      redirect_to resource
    else
      flash[:validation_errors] = resource
      render :new
    end
  end

  def edit
    resource = controller_name.classify.constantize.find(params[:id])
    self.instance_variable_set "@#{controller_name.tableize.singularize}", resource
  end

  def update
    resource = self.instance_variable_get "@#{controller_name.tableize.singularize}"
    if resource.nil?
      resource = controller_name.classify.constantize.find(params[:id])
    end

    if resource.update_attributes(resource_params)
      flash[:success] = "#{resource.class.name.humanize} updated."
      redirect_to resource
    else
      flash[:validation_errors] = resource
      render :edit
    end
  end

  def destroy
    controller_name.classify.constantize.find(params[:id]).destroy
    flash[:success] = "#{controller_name.singularize.humanize} deleted."
    redirect_to url_for(action: :index)
  end

  def administrator_signed_in?
    current_user.try(:administrator?)
  end

  def ajax_params
    {}
  end

  protected
    def sanitize_devise_parameters
       devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
       devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
    end

  private
    def not_found
      render template: 'errors/not_found', status: :not_found
    end

    def authorize_administrator
      not_found unless administrator_signed_in? || devise_controller?
    end
end
