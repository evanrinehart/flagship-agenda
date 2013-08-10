class ExampleController < CommonAPIController

  # route /api/<method> here

  def peek
    record = Thing.find(params[:id])
    send_data record.to_json
  end

  def poke
    record = Thing.find(params[:id])
    record.value = params[:value]
    record.save!
    head 200
  end

end
