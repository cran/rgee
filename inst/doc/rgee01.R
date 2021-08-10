## ---- setup, include=FALSE----------------------------------------------------
knitr::opts_chunk$set(
  comment = '', fig.width = 6, fig.height = 6
)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("rgee")

## ----eval = FALSE-------------------------------------------------------------
#  remotes::install_github("r-spatial/rgee")

## ----eval = FALSE-------------------------------------------------------------
#  library(rgee)
#  ee_install(py_env = "rgee") # It is just necessary once!

## ----eval = FALSE-------------------------------------------------------------
#  library(rgee)
#  #ee_reattach() # reattach ee as a reserve word
#  # Initialize just Earth Engine
#  ee_Initialize()
#  ee_Initialize(user = 'csaybar@gmail.com') # Use the argument email is not mandatory, but it's helpful to change of EE user.
#  # Initialize Earth Engine and GD
#  ee_Initialize(user = 'csaybar@gmail.com', drive = TRUE)
#  # Initialize Earth Engine and GCS
#  ee_Initialize(user = 'csaybar@gmail.com', gcs = TRUE)
#  # Initialize Earth Engine, GD and GCS
#  ee_Initialize(user = 'csaybar@gmail.com', drive = TRUE, gcs = TRUE)

## ----eval = FALSE-------------------------------------------------------------
#  ee_get_earthengine_path()

## ----eval = FALSE-------------------------------------------------------------
#  library(rgee)
#  ee_Initialize()
#  srtm <- ee$Image("USGS/SRTMGL1_003")

## -----------------------------------------------------------------------------
viz <- list(
  max = 4000,
  min = 0,
  palette = c("#000000","#5AAD5A","#A9AD84","#FFFFFF")
)

## ----eval=FALSE---------------------------------------------------------------
#  Map$addLayer(
#    eeObject = srtm,
#    visParams =  viz,
#    name = 'SRTM',
#    legend = TRUE
#  )

