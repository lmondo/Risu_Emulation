
#[(0,0), (0,1)]     ↓x  →y
#[(1,0), (1,1)]


def ndarry(n)
    ndarry = []
    n.times do
        ndarry << Array.new(n, 0)
    end
    return ndarry
end

class Field                            #Field class    木の生えたフィールド、木の実を埋められたフィールドの２種フィールドがある。
    def initialize(n)                  #initialize
        @n = n
        @fld = ndarry(@n)             #@fld: n*nのField
        @seedfld = ndarry(@n)         #@seedfld:Seed Field, 埋められた種の位置のフィールド
        @surfacefld = ndarry(@n)      #木の実が落ちてる位置のフィールド
        @c = 0                        #埋められた種の総数
        @d = 0                        #掘り出された種の総数
        @f = 4                        #線引きの倍率
        @trees = []                   #木を植えた位置を保存   @trees = [[x1, y1,[UDRL]], [x2, y1,[UDRL]], ...]
        self.tree                     #木を植える
    end

    def tree                          #木を植える
        @n.times do
            udrl = []
            x = rand(@n)
            y = rand(@n)
            
            if x > 0
                if @surfacefld[x-1][y] != "T"
                    udrl << [x-1, y]      #up 
                end
            end
            if x < @n-1
                if @surfacefld[x+1][y] != "T"
                    udrl << [x+1, y]      #down
                end
            end
            if y < @n-1
                if @surfacefld[x][y+1] != "T"
                    udrl << [x, y+1]      #right
                end
            end    
            if y > 0
                if @surfacefld[x][y-1] != "T"
                    udrl << [x, y-1]      #left
                end
            end        

            @trees << [[x, y], udrl]
            @fld[x][y] = "T"
            @seedfld[x][y] = "T"
            @surfacefld[x][y] = "T"
        end
    end

    def fallin      木の実を落とす座標をudrlに格納します。
        for i in 0...@n
            udrl = @trees[i][1]
            udrl.map{|v|
                x = v[0]
                y = v[1]
                if rand(2) > 0
                    if surfacefld[x][y] != "T"
                        @surfacefld[x][y] += 1
                    end
                end
            }
        end
    end

    def fld
        return @fld
    end

    def seedfld
        return @seedfld
    end

    def surfacefld
        return @surfacefld
    end

    def trees
        return @trees
    end

    def fldpoin(x, y)
        return @fld[x][y]
    end

    def show
        self.disp
        self.cdisp
        self.sdisp
    end

    def disp                #現在の Field を表示
        for i in 0...@n
            p @fld[i]
        end
        puts "-"*@n*@f
    end

    def cdisp               #現在の Seed Field を表示
        puts "Seed Field"
        for i in 0...@n
            p @seedfld[i]
        end
        puts "-"*@n*@f
    end

    def sdisp               #現在の surface Field を表示
        puts "surface Field"
        for i in 0...@n
            p @surfacefld[i]
        end
        puts "-"*@n*@f
    end

    def locate(x, y)           #Risu の現在位置を Field に "R" として置く
        @fld[x][y] = "R"
    end

    def clean(x,y)
        @fld[x][y] = 0
    end

    def locsp(x, y)          #Risu の現在位置を Field に "R" として置き尚且つ表示
        self.locate(x, y)
        self.disp
    end

    def chase               #Risu のいた履歴を近い順に5,4,3,2,1で表示。   現在廃止。
        for i in 0...@n
            for j in 0...@n
                if @fld[i][j] == "R"
                    @fld[i][j] = 5
                end
                if (@fld[i][j] != "T") and (@fld[i][j] > 0)
                    @fld[i][j] -= 1
                end
            end
        end
        return @fld
    end

    def fillin(x, y)          #Risu の現在位置に木の実を埋める。
        if @seedfld[x][y] != "T"      #埋める場所に木が生えてないこと
            @seedfld[x][y] += 1
            puts "fill in!"
            self.cdisp
            @c += 1
            num = 1
        else
            num = 0
        end
        return num
    end

    def cnum                #埋めた木の実の数を表示。
        puts @c
    end

    def seednum
        return @c
    end

    def dig(x, y)       #木の実を掘り出す。
        if @seedfld[x][y] != "T"      #掘り起こす場所が木でないこと
            @seedfld[x][y] -= 1
            puts "dig!"
            self.cdisp
            @c -= 1
            @d += 1
            num = 1
        else
            num = 0
        end
        return num
    end

    def getseed(x, y)   #木の実を拾う。
        if surfacefld[x][y] != "T"
            if @surfacefld[x][y] > 0
                @surfacefld[x][y] -= 1
                num = 1
            else
                num = 0
            end
        else
            num = 0
        end
        return num
    end

    def dnum            #掘り出した木の実の数を表示。
        puts @d
    end

end


class Risu              #Risu の誕生。移動move, 埋めるseed, 掘り出すdig の計３種の動き, Risu と同時に Field も作成。
    def initialize(n)
        @n = n
        @x = rand(n)
        @y = rand(n)
        @hvsd = 0       #持ってる数
        @gtsd = 0       #ゲットした数
        @fld = Field.new(@n)
        @fld.tree
        puts "First location"
        @fld.locate(@x, @y)
        #@fld.chase
    end

    def move            #移動　上下左右、　ランダム。
        @fld.clean(@x, @y)
        d = ["up", "down","right", "left", "jump"]
        loop{
            r = rand(@n)
            if r == 0
                @x -= 1 if @x > 0
            elsif r == 1
                @x += 1 if @x < @n - 1
            elsif r == 2
                @y += 1 if @y < @n -1
            elsif r == 3
                @y -= 1 if @y > 0
            elsif r == 4
                @x = rand(@n)
                @y = rand(@n)
            end

            if @fld.fldpoin(@x, @y) != "T"
                @fld.locate(@x, @y)
                puts d[r]
                break
            end
        }
        @fld.disp
        #@fld.chase       
    end

    def dig                 #木の実を掘り出す。
        @hvsd += @fld.dig(@x, @y)
    end

    def fillin              #現在位置に木の実を埋める。
        if @hvsd > 0
            @hvsd -= @fld.fillin(@x, @y)
        end
    end

    def getseed             #木の実を掘り出す。
        @gtsd += 1
        @hvsd += @fld.getseed(@x, @y)
    end

    def play
        dice = rand(4)
        if dice == 0
            self.move           #移動
        elsif dice == 1
            self.dig            #木の実を掘り出す
        elsif dice == 2
            self.fillin         #木の実を埋める
        elsif dice == 3
            self.getseed        #木の実を拾う
        else
            self.move
        end

        @fld.fallin
    end
    
    def seeds
        print "埋まってる数"
        @fld.cnum
        print "掘り出した数"
        @fld.dnum
        puts "持ってる数 #{@hvsd}"
        puts "ゲットした数 #{@gtsd}"
    end

    def fldisp
        puts "Field"
        @fld.disp
    end

    def cdisp
        @fld.cdisp
    end

    def sdisp
        @fld.sdisp
    end

    def show
        @fld.show
    end

    def fallin
        @fld.fallin
    end

end



n = 4
risu = Risu.new(n)

100.times do
    risu.play
    sleep(0.01)
end

risu.seeds
risu.fallin
#risu.show
