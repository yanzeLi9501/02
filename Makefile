all:

# XXX #
missing_input: 04_mapseq/make_target Fig5_Fig6_FigS8_FigS9/species_df_h233.csv
extraneous: Fig3/x
# XXX #

mk.svg: mkgraph.pl Makefile
	perl $<

target += Fig1_FigS2/SpeciesChangeBoxPlot_Decrease.pdf Fig1_FigS2/GenusChangeBoxPlot_Decrease.pdf
Fig1_FigS2/SpeciesChangeBoxPlot_Decrease.pdf Fig1_FigS2/GenusChangeBoxPlot_Decrease.pdf: Fig1_FigS2/boxplot_log2foldChange.R Fig1_FigS2/list_all.xlsx 04_mapseq/make_target Fig1_FigS2/Species_foldChange_position.csv Fig1_FigS2/Genus_foldChange_condition.csv
	Rscript $<

target += Fig3/heatmap3.pdf
Fig3/heatmap3.pdf: Fig3/heatmap3.2.r Fig3/frac_light.r Fig3/frac_rgb.r Fig3/mdian_list.csv
	Rscript $<

target += Fig4/BarplotTimeEnterotype3Type.pdf
Fig4/BarplotTimeEnterotype3Type.pdf: Fig4/TimeLinePlot3Enterotyep.R Fig4/TimeLine6SplitEnterotype.csv
	Rscript $<

target += Fig5_Fig6_FigS8_FigS9/boxplotFourgenus.pdf
Fig5_Fig6_FigS8_FigS9/boxplotFourgenus.pdf: Fig5_Fig6_FigS8_FigS9/boxplot_four_genus.r Fig5_Fig6_FigS8_FigS9/highchange_ratio2.csv
	Rscript $<

target += Fig5_Fig6_FigS8_FigS9/boxplotfourSpecies.pdf
Fig5_Fig6_FigS8_FigS9/boxplotfourSpecies.pdf: Fig5_Fig6_FigS8_FigS9/boxplot_four_species.r Fig5_Fig6_FigS8_FigS9/highchange_ratio2_species.csv
	Rscript $<

target += Fig5_Fig6_FigS8_FigS9/boxplotAllGenus.pdf
Fig5_Fig6_FigS8_FigS9/boxplotAllGenus.pdf: Fig5_Fig6_FigS8_FigS9/boxplot_all_genus.r Fig5_Fig6_FigS8_FigS9/genus_df_h233.csv
	Rscript $<

target += Fig5_Fig6_FigS8_FigS9/boxplotAllSpecies.pdf
Fig5_Fig6_FigS8_FigS9/boxplotAllSpecies.pdf: Fig5_Fig6_FigS8_FigS9/boxplot_all_species.r Fig5_Fig6_FigS8_FigS9/species_df_h233.csv
	Rscript $<

target += FigS6/GenusDot.pdf
FigS6/GenusDot.pdf: FigS6/DotPlot.r FigS6/Genus_log2Human.csv FigS6/Genus_log2Mouse.csv FigS6/Species_log2Human.csv FigS6/Species_log2Mouse.csv FigS6/Genus_foldChangeAll.csv FigS6/Species_foldChangeAll.csv
	Rscript $<

all: $(target)
