module PgLtree
  class Options
    attr_reader :column, :cascade_update, :cascade_destroy, :scope

    def initialize(column: :path, cascade_update: true, cascade_destroy: true, cascade: nil, scope: nil)
      @column = column
      @cascade_update = cascade.nil? ? cascade_update : cascade
      @cascade_destroy = cascade.nil? ? cascade_destroy : cascade
      @scope = normalize_scope(scope)
      freeze
    end

    def [](key)
      case key
      when :column then @column
      when :cascade_update then @cascade_update
      when :cascade_destroy then @cascade_destroy
      when :scope then @scope
      end
    end

    def resolve_scope(record)
      klass = record.class
      case @scope
      when nil
        klass
      when Proc
        if @scope.arity.zero?
          klass.instance_exec(&@scope)
        else
          klass.instance_exec(record, &@scope)
        end
      when Symbol, Array
        conditions = Array(@scope).each_with_object({}) do |attr, hash|
          hash[attr] = record.public_send(attr)
        end
        klass.where(conditions)
      end
    end

    def to_h
      hash = {
        cascade_destroy: @cascade_destroy,
        cascade_update: @cascade_update,
        column: @column
      }
      hash[:scope] = @scope unless @scope.nil?
      hash
    end

    private

    def normalize_scope(scope)
      case scope
      when nil, Proc
        scope
      when Symbol, String
        scope.to_sym
      when Array
        scope.map(&:to_sym).freeze
      else
        raise ArgumentError, "Invalid ltree :scope option: #{scope.inspect}. Expected Symbol, Array<Symbol>, Proc, or nil."
      end
    end
  end
end
