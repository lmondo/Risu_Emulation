
class Field                 #Field class    木の生えたフィールド、木の実を埋められたフィールドの２種フィールドがある。
    def initialize(n)       #initialize
        @fld = []           #@fld: n*nのField
        @sdfld = []         #@sdfld:Seed Field,  植えられた種の情報 
        @n = n
        @c = 0              #埋められた種の総数
        @d = 0              #掘り出された種の総数
        @f = 4              #線引きの倍率

        n.times do                  #Making Field
            @fld << Array.new(n, 0)
        end

        n.times do                  #Making Seed Field
            @sdfld << Array.new(n, 0)
        end
    end

    def tree                #木を植える
        @n.times do
            x = rand(@n)
            y = rand(@n)
            @fld[x][y] = "T"
            @sdfld[x][y] = "T"
        end
    end

    def fld
        return @fld
    end

    def fldpoin(x, y)
        return @fld[x][y]
    end

    def sdfld
        return @sdfld
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
            p @sdfld[i]
        end
        puts "-"*@n*@f
    end

    def now(x, y)           #Risu の現在位置を Field に "R" として置く
        @fld[x][y] = "R"
    end

    def clean(x,y)
        @fld[x][y] = 0
    end

    def show(x, y)          #Risu の現在位置を Field に "R" として置き尚且つ表示
        self.now(x, y)
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

    def seed(x, y)          #2/3の確率で Risu の現在位置に木の実を埋める。
        if (rand(3) > 0) and (@sdfld[x][y] != "T")      #埋める場所に木が生えてないこと
            @sdfld[x][y] += 1
            self.cdisp
            @c += 1
        end
    end

    def cnum                #埋めた木の実の数を表示。
        puts @c
    end

    def seednum
        return @c
    end

    def dig(x, y)
        if (rand(2) > 0) and (@sdfld[x][y] != "T")      #掘り起こす場所が木でないこと
            if @sdfld[x][y] >= 1
                @sdfld[x][y] -= 1
                puts "dig!"
                self.cdisp
                @c -= 1
                @d += 1
            end
        end
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
        @hvsd = 0
        @fld = Field.new(@n)
        @fld.tree
        puts "First Location"
        @fld.show(@x, @y)
        #@fld.chase
    end

    def move
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
                @fld.now(@x, @y)
                puts d[r]
                break
            end
        }
        @fld.disp
        #@fld.chase       
    end

    def dig
        @fld.dig(@x, @y)
    end

    def seed
        @fld.seed(@x, @y)
    end

    def play
        dice = rand(3)
        if dice == 0
            self.move
        elsif dice == 1
            self.dig
        elsif dice == 2
            self.seed
        else
            self.move
        end
    end
    
    def seeding
        print "埋まってる数"
        @fld.cnum
        print "掘り出した数"
        @fld.dnum
    end

    def fldisp
        puts "Field"
        @fld.disp
    end

    def sdisp
        @fld.cdisp
    end

end



n = 8
risu = Risu.new(n)

10.times do
    risu.play
    sleep(0.1)
end
risu.seeding

risu.fldisp
risu.sdisp

