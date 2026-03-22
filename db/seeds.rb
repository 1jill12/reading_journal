# Idempotent — safe to run multiple times
# Run with: bin/rails db:seed

# ── Tropes ──────────────────────────────────────────────────────────────────
ALL_TROPES = [
  # Romantasy
  'Ancient Curse', 'Chosen Family', 'Chosen One', 'Enemies to Lovers',
  'Fae/Fair Folk', 'Fake Dating', 'Forced Proximity', 'Forbidden Romance',
  'Found Family', 'Grumpy x Sunshine', 'Hidden Identity', 'Love Triangle',
  'Magic System', 'Morally Grey Love Interest', 'Prophecy', 'Redemption Arc',
  'Rivals to Lovers', 'Second Chance Romance', 'Slow Burn', 'Touch Starved',
  # Thriller
  'Cold Case', 'Conspiracy', 'Corrupt Institution', 'Dark Secret',
  'Double Cross', 'False Accusation', 'Femme Fatale', 'Locked Room Mystery',
  'Missing Person', 'Murder Mystery', 'Psychological Manipulation',
  'Race Against Time', 'Red Herring', 'Rival Investigators', 'Serial Killer',
  'Unreliable Memory', 'Unreliable Narrator', 'Whodunit', 'Wrong Place Wrong Time',
  # Dark Academia
  'Class Divide', 'Elite School', 'Forbidden Knowledge', 'Gothic Setting',
  'Moral Ambiguity', 'Obsessive Friendship', 'Plot Twist', 'Rivalry',
  'Secret Society', 'Unrequited Love',
  # General
  'Coming of Age', 'Portal Fantasy', 'Reluctant Hero', 'Revenge Plot',
  'The Mentor Dies', 'Unlikely Allies'
].sort.freeze

ALL_TROPES.each do |name|
  Trope.find_or_create_by!(name: name)
end

puts "Seeded #{Trope.count} tropes"

# ── Bingo Cards ──────────────────────────────────────────────────────────────
BINGO_CARDS = [
  {
    title: 'Romantasy Bingo',
    description: 'Track the most beloved tropes from your favourite romantic fantasy reads.',
    theme: 'romantasy',
    tropes: [
      'Enemies to Lovers', 'Fake Dating', 'Slow Burn', 'Forbidden Romance',
      'Found Family', 'Fae/Fair Folk', 'Magic System', 'Prophecy',
      'Second Chance Romance', 'Love Triangle', 'Grumpy x Sunshine',
      'Touch Starved', 'Morally Grey Love Interest', 'Forced Proximity',
      'Chosen One', 'Redemption Arc', 'Rivals to Lovers', 'Hidden Identity',
      'Unlikely Allies', 'Portal Fantasy', 'Revenge Plot', 'Dark Secret',
      'Ancient Curse', 'Unrequited Love', 'Chosen Family'
    ]
  },
  {
    title: 'Thriller Bingo',
    description: 'Mark off the tension-building tropes as you race through your thrillers.',
    theme: 'thriller',
    tropes: [
      'Unreliable Narrator', 'Plot Twist', 'Red Herring', 'Missing Person',
      'Corrupt Institution', 'Locked Room Mystery', 'Race Against Time',
      'Hidden Identity', 'Double Cross', 'Dark Secret',
      'Psychological Manipulation', 'Serial Killer', 'Whodunit',
      'Femme Fatale', 'Unreliable Memory', 'Rival Investigators',
      'False Accusation', 'Cold Case', 'Conspiracy', 'Wrong Place Wrong Time',
      'Revenge Plot', 'Forbidden Knowledge', 'Moral Ambiguity',
      'Secret Society', 'Murder Mystery'
    ]
  },
  {
    title: 'Dark Academia Bingo',
    description: 'Dust off your tweed jacket and track the tropes of scholarly darkness.',
    theme: 'dark_academia',
    tropes: [
      'Secret Society', 'Forbidden Knowledge', 'Gothic Setting',
      'Obsessive Friendship', 'Class Divide', 'Rivalry', 'Ancient Curse',
      'Unrequited Love', 'Elite School', 'Moral Ambiguity', 'Murder Mystery',
      'Coming of Age', 'Enemies to Lovers', 'The Mentor Dies', 'Dark Secret',
      'Hidden Identity', 'Redemption Arc', 'Chosen One', 'Found Family',
      'Psychological Manipulation', 'Corrupt Institution', 'Unlikely Allies',
      'Double Cross', 'Slow Burn', 'Revenge Plot'
    ]
  },
  {
    title: 'General Reading Bingo',
    description: 'A catch-all card for every genre. Perfect for your eclectic reading life.',
    theme: 'neutral',
    tropes: [
      'Found Family', 'Redemption Arc', 'Coming of Age', 'Chosen One',
      'Reluctant Hero', 'Love Triangle', 'The Mentor Dies', 'Hidden Identity',
      'Enemies to Lovers', 'Slow Burn', 'Plot Twist', 'Moral Ambiguity',
      'Unlikely Allies', 'Second Chance Romance', 'Dark Secret',
      'Revenge Plot', 'Forbidden Romance', 'Secret Society', 'Ancient Curse',
      'Obsessive Friendship', 'Portal Fantasy', 'Grumpy x Sunshine',
      'Forced Proximity', 'Unreliable Narrator', 'Chosen Family'
    ]
  }
].freeze

BINGO_CARDS.each do |card_data|
  card = BingoCard.find_or_create_by!(title: card_data[:title]) do |c|
    c.description = card_data[:description]
    c.theme       = card_data[:theme]
  end

  card_data[:tropes].each_with_index do |trope, index|
    BingoSquare.find_or_create_by!(bingo_card: card, position: index) do |square|
      square.trope_name = trope
      square.free_space = (index == 12)
    end
  end

  puts "Seeded: #{card.title} (#{card.bingo_squares.count} squares)"
end

# ── Romantasy Books ───────────────────────────────────────────────────────────
ROMANTASY_BOOKS = [
  {
    title: 'A Court of Thorns and Roses',
    author: 'Sarah J Maas',
    genre: 'Fantasy',
    spice_rating: 3,
    description: 'A young huntress is taken to a magical land after killing a wolf in the woods.',
    tropes: ['Enemies to Lovers', 'Fae/Fair Folk', 'Forbidden Romance', 'Slow Burn']
  },
  {
    title: 'A Court of Mist and Fury',
    author: 'Sarah J Maas',
    genre: 'Fantasy',
    spice_rating: 4,
    description: 'Feyre discovers the dangerous truths about the Night Court and its High Lord.',
    tropes: ['Enemies to Lovers', 'Slow Burn', 'Found Family', 'Morally Grey Love Interest']
  },
  {
    title: 'Fourth Wing',
    author: 'Rebecca Yarros',
    genre: 'Fantasy',
    spice_rating: 4,
    description: 'A young woman enters a brutal war college to become a dragon rider.',
    tropes: ['Enemies to Lovers', 'Forced Proximity', 'Magic System', 'Forbidden Romance']
  },
  {
    title: 'Iron Flame',
    author: 'Rebecca Yarros',
    genre: 'Fantasy',
    spice_rating: 4,
    description: 'Violet Sorrengail returns for her second year at Basgiath War College.',
    tropes: ['Enemies to Lovers', 'Forbidden Romance', 'Magic System', 'Chosen One']
  },
  {
    title: 'From Blood and Ash',
    author: 'Jennifer L Armentrout',
    genre: 'Fantasy',
    spice_rating: 5,
    description: 'A young maiden chosen by the gods falls for her guard.',
    tropes: ['Forbidden Romance', 'Forced Proximity', 'Hidden Identity', 'Slow Burn']
  },
  {
    title: 'A Kingdom of the Wicked',
    author: 'Kerri Maniscalco',
    genre: 'Fantasy',
    spice_rating: 3,
    description: 'A Sicilian girl summons a demon prince to solve her twin sister\'s murder.',
    tropes: ['Enemies to Lovers', 'Dark Secret', 'Forbidden Romance', 'Morally Grey Love Interest']
  },
  {
    title: 'The Bridge Kingdom',
    author: 'Danielle L Jensen',
    genre: 'Fantasy',
    spice_rating: 4,
    description: 'A princess sent to spy on the king she\'s been raised to hate.',
    tropes: ['Enemies to Lovers', 'Forbidden Romance', 'Hidden Identity', 'Slow Burn']
  },
  {
    title: 'Crescent City: House of Earth and Blood',
    author: 'Sarah J Maas',
    genre: 'Fantasy',
    spice_rating: 4,
    description: 'Half-Fae, half-human Bryce investigates a string of murders in a modern city.',
    tropes: ['Found Family', 'Slow Burn', 'Magic System', 'Second Chance Romance']
  },
  {
    title: 'The Cruel Prince',
    author: 'Holly Black',
    genre: 'Fantasy',
    spice_rating: 2,
    description: 'A human girl raised among faeries yearns for a place in their world.',
    tropes: ['Enemies to Lovers', 'Fae/Fair Folk', 'Forbidden Romance', 'Rivals to Lovers']
  },
  {
    title: 'Kingdom of the Wicked',
    author: 'Kerri Maniscalco',
    genre: 'Fantasy',
    spice_rating: 3,
    description: 'An Italian girl who summons a demon to hunt down her sister\'s murderer.',
    tropes: ['Enemies to Lovers', 'Morally Grey Love Interest', 'Dark Secret', 'Forbidden Romance']
  },
  {
    title: 'Flame in the Mist',
    author: 'Renée Ahdieh',
    genre: 'Fantasy',
    spice_rating: 2,
    description: 'A Japanese noblewoman survives an attack and disguises herself as a boy.',
    tropes: ['Hidden Identity', 'Fake Dating', 'Forbidden Romance', 'Slow Burn']
  },
  {
    title: 'The Midnight Library',
    author: 'Matt Haig',
    genre: 'Fantasy',
    spice_rating: 1,
    description: 'A library between life and death where every book is a different life you could have lived.',
    tropes: ['Second Chance Romance', 'Coming of Age', 'Redemption Arc']
  },
  {
    title: 'Daughter of the Moon Goddess',
    author: 'Sue Lynn Tan',
    genre: 'Fantasy',
    spice_rating: 2,
    description: 'A young woman embarks on a quest to free her mother from an immortal\'s curse.',
    tropes: ['Chosen One', 'Found Family', 'Ancient Curse', 'Forbidden Romance']
  },
  {
    title: 'An Ember in the Ashes',
    author: 'Sabaa Tahir',
    genre: 'Fantasy',
    spice_rating: 3,
    description: 'A slave and a soldier find themselves on opposite sides of a brutal world.',
    tropes: ['Enemies to Lovers', 'Forbidden Romance', 'Forced Proximity', 'Slow Burn']
  },
  {
    title: 'The Name of the Wind',
    author: 'Patrick Rothfuss',
    genre: 'Fantasy',
    spice_rating: 2,
    description: 'The story of the magically gifted young man who grows to be the most notorious wizard.',
    tropes: ['Chosen One', 'Magic System', 'Coming of Age', 'Reluctant Hero']
  },
  {
    title: 'Nona the Ninth',
    author: 'Tamsyn Muir',
    genre: 'Fantasy',
    spice_rating: 2,
    description: 'The world is collapsing — but Nona just wants to go to school.',
    tropes: ['Found Family', 'Unlikely Allies', 'Chosen One', 'Dark Secret']
  },
  {
    title: 'Serpent and Dove',
    author: 'Shelby Mahurin',
    genre: 'Fantasy',
    spice_rating: 3,
    description: 'A witch and a witch hunter are forced into marriage.',
    tropes: ['Enemies to Lovers', 'Fake Dating', 'Forbidden Romance', 'Forced Proximity']
  },
  {
    title: 'Once a Rogue',
    author: 'Once A Rogue',
    genre: 'Romance',
    spice_rating: 4,
    description: 'A roguish lord meets his match in a sharp-tongued lady.',
    tropes: ['Enemies to Lovers', 'Fake Dating', 'Slow Burn', 'Grumpy x Sunshine']
  },
  {
    title: 'In a Holidaze',
    author: 'Christina Lauren',
    genre: 'Romance',
    spice_rating: 2,
    description: 'A woman finds herself in a holiday time loop.',
    tropes: ['Second Chance Romance', 'Grumpy x Sunshine', 'Forced Proximity']
  },
  {
    title: 'The Jasad Heir',
    author: 'Sara Hashem',
    genre: 'Fantasy',
    spice_rating: 3,
    description: 'A princess in hiding is forced to compete in deadly trials with her enemy.',
    tropes: ['Enemies to Lovers', 'Hidden Identity', 'Forbidden Romance', 'Magic System', 'Slow Burn']
  },
  {
    title: 'Bride',
    author: 'Ali Hazelwood',
    genre: 'Fantasy',
    spice_rating: 4,
    description: 'A vampire is married off to a werewolf in a political match.',
    tropes: ['Enemies to Lovers', 'Forbidden Romance', 'Fake Dating', 'Touch Starved']
  },
  {
    title: 'House of Salt and Sorrows',
    author: 'Erin A Craig',
    genre: 'Fantasy',
    spice_rating: 2,
    description: 'A dark retelling of the Twelve Dancing Princesses.',
    tropes: ['Dark Secret', 'Ancient Curse', 'Forbidden Romance', 'Gothic Setting']
  }
].freeze

ROMANTASY_BOOKS.each do |book_data|
  trope_names = book_data.delete(:tropes)

  book = Book.find_or_initialize_by(title: book_data[:title], user_id: nil)
  book.assign_attributes(book_data.merge(status: 'Want to Read'))
  book.save!

  trope_names.each do |name|
    trope = Trope.find_or_create_by!(name: name)
    BookTrope.find_or_create_by!(book: book, trope: trope)
  end

  puts "Seeded book: #{book.title} (#{trope_names.count} tropes)"
end

puts "\nDone! #{Book.where(user_id: nil).count} seed books, #{Trope.count} tropes."
