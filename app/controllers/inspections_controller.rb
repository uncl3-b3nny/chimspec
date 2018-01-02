# encoding : utf-8


class InspectionsController < BeautifulController

  before_action :load_inspection, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session['fields'] ||= {}
    session['fields']['inspection'] ||= (Inspection.columns.map(&:name) - ["id"])[0..4]
    do_select_fields('inspection')
    do_sort_and_paginate('inspection')
    
    @q = Inspection.ransack(
      params[:q]
    )

    @inspection_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @inspection_scope_for_scope = @inspection_scope.dup
    
    unless params[:scope].blank?
      @inspection_scope = @inspection_scope.send(params[:scope])
    end
    
    @inspections = @inspection_scope.paginate(
      :page => params[:page],
      :per_page => 20
    ).to_a

    respond_to do |format|
      format.html{
        render
      }
      format.json{
        render :json => @inspection_scope.to_a
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Inspection.attribute_names
          @inspection_scope.to_a.each{ |o|
            csv << Inspection.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @inspection_scope.to_a
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Inspection,@inspection_scope)
        send_data pdfcontent
      }
    end
  end

  def show
    respond_to do |format|
      format.html{
        render
      }
      format.json { render :json => @inspection }
    end
  end

  def new
    @inspection = Inspection.new

    respond_to do |format|
      format.html{
        render
      }
      format.json { render :json => @inspection }
    end
  end

  def edit
    
  end

  def create
    @inspection = Inspection.new(params_for_model)

    respond_to do |format|
      if @inspection.save
        format.html {
          if params[:mass_inserting] then
            redirect_to inspections_path(:mass_inserting => true)
          else
            redirect_to inspection_path(@inspection), :flash => { :notice => t(:create_success, :model => "inspection") }
          end
        }
        format.json { render :json => @inspection, :status => :created, :location => @inspection }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to inspections_path(:mass_inserting => true), :flash => { :error => t(:error, "Error") }
          else
            render :action => "new"
          end
        }
        format.json { render :json => @inspection.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @inspection.update_attributes(params_for_model)
        format.html { redirect_to inspection_path(@inspection), :flash => { :notice => t(:update_success, :model => "inspection") }}
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @inspection.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @inspection.destroy

    respond_to do |format|
      format.html { redirect_to inspections_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @inspections = []    
    
    Inspection.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:inspection)

        @inspections = Inspection.ransack(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @inspections = Inspection.find(params[:ids].to_a)
      end

      @inspections.each{ |inspection|
        if not Inspection.columns_hash[attr_or_method].nil? and
               Inspection.columns_hash[attr_or_method].type == :boolean then
         inspection.update_attribute(attr_or_method, boolean(value))
         inspection.save
        else
          case attr_or_method
          # Set here your own batch processing
          # inspection.save
          when "destroy" then
            inspection.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Inspection
    foreignkey = :inspection_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_inspection
    @inspection = Inspection.find(params[:id])
  end

  def params_for_model
    params.require(:inspection).permit(Inspection.permitted_attributes)
  end
end

