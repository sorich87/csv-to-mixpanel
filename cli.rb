require './import'

import = CSVToMixpanel::Import.new(ARGV[0], ARGV[1])
import.perform!
