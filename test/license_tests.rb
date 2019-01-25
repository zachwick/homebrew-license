require "json"
require "csv"
require "test/unit"

class TestLicenseIdentifiers < Test::Unit::TestCase

    def test_all_formulae_licenses
        spdx_file = File.expand_path File.dirname(__FILE__) + '/spdx_licenses.csv'
        spdx_licenses = CSV.read(spdx_file).flatten
        formulae_file = File.read(File.expand_path File.dirname(__FILE__) + '/../cmd/licenses.json')
        formulae_licenses = JSON.parse(formulae_file)

        use_only_spdx_identifiers = true

        formulae_licenses.each_key do |formula|
            

            unless formulae_licenses[formula].empty?
                if formulae_licenses[formula].is_a? String
                    use_only_spdx_identifiers = spdx_licenses.include? formulae_licenses[formula]
                    unless use_only_spdx_identifiers
                        unless formulae_licenses[formula].include? 'WITH' || license.include? 'Custom'
                            puts "Formula #{formula} has license #{formulae_licenses[formula]} which is not comprised of SPDX identifiers"
                            assert_true(false)
                        end
                    end
                else
                    formulae_licenses[formula].each do |license|
                        use_only_spdx_identifiers = spdx_licenses.include? license
                        unless use_only_spdx_identifiers
                            unless license.include? 'WITH' || license.include? 'Custom"'
                                puts "Formula #{formula} has license #{license} which is not comprised of SPDX identifiers"
                                assert_true(false)
                            end
                        end
                    end
                end
            end
        end
        assert_true(use_only_spdx_identifiers)
    end
end