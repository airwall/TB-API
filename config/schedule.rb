every 3.hours do
  runner "GetDataFromApiJob.perform_later"
end
