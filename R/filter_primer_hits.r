#' Remove empty accession numbers and other problematic rows
#' @param hits_table a data.frame generated by parse_primer_hits
#'        or by iterative_primer_search
#' @param mismatch the maximum allowable value (inclusive) in the
#'        mismatch_forward and mismatch_reverse columns
#' @return a data.table with problematic rows removed
#' @export
filter_primer_hits <- function(hits_table, mismatch = 3, minimum_length = 5,
                                maximum_length = 500) {
    # filter like get_blast_seeds used to
    data.table::setDT(hits_table)
    output <- dplyr::filter(!(accession == " "))
    output <- output %>%
        dplyr::filter(mismatch_forward <= mismatch) %>%
        dplyr::filter(mismatch_reverse <= mismatch) %>%
        dplyr::filter(product_length >= minimum_length) %>%
        dplyr::filter(product_length <= maximum_length)

    # Add amplicon_length column
    # This needs to know the size of the forward and reverse primers
    # That means we either need to pass the forward and reverse primers
    # to this function or we need to pass their lengths here
    # Or maybe that is supposed to happen in another function?
    output <- output %>%
        dplyr::mutate(amplicon_length = product_length - nchar(forward_primer)
                        - nchar(reverse_primer))

    # Arrange by taxonomy
    output <- output %>%
        dplyr::arrange(species) %>%
        dplyr::arrange(genus) %>%
        dplyr::arrange(family)  %>%
        dplyr::arrange(order) %>%
        dplyr::arrange(class) %>%
        dplyr::arrange(phylum) %>%
        dplyr::arrange(superkingdom)
}

`%>%` <- magrittr::`%>%`