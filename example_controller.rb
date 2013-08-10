class ExampleController < CommonAPIController

  # route /api/<method> here

  def peek
    record = Thing.find(params[:id])
    render :json => record
  end

  def poke
    record = Thing.find(params[:id])
    record.value = params[:value]
    record.save!
    head 200
  end

end
