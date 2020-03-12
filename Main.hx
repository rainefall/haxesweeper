import hxd.Key;
import h2d.Interactive;
import h2d.Object;

class Main extends hxd.App {
    var BoardWidth = 14;
    var BoardHeight = 14;
    var Bombs = 14;
    var board : Array<Array<Int>>;
    // resources
    var tiles : Array<h2d.Tile>;
    // sprites
    var visuals : Array<h2d.Object> = [];
    var blanks : Array<h2d.Object> = [];

    override function init() {
        /*
        obj = new h2d.Object(s2d);

        obj.x = Std.int(s2d.width / 2);
        obj.y = Std.int(s2d.height / 2);

        // load the haxe logo png into a tile
        var tile = hxd.Res.mann.toTile();

        // change its pivot so it is centered
        tile = tile.center();

        var bmp = new h2d.Bitmap(tile, obj);
        */
        // load tiles, please replace these
        tiles = [
            hxd.Res.mann.toTile(), // mine
            hxd.Res.zero.toTile(), // 0
            hxd.Res.one.toTile(), // 1
            hxd.Res.two.toTile(), // 2
            hxd.Res.mann.toTile(), // 3
            hxd.Res.mann.toTile(), // 4
            hxd.Res.mann.toTile(), // 5
            hxd.Res.mann.toTile(), // 6
            hxd.Res.mann.toTile(), // 7
            hxd.Res.mann.toTile()  // 8
        ];

        var blank = hxd.Res.blank.toTile();

        // generate board
        board = [for (y in 0...BoardHeight) [for (x in 0...BoardWidth) 0 ]];

        // add bombs
        for (y in 0...Bombs){
            while (true){
                var x = Std.int(Math.max(Std.int(Math.random()*BoardWidth)-1, 0));
                var y = Std.int(Math.max(Std.int(Math.random()*BoardHeight)-1, 0));
                if (board[y][x] != -1) {
                    board[y][x] = -1;
                    break;
                }
            }
        }

        // calculate other tiles
        for (y in 0...BoardHeight) {
            for (x in 0...BoardWidth) {
                if (board[y][x] == -1) {
                    // we can calculate everything else
                    var n = 0;
                    if (y > 0 && x > 0 && board[y-1][x-1] == -1) n++;
                    if (y > 0 && board[y-1][x] == -1) n++;
                    if (y > 0 && x < BoardWidth-1 && board[y-1][x+1] == -1) n++;
                    if (x > 0 && board[y][x-1] == -1) n++;
                    if (x > 0 && board[y][x] == -1) n++;
                    if (x < BoardWidth-1 && board[y][x+1] == -1) n++;
                    if (y < BoardHeight-1 && x > 0 && board[y+1][x-1] == -1) n++;
                    if (y < BoardHeight-1 && x > 0 && board[y+1][x] == -1) n++;
                    if (y < BoardHeight-1 && x < BoardWidth-1 && board[y+1][x+1] == -1) n++;
                    board[y][x] = Std.int(Math.min(n, 8));
                }
                // make visuals
                visuals.push(new h2d.Object(s2d));
                visuals[y*BoardHeight+x].addChild(new h2d.Bitmap(tiles[board[y][x]+1]));
                visuals[y*BoardHeight+x].setPosition(x * 24, y * 24);
                visuals[y*BoardHeight+x].visible = false;
                // generate visualse: blanks
                blanks.push(new h2d.Object(s2d));
                blanks[y*BoardHeight+x].addChild(new h2d.Bitmap(blank));
                // interactability
                var interact = new h2d.Interactive(24,24,blanks[y*BoardHeight+x]);
                interact.onPush = function(event : hxd.Event) {
                    if (event.keyCode == Key.MOUSE_LEFT) reveal(x, y);
                }
                //blanks[y*BoardHeight+x].addChild(interact);
                blanks[y*BoardHeight+x].setPosition(x * 24, y * 24);
            }
        }
    }

    function reveal(x:Int, y:Int){
        visuals[y*BoardHeight+x].visible = true;
        blanks[y*BoardHeight+x].visible = false;
        if (board[y][x] == 0) {
            // it's zero we can reveal everything around it no problem
            revealSurroundings(x,y);
        }
        if (board[y][x] == -1) {
            // you lose
            trace("boom");
        }
    }

    function revealSurroundings(x:Int, y:Int) {
        if (y > 0 && x > 0 && board[y-1][x-1] == -1) reveal(x-1, y-1);
        if (y > 0 && board[y-1][x] == -1) reveal(x, y-1);
        if (y > 0 && x < BoardWidth-1 && board[y-1][x+1] == -1) reveal(x+1, y-1);
        if (x > 0 && board[y][x-1] == -1) reveal(x-1, y);
        if (x > 0 && board[y][x] == -1) reveal(x, y);
        if (x < BoardWidth-1 && board[y][x+1] == -1) reveal(x+1, y);
        if (y < BoardHeight-1 && x > 0 && board[y+1][x-1] == -1) reveal(x-1, y+1);
        if (y < BoardHeight-1 && x > 0 && board[y+1][x] == -1) reveal(x, y+1);
        if (y < BoardHeight-1 && x < BoardWidth-1 && board[y+1][x+1] == -1) reveal(x+1, y+1);
    }

    override function update(dt:Float) {
        // update is called once per frame
    }
    
    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}