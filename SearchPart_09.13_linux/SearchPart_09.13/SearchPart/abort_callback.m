function abort_callback(obj,a,pbar)
    delete(pbar.bar);
    pbar.aborted=true;      % abort search
end