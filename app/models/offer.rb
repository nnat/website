class Offer
  def self.data
  	{
    	'ultime' => {
    		'location' => {
    			price: 149,
    			price_tag: '149€ par mois',
    			condition: "Engagement 12 mois, option d'achat et reprise gratuite",
    			small_line: "Le dépôt de garantie de 400€ sera demandé au mois d'Octobre",
    			reservation: 100
    		},
    		'achat' => {
    			price: 2590,
    			price_tag: '2590€',
                condition: 'Paiment 3 fois sans frais possible<br/><br/>',
                small_line: "Le solde de 2490€ sera demandé au mois d'Octobre",
                reservation: 100
    		}
    	},
    	'minime' => {
    		'location' => {
    			price: 99,
    			price_tag: '99€ par mois',
                condition: "Engagement 12 mois, option d'achat et reprise gratuite",
                small_line: "Le dépôt de garantie de 400€ sera demandé au mois d'Octobre",
                reservation: 100
    		},
    		'achat' => {
    			price: 1990,
    			price_tag: '1990€',
                condition: 'Paiment 3 fois sans frais possible<br/><br/>',
                small_line: "Le solde de 1890€ sera demandé au mois d'Octobre",
                reservation: 100
    		}
    	},
    }
  end
end