class Submission
  def initialize
    @submission_data = JSON.parse(File.read("./submission.json"))
  end

  def id
    @submission_data["id"]
  end

  def data
    @submission_data
  end

  def checklist
    @submission_data["checklist"]
  end

  def evaluation_criteria
    @submission_data["target"]["evaluation_criteria"]
  end

  def evaluation_criteria_ids
    @submission_data["target"]["evaluation_criteria"].map do |criteria|
      criteria["id"]
    end
  end
end
