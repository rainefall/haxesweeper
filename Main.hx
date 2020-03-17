import h3d.Vector;
import hxd.Key;
import h2d.Interactive;
import h2d.Object;

class Main extends hxd.App {
    var BoardWidth = 64;
    var BoardHeight = 32;
    var Bombs = 256;
    var board : Array<Array<Int>>;
    // resources
    var tiles : Array<h2d.Tile>;
    var blank : h2d.Tile;
    // sprites
    var visuals : Array<h2d.Object>;
    var blanks : Array<h2d.Object>;
    var text : h2d.Text;

    var exploded : Bool;

    function generateBoard() {
        exploded = false;
        blanks = [];
        visuals = []; 
        
        // generate board
        board = [for (y in 0...BoardHeight) [for (x in 0...BoardWidth) 0 ]];

        // add bombs
        for (i in 0...Bombs){
            while (true){
                var x = Std.int(Math.max(Std.int(Math.random()*BoardWidth)-1, 0));
                var y = Std.int(Math.max(Std.int(Math.random()*BoardHeight)-1, 0));
                trace (x); trace(y);
                if (board[y][x] != -1) {
                    board[y][x] = -1;
                    break;
                }
            }
        }

        // calculate other tiles
        for (y in 0...BoardHeight) {
            for (x in 0...BoardWidth) {
                if (board[y][x] != -1) {
                    // we can calculate everything else
                    var n = 0;
                    if (y > 0 && x > 0 && board[y-1][x-1] == -1) n++;
                    if (y > 0 && board[y-1][x] == -1) n++;
                    if (y > 0 && x < BoardWidth-1 && board[y-1][x+1] == -1) n++;
                    
                    if (x > 0 && board[y][x-1] == -1) n++;
                    if (x < BoardWidth-1 && board[y][x+1] == -1) n++;
                    
                    if (y < BoardHeight-1 && x > 0 && board[y+1][x-1] == -1) n++;
                    if (y < BoardHeight-1 && board[y+1][x] == -1) n++;
                    if (y < BoardHeight-1 && x < BoardWidth-1 && board[y+1][x+1] == -1) n++;
                    
                    board[y][x] = n;
                }
                // make visuals
                visuals.push(new h2d.Object(s2d));
                visuals[y*BoardWidth+x].addChild(new h2d.Bitmap(tiles[board[y][x]+1]));
                var interact = new h2d.Interactive(24,24,visuals[y*BoardWidth+x]);
                interact.onClick = function(e : hxd.Event) {
                    if (exploded) {
                        generateBoard();
                    }
                }
                visuals[y*BoardWidth+x].addChild(interact);
                visuals[y*BoardWidth+x].setPosition(x * 24, y * 24);
                visuals[y*BoardWidth+x].visible = false;
                // generate visualse: blanks
                blanks.push(new h2d.Object(s2d));
                blanks[y*BoardWidth+x].addChild(new h2d.Bitmap(blank));
                // interactability
                interact = new h2d.Interactive(24,24,blanks[y*BoardWidth+x]);
                interact.onClick = function(e : hxd.Event) {
                    if (exploded) {
                        generateBoard();
                    } else if (e.button == 0) {
                        reveal(x, y);
                    }
                }
                blanks[y*BoardWidth+x].addChild(interact);
                blanks[y*BoardWidth+x].setPosition(x * 24, y * 24);
            }
        }

        text = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        text.setPosition(32,32);
        text.color = new h3d.Vector(0,0,0);
        text.text = "you utter fool.";
        text.visible = false;
    }

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
            hxd.Res.bomb.toTile(), // mine
            hxd.Res.zero.toTile(), // 0
            hxd.Res.one.toTile(), // 1
            hxd.Res.two.toTile(), // 2
            hxd.Res.three.toTile(), // 3
            hxd.Res.four.toTile(), // 4
            hxd.Res.five.toTile(), // 5
            hxd.Res.six.toTile(), // 6
            hxd.Res.seven.toTile(), // 7
            hxd.Res.eight.toTile()  // 8
        ];

        blank = hxd.Res.blank.toTile();

        generateBoard();
    }

    inline function reveal(x:Int, y:Int){
        if (visuals[y*BoardWidth+x].visible == false) {
            visuals[y*BoardWidth+x].visible = true;
            blanks[y*BoardWidth+x].visible = false;
            if (board[y][x] == 0) {
                // it's zero we can reveal everything around it no problem
                revealSurroundings(x,y);
            }
            if (board[y][x] == -1) {
                // you lose
                text.visible = true;
                exploded = true;
            }
        }
    }

    inline function revealSurroundings(x:Int, y:Int) {
        trace (x); trace (y);
        if (y > 0 && x > 0) reveal(x-1, y-1); // ul
        if (y > 0) reveal(x, y-1); // uc
        if (y > 0 && x < BoardWidth-1) reveal(x+1, y-1); // ur

        if (x > 0) reveal(x-1, y); // cl
        if (x < BoardWidth-1) reveal(x+1, y); // cr

        if (y < BoardHeight-1 && x > 0) reveal(x-1, y+1); // ll
        if (y < BoardHeight-1) reveal(x, y+1); // lc
        if (y < BoardHeight-1 && x < BoardWidth-1) reveal(x+1, y+1); // lr
    }

    override function update(dt:Float) {
        // update is called once per frame
    }
    
    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}