# Install if needed
# install.packages(c("sf", "ggplot2", "rnaturalearth", "rnaturalearthdata", "patchwork"))

library(sf)
library(ggplot2)
library(rnaturalearth)
library(patchwork)

case_palette <- list(
  background   = "#FFFFFF",
  land_base    = "#00608E",
  country_fill = "#FF5974",
  border       = "#2F3A3B",
  grid         = "#D6D1C4",
  text         = "#1F2933"
)

# ------------------------------------------------------------
# Bounding boxes
# ------------------------------------------------------------

bbox_list <- list(
  ES = c(xmin = -9.5, ymin = 36.0, xmax =  2.7, ymax = 43.7),
  FR = c(xmin = -5.0, ymin = 42.5, xmax =  8.0, ymax = 51.0),
  IT = c(xmin =  6.5, ymin = 37.0, xmax = 18.0, ymax = 47.0)
)

country_lookup <- c(
  ES = "Spain",
  FR = "France",
  IT = "Italy"
)

# ------------------------------------------------------------
# Country boundaries
# ------------------------------------------------------------

world <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

# ------------------------------------------------------------
# Function to create one country plot
# ------------------------------------------------------------

make_country_plot <- function(code) {
  
  bbox <- bbox_list[[code]]
  country_name <- country_lookup[[code]]
  
  country <- world[world$name == country_name, ]
  
  ggplot() +
    geom_sf(
      data = world,
      fill = case_palette$land_base,
      color = case_palette$grid,
      linewidth = 0.25
    ) +
    geom_sf(
      data = country,
      fill = case_palette$country_fill,
      color = case_palette$border,
      linewidth = 0.55
    ) +
    coord_sf(
      xlim = c(bbox["xmin"], bbox["xmax"]),
      ylim = c(bbox["ymin"], bbox["ymax"]),
      expand = FALSE
    ) +
    labs(
      title = code,
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal() +
    theme(
      plot.background = element_rect(
        fill = case_palette$background,
        color = NA
      ),
      panel.background = element_rect(
        fill = case_palette$background,
        color = NA
      ),
      panel.grid.major = element_line(
        linewidth = 0.2,
        color = case_palette$grid
      ),
      plot.title = element_text(
        face = "bold",
        hjust = 0.5,
        size = 14,
        color = case_palette$text
      ),
      axis.title = element_text(
        size = 9,
        color = case_palette$text
      ),
      axis.text = element_text(
        size = 8,
        color = case_palette$text
      )
    )
}

# ------------------------------------------------------------
# Create maps in requested order: ES, FR, IT
# ------------------------------------------------------------

map_ES <- make_country_plot("ES")
map_FR <- make_country_plot("FR")
map_IT <- make_country_plot("IT")

combined_map <- map_ES + map_FR + map_IT +
  plot_annotation(
    title = "Country Maps Based on Bounding Coordinates",
    subtitle = "", # "Spain, France, and Italy",
    theme = theme(
      plot.background = element_rect(
        fill = case_palette$background,
        color = NA
      ),
      plot.title = element_text(
        face = "bold",
        size = 16,
        color = case_palette$text
      ),
      plot.subtitle = element_text(
        size = 11,
        color = case_palette$text
      )
    )
  )

combined_map