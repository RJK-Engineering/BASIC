# FONT.BAS

## Reference

https://github.com/cc65/cc65/blob/master/src/chrcvt65/main.c

## TODO

only catch out of data error

pack x,y into integer

get rid of remaining?

- Q to exit
- menu with options: previews, quit, font select
- string input, font selection

### Fonts on html5 canvas

- https://www.w3schools.com/jsref/dom_obj_canvas.asp
- https://www.w3resource.com/html5-canvas/html5-canvas-path.php

1. font2json
2. draw chars using json file

```
<!DOCTYPE html>
<html>
<head>
<title>Sample arcs example</title>
</head>
<body>
<canvas id="myCanvas" width="300" height="600"></canvas>
<script>
var canvas = document.getElementById("myCanvas");
if (canvas.getContext)
{
 var ctx = canvas.getContext('2d');
 ctx.beginPath();     // Start a new path.
 ctx.lineWidth = "3";
 ctx.strokeStyle = "green";  // This path is green.
 ctx.moveTo(0, 0);
 ctx.lineTo(160, 160);
 ctx.lineTo(200, 160);
 ctx.stroke();
 ctx.beginPath();
 ctx.strokeStyle = "blue";  // This path is blue.
 ctx.moveTo(0, 0);
 ctx.lineTo(50, 170);
 ctx.stroke();
 ctx.closePath(); // Close the current path.
}
</script>
</body>
</html>
```
