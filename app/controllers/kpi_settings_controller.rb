class KpiSettingsController < ApplicationController
  before_action :set_kpi_setting, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  # GET /kpi_settings
  def index
    @kpi_settings = KpiSetting.all
  end

  # GET /kpi_settings/1
  def show
  end

  # GET /kpi_settings/new
  def new
    @kpi_setting = KpiSetting.default
  end

  # GET /kpi_settings/1/edit
  def edit
  end

  # POST /kpi_settings
  def create
    @kpi_setting = KpiSetting.new(kpi_setting_params)

    if @kpi_setting.save
      redirect_to @kpi_setting, notice: 'Kpi setting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /kpi_settings/1
  def update
    if @kpi_setting.update(kpi_setting_params)
      redirect_to @kpi_setting, notice: 'Kpi setting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /kpi_settings/1
  def destroy
    @kpi_setting.destroy
    redirect_to kpi_settings_url, notice: 'Kpi setting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kpi_setting
      @kpi_setting = KpiSetting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def kpi_setting_params
      params.require(:kpi_setting).permit!
    end
end
