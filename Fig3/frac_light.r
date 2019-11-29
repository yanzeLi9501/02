#!/bin/r


frac_light <- function(x) {
        f <- function(frac) {
                x <- colorRamp(c("Purple", "Orange"));
                xx <- x(frac);
                rgb(xx[1], xx[2], xx[3], maxColorValue=255);
        }
        sapply(as.matrix(x), f);
}

