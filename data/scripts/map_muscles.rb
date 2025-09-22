## Script to map exercises to STRICT muscle group categories provided by the user.
## Outputs: data/gym_exercise_dataset_grouped.csv
##
## Rules:
## - Only categories from the user's list are allowed. If a muscle can't be mapped, assign 'N/A'.
## - Primary muscle preference: Main_muscle -> Target_Muscles first token -> Secondary Muscles first token.
## - Secondary muscle preference: Secondary Muscles -> Target_Muscles second token -> N/A.
##
## Categories allowed (exact labels):
## [ "Chest", "Upper back", "Abs", "Traps", "Front delts", "Rear delts", "Side delts", "Lats", "Upper back", "Triceps", "Biceps", "Forearms", "Lower back", "Abductors", "Adductors", "Glutes", "Hamstrings", "Quadriceps", "Calves" ]

require 'csv'

INPUT = File.expand_path(File.join(__dir__, '..', 'gym_exercise_dataset.csv'))
OUTPUT = File.expand_path(File.join(__dir__, '..', 'gym_exercise_dataset_grouped.csv'))

# Allowed categories (deduplicated and normalized to exact labels the user asked for)
ALLOWED = [
  'Chest', 'Upper back', 'Abs', 'Traps', 'Front delts', 'Rear delts', 'Side delts',
  'Lats', 'Triceps', 'Biceps', 'Forearms', 'Lower back', 'Abductors', 'Adductors',
  'Glutes', 'Hamstrings', 'Quadriceps', 'Calves'
]

# Mapping rules: regex (downcased) => category from ALLOWED
MAPPING = {
  /pectoralis|pecs|chest/ => 'Chest',
  /rectus abdominis|obliques|abdominal|abs/ => 'Abs',
  /trapezius|trap/ => 'Traps',
  /anterior deltoid|front delt|deltoid anterior|deltoid, anterior|anterior deltoid/ => 'Front delts',
  /posterior deltoid|rear delt|deltoid posterior|rear deltoid/ => 'Rear delts',
  /lateral deltoid|side delt|deltoid lateral|lateral deltoid/ => 'Side delts',
  /latissimus dorsi|lats|latissimus/ => 'Lats',
  /biceps|biceps brachii/ => 'Biceps',
  /triceps|triceps brachii/ => 'Triceps',
  /brachioradialis|forearm|wrist/ => 'Forearms',
  /erector spinae|lower back|lumbar|spinae/ => 'Lower back',
  /gluteus maximus|gluteus medius|gluteus minimus|gluteus|glutes/ => 'Glutes',
  /hamstring|biceps femoris|semitendinosus|semimembranosus/ => 'Hamstrings',
  /quadriceps|rectus femoris|vastus|quads|quadriceps femoris/ => 'Quadriceps',
  /calf|gastrocnemius|soleus/ => 'Calves',
  /adductor|adductors/ => 'Adductors',
  /abductor|abductors|gluteus medius/ => 'Abductors',
  /rhomboid|teres major|teres minor|infraspinatus|supraspinatus|rotator cuff/ => 'Upper back',
  /latissimus dorsi/ => 'Lats',
  /serratus anterior/ => 'Chest',
}

def normalize(str)
  return '' if str.nil?
  str.to_s.downcase.gsub(/[^a-z0-9, ]/, ' ').squeeze(' ').strip
end

def map_token_to_category(tok)
  return 'N/A' if tok.nil? || tok.strip.empty?
  t = normalize(tok)
  MAPPING.each do |rx, cat|
    return cat if t.match?(rx)
  end
  # last-ditch heuristics: keyword lookups
  return 'Chest' if t.include?('pec')
  return 'Front delts' if t.include?('anterior') && t.include?('deltoid')
  return 'Side delts' if t.include?('lateral') && t.include?('deltoid')
  return 'Rear delts' if t.include?('posterior') && t.include?('deltoid')
  return 'Abs' if t.include?('abdom') || t.include?('oblique')
  # fallback: N/A
  'N/A'
end

rows = []
unmapped = []

CSV.open(INPUT, headers: true) do |csv|
  csv.each do |row|
    main = row['Main_muscle']
    target = row['Target_Muscles']
    secondary_field = row['Secondary Muscles']

    primary = nil
    secondary = nil

    # Primary preference
    if main && !main.strip.empty?
      primary = map_token_to_category(main)
    end

    if (primary.nil? || primary == 'N/A') && target && !target.strip.empty?
      first = target.split(',').map(&:strip).first
      primary = map_token_to_category(first)
    end

    # Secondary preference: collect multiple matches and join with '|'
    secondary_cats = []
    if secondary_field && !secondary_field.strip.empty?
      secondary_field.split(',').map(&:strip).each do |tok|
        cat = map_token_to_category(tok)
        secondary_cats << cat unless cat == 'N/A'
      end
    end

    # Also inspect Target_Muscles tokens for additional secondary matches
    if target && !target.strip.empty?
      target.split(',').map(&:strip)[1..-1]&.each do |tok|
        next if tok.nil? || tok.empty?
        cat = map_token_to_category(tok)
        secondary_cats << cat unless cat == 'N/A'
      end
    end

    # dedupe and remove any that match the primary
    secondary_cats.map!(&:strip)
    secondary_cats.uniq!
    secondary_cats.reject! { |c| c == primary }

    primary = 'N/A' if primary.nil?
    secondary = secondary_cats.empty? ? 'N/A' : secondary_cats.join('|')

    if primary == 'N/A' && secondary == 'N/A'
      unmapped << row['Exercise Name']
    end

    row['primary_muscle'] = primary
    row['secondary_muscle'] = secondary
    rows << row
  end
end

CSV.open(OUTPUT, 'w') do |csv|
  csv << rows.first.headers
  rows.each { |r| csv << r }
end

puts "Wrote #{OUTPUT} (#{rows.size} rows)."
puts "Unmapped exercises: #{unmapped.uniq.size}"
puts unmapped.uniq.take(50).join(', ')
