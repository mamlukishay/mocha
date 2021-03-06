require 'mocha/class_method'
require 'mocha/any_instance_method'

module Mocha

  class InstanceWithIdMethod < AnyInstanceMethod

    def mock
      stubbee.instance_with_id(@stubba_id).mocha
    end

    def reset_mocha
      stubbee.any_instance.reset_mocha
    end

    def hide_original_method
      if method_exists?(method)
        begin
          @original_method = stubbee.instance_method(method)
          if @original_method && @original_method.owner == stubbee
            @original_visibility = :public
            if stubbee.protected_instance_methods.include?(method)
              @original_visibility = :protected
            elsif stubbee.private_instance_methods.include?(method)
              @original_visibility = :private
            end
            stubbee.send(:remove_method, method)
          end
        rescue NameError
          # deal with nasties like ActiveRecord::Associations::AssociationProxy
        end
      end
    end

    def define_new_method
      stubbee.class_eval(%{
        if self.id == stubbe_id
          def #{method}(*args, &block)
            self.class.instance_with_id(#{stubbe_id}).mocha.method_missing(:#{method}, *args, &block)
          end          
        end
      }, __FILE__, __LINE__)
    end

    def remove_new_method
      stubbee.send(:remove_method, method)
    end

    def restore_original_method
      if @original_method && @original_method.owner == stubbee
        stubbee.send(:define_method, method, @original_method)
        Module.instance_method(@original_visibility).bind(stubbee).call(method)
      end
    end

    def method_exists?(method)
      return true if stubbee.public_instance_methods(false).include?(method)
      return true if stubbee.protected_instance_methods(false).include?(method)
      return true if stubbee.private_instance_methods(false).include?(method)
      return false
    end

  end

end
