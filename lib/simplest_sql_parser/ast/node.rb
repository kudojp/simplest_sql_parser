module AST
  class Node # used as an abstract class
    # This should be overwritten in each node if necessary.
    def list_attributes_without_child
      []
      # ["attr1", "attr2"]
    end

    # This should be overwritten in each node if necessary.
    def list_attributes_of_single_child_node
      []
      # [:attr3, attr4]
    end

    # This should be overwritten in each node if necessary.
    def list_attributes_of_multiple_child_nodes
      []
      # [:attr5, attr6]
    end

    # used for debugging.
    def self_and_descendants
      attributes = list_attributes_without_child.map{|attr_sym| "#{attr_sym}=#{self.send(attr_sym)}"}.join ","

      descendants = {}

      list_attributes_of_single_child_node.each do |attr_sym|
        descendants[attr_sym.to_s] = self.send(attr_sym)&.self_and_descendants
      end

      list_attributes_of_multiple_child_nodes.each do |attr_sym|
        descendants[attr_sym.to_s] = self.send(attr_sym).map{|attribute| attribute&.self_and_descendants}
      end

      { "#{self.class}(#{attributes})" => descendants }
    end
  end
end

=begin
QueryNode.new
  @select: SelectStatementNode.new
    @columns: Array.new
      - SelectedColumnNode.new   # name
          @alias_name: String.new
          @col_def: ColumnNode.new
            @type: :single_col
            @name: "name"
      - SelectedColumnNode.new   # *
          @alias_name: String.new
          @col_def: ColumnNode.new
            @type: :asterisk
            @name: nil
      - SelectedColumnNode.new   # COUNT(name)
          @alias_name: String.new
          @col_def: FunctionNode.new
            @type: :count
            @args: Array.new
              - ColumnNode.new
                @type: :single_col
                @name: "name"
  @from: FromStatementNode.new
    @table: TableNode.new
      @table_def: ExpressionNode.new
      @alias_name: String.new
 @where: WhereStatementNode.new
    @predicate: EqualsPredicateNode.new (< PredicateNode)
      @left: ExpressionNode.new
      @right: ExpressionNode.new

Maybe,,
- I should create separate classes for each ExpressionNode depending on where it is used??
- I should create a parent class `StatementNode` for SelectStatementNode, FromStatementNode, and WhereStatementNode.
=end
