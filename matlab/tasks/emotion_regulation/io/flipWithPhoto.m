function vbl = flipWithPhoto(win, drawPhotoFn)
drawPhotoFn(win);
vbl = Screen('Flip', win);
end