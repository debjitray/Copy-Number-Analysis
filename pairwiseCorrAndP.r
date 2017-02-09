pairwiseCorrAndP <- function (x, y = NULL, use = "pairwise", method = "pearson", adjust = "holm")
# pairwiseCorrAndP <- function (x, y = NULL, use = "pairwise", method = "pearson/kendall/spearman", adjust = "holm/hochberg/hommel/bonferroni/BH/BY/fdr/none")
{
    cl <- match.call()
    if (is.null(y)) {
        r <- cor(x, use = use, method = method)
        sym <- TRUE
        n <- t(!is.na(x)) %*% (!is.na(x))
    }
    else {
        r <- cor(x, y, use = use, method = method)
        sym = FALSE
        n <- t(!is.na(x)) %*% (!is.na(y))
    }
    if ((use == "complete") | (min(n) == max(n)))
        n <- min(n)
    t <- (r * sqrt(n - 2))/sqrt(1 - r^2)
    p <- 2 * (1 - pt(abs(t), (n - 2)))
    nvar <- ncol(r)
    p[p > 1] <- 1
    if (adjust != "none") {
        if (is.null(y)) {
            lp <- upper.tri(p)
            pa <- p[lp]
            pa <- p.adjust(pa, adjust)
            p[upper.tri(p, diag = FALSE)] <- pa
        }
        else {
            p[] <- p.adjust(p, adjust)
        }
    }

    result <- list(r = r, n = n, t = t, p = p, adjust = adjust, Call = cl)
    class(result) <- c("Pairwise", "pairwiseCorrAndP")
    return(result)
}