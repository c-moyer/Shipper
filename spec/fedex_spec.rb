require 'shipper'
require "json"

describe Shipper::FedEx do

  context 'shipping labels' do
    it 'gets valid shipping label' do
      packages = []
      packages << Shipper::Package.new(10, [15, 10, 4.5], units: :imperial)
      origin = Shipper::Location.new(
                                     name: "Cannon Moyer",
                                     company: "Treadmill Doctor",
                                     phone: "901-362-3360",
                                     address1: "1333 Kansas St",
                                     country: 'US',
                                     state: 'TN',
                                     city: 'Memphis',
                                     zip: '38106')

      destination = Shipper::Location.new(name: "John Doe",
                                          phone: "901-239-2955",
                                          address1: "1250 McIngvale Rd.",
                                          country: "US",
                                          state: "MS",
                                          city: "Hernando",
                                          zip: "38632")

      carrier = Shipper::FedEx.new(login: ENV['LOGIN'],
                                   password: ENV['PASSWORD'],
                                   key: ENV['KEY'],
                                   account: ENV['ACCOUNT'], test: true)


      label = carrier.create_shipment(origin, destination, packages)

      #puts label.labels.first
      puts label.labels.first.tracking_number
      puts label.total_price

      File.open("test.png", "w") do |f|
        f.write(label.labels.first.img_data)
      end

    end
  end

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

    carrier = Shipper::FedEx.new(login: ENV["FEDEX_LOGIN"],
                                 password: ENV["FEDEX_PASSWORD"],
                                 key: ENV["FEDEX_KEY"],
                                 account: ENV["FEDEX_ACCOUNT"])

    response = carrier.find_rates(origin, destination, packages)
    expect(response.rates).to be_present
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

    carrier = Shipper::FedEx.new(login: ENV["FEDEX_LOGIN"],
                                password: ENV["FEDEX_PASSWORD"],
                                key: ENV["FEDEX_KEY"],
                                account: ENV["FEDEX_ACCOUNT"])

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

      carrier = Shipper::FedEx.new(login: ENV["FEDEX_LOGIN"],
                                    password: ENV["FEDEX_PASSWORD"],
                                    key: ENV["FEDEX_KEY"],
                                    account: ENV["FEDEX_ACCOUNT"])

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

        carrier = Shipper::FedEx.new(login: ENV["FEDEX_LOGIN"],
                                      password: ENV["FEDEX_PASSWORD"],
                                      key: ENV["FEDEX_KEY"],
                                      account: ENV["FEDEX_ACCOUNT"])
        begin
          response = carrier.find_rates(origin, destination, packages)
        rescue => e
          expect(e.class).to equal(Shipper::ResponseError)
        end
end


end
