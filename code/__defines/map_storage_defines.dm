
#define ADD_SAVED_VAR(X) map_storage_saved_vars = "[map_storage_saved_vars][length(map_storage_saved_vars)? ";" : null][#X]"
#define ADD_SKIP_EMPTY(X) skip_empty = "[skip_empty][length(skip_empty)? ";" : null][#X]"