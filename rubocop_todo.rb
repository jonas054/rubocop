# coding: utf-8

module RuboCop
  # User defined configuration.
  class ConfigLoader
    def self.config_from_user_code
      {
        # Offense count: 122
        'Metrics/AbcSize' => { 'Max' => 38 },

        # Offense count: 9
        # Configuration parameters: CountComments.
        'Metrics/ClassLength' => { 'Max' => 148 },

        # Offense count: 28
        'Metrics/CyclomaticComplexity' => { 'Max' => 10 },

        # Offense count: 130
        # Configuration parameters: CountComments.
        'Metrics/MethodLength' => { 'Max' => 16 },

        # Offense count: 18
        'Metrics/PerceivedComplexity' => { 'Max' => 11 }
      }
    end
  end
end
