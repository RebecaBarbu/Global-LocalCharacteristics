function struct_imagePoints = ConvertSurfPointsTypeToTransmisibleType(surf_imagePoints)

struct_imagePoints.Scale =   uint64( 10^10 *double(surf_imagePoints.Scale));
struct_imagePoints.SignOfLaplacian = uint64( 10^10 *   double(surf_imagePoints.SignOfLaplacian)) ;
struct_imagePoints.Orientation = uint64(10^10 *   double(surf_imagePoints.Orientation)) ;
struct_imagePoints.Location =  uint64(10^10 *  double(surf_imagePoints.Location)) ;
struct_imagePoints.Metric =  uint64(10^10 *  double(surf_imagePoints.Metric)) ;
struct_imagePoints.Count = uint64(10^10 * double(surf_imagePoints.Count));

struct_imagePoints.Scale =   single(struct_imagePoints.Scale) / 10^10 ;
struct_imagePoints.SignOfLaplacian =  int8(2*(double(struct_imagePoints.SignOfLaplacian)/10^10) - 1);
struct_imagePoints.Orientation = single(struct_imagePoints.Orientation)/ 10^10  ;
struct_imagePoints.Location =  single(struct_imagePoints.Location)/ 10^10  ;
struct_imagePoints.Metric =  single(struct_imagePoints.Metric)/ 10^10 ;
struct_imagePoints.Count = single(struct_imagePoints.Count)/ 10^10 ;

end