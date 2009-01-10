class Nicovideo::Comments
  def initialize video_id, xml
    @video_id = video_id
    @xml = xml
  end

  def to_s() @xml.to_s end
  def to_xml() @xml.to_s end
end
