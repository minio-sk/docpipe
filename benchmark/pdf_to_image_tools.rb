require 'benchmark'
require 'fileutils'

Benchmark.bm do |x|
  x.report("gm hi-res 200dpi") { `gm convert +adjoin -define pdf:use-cropbox=true -limit memory 256MiB -limit map 512MiB -density 200 -quality 85 hi-res.pdf gm-hr-%d.jpg 2>&1 /dev/null` }
  x.report("gs hi-res 200dpi") { `gs -dNOPAUSE -dBATCH -sDEVICE=jpeg -r200 -sOutputFile='gs-hr-%00d.jpg' hi-res.pdf 2>&1 /dev/null` }
  x.report("gm low-res 200dpi") { `gm convert +adjoin -define pdf:use-cropbox=true -limit memory 256MiB -limit map 512MiB -density 200 -quality 85 low-res.pdf gm-lr-%d.jpg 2>&1 /dev/null` }
  x.report("gs low-res 200dpi") { `gs -dNOPAUSE -dBATCH -sDEVICE=jpeg -r200 -sOutputFile='gs-lr-%00d.jpg' low-res.pdf 2>&1 /dev/null` }
end

Dir.glob('*.jpg').each { |path| FileUtils.rm(path) }
