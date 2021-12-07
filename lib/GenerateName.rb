class GenerateName
    def world
        name = [
            'Earth',
            'Solace',
            'Terra',
            'Nova',
            'Solida',
            'Humus',
            'Viridis',
            'Orb',
            'Solo',
            'Lutum',
            'Vita',
        ].sample

        adjective = [
            '',
            'Red',
            'Green',
            'Blue',
            'Speckled',
            'Spotted',
        ].sample

        suffix = [
            '',
            '',
            '',
            'One',
            'Two',
            'Seven',
        ].sample

        "#{adjective} #{name} #{suffix}"
    end
end
