require_relative 'spec_helper'

describe WoodPecker::Page do
  let(:page) {WoodPecker::Page.new("http://www.xvideos.com/video1213402/tsubomi_2_000")}

  it {expect(page.append_base_tag).to eq ''}
  it {expect(page.headers).to eq ""}
end