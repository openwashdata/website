## --------------------------------------------------------------------------------
#| label: load-packages
#| echo: false
#| include: false
library(tidyverse)
library(gridExtra)


## --------------------------------------------------------------------------------
#| label: load-data
#| echo: false
#| include: false
source("data_collection.R")


## --------------------------------------------------------------------------------
#| label: set-up
#| echo: false
#| include: false

low_purple <- "#ab84a8"
high_purple <- "#5b195b"
map_grey <- "grey80"
background_color <- "#f5f5f2"

owd_palette <- c("#5b195b", "#9b2c60", "#ce525b",
                 "#f08453", "#ffbd54", "#f9f871")


nrow(registration)
registration$country_ISO3 |> na.omit() |> unique() |> length()
## --------------------------------------------------------------------------------
#| label: registration-data
#| echo: false
#| fig.width: 8
#| fig.height: 4

registration_country <- registration |> 
  group_by(country_ISO3) |> 
  summarise(n_resgitered = n()) |> 
  ungroup() |> 
  right_join(world, join_by(country_ISO3 == ISO3)) |> 
  filter(region != "Antarctica")

storage_df <- registration |> 
    mutate(storage_type =
           case_when(
             str_detect(data_storage, "Google")   ~ "Spreadsheets",
             str_detect(data_storage, "database") ~ "Databases",
             str_detect(data_storage, "CSV")      ~ "Machine readable files",
             str_detect(data_storage, "paper")    ~ "Physically",
             str_detect(data_storage, "know")     ~ "Unknown",
             TRUE                                 ~ "Other"
           )
         ) |> 
  group_by(storage_type) |> 
  summarise(n = n()) |> 
  ungroup()


## --------------------------------------------------------------------------------
#| label: themes
#| echo: false
#| fig.width: 8
#| fig.height: 4

plain <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank(),
  plot.background = element_rect(fill = background_color, color = NA),
  panel.background = element_rect(fill = background_color, color = NA),
  legend.background = element_rect(fill = background_color, color = NA),
  plot.margin =  margin(t = 40, r = 17, b = 40, l = 17, 
                        unit = "pt"),
  plot.title.position = "plot",
  plot.title = element_text(hjust = 0.5, 
                            size = 14, 
                            face = "bold")
)

bar_theme <- theme(plot.title.position = "plot",
                   plot.title = element_text(hjust = 0.5,
                                             size = 14, 
                                             face = "bold"),
                   plot.background = element_rect(fill = background_color,
                                                  color = NA),
                   panel.background = element_rect(fill = background_color,
                                                   color = NA),
                   legend.background = element_rect(fill = background_color,
                                                    color = NA))


## --------------------------------------------------------------------------------
#| label: plot-countries
#| echo: false
#| fig.width: 8
#| fig.height: 4

countries_plot <- ggplot(data = registration_country, 
                         mapping = aes(x = long, 
                                       y = lat, 
                                       group = group)) + 
  coord_sf() +
  geom_polygon(aes(fill = n_resgitered)) +
  scale_fill_gradient(low = low_purple, 
                      high = high_purple, 
                      na.value = map_grey) +
  labs(title = "Number of registrations for ds4owd-001", 
       fill = "") +
  plain

countries_plot


## --------------------------------------------------------------------------------
#| label: plot-organisation
#| echo: false
#| fig-height: 3
#| fig-width: 8

org_plot <- ggplot(registration, 
                   aes(y = fct_infreq(organisation_type), 
                       fill = as_factor(organisation_type))) +
  geom_bar() +
  geom_text(stat = "count", 
            aes(label = after_stat(count), 
                x = after_stat(count)),
            position = position_stack(vjust = 1),
            colour = "black",
            fontface = "bold",
            size = 3.5,
            hjust = -0.25) +
  scale_fill_manual(values = owd_palette, guide = "none") +
  labs(title = "Organization type registered professionals work for", 
       x = "", 
       y = "") + 
  theme_minimal() +
  bar_theme

org_plot


## --------------------------------------------------------------------------------
#| label: plot-storage
#| echo: false
#| fig-height: 3
#| fig-width: 8

storage_plot <- ggplot(storage_df, 
                       aes(x = n,
                           y = fct_infreq(storage_type, w = n),
                           fill = as_factor(storage_type))) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = n, 
                x = n),
            position = position_stack(vjust = 1),
            colour = "black",
            fontface = "bold",
            size = 3.5,
            hjust = -0.25) +
  scale_fill_manual(values = owd_palette, guide = "none") +
  labs(title = "Method for data storage", 
       x = "", 
       y = "") + 
  theme_minimal() +
  bar_theme

storage_plot


## --------------------------------------------------------------------------------
#| label: programming-experience-data
#| echo: false

exp_levels <- c("I have none.",
                "I have written a few lines now and again.",
                "I have written programs for my own use that are a couple of pages long.",
                "I have written and maintained larger pieces of software.")

exp_labels <- c("None",
                "Few lines now and again",
                "Programs for own use",
                "Developed and maintained\npieces of software")

registration <- registration |> 
  mutate(programming_experience = factor(programming_experience,
                                         levels = exp_levels),
         r_experience = factor(r_experience,
                               levels = exp_levels))

no_exp <- ((registration |> 
  filter(programming_experience == exp_levels[1]) |> 
  nrow()) / nrow(registration) * 100) |> 
  round()

more_exp <- ((registration |> 
  filter(programming_experience == exp_levels[3]) |> 
  nrow()) / nrow(registration) * 100) |> 
  round()


no_exp
more_exp
## --------------------------------------------------------------------------------
#| label: plot-programming-experience
#| echo: false
#| fig-height: 6
#| fig-width: 8

prog_plot <- ggplot(registration, 
                    aes(y = programming_experience, 
                        fill = programming_experience)) +
  geom_bar() + 
  geom_text(stat = "count", 
            aes(label = after_stat(count), 
                x = after_stat(count)),
            position = position_stack(vjust = 1),
            colour = "black",
            fontface = "bold",
            size = 3.5,
            hjust = -0.25) +
  scale_fill_manual(values = owd_palette, guide = "none") +
  scale_y_discrete(labels = exp_labels) +
  labs(title = "Experience with programming in gereral", 
       x = "", 
       y = "") + 
  theme_minimal() +
  bar_theme

r_plot <- ggplot(registration, 
                 aes(y = r_experience,
                     fill = r_experience)) +
  geom_bar() + 
  geom_text(stat = "count", 
            aes(label = after_stat(count), 
                x = after_stat(count)),
            position = position_stack(vjust = 1),
            colour = "black",
            fontface = "bold",
            size = 3.5,
            hjust = -0.25) +
  scale_fill_manual(values = owd_palette, guide = "none") +
  scale_y_discrete(labels = exp_labels) +
  labs(title = "Experience with programming in R", 
       x = "", 
       y = "") + 
  theme_minimal() +
  bar_theme


grid.arrange(prog_plot, r_plot, nrow = 2)


## --------------------------------------------------------------------------------
#| label: participants-data
#| echo: false

participants <- course_participation |> 
  filter(guest == "Yes") |>
  mutate(name = if_else(is.na(name), user_email, name)) |> 
  group_by(name) |> 
  arrange(user_email) |> 
  summarise(modules_taken = n(),
            email = first(user_email)) |> 
  ungroup() |> 
  filter(modules_taken >= 4,
         # !is.na(email)
         ) 


nrow(registration)
nrow(participants)
## --------------------------------------------------------------------------------
#| label: post-data
#| echo: false
#| include: false

percentage_post <- post_survey |> 
  transmute(r_competency = as_factor(rating_self_r_comp),
            git_competency = as_factor(rating_self_vc_comp),
            confidence = as_factor(conf_skill_app)) |> 
  pivot_longer(cols = everything(),
               names_to = "Question", 
               values_to = "Answer") |> 
  count(Question, Answer) |> 
  group_by(Question) |> 
  mutate(Percentage = n / sum(n)) |> 
  select(Question, Answer, Percentage)
  
summary_post <- percentage_post |> 
  mutate(Answer = if_else(Answer %in% c("1", "2"), "no", "yes")) |> 
  group_by(Question, Answer) |> 
  summarise(Total = (sum(Percentage) * 100)) |> 
  ungroup() |> 
  filter(Answer == "yes")


summary_post |> filter(Question == "r_competency") |> select(Total) |> as_vector()
summary_post |> filter(Question == "git_competency") |> select(Total) |> as_vector()
summary_post |> filter(Question == "confidence") |> select(Total) |> as_vector()
## --------------------------------------------------------------------------------
#| label: plot-post
#| echo: false
#| fig-height: 5
#| fig-width: 8

legend_values = c("r_competency" = owd_palette[1], 
                  "git_competency" = owd_palette[2], 
                  "confidence" = owd_palette[3])

legend_labels <- c("\nR competency\n", 
                     "Git/GitHub\ncompetency\n", 
                     "Confidence\napplying skills\n")

post_plot <- ggplot(percentage_post,
                    aes(x = Answer, y = Percentage, fill = Question)) +
  geom_bar(stat = "identity",
           position = "dodge",
           width = 0.9) +
  geom_text(aes(label = paste0(Percentage * 100, "%")),
            position = position_dodge(width = 0.9), 
            vjust = -0.5, 
            size = 3.5, 
            fontface = "bold") +
  scale_fill_manual(name = "", 
                    values = legend_values,
                    labels = legend_labels) +
  scale_y_continuous(labels = scales::label_percent()) +
  labs(title = "Self-assessment after completing the course", 
       x = "Rating", 
       y = "") +
  theme_minimal() +
  bar_theme +
  theme(plot.title.position = "plot",
        plot.title = element_text(hjust = 0.5,
                            size = 14, 
                            face = "bold"),
        axis.title.x = element_text(vjust = -5),
        plot.margin = margin(10, 10, 30, 50, unit = "pt")) +
  annotate("text", 
           x = 0, 
           y = -0.08, 
           label = "Not confident or\ncompetent at all", 
           hjust = 0.5, 
           size = 3.5) +
  annotate("text", 
           x = 5, 
           y = -0.08, 
           label = "Very confident\nor competent", 
           hjust = 0.5, 
           size = 3.5) +
  annotate("segment", x=0.5, y=-0.08, xend=4.5, yend=-0.08,
         arrow = arrow(ends = "both",
                       angle = 25,
                       length = unit(12, "pt"))) +
  coord_cartesian(ylim = c(0, 0.6),
                  xlim = c(1, 4),
                  clip = "off")
  
post_plot

