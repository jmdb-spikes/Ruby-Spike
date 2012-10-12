class ApplicantsController < ApplicationController
  #modify these actions to redirect to post
  
  
  # GET /applicants
  # GET /applicants.json
  def index
    @applicants = Applicant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @applicants }
    end
  end

  # GET /applicants/1
  # GET /applicants/1.json
  def show
    resource = RestClient.get 'http://localhost:3001/applicants/1.json'
    resource_hash = JSON.parse(resource)
    p 'RESOURCE: ', resource_hash
    
    @applicant = Applicant.new
    @applicant.firstname = resource_hash['firstname']
    @applicant.lastname = resource_hash['lastname']
    @applicant.age = resource_hash['age']
    @applicant.claimDate = resource_hash['claimDate']
    @applicant.id = resource_hash['id']
    
    respond_to do |format|
      format.html #show.html.erb
      format.json { render json: @applicant }
    end
  end

  # GET /applicants/new
  # GET /applicants/new.json
  def new
    @applicant = Applicant.new
    respond_to do |format|
      format.html #new.html.erb
      format.json { render json: @applicant }
    end
  end

  # GET /applicants/1/edit
  def edit
    @applicant = Applicant.find(params[:id])
  end

  # POST /applicants
  # POST /applicants.json
  def create
    @applicant = Applicant.new(params[:applicant])

    respond_to do |format|
      if @applicant.save
        format.html { redirect_to @applicant, notice: 'Applicant was successfully created.' }
        format.json { render json: @applicant, status: :created, location: @applicant }
      else
        format.html { render action: "new" }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /applicants/1
  # PUT /applicants/1.json
  def update
    puts params[:applicant]
    @applicant = Applicant.find(params[:id])
    
    begin
      respond_to do |format|
        if @applicant.update_attributes(params[:applicant])
          format.html { redirect_to @applicant, notice: 'Applicant was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @applicant.errors, status: :unprocessable_entity }
        end
      end
    rescue => e
      p e
      p e.message
      p "AN ERROR WAS THROWN"
    end
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.json
  def destroy
    @applicant = Applicant.find(params[:id])
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to applicants_url }
      format.json { head :no_content }
    end
  end
end
