class VirtualTable
  include ActiveModel::Conversion
  include ActiveModel::Model

  def new_record?
    false
  end

  def _destroy
    false
  end

  def attributes(ar_variables = instance_variables)
    ar_variables.to_h { |a| [a.to_s.gsub('@', ''), instance_variable_get(a)] }
  end

  def to_json(*_args)
    attributes.to_json
  end

  class << self
    delegate :first, :last, to: :all

    def all
      @all ||= load_all
    end

    def find(id)
      id = id.to_i
      all.detect { |record| record.id == id } || raise(ActiveRecord::RecordNotFound)
    end

    def count
      all.size
    end

    def find_by_name(name)
      name = name.to_s
      all.detect { |record| record.name == name }
    end

    def find_by_id(id)
      id = id.to_i
      all.detect { |record| record.id == id }
    end

    def where(attributes)
      all.philter(attributes)
    end

    private

    def load_all
      all = []
      UserDocumentModel.all.find_each do |document|
        all.concat(document.sign_points)
        # all << new({ document_id: document.id }.merge data)
      end
      all
    end
  end
end
