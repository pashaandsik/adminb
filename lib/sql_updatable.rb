# frozen_string_literal: true
module SQLUpdatable
  def sql_update!(updates)
    conn = self.class.connection

    if self.class.column_names.include?("updated_at")
      updates["updated_at"] ||= conn.quote(Time.zone.now)
    end

    updates_sql = updates.map do |attr, value|
      "#{conn.quote_column_name(attr)} = #{value}"
    end

    sql = "UPDATE #{self.class.table_name} SET #{updates_sql.join(", ")} " \
          "WHERE id = #{id.to_i} RETURNING *"

    new_attributes = conn.execute(sql).first or return false

    updates.keys.each do |attr|
      send("#{attr}=", new_attributes[attr.to_s])
      clear_attribute_changes(attr.to_s)
    end

    true
  end
end
