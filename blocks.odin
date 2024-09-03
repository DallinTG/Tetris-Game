package tetris

import rl "vendor:raylib"
import re"rendering"
import as "assets"

init_blocks::proc(){
//l_block
l_block.cells[0][0]={0,2}
l_block.cells[0][1]={1,0}
l_block.cells[0][2]={1,1}
l_block.cells[0][3]={1,2}
l_block.cells[1][0]={0,1}
l_block.cells[1][1]={1,1}
l_block.cells[1][2]={2,1}
l_block.cells[1][3]={2,2}
l_block.cells[2][0]={1,0}
l_block.cells[2][1]={1,1}
l_block.cells[2][2]={1,2}
l_block.cells[2][3]={2,0}
l_block.cells[3][0]={0,0}
l_block.cells[3][1]={0,1}
l_block.cells[3][2]={1,1}
l_block.cells[3][3]={2,1}
l_block.id = 1
l_block.starting_pos = {3,0}
l_block.r_state = 3
//j_block
j_block.cells[0][0]={0,0}
j_block.cells[0][1]={1,0}
j_block.cells[0][2]={1,1}
j_block.cells[0][3]={1,2}
j_block.cells[1][0]={0,1}
j_block.cells[1][1]={0,2}
j_block.cells[1][2]={1,1}
j_block.cells[1][3]={2,1}
j_block.cells[2][0]={1,0}
j_block.cells[2][1]={1,1}
j_block.cells[2][2]={1,2}
j_block.cells[2][3]={2,2}
j_block.cells[3][0]={0,1}
j_block.cells[3][1]={1,1}
j_block.cells[3][2]={2,0}
j_block.cells[3][3]={2,1}
j_block.id = 2
j_block.starting_pos = {3,0}
j_block.r_state = 3
//i_block
i_block.cells[0][0]={1,0}
i_block.cells[0][1]={1,1}
i_block.cells[0][2]={1,2}
i_block.cells[0][3]={1,3}
i_block.cells[1][0]={0,2}
i_block.cells[1][1]={1,2}
i_block.cells[1][2]={2,2}
i_block.cells[1][3]={3,2}
i_block.cells[2][0]={2,0}
i_block.cells[2][1]={2,1}
i_block.cells[2][2]={2,2}
i_block.cells[2][3]={2,3}
i_block.cells[3][0]={0,1}
i_block.cells[3][1]={1,1}
i_block.cells[3][2]={2,1}
i_block.cells[3][3]={3,1}
i_block.id = 3
i_block.starting_pos = {3,-1}
i_block.r_state = 3
i_block.scr_ofset = {-15,10}
//o_block
o_block.cells[0][0]={0,0}
o_block.cells[0][1]={0,1}
o_block.cells[0][2]={1,0}
o_block.cells[0][3]={1,1}
o_block.cells[1][0]={0,0}
o_block.cells[1][1]={0,1}
o_block.cells[1][2]={1,0}
o_block.cells[1][3]={1,1}
o_block.cells[2][0]={0,0}
o_block.cells[2][1]={0,1}
o_block.cells[2][2]={1,0}
o_block.cells[2][3]={1,1}
o_block.cells[3][0]={0,0}
o_block.cells[3][1]={0,1}
o_block.cells[3][2]={1,0}
o_block.cells[3][3]={1,1}
o_block.id = 4
o_block.starting_pos = {4,0}
o_block.r_state = 3
o_block.scr_ofset = {-15,0}
//s_block
s_block.cells[0][0]={0,1}
s_block.cells[0][1]={0,2}
s_block.cells[0][2]={1,0}
s_block.cells[0][3]={1,1}
s_block.cells[1][0]={0,1}
s_block.cells[1][1]={1,1}
s_block.cells[1][2]={1,2}
s_block.cells[1][3]={2,2}
s_block.cells[2][0]={1,1}
s_block.cells[2][1]={1,2}
s_block.cells[2][2]={2,0}
s_block.cells[2][3]={2,1}
s_block.cells[3][0]={0,0}
s_block.cells[3][1]={1,0}
s_block.cells[3][2]={1,1}
s_block.cells[3][3]={2,1}
s_block.id = 5
s_block.starting_pos = {3,0}
s_block.r_state = 3
//t_block
t_block.cells[0][0]={0,1}
t_block.cells[0][1]={1,0}
t_block.cells[0][2]={1,1}
t_block.cells[0][3]={1,2}
t_block.cells[1][0]={0,1}
t_block.cells[1][1]={1,1}
t_block.cells[1][2]={1,2}
t_block.cells[1][3]={2,1}
t_block.cells[2][0]={1,0}
t_block.cells[2][1]={1,1}
t_block.cells[2][2]={1,2}
t_block.cells[2][3]={2,1}
t_block.cells[3][0]={0,1}
t_block.cells[3][1]={1,0}
t_block.cells[3][2]={1,1}
t_block.cells[3][3]={2,1}
t_block.id = 6
t_block.starting_pos = {3,0}
t_block.r_state = 3
//z_block
z_block.cells[0][0]={0,0}
z_block.cells[0][1]={0,1}
z_block.cells[0][2]={1,1}
z_block.cells[0][3]={1,2}
z_block.cells[1][0]={0,2}
z_block.cells[1][1]={1,1}
z_block.cells[1][2]={1,2}
z_block.cells[1][3]={2,1}
z_block.cells[2][0]={1,0}
z_block.cells[2][1]={1,1}
z_block.cells[2][2]={2,1}
z_block.cells[2][3]={2,2}
z_block.cells[3][0]={0,1}
z_block.cells[3][1]={1,0}
z_block.cells[3][2]={1,1}
z_block.cells[3][3]={2,0}
z_block.id = 7
z_block.starting_pos = {3,0}
z_block.r_state = 3
}