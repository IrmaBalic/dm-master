class MathModel
  
  attr_accessor :f, :a, :b, :y, :k_limit, :s_limit, :s_0, :s_n, :n, :z, :xs 

  def initialize(n, f, a, b, y, k_limit, s_limit, s_0, s_n)
    @n = n
    @f = f
    @a = a
    @b = b
    @y = y
    @k_limit = k_limit
    @s_limit = s_limit
    @s_0 = s_0
    @s_n = s_n

    @z = []
    @xs = []

    self
  end


  # Calculate C(x, s)
  def val_i(i, x_i, s_i)
    val = s_i * b[i]
    val += f[i] + x_i * a[i] if x_i != 0
    return val
  end

  def read_result
    # Read results : x-s pairs and minimal z value
    xs_result = []
    s, x = xs[n-1][0][1], xs[n-1][0][0]

    (0..n-1).reverse_each { |i|
      xs_result << [x, s]

      if i > 0
        s = s + y[i] - x
        x = xs[i-1][s][0]
      end
    }

    return {
      :z => z[n-1][0],
      :xs_pairs => xs_result.reverse!
    }
  end


  def solve_problem
    # Periods
    for i in 0..n-1
      z[i], xs[i] = [], []

      s_dlimit = 0 # Down limit s
      s_hlimit = [ s_limit[i], s_n + y[i+1..n].sum ].min #Up limit s
      s_temp_i = *(s_dlimit..s_hlimit) # Set range as array
      
      # s values
      for k in 0..(s_temp_i.size - 1)
        s_temp = s_temp_i[k]

        if i == 0
          x_dlimit = 0 # Down limit x
          x_hlimit = k_limit[i] #Up limit x

          x_temp = s_temp + y[i] - s_0
          if x_temp.between?(x_dlimit, x_hlimit)
              z[i][s_temp] = val_i(i, x_temp, s_temp)
              xs[i][s_temp] = [x_temp, s_temp]
          end
        else

          # Check if current iteration is the last one
          # If yes, s value is already given
          if i == n - 1 
            next unless k == s_n
            s_temp = s_n
          end

          x_dlimit = [0, s_temp + y[i] - s_limit[i-1]].max # Down limit x
          x_hlimit = [k_limit[i], s_temp + y[i]].min #Up limit x
          min, counter = 0, 0

          for m in x_dlimit..x_hlimit
            x_temp = m
            current_val = val_i(i, x_temp, s_temp)
            
            # Calculate Z value for each pair combinaton
            s_prev = s_temp + y[i] - x_temp
            x_prev = 0
            if i == 1
              x_prev = s_prev + y[i-1] - s_0      
              z_val = current_val + z[i-1][s_prev]
            elsif i > 1
              next if xs[i-1][s_prev].nil?      
          
              x_prev = xs[i-1][s_prev].first                
              z_val = current_val + z[i-1][s_prev]
            end

            # Find min z value for each s
            if counter == 0
                min = z_val
                z[i] << min
                xs[i] << [x_temp, s_temp]
            else
                if z_val < min
                    min = z_val
                    z[i][s_temp] = min
                    xs[i][s_temp] = [x_temp, s_temp]
                end
            end
            counter += 1

            end
              
          end
      end

    end
  end

end