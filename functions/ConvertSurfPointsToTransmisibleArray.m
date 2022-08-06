function surfPointsArray = ConvertSurfPointsToTransmisibleArray(imagePoints)

surfPointsArray = uint64(10^10 * [ ...
    double(imagePoints.Count) ...
    double(imagePoints.Scale') ...
    double(imagePoints.SignOfLaplacian') ...
    double(imagePoints.Orientation') ...
    double(imagePoints.Location(:,1)') ...
    double(imagePoints.Location(:,2)') ...
    double(imagePoints.Metric') ...
    ]);


end