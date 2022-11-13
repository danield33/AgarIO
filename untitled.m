tic
dist = zeros(0, 1000)
for i = 1:1000
    x1 = randi(500);
    y1 = randi(500);
    x2 = randi(500);
    y2 = randi(500);
    dist(i) = norm([x1 y1] - [x2 y2]);
end
toc
fprintf("hi\n")
tic
dista = zeros(0, 1000);
for i = 1:1000
    x1 = randi(500);
    y1 = randi(500);
    x2 = randi(500);
    y2 = randi(500);
    dista(i) = sqrt((x1-x2)^2 + (y1-y2)^2);
end
toc