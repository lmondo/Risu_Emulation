
class Field
    def initialize(n)
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

    def tree
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

    def disp
        for i in 0...@n
            p @fld[i]
        end
        puts "-"*@n*@f
    end

    def cdisp
        puts "Seed Field"
        for i in 0...@n
            p @sdfld[i]
        end
        puts "-"*@n*@f
    end

    def now(x, y)
        @fld[x][y] = "R"
    end

    def show(x, y)
        self.now(x, y)
        self.disp
    end

    def chase
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

    def seed(x, y)
        if (rand(2) > 0) and (@sdfld[x][y] != "T")
            @sdfld[x][y] += 1
            self.cdisp
            @c += 1
        end
    end

    def cnum
        puts @c
    end

    def seednum
        return @c
    end

    def dig(x, y)
        if (rand(2) > 0) and (@sdfld[x][y] != "T")
            if @sdfld[x][y] >= 1
                @sdfld[x][y] -= 1
                puts "dig!"
                self.cdisp
                @c -= 1
                @d += 1
            end
        end
    end

    def dnum
        puts @d
    end

end


class Risu
    def initialize(n)
        @n = n
        @x = rand(n)
        @y = rand(n)
        @hvsd = 0
        @fld = Field.new(@n)
        @fld.tree
        puts "First Location"
        @fld.show(@x, @y)
        @fld.chase
    end

    def move
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
        @fld.chase       
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


end



n = 5
risu = Risu.new(n)

100.times do
    risu.play
    sleep(0.1)
end
risu.seeding




