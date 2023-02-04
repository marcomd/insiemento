# app/controllers/concerns/shared_admin.rb
# Module: common methods for ActiveAdmin resources
module AdminSharedBatchActions
  extend ActiveSupport::Concern

  # See https://github.com/activeadmin/activeadmin/issues/3673
  def shared_batch_action(class_object:, action_name:, selection: nil, records: nil, is_transaction: false, return_scope_if_ok: nil, return_scope_if_error: nil)
    raise('Please set selection ids or records param!') unless selection || records

    records ||= class_object.find(selection)
    err = []
    ok = []
    messaggio = ''
    records.each do |record|
      raise("Operazione #{action_name} non valida!") if is_transaction && !record.send("may_#{action_name}?")

      raise(record.errors.map { |e| e.message }.join(', ')) unless record.send("#{action_name}!")
      ok << record.id

    rescue StandardError
      message = record.errors.map { |e| e.message }.join(', ') if record.errors.present?
      err << "#{record.id}: #{message || $!.message}"
    end

    if ok.any?
      return_scope = return_scope_if_ok
      flash[:notice] = if ok.size == 1
                         "Operazione eseguita per #{class_object.model_name.human} #{ok.join(', ')}"
                       elsif ok.size < 5
                         "Operazione eseguita per gli id: #{ok.join(', ')}"
                       else
                         "Operazione eseguita per #{ok.size} #{class_object.model_name.human(count: 2)}"
                       end
    end
    if err.any?
      return_scope ||= return_scope_if_error
      flash[:error] = if err.size == 1
                        "Operazione non eseguita per #{class_object.model_name.human} #{err.join(', ')}"
                      elsif err.size < 5
                        "Operazione non eseguita per i seguenti id: #{err.join(' - ')}".html_safe
                      else
                        "Operazione non eseguita per #{err.size} #{class_object.model_name.human(count: 2)}"
                      end
      flash[:error] << ' ' << messaggio
    end

    redirect_to(collection_path(scope: return_scope))
  end
end
