// Lake Charles, Louisiana, analyze for pre- and post-flood Sentinel-1.

//*********************************************************************************************************************************//
//                                                       Define the Area of Interest                                              //
//*********************************************************************************************************************************//
// Define the Area of Interest (Note: Ensure 'full' is defined as your polygon in GEE)
var lakeCharlesBoundary = full; 

Map.centerObject(lakeCharlesBoundary, 15);
Map.addLayer(lakeCharlesBoundary, {color: 'blue', fillColor: '00000000'}, 'Lake Charles Boundary');

//*********************************************************************************************************************************//
//                                                  Load Sentinel-1 (VV & VH)                                                    //
//*********************************************************************************************************************************//
// Load Sentinel-1 ImageCollection and filter for VV and VH polarizations
var sentinel1 = ee.ImageCollection('COPERNICUS/S1_GRD')
                  .filterBounds(lakeCharlesBoundary)
                  .filter(ee.Filter.eq('instrumentMode', 'IW'))
                  .filter(ee.Filter.listContains('transmitterReceiverPolarisation', 'VV'))
                  .filter(ee.Filter.listContains('transmitterReceiverPolarisation', 'VH')); 

// Extract Pre-Flood image (Aug 3, 2020)
var preImage = sentinel1.filterDate('2020-08-03', '2020-08-04').first().clip(lakeCharlesBoundary); 

// Extract Post-Flood image (Sep 1, 2020 - shortly after Hurricane Laura landfall)
var postImage = sentinel1.filterDate('2020-09-01', '2020-09-02').first().clip(lakeCharlesBoundary); 

//*********************************************************************************************************************************//
//                                           Export to Google Drive as GeoTIFF                                                   //
//*********************************************************************************************************************************//

var exportRegion = lakeCharlesBoundary.bounds();

// Export Pre-Flood VV & VH Bands
Export.image.toDrive({
  image: preImage.select(['VV', 'VH']),
  description: 'Pre_Flood_Sentinel1_VV_VH',
  folder: 'EarthEngineExports',
  region: exportRegion,
  scale: 10,
  fileFormat: 'GeoTIFF'
});

// Export Post-Flood VV & VH Bands
Export.image.toDrive({
  image: postImage.select(['VV', 'VH']),
  description: 'Post_Flood_Sentinel1_VV_VH',
  folder: 'EarthEngineExports',
  region: exportRegion,
  scale: 10,
  fileFormat: 'GeoTIFF'
});
