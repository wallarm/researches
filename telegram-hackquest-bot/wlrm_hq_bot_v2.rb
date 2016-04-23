#!/usr/bin/ruby

require 'telegram/bot'
require 'redis'
require 'pp'

r = Redis.new
token = 'aa:bb'
master_chat = 1234567890

#r.flushall
#r.set 'FLG_7ce34b57c3c6b6c7aee372f1794a8993', {cost: 100,  name: 'Welcome bonus',        url: 'N/A'}.to_json

Telegram::Bot::Client.run(token) do |bot|
begin
  bot.listen do |message|
    begin
      r.hset 'chats', message.chat.id, Time.now.to_i
      userid = message.from.id.to_s
      command = message.text.split(' ', 2)
      case command[0]
      when '/start'
        bot.api.sendMessage(chat_id: message.chat.id, text: "Welcome to the PHDays2016 hackquest, #{message.from.first_name} (#{userid})!")
        bot.api.sendMessage(chat_id: message.chat.id, text: "Usage: \n/unsolved\n/addflag 7ce34b57c3c6b6c7aee372f1794a8993\n/stats <all>\n/history")
      when '/addflag'
        flag = command[1]
        if flag==nil or !flag.match(/[0-9a-fA-F]{32}/) then
          bot.api.sendMessage(chat_id: message.chat.id, text: "[ERR] MySQL Error 1064: You have an error in your SQL syntax")
        else
          flag_data = r.get 'FLG_'+flag
          if flag_data!=nil
            flag_data = JSON.parse(flag_data)
            if flag_data!=nil && flag_data['cost']>0 then
              flag_index = r.hget userid+'_flags', flag
              if(flag_index==nil)
                user_hash = "#{message.from.username} (#{userid})"
                last_flag_time = Time.now.to_i

                r.hset    userid+'_flags', flag,   last_flag_time
                r.hincrby 'stats',         userid, flag_data['cost']
                r.hset    'last',          userid, { name: message.from.username==nil ? 'U-'+userid : message.from.username , 
                                                     time: last_flag_time, 
                                                     score: (r.hget 'stats', userid)
                                                   }.to_json
                
                bot.api.sendMessage(chat_id: message.chat.id, text: "Success! Task #{flag_data['name']} solved. You got #{flag_data['cost']} points!")
                bot.api.sendMessage(chat_id: master_chat,     text: "[FLG-#{flag_data['cost']}] Task #{flag_data['name']} solved by #{message.from.username} (#{userid})")
              else
                bot.api.sendMessage(chat_id: message.chat.id, text: "[ERR] This flag has been added before")
              end
            end
          else
            bot.api.sendMessage(chat_id: message.chat.id, text: "[ERR] Flag not found! Try again...")
          end
        end
      when '/history'
        flags = r.hgetall userid+'_flags'
        if flags!=nil
          flags.each { |f| 
            flag_data = JSON.parse(r.get 'FLG_'+f[0])
            bot.api.sendMessage(chat_id: message.chat.id, text: Time.at(f[1].to_i).to_s+" "+flag_data['name']+" "+flag_data['cost'].to_s)
          }
        else
          bot.api.sendMessage(chat_id: message.chat.id, text: "Try to solve smth first...")
        end
      when '/stats'
        if command[1]!='tasks' then
          stats = r.hgetall 'last'
          if stats.count>0
            i = 0
            s = stats.map{|k, v| { name: JSON.parse(v)['name'], score: JSON.parse(v)['score'].to_i, time: JSON.parse(v)['time'].to_i } }
            s = s.sort_by{ |v| [ -v[:score], v[:time] ] }.map{ |v| "#{i = i+1}. #{v[:score]} \t #{v[:name]}"}
            bot.api.sendMessage(chat_id: message.chat.id, text: command[1]=='all' ? s.join("\n")  : s.first(10).join("\n") )
          end
        else
          solved = Hash.new
          tasks = Hash.new

          (r.keys '*_flags').each { |k|
            (r.hgetall k).each { |f|
              solved[f[0]]==nil ? solved[f[0]] = 1 : (solved[f[0]] += 1)
            }
          }

          flags = (r.keys 'FLG_*').map{ |v| v[4..v.length] }
          
          flags.each{ |f|
            task = JSON.parse(r.get 'FLG_'+f)['name']
            tasks[task] = solved[f]==nil ? 0 : solved[f]
          }
          tasks = tasks.sort_by{ |k,v| -v }.map{ |name,solved| "#{name}: #{solved}" }
          bot.api.sendMessage(chat_id: message.chat.id, text: tasks.join("\n"))
          participants = r.hlen 'chats'
          qualified = r.hlen 'last'
          bot.api.sendMessage(chat_id: message.chat.id, text: "TOTAL: #{qualified}/#{participants} participants solved more than one task")
        end
      when '/unsolved'
        flags  = r.keys 'FLG_*'
        flags = flags.map{ |v| v[4..v.length] }
        solved = r.hgetall userid+'_flags'
        solved = solved.map{ |v| v[0] }
        unsolved = flags-solved
        unsolved_flags = Array.new
        unsolved.each { |f| unsolved_flags << JSON.parse(r.get 'FLG_'+f) }
        unsolved_flags.sort_by! { |v| -v['cost'] }
        unsolved_flags.map! { |flag_data| "[#{flag_data['cost'].to_s}] #{flag_data['name']}: #{flag_data['url']}" }
        bot.api.sendMessage(chat_id: message.chat.id, text: unsolved_flags.join("\n"))
      when '/debug-hasd67yvt76gsf6d57asuydasd'
        bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.chat.id}")
      when '/giveahint'
        if message.chat.id==master_chat
          chats = r.hgetall 'chats'
          chats.each { |ch|
            begin
              bot.api.sendMessage(chat_id: ch[0], text: command[1])
            rescue Exception => x
               sleep(0.1)
            end
          } 
        end
      end
    rescue Exception => e
      bot.api.sendMessage(chat_id: message.chat.id, text: "[ERR] Bot #{e} exception: #{e.message}. Exception bonus is f1c0db1e6ebd4690b3030d129b92ba86")
      pp e.backtrace
    end
  end

rescue Exception => ee
  pp ee.backtrace
  retry 
end

end
