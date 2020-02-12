require 'shipper'
require "json"

describe Shipper::FedEx do
  it "should get domestic rates" do
    weight = 50
    packages = []
    while weight > 2400
      weight = weight - 2400
      packages << Shipper::Package.new(2400.0, [], units: :imperial)
    end
    packages << Shipper::Package.new(weight, [], units: :imperial)
    origin = Shipper::Location.new(country: 'US',
                                   state: 'TN',
                                   city: 'Memphis',
                                   zip: '38106')

    destination = Shipper::Location.new(country: "US",
                                        state: "MS",
                                        city: "Hernando",
                                        zip: "38632")

    carrier = Shipper::FedEx.new(login: RSpec.configuration.credentials["fedex"]["login"],
                                 password: RSpec.configuration.credentials["fedex"]["password"],
                                 key: RSpec.configuration.credentials["fedex"]["key"],
                                 account: RSpec.configuration.credentials["fedex"]["account"])

    response = carrier.find_rates(origin, destination, packages)
    expect(response.rates).to be_present
    response.rates.each do |i|
      puts i.service_name
      puts i.price.to_f/100
    end
  end

  it "should get international rates" do

    weight = 10
    packages = []
    while weight > 2400
      weight = weight - 2400
      packages << Shipper::Package.new(2400.0, [], units: :imperial)
    end
    packages << Shipper::Package.new(weight, [], units: :imperial)
    origin = Shipper::Location.new(country: 'US',
                                   state: 'TN',
                                   city: 'Memphis',
                                   zip: '38106')

    destination = Shipper::Location.new(country: "CA",
                                        state: "ON",
                                        city: "Toronto",
                                        zip: "M4B 1B4")

    carrier = Shipper::FedEx.new(login: RSpec.configuration.credentials["fedex"]["login"],
                                 password: RSpec.configuration.credentials["fedex"]["password"],
                                 key: RSpec.configuration.credentials["fedex"]["key"],
                                 account: RSpec.configuration.credentials["fedex"]["account"])

    response = carrier.find_rates(origin, destination, packages)
    expect(response.rates).to be_present
  end


  it "should get multi package domestic rates" do

      weight = 10
      packages = []
      while weight > 2400
        weight = weight - 2400
        packages << Shipper::Package.new(2400.0, [], units: :imperial)
      end
      packages << Shipper::Package.new(weight, [], units: :imperial)
      origin = Shipper::Location.new(country: 'US',
                                     state: 'TN',
                                     city: 'Memphis',
                                     zip: '38106')

      destination = Shipper::Location.new(country: "US",
                                          state: "MS",
                                          city: "Southaven",
                                          zip: "38654")

      carrier = Shipper::FedEx.new(login: RSpec.configuration.credentials["fedex"]["login"],
                                   password: RSpec.configuration.credentials["fedex"]["password"],
                                   key: RSpec.configuration.credentials["fedex"]["key"],
                                   account: RSpec.configuration.credentials["fedex"]["account"])

      response = carrier.find_rates(origin, destination, packages)
      expect(response.rates).to be_present
  end

  it "invalid zip code" do

        weight = 10
        packages = []
        while weight > 2400
          weight = weight - 2400
          packages << Shipper::Package.new(2400.0, [], units: :imperial)
        end
        packages << Shipper::Package.new(weight, [], units: :imperial)
        origin = Shipper::Location.new(country: 'US',
                                       state: 'TN',
                                       city: 'Memphis',
                                       zip: '38106')

        destination = Shipper::Location.new(country: "US",
                                            state: "MS",
                                            city: "Southaven",
                                            zip: "invalid_zip_code")

        carrier = Shipper::FedEx.new(login: RSpec.configuration.credentials["fedex"]["login"],
                                     password: RSpec.configuration.credentials["fedex"]["password"],
                                     key: RSpec.configuration.credentials["fedex"]["key"],
                                     account: RSpec.configuration.credentials["fedex"]["account"])
        begin
          response = carrier.find_rates(origin, destination, packages)
        rescue => e
          expect(e.class).to equal(Shipper::ResponseError)
        end
end


end