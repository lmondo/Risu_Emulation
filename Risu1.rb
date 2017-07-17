
class Fld
    def initialize(n)
        @fld = []
        @sdfld = []
        @n = n
        @x = rand(n)
        @y = rand(n)
        @c = 0
        @d = 0

        n.times do
            @fld << Array.new(n, 0)
        end

        n.times do
            @sdfld << Array.new(n, 0)
        end

        self.now
        self.cdisp
        return [@fld, @sdfld]
    end
    
    def arry
        return @fld
    end

    def disp
        for i in 0...@n
            p @fld[i]
        end
        puts ""
    end

    def cdisp
        puts "Seed Field"
        for i in 0...@n
            p @sdfld[i]
        end
        puts ""
    end
    

    def now
        @fld[@x][@y] = "R"
        self.disp
        @fld[@x][@y] = 5
    end

    def move
        d = ["up", "down","right", "left", "jump"]
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
        puts d[r]
        self.now
        self.chase
    end

    def chase
        for i in 0...@n
            for j in 0...@n
                if @fld[i][j] > 0
                    @fld[i][j] -= 1
                end
            end
        end
        return @fld
    end

    def seed
        if rand(2) > 0
            @sdfld[@x][@y] += 1
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

    def dig
        if rand(2) > 0
            if @sdfld[@x][@y] >= 1
                @sdfld[@x][@y] -= 1
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

    def plya
        self.move
        self.seed
        self.dig
    end

end

n = 5
fld =  Fld.new(n)
100.times do
    fld.plya
    sleep(0.1)
end

print "number of seeds = "
fld.cnum

print "number of digs = "
fld.dnum