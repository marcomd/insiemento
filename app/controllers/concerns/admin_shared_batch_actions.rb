# app/controllers/concerns/shared_admin.rb
# Module: common methods for ActiveAdmin resources
module AdminSharedBatchActions
  extend ActiveSupport::Concern

  # See https://github.com/activeadmin/activeadmin/issues/3673
  def shared_batch_action(class_object:, selection:, transaction_name:, return_scope_if_ok: nil, return_scope_if_error: nil)
    records = class_object.find(selection)
    err, ok = [], []
    messaggio = ""
    records.each do |record|
      begin
        raise "Operazione #{transaction_name} non valida!" unless record.send("may_#{transaction_name}?")

        if record.send("#{transaction_name}!")
          ok << record.id
        else
          raise record.errors.map{|k, v| v}.join(', ')
        end
      rescue
        err << "#{record.id}: #{$!.message}"
      end
    end

    if ok.any?
      return_scope = return_scope_if_ok
      if ok.size == 1
        flash[:notice] = "Operazione eseguita per #{class_object.model_name.human} #{ok.join(', ')}"
      elsif ok.size < 5
        flash[:notice] = "Operazione eseguita per gli id: #{ok.join(', ')}"
      else
        flash[:notice] = "Operazione eseguita per #{ok.size} #{class_object.model_name.human(count: 2)}"
      end
    end
    if err.any?
      return_scope ||= return_scope_if_error
      if err.size == 1
        flash[:error] = "Operazione non eseguita per #{class_object.model_name.human} #{err.join(', ')}"
      elsif err.size < 5
        flash[:error] = "Operazione non eseguita per i seguenti id: #{err.join(' - ')}".html_safe
      else
        flash[:error] = "Operazione non eseguita per #{err.size} #{class_object.model_name.human(count: 2)}"
      end
      flash[:error] << " " << messaggio
    end

    redirect_to collection_path(scope: return_scope)
  end

end