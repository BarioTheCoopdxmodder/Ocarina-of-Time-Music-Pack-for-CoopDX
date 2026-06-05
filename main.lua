-- name: Legend Of Zelda: Ocarina of Time music
-- description: If you are a fan of OOT, you're gonna love this. Mod by \\#ff0000\\B\\#cc0000\\a\\#990000\\r\\#660000\\i\\#330000\\o\\#ffffff\\.

--pausable: false

hook_event(HOOK_ON_WARP, function() 
    play = true
     playgrass = false
     playslider = false
     playwater = false
     mario_is_dying = false
     grasstimer = 0
     slidertimer = 0
     event = false
     starchance = false
     starplaying = false
     audio_stream_stop(GRASS)
     audio_stream_stop(WATER) 
     audio_stream_stop(SLIDER)
     audio_stream_stop(STAR_CHANCE)
     if gNetworkPlayers[0].currLevelNum ~= LEVEL_CASTLE then
         audio_stream_stop(CASTLE_WALLS) 
     end
     grasstimer = 0
     slidertimer = 0
end)
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_SPOOKY, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_GRASS, 0, 0.00000001, "_silent") 
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_SNOW, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_HOT, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_WATER, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_SLIDE, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_EVENT_CUTSCENE_COLLECT_STAR, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_EVENT_METAL_CAP, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_EVENT_POWERUP, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_EVENT_BOSS, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_BOSS_KOOPA, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_BOSS_KOOPA_FINAL, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_INSIDE_CASTLE, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_KOOPA_ROAD, 0, 0.00000001, "_silent")
       smlua_audio_utils_replace_sequence(SEQ_LEVEL_UNDERGROUND, 0, 0.00000001, "_silent")

gLevelValues.wingCapDuration = 61*30
gLevelValues.metalCapDuration = 61*30
gLevelValues.vanishCapDuration = 61*30

GRASS = audio_stream_load("grass.mp3")
SNOW = audio_stream_load("snow.mp3")
HOT = audio_stream_load("hot.mp3")
SLIDER = audio_stream_load("slider.mp3")
WATER = audio_stream_load("water.mp3")
METAL_CAP = audio_stream_load("metal.mp3")
WING_CAP = audio_stream_load("flying.mp3")
VANISH_CAP = audio_stream_load("vanish.mp3")
POWER_STAR = audio_stream_load("powerstar.mp3")
STAR_CHANCE = audio_stream_load("starchance.mp3")
BOSS_TROUBLE = audio_stream_load("boss.mp3")
KOOPA_FIGHT = audio_stream_load("bowserfight.mp3")
SOUND_TOO_BAD = audio_stream_load("too_bad.mp3")
CASTLE_WALLS = audio_stream_load("castle.mp3")
SPOOKY = audio_stream_load("spooky.mp3")
KOOPA_ROAD = audio_stream_load("koopa_road.mp3")
UNDERGROUND = audio_stream_load("underground.mp3")

gLevelValues.metalCapSequence = 0
gLevelValues.wingCapSequence = 0
gLevelValues.vanishCapSequence = 0
grasstimer = 0
slidertimer = 0
poweruptimer = 0
volume = 0
volumep = 0
song = 0
star = 0
color = 110

function cap_music(m)

    local m = gMarioStates[0]
    
    if (m.flags & MARIO_SPECIAL_CAPS) ~= 0 then
      powerful = true
      else
      poweful = false
    end
    
    if (m.flags & MARIO_METAL_CAP) ~= 0 then
      metal = true
      else
      metal = false
    end
        
     if metal then       
      audio_stream_play(METAL_CAP, false, 0.5 - volume)
      if m.capTimer < (5*30) then
        audio_stream_set_volume(METAL_CAP, (m.capTimer/150) - volume/m.capTimer)
      else
        audio_stream_set_volume(METAL_CAP, 0.5 - volume)
      end
      else
        audio_stream_stop(METAL_CAP)
    end
    
    if (m.flags & MARIO_VANISH_CAP) ~= 0 then
      vanish = true
      else
      vanish = false
    end
        
     if vanish then       
      audio_stream_play(VANISH_CAP, false, 0.5 - volume)
      if m.capTimer < (5*30) then
        audio_stream_set_volume(VANISH_CAP, (m.capTimer/150) - volume/m.capTimer)
      else
        audio_stream_set_volume(VANISH_CAP, 0.5 - volume)
      end
      else
        audio_stream_stop(VANISH_CAP)
    end
    
    if (m.flags & MARIO_WING_CAP) ~= 0 then
      wing = true
      else
      wing = false
    end
        
     if wing then       
      audio_stream_play(WING_CAP, false, 0.5 - volume)
      if m.capTimer < (5*30) then
        audio_stream_set_volume(WING_CAP, (m.capTimer/150) - volume/m.capTimer)
      else
        audio_stream_set_volume(WING_CAP, 0.5 - volume)
      end
      else
        audio_stream_stop(WING_CAP)
    end
end

hook_event(HOOK_UPDATE, cap_music)

function star(m)
    
    if (m.action == ACT_FALL_AFTER_STAR_GRAB or m.action == ACT_STAR_DANCE_EXIT or m.action == ACT_STAR_DANCE_NO_EXIT) and starplaying ~= true then
        starplaying = true
        m.action = ACT_STAR_DANCE_WATER
    end
end

hook_event(HOOK_MARIO_UPDATE, star)

function levels(m)
    local m = gMarioStates[0]
    local p = gNetworkPlayers[0]
    local m = gMarioStates[m.playerIndex]
    
    if bruh then
      audio_stream_play(SOUND_TOO_BAD, false, 1)
      bruh = false
      play_cap_music(0)
    end
    
    if gLakituState.pos.y < m.waterLevel then
       volume = 0.2
    elseif is_game_paused() then
       volume = 0.5
    elseif luigi_do_something then
       volume = 0.5
    else
       volume = -0.2
    end
    
     if audio_stream_get_position(BOSS_TROUBLE) > (85.8) then
		 audio_stream_set_position(BOSS_TROUBLE, 0)
     end
    
    if starplaying == true then
        audio_stream_play(POWER_STAR, false, 1)
        audio_stream_stop(STAR_CHANCE)
    end

if m.action ~= ACT_DISAPPEARED and wing ~= true and metal ~= true and vanish ~= true and starchance ~= true then       
    grasstimer = grasstimer + 1
    slidertimer = slidertimer + 1
    
    if p.currLevelNum == LEVEL_BOB
    or p.currLevelNum == LEVEL_WF
    or (p.currLevelNum == LEVEL_TTM and p.currAreaIndex == 1)
    or p.currLevelNum == LEVEL_THI and (p.currAreaIndex == 1 or p.currAreaIndex == 2) then
        audio_stream_play(GRASS, false, 0.5 - volume)
        audio_stream_set_looping(GRASS, true)
       else
        audio_stream_stop(GRASS)
    end
    
    if p.currLevelNum == LEVEL_BITDW
    or p.currLevelNum == LEVEL_BITFS
    or p.currLevelNum == LEVEL_BITS then
        audio_stream_play(KOOPA_ROAD, false, 0.5 - volume)
        audio_stream_set_looping(KOOPA_ROAD, true)
       else
        audio_stream_stop(KOOPA_ROAD)
    end

    if p.currLevelNum == 30
    or p.currLevelNum == 33
    or p.currLevelNum == 34 then
       audio_stream_play(KOOPA_FIGHT, false, 0.5 - volume)
       else
       audio_stream_stop(KOOPA_FIGHT)
    end
    
    if p.currLevelNum == LEVEL_CASTLE then 
        audio_stream_play(CASTLE_WALLS, false, 0.5 - volume)
    else 
        audio_stream_stop(CASTLE_WALLS) 
    end
    
    if (p.currLevelNum == LEVEL_CCM and p.currAreaIndex == 1)
    or (p.currLevelNum == LEVEL_SL and p.currAreaIndex == 1) then
       audio_stream_play(SNOW, false, 0.5 - volume)
       audio_stream_set_looping(SNOW, true)
       else
       audio_stream_stop(SNOW)
    end

    if p.currLevelNum == LEVEL_HMC
    or p.currLevelNum == LEVEL_WDW
    or p.currLevelNum == LEVEL_COTMC then
       audio_stream_play(UNDERGROUND, false, 0.5 - volume)
       audio_stream_set_looping(UNDERGROUND, true)
       else
       audio_stream_stop(UNDERGROUND)
    end

    if p.currLevelNum == LEVEL_BBH then
       audio_stream_play(SPOOKY, false, 0.5 - volume)
       audio_stream_set_looping(SPOOKY, true)
       else
       audio_stream_stop(SPOOKY)
    end
    
    if (p.currLevelNum == LEVEL_LLL)
    or (p.currLevelNum == LEVEL_SSL) then
       audio_stream_play(HOT, false, 0.5 - volume)
       audio_stream_set_looping(HOT, true)
       else
       audio_stream_stop(HOT)
    end
    
    if p.currLevelNum == LEVEL_PSS
    or p.currLevelNum == LEVEL_WMOTR
    or p.currLevelNum == LEVEL_VCUTM
    or p.currLevelNum == LEVEL_TOTWC
    or p.currLevelNum == LEVEL_RR
    or (p.currLevelNum == LEVEL_CCM and p.currAreaIndex == 2)
    or (p.currLevelNum == LEVEL_TTM and p.currAreaIndex == 2)
    or p.currLevelNum == LEVEL_TTC then
        audio_stream_play(SLIDER, false, 0.5 - volume)
        audio_stream_set_looping(SLIDER, true)
       else
       audio_stream_stop(SLIDER)
    end
    
    if  p.currLevelNum == LEVEL_JRB
    or p.currLevelNum == LEVEL_DDD
    or p.currLevelNum == LEVEL_SA then
       audio_stream_play(WATER, false, 0.5 - volume)
       audio_stream_set_looping(WATER, true)
       else
       audio_stream_stop(WATER)
    end
 else
       audio_stream_stop(WATER)
       audio_stream_stop(SLIDER)
        audio_stream_stop(GRASS)
 end
end

hook_event(HOOK_UPDATE, levels)

scale = 0

function hud()
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_resolution(RESOLUTION_N64)
    screenWidth = djui_hud_get_screen_width()
    screenHeight = djui_hud_get_screen_height()
    halfScreenWidth = djui_hud_get_screen_width() / 2
    halfScreenHeight = djui_hud_get_screen_height() / 2
    djui_hud_set_font(FONT_HUD)
    local m = gMarioStates[0]
    local s = gPlayerSyncTable[0]
    local x = ";"
    local air = ""
    
      if change == true then
        color = color - 10
        else
        color = color + 10
      end
      if color > 220 then change = true end
      if color < 20 then change = false end
    
    djui_hud_set_color(color, 0xff, 0, scale)
    djui_hud_set_font(FONT_MENU)
    
    if starplaying == true then
       if scale < 255/2 then
          scale = scale + 7
       end
      djui_hud_print_text("YOU GOT A STAR!", djui_hud_get_screen_width() / 2 - djui_hud_measure_text("YOU GOT A STAR!") / 4, 175, 0.5)
      djui_hud_print_text("YOU GOT A STAR!", djui_hud_get_screen_width() / 2 - djui_hud_measure_text("YOU GOT A STAR!") / 4, 175, 0.5)
    end
    
    djui_hud_set_color(0xca, 0, 0x40, 0x20)
    djui_hud_set_font(FONT_MENU)
    
    if (m.action == ACT_QUICKSAND_DEATH or m.action == ACT_STANDING_DEATH or m.action == ACT_DEATH_ON_BACK or m.action == ACT_DEATH_ON_STOMACH or m.action == ACT_SUFFOCATION or m.action == ACT_ELECTROCUTION or m.action == ACT_EATEN_BY_BUBBA or m.action == ACT_DROWNING or m.action == ACT_LAVA_BOOST and m.health < 0x180) then    
    m.actionTimer = m.actionTimer + 4
    mario_is_dying = true
    if m.action == ACT_LAVA_BOOST then
      m.actionTimer = m.actionTimer + 4
    end
    if m.actionTimer > 10 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 20 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 30 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 40 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 50 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 60 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 70 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 80 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 90 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 100 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 110 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 120 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 130 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 140 then
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
    if m.actionTimer > 150 then
    bruh = true
    djui_hud_print_text(tostring"TOO BAD!", (halfScreenWidth - halfScreenWidth / 4), 175, 0.5)
    end
 end
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, hud)

function boss(x, SEQ_ID)
    if SEQ_ID == SEQ_EVENT_BOSS or SEQ_ID == SEQ_EVENT_CUTSCENE_COLLECT_STAR or SEQ_ID == SEQ_EVENT_CUTSCENE_STAR_SPAWN then
        luigi_do_something = true
        if SEQ_ID == SEQ_EVENT_CUTSCENE_STAR_SPAWN then
             audio_stream_play(STAR_CHANCE, false, 0.5)
             audio_stream_set_looping(STAR_CHANCE, true)
             audio_stream_stop(BOSS_TROUBLE)
             starchance = true
        end
        if SEQ_ID == SEQ_EVENT_BOSS then
            audio_stream_play(BOSS_TROUBLE, false, 0.5)
            volume = 0
        end
        else
        luigi_do_something = false
        scale = 0
    end
end

hook_event(HOOK_ON_SEQ_LOAD, boss)_event(HOOK_ON_SEQ_LOAD, boss)