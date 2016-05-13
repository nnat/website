class OffersController < ApplicationController

  def index
    @section = :program
    @chosen_version = params[:version]
    @offer = {
    	'ultimate' => {
    		'location' => {
    			price: '149€ par mois',
    			duration: 'Engagement 12 mois, reprise gratuite'
    		},
    		'achat' => {
    			price: '2590€'
    		}
    	},
    	'medium' => {
    		'location' => {
    			price: '99€ par mois'
    		},
    		'achat' => {
    			price: '1990€'
    		}
    	},
    }
  end

end
