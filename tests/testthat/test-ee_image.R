context("rgee: sf_as_stars test")

library(rgee)
ee_Initialize(drive = TRUE, gcs = TRUE)
# -------------------------------------------------------------------------

img <- ee$Image("LANDSAT/LC08/C01/T1_SR/LC08_038029_20180810")$
  select(c("B4", "B3", "B2"))$
  divide(10000)

geometry <- ee$Geometry$Rectangle(
  coords = c(-110.8, 44.6, -110.6, 44.7),
  proj = "EPSG:4326",
  geodesic = FALSE
)
tif <- system.file("tif/L7_ETMs.tif", package = "stars")
stars_x <- stars::read_stars(tif)
starsproxy_x <- stars::read_stars(tif, proxy = TRUE)
assetId <- sprintf("%s/%s",ee_get_assethome(),'stars_l7')
image_srtm <- ee$Image("CGIAR/SRTM90_V4")


# ee_as_stars lazy ---------------------------------------------------
test_that('image lazy', {
  img_stars_01 <- ee_as_stars(
    image = img,
    region = geometry,
    scale = 250,
    via = "drive",
    lazy = TRUE
  )

  img_stars_02 <- ee_as_stars(
    image = img,
    region = geometry,
    scale = 250,
    via = "gcs",
    container = "rgeedev2",
    lazy = TRUE
  )
  expect_s3_class(img_stars_01, "Future")
  expect_s3_class(img_stars_02, "Future")
})

# getInfo geometry ---------------------------------------------------
test_that('Geometry consideration for "getInfo"', {
  rect_01 <- ee$Geometry$Rectangle(-3, -3, 3, 3)
  test_image_01 <- ee$Image(0)$add(1)

  # test01: base case
  img_01 <- ee_as_raster(image = test_image_01, region = rect_01,
                               quiet = TRUE)
  expect_s4_class(raster::extent(img_01), "Extent")

  # test02: even a small increase will add a new pixel
  nominalscale <- test_image_01$projection()$nominalScale()$getInfo()
  test_image_02 <- test_image_01$reproject(
    crs = "EPSG:4326",
    scale = round(nominalscale)
  )
  img_02 <- ee_as_raster(image = test_image_02, region = rect_01,
                               quiet = TRUE)
  expect_s4_class(raster::extent(img_02), "Extent")
})

# ee_Image_local ---------------------------------------------------
test_that("ee_as_proxystars ", {
  proxy_01 <- rgee:::ee_as_proxystars(tif)
  proxy_02 <- rgee:::ee_as_proxystars(stars_x)
  proxy_03 <- rgee:::ee_as_proxystars(starsproxy_x)
  expect_s3_class(proxy_01, 'stars_proxy')
  expect_s3_class(proxy_02, 'stars_proxy')
  expect_s3_class(proxy_03, 'stars_proxy')
})

test_that("ee_as_stars - simple ", {
  #drive
  img_stars_02 <- ee_as_stars(
    image = img,
    region = geometry,
    scale = 250,
    via = "drive"
  )
  expect_s3_class(img_stars_02, 'stars')

  img_raster_03 <- ee_as_raster(
    image = img,
    region = geometry,
    scale = 250,
    via = "gcs",
    container = 'rgeedev2'
  )
  expect_s4_class(img_raster_03, 'RasterStack')

  gcs <- mean(raster::getValues(img_raster_03))
  drive <- mean(raster::getValues(raster::stack(img_stars_02[[1]])),na.rm = TRUE)
  # Equal value but some problems in the bounds
  expect_equal(gcs, drive, tolerance = 0.1)
})


# world image thumbnail -----------------------------------------------
region <- ee$Geometry$Rectangle(
  coords = c(-180,-60,180,60),
  proj =  "EPSG:4326",
  geodesic = FALSE
)

test_that("ee_as_thumbnail world", {
  world_dem <- ee_as_thumbnail(image = image_srtm, region = region)
  expect_s3_class(world_dem, 'stars')
})

# clean containers  ---------------------------------------------------
test_that("ee_clean_container", {
  drive <- ee_clean_container()
  gcs <- ee_clean_container(name = 'rgeedev2',type = 'gcs')
  expect_true(gcs)
  expect_true(drive)
})

# errors  ------------------------------------------------------------
test_that("ee_image_local error 1", {
  expect_error(
    rgee:::ee_image_local(
      image = "ee$Image",
      region = geometry,
      scale = 100,
      via = "getInfo"
      )
    )
  }
)

test_that("ee_image_local error 2", {
  expect_error(
    rgee:::ee_image_local(
      image = image_srtm,
      region = image_srtm,
      scale = 100,
      via = "getInfo"
      )
    )
  }
)

test_that("ee_image_local error 4", {
  expect_error(
    rgee:::ee_image_local(
      image = image_srtm,
      region = geometry,
      scale = "100",
      via = "getInfo"
    )
  )
}
)

test_that("ee_image_local error 5", {
  expect_error(
    rgee:::ee_image_local(
      image = image_srtm,
      region = geometry,
      scale = c(100, 120),
      via = "getInfo"
    )
  )
}
)

test_that("ee_image_local error 6", {
  expect_error(
    rgee:::ee_image_local(
      image = image_srtm,
      region = geometry,
      via = "testing"
    )
  )
}
)


test_that("ee_image_local error 7", {
  expect_error(
    rgee:::ee_image_local(
      image = image_srtm,
      region = geometry,
      scale = 0.1,
      via = "getInfo"
    )
  )
}
)

test_that("ee_image_local error 8", {
  expect_error(
  ee_as_raster(
    image = image_srtm,
    region = geometry,
    scale = 20000,
    via = "getInfo"
  )
  )
})

test_that("ee_image_local error 9", {
  GEOtransform <- image_srtm$projection()$getInfo()$transform
  GEOtransform[[2]] <- 10
  GEOtransform[[4]] <- 10
  expect_error(
    ee_as_raster(
      image = image_srtm$reproject(crs = "EPSG:4326",
                                   crsTransform = GEOtransform),
      region = geometry,
      scale = 20000,
      via = "getInfo"
    )
  )
 }
)


# ee_image_info test
test_that("ee_image_info", {
  # World SRTM
  srtm <- ee$Image("CGIAR/SRTM90_V4")
  srtm_list <- ee_image_info(srtm)

  austria_dem <- ee$Image("users/csaybar/austria_dem")
  image_id <- ee_utils_py_to_r(austria_dem$get("system:id")$getInfo())
  austria_dem_info <- ee_image_info(austria_dem)
  expect_is(austria_dem_info, "list")
})

