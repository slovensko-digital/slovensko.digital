class ParticipationActivity < OpenStruct
  ACTIVITIES = YAML.load_file('data/participation_activities.yml').map{ |v| new(v) }

  def self.all
    ACTIVITIES
  end

  def url
    id.gsub('_','-')
  end
end
