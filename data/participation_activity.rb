class ParticipationActivity < OpenStruct
  ACTIVITIES = YAML.load_file('data/participation_activities.yml').map{ |v| new(v) }

  def self.all
    ACTIVITIES
  end

  def url
    id.gsub('_','-')
  end

  def partial
    super || id
  end

  def related_activities
    self.class.all.select{ |a| a.category == category}.reject{ |a| a.id == id }.first(3)
  end
end
