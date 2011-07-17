function fake = deviceIsFake(device)

if any(cellfun(@(x) strcmp(x, 'fake'), properties(device)))
  fake = true;
else
  fake = false;
end
