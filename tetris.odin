package tetris

//import "core:fmt"
import rl "vendor:raylib"
import re"rendering"
import as "assets"
import rand "core:math/rand"
import "core:fmt"
import "core:strings"
import "core:strconv"

cell_size:i32:30
game_g_w:i32:10
game_g_h:i32:20
game_grid:[game_g_w][game_g_h]i32
colors:=[?]rl.Color {
{100,100,100,100},
{47,230,23,255},
{232,18,18,255},
{226,116,17,255},
{237,234,4,255},
{116,0,247,255},
{21,204,209,255},
{13,64,216,255}
}

block_data::struct{
    cells:[4][4][2]i32,
    id:i32,
    r_state:i32,
    starting_pos:[2]i32,
    scr_ofset:[2]f32
}


l_block:block_data
j_block:block_data
i_block:block_data
o_block:block_data
s_block:block_data
t_block:block_data
z_block:block_data
cer_block:block_data
next_block:block_data
cer_block_pos:[2]i32
all_blocks:[7]block_data
rand_blocks:[7]int={0,1,2,3,4,5,6}
rand_cycle:int=6
game_over:bool
tick_timer: f32 = tick_rate
tick_rate::0.2

score_size:i32:190
pading:i32:20
canvas_size_w::game_g_w*cell_size+score_size+pading
canvas_size_h::game_g_h*cell_size+1

score:i32
hight_score:i32

cant_slide:rl.Sound

init_tetris::proc(){
// game_grid[2][3]=3
// game_grid[7][4]=1
// game_grid[0][0]=1
// game_grid[9][0]=2
// game_grid[9][1]=3
// game_grid[0][0]=1
rl.SetSoundVolume(as.sounds[as.sound_names.s_pop], 0.7)
rl.SetSoundVolume(as.sounds[as.sound_names.s_thud], 0.5)
rl.SetSoundVolume(as.sounds[as.sound_names.s_nu], 0.3)
rl.SetSoundVolume(as.sounds[as.sound_names.running_1], 2)
rl.SetSoundVolume(as.sounds[as.sound_names.running_6], 40)
rl.SetSoundPitch(as.sounds[as.sound_names.s_nu], 1.5) 
rl.SetSoundPitch(as.sounds[as.sound_names.running_6], 0.7) 
cant_slide = rl.LoadSoundAlias(as.sounds[as.sound_names.s_nu])
rl.SetSoundVolume(cant_slide, 0.5)

init_blocks()
all_blocks = {l_block,j_block,i_block,o_block,s_block,t_block,z_block}
rand.shuffle(rand_blocks[:])
cer_block=get_rand_block()
cer_block_pos = cer_block.starting_pos
next_block=get_rand_block()

}
get_rand_block::proc()->block_data{
    if rand_cycle <1{
        rand_cycle = 7
        rand.shuffle(rand_blocks[:])
    }
 
    rand_cycle -= 1
    //fmt.print(rand_blocks[rand_cycle])
    //fmt.print("                                                                                                                                                                                                                               ")
 return all_blocks[rand_blocks[rand_cycle]]
}

tetris_logic::proc(){
    //cer_block = get_rand_block()
    input()
    if game_over {
        //fmt.print("GAME OVER")
    }else{
        tick_timer -= rl.GetFrameTime()
    }

    if tick_timer <= 0 {
        if can_set_cer_block({0,1}){
            move_cer_block({0,1})
        }else{
            if can_set_cer_block(){
                set_cer_block()
                cer_block = next_block
                next_block = get_rand_block()
                cer_block_pos = cer_block.starting_pos

            }else{
                game_over = true
            }
        }
        competed_rows:i32=0
        for y := game_g_h-1; y > -1; y -= 1 {
            cells_filled:i32=0
            for x in 0..<game_g_w{
                if x == 9 && competed_rows > 0{
                    for j in 0..<10{
                        game_grid[x-cast(i32)j][y+competed_rows] = game_grid[x-cast(i32)j][y]
                    }
                }
                if game_grid[x][y] != 0{
                    cells_filled += 1
                    if cells_filled == 10{
                        competed_rows += 1
                        for i in 0..<10{
                            for t in 0..=30 {
                                particle :re.Particle = re.gen_p({cast(f32)(x-cast(i32)i*cell_size)*-1,cast(f32)(y*cell_size)},colors[game_grid[x+cast(i32)i-9][y]])
                                re.spawn_particle(particle)
                            }
                            game_grid[x+cast(i32)i-9][y] = 0
                        }
                    }
                }
            }
            cells_filled = 0
        }
        if competed_rows > 0 {
            if competed_rows == 1{ score += competed_rows * 40}
            if competed_rows == 2{ score += competed_rows * 50}
            if competed_rows == 3{ score += competed_rows * 100}
            if competed_rows == 4{ score += competed_rows * 300}
            rl.PlaySound(as.sounds[as.sound_names.running_6])
        }
        tick_timer = tick_rate + tick_timer
    }
}
restart_tetris::proc(){
    if hight_score<score{
        hight_score = score
    }
    score = 0
    cer_block=get_rand_block()
    next_block=get_rand_block()
    cer_block=get_rand_block()
    next_block=get_rand_block()
    cer_block=get_rand_block()
    next_block=get_rand_block()
    cer_block=get_rand_block()
    next_block=get_rand_block()
    cer_block=get_rand_block()
    next_block=get_rand_block()
    cer_block=get_rand_block()
    next_block=get_rand_block()
    cer_block=get_rand_block()
    next_block=get_rand_block()
    rand_cycle = 6
    cer_block_pos = cer_block.starting_pos
    for y := game_g_h-1; y > -1; y -= 1 {
        for x in 0..<game_g_w{
            game_grid[x][y] = 0
        }
    }    
    game_over = false
}
input::proc(){
    key_pressed := rl.GetKeyPressed()
    if key_pressed == .LEFT{
        //fmt.print("l")
        if can_set_cer_block({-1,0}){
            move_cer_block({-1,0})
            rl.PlaySound(as.sounds[as.sound_names.running_1])
        }else{
            rl.PlaySound(cant_slide)
        }
    } else if key_pressed == .RIGHT {
        //fmt.print("r")
        if can_set_cer_block({1,0}){
            move_cer_block({1,0})
            rl.PlaySound(as.sounds[as.sound_names.running_1])
        }else{
            rl.PlaySound(cant_slide)
        }
    } else if key_pressed == .DOWN {
        //fmt.print("d")
        if can_set_cer_block({0,1}){
            move_cer_block({0,1})
            rl.PlaySound(as.sounds[as.sound_names.running_1])
            score += 1
        }
    } else if key_pressed == .UP {
        //fmt.print("u")
        if can_rot_cer_block(){
            rotate_cer_block()
        }else if can_rot_cer_block({1,0}){
            move_cer_block({1,0})
            rotate_cer_block()
        }else if can_rot_cer_block({-1,0}){
            move_cer_block({-1,0})
            rotate_cer_block()
        }else if can_rot_cer_block({2,0}){
            move_cer_block({2,0})
            rotate_cer_block()
        }else if can_rot_cer_block({-2,0}){
            move_cer_block({-2,0})
            rotate_cer_block()
        }
        rl.PlaySound(as.sounds[as.sound_names.s_nu])
    } else if key_pressed ==.SPACE {
            for i in 0..=20 {
                if can_set_cer_block({0,1}){
                move_cer_block({0,1})
                score += 1
            }
            tick_timer = 0
            rl.PlaySound(as.sounds[as.sound_names.s_pop])
        }
    }
    if game_over{
        if rl.IsKeyPressed(.ENTER){
            restart_tetris()
        }
    }
}

tetris_draw::proc(){
    draw_grid()
    if !game_over{
        draw_block(cer_block,cer_block_pos)
    }else if game_over{
        rl.DrawText("Game Over!" ,4 ,4 ,25,rl.RED)
        rl.DrawText("Press Enter to Play Again" ,4 ,30 ,15,rl.BLACK)
    }
    rl.DrawRectangleLinesEx(rl.Rectangle{-cast(f32)pading, -cast(f32)pading, cast(f32)canvas_size_w+cast(f32)pading*2, cast(f32)canvas_size_h+cast(f32)pading*2},cast(f32)pading,{0,0,40,255})
    rl.DrawRectangleLinesEx(rl.Rectangle{cast(f32)cell_size*10+1, -cast(f32)pading, cast(f32)pading, cast(f32)canvas_size_h+cast(f32)pading*2},cast(f32)pading,{0,0,40,255})
    rl.DrawTextEx(rl.GetFontDefault(),"Score" ,{360,15},38,2,{100,100,100,255})
    rl.DrawTextEx(rl.GetFontDefault(),"Hight Score" ,{330,460},30,2,{100,100,100,255})
    rl.DrawTextEx(rl.GetFontDefault(),"Next" ,{375,175},38,2,{100,100,100,255})
    rl.DrawRectangleRounded({330,55,170,60},0.3,6,{200,200,200,200})
    rl.DrawRectangleRounded({330,215,170,180},0.3,6,{200,200,200,200})
    rl.DrawRectangleRounded({330,500,170,60},0.3,6,{200,200,200,200})

    score_string := fmt.aprint(score)
    score_text_size := rl.MeasureTextEx(rl.GetFontDefault(),strings.clone_to_cstring(score_string),36,2)
    rl.DrawTextEx(rl.GetFontDefault(),strings.clone_to_cstring(score_string) ,{330+cast(f32)(170-cast(i32)score_text_size.x)/2,65},38,2,{100,100,100,255})

    hight_score_string := fmt.aprint(hight_score)
    hight_score_text_size := rl.MeasureTextEx(rl.GetFontDefault(),strings.clone_to_cstring(hight_score_string),36,2)
    rl.DrawTextEx(rl.GetFontDefault(),strings.clone_to_cstring(hight_score_string) ,{330+cast(f32)(170-cast(i32)hight_score_text_size.x)/2,510},38,2,{100,100,100,255})

    draw_block_pos(next_block, next_block.starting_pos,{280,273}+next_block.scr_ofset)
    //fmt.print(len(score_string))
}

draw_grid::proc(){
    for x in 0..<game_g_w{
        for y in 0..<game_g_h{
            re.draw_texture(as.texture_names.square,rl.Rectangle{cast(f32)x*cast(f32)cell_size+1,cast(f32)y*cast(f32)cell_size+1,cast(f32)cell_size-1,cast(f32)cell_size-1},{0,0}, 0, colors[game_grid[x][y]])
        }
    }
}
draw_block::proc(block:block_data,pos:[2]i32){
    for cell in 0..<4{
        x:=block.cells[block.r_state][cell].x
        y:=block.cells[block.r_state][cell].y
        
        re.draw_texture(as.texture_names.square,rl.Rectangle{cast(f32)((x*cell_size+1)+(pos.x*cell_size)),cast(f32)((y*cell_size+1)+(pos.y*cell_size)),cast(f32)cell_size-1,cast(f32)cell_size-1},{0,0}, 0, colors[block.id])
    }
}
draw_block_pos::proc(block:block_data,pos:[2]i32,pos_2: [2]f32){
    for cell in 0..<4{
        x:=block.cells[block.r_state][cell].x
        y:=block.cells[block.r_state][cell].y
        
        re.draw_texture(as.texture_names.square,rl.Rectangle{cast(f32)((x*cell_size+1)+(pos.x*cell_size))+pos_2.x,cast(f32)((y*cell_size+1)+(pos.y*cell_size))+pos_2.y,cast(f32)cell_size-1,cast(f32)cell_size-1},{0,0}, 0, colors[block.id])
    }
}
set_cer_block::proc(pos:[2]i32 = {0,0}){
    for cell in 0..<4{
        x:=cer_block.cells[cer_block.r_state][cell].x
        y:=cer_block.cells[cer_block.r_state][cell].y
    
        game_grid[pos.x+x+cer_block_pos.x][pos.y+y+cer_block_pos.y] = cer_block.id
        for i in 0..=12 {
            particle :re.Particle = re.gen_p({cast(f32)((pos.x+cer_block_pos.x*cell_size+(x*cell_size))+(pos.x*cell_size)),cast(f32)((pos.y+cer_block_pos.y*cell_size+(y*cell_size))+(pos.y*cell_size))},colors[cer_block.id])
            re.spawn_particle(particle)
        }
    }
    rl.PlaySound(as.sounds[as.sound_names.s_thud])
}
can_set_cer_block::proc(pos:[2]i32 = {0,0})->bool{
    for cell in 0..<4{
        x:=cer_block.cells[cer_block.r_state][cell].x
        y:=cer_block.cells[cer_block.r_state][cell].y
    
        if pos.x+x+cer_block_pos.x < 0 || pos.x+x+cer_block_pos.x > 9 {
            return false
        }
        if pos.y+y+cer_block_pos.y < 0 || pos.y+y+cer_block_pos.y > 19 {
            return false
        }
        if game_grid[pos.x+x+cer_block_pos.x][pos.y+y+cer_block_pos.y] != 0{
            return false
        }
    }
    return true
}
can_rot_cer_block::proc(pos:[2]i32 = {0,0})->bool{
    for cell in 0..<4{
        temp_r_state:=cer_block.r_state
        if temp_r_state > 2{
            temp_r_state = 0
        }else{
            temp_r_state += 1
        }
        x:=cer_block.cells[temp_r_state][cell].x
        y:=cer_block.cells[temp_r_state][cell].y
    
        if pos.x+x+cer_block_pos.x < 0 || pos.x+x+cer_block_pos.x > 9 {
            return false
        }
        if pos.y+y+cer_block_pos.y < 0 || pos.y+y+cer_block_pos.y > 19 {
            return false
        }
        if game_grid[pos.x+x+cer_block_pos.x][pos.y+y+cer_block_pos.y] != 0{
            return false
        }
    }
    return true
}
rotate_cer_block::proc(){
    if cer_block.r_state > 2{
        cer_block.r_state = 0
    }else{
        cer_block.r_state += 1
    }
}

move_cer_block::proc(pos:[2]i32){
    cer_block_pos += pos
}

screen_width: i32
screen_height: i32  
center_zoom::proc(){
    screen_width = rl.GetScreenWidth()-(pading)
    screen_height = rl.GetScreenHeight()-(pading)
    re.camera.target={cast(f32)-(pading),cast(f32)-(pading)}
    
    
    //if screen_width <= screen_height{
        //re.camera.zoom = f32(screen_width)/(cast(f32)canvas_size_w+f32(pading))
        //re.camera.offset.y =+ (cast(f32)screen_height - cast(f32)screen_width )/2
    //}else{
        re.camera.zoom = f32(screen_height)/(cast(f32)canvas_size_h+f32(pading))
        re.camera.offset.x =+  (cast(f32)screen_width - cast(f32)screen_height+90)/2
    //}
    //fmt.print(re.camera.zoom)
}