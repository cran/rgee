## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## -----------------------------------------------------------------------------
#  # remotes::install_github("r-spatial/rgee") Install rgee v.1.3
#  library(rgee)
#  
#  ee_Initialize("csaybar")
#  
#  SaK_file <- "/home/csaybar/Downloads/SaK_rgee.json" # PUT HERE THE FULLNAME OF YOUR SAK.
#  
#  # Assign the SaK to a EE user.
#  ee_utils_sak_copy(
#    sakfile =  SaK_file,
#    users = c("csaybar", "ryali93") # Unlike GD, we can use the same SaK for multiple users.
#  )
#  
#  # Validate your SaK
#  ee_utils_sak_validate()

## -----------------------------------------------------------------------------
#  library(rgee)
#  library(jsonlite)
#  library(googleCloudStorageR)
#  
#  ee_Initialize("csaybar", gcs = TRUE)
#  
#  # Create your own container
#  project_id <- ee_get_earthengine_path() %>%
#    list.files(., "\\.json$", full.names = TRUE) %>%
#    jsonlite::read_json() %>%
#    '$'(project_id) # Get the Project ID
#  
#  googleCloudStorageR::gcs_create_bucket("CHOOSE_A_BUCKET_NAME", projectId = project_id)
#  

## -----------------------------------------------------------------------------
#  demo_data <- data.frame(a = 1:10, b = 1:10)
#  
#  # Bad --------------------------------------------------
#  googleCloudStorageR::gcs_upload(
#    file = demo_data,
#    name = "demo_data.csv",
#    bucket = "demo_0002" # Bucket with uniform control access
#  )
#  #  Error: Insert legacy ACL for an object when uniform bucket-level access
#  #  is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access
#  
#  
#  # Good -------------------------------------------------
#  googleCloudStorageR::gcs_upload(
#    file = demo_data,
#    name = "demo_data.csv",
#    bucket = "demo_0002", # Bucket with uniform control access
#    predefinedAcl = "bucketLevel"
#  )

## -----------------------------------------------------------------------------
#  library(rgee)
#  
#  ee_Initialize(gcs = TRUE)
#  
#  
#  # Define an image.
#  img <- ee$Image("LANDSAT/LC08/C01/T1_SR/LC08_038029_20180810")$
#    select(c("B4", "B3", "B2"))$
#    divide(10000)
#  
#  # Define an area of interest.
#  geometry <- ee$Geometry$Rectangle(
#    coords = c(-110.8, 44.6, -110.6, 44.7),
#    proj = "EPSG:4326",
#    geodesic = FALSE
#  )
#  
#  img_03 <- ee_as_raster(
#    image = img,
#    region = geometry,
#    container = "demo_0001",
#    via = "gcs",
#    scale = 1000
#  )
#  
#  # ERROR in Earth Engine servers: Unable to write to bucket demo_0001 (permission denied).

