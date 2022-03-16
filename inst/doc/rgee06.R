## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## -----------------------------------------------------------------------------
#  library(rgee)
#  library(rgeeExtra)
#  
#  ee_Initialize()
#  
#  img <- ee$Image$Dataset$CGIAR_SRTM90_V4
#  Map$addLayer(log1p(img), list(min = 0, max = 7))

## -----------------------------------------------------------------------------
#  library(rgee)
#  library(googleCloudStorageR)
#  
#  # Init the EE API
#  ee_Initialize("csaybar", gcs = TRUE)
#  
#  # Validate your SaK
#  # ee_utils_sak_validate(bucket = "rgee_examples")

## -----------------------------------------------------------------------------
#  # Define an study area
#  EE_geom <- ee$Geometry$Point(c(-70.06240, -6.52077))$buffer(5000)

## -----------------------------------------------------------------------------
#  l8img <- ee$ImageCollection$Dataset$LANDSAT_LC08_C02_T2_L2 %>%
#    ee$ImageCollection$filterDate('2021-06-01', '2021-12-01') %>%
#    ee$ImageCollection$filterBounds(EE_geom) %>%
#    ee$ImageCollection$first()

## -----------------------------------------------------------------------------
#  gcs_l8_name  <- "l8demo2" # name of the image in GCS.
#  BUCKET_NAME <- "rgee_examples" # set here your bucket name
#  task <- ee_image_to_gcs(
#    image = l8img$select(sprintf("SR_B%s",1:5)),
#    region = EE_geom,
#    fileNamePrefix = gcs_l8_name,
#    timePrefix = FALSE,
#    bucket = BUCKET_NAME,
#    scale = 10,
#    formatOptions = list(cloudOptimized = TRUE) # Return a COG rather than a TIFF file.
#  )
#  task$start()
#  ee_monitoring()

## -----------------------------------------------------------------------------
#  # Make PUBLIC the GCS object
#  googleCloudStorageR::gcs_update_object_acl(
#    object_name = paste0(gcs_l8_name, ".tif"),
#    bucket = BUCKET_NAME,
#    entity_type = "allUsers"
#  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
library(rgee)
gcs_l8_name  <- "l8demo2" # name of the image in GCS.
BUCKET_NAME <- "rgee_examples" # set here your bucket name

## ----eval=TRUE----------------------------------------------------------------
img_id <- sprintf("https://storage.googleapis.com/%s/%s.tif", BUCKET_NAME, gcs_l8_name)
visParams <- list(bands=c("SR_B4","SR_B3","SR_B2"), min = 8000, max = 20000, nodata = 0)
Map$centerObject(img_id)
Map$addLayer(
  eeObject = img_id, 
  visParams = visParams,
  name = "My_first_COG",
  titiler_server = "https://api.cogeo.xyz/"
)

## ----eval=TRUE----------------------------------------------------------------
visParams <- list(expression = "B4,B3,B2", rescale = "8000, 20000", resampling_method = "cubic")
Map$addLayer(
  eeObject = img_id, 
  visParams = visParams,
  name = "My_first_COG",
  titiler_server = "https://api.cogeo.xyz/",
  titiler_viz_convert = FALSE
)

