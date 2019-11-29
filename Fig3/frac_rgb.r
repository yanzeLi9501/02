#!/bin/r

frac_rgb <- function(x, palette=c("Red", "Black")) {
	f <- function(frac) {
		x <- colorRamp(palette);
		xx <- x(frac);
		rgb(xx[1], xx[2], xx[3], maxColorValue=255);
	}
	y <- x;
	y[] <- sapply(y, f);
	y;
}
