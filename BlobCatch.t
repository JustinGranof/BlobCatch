% Blob Catch
% Justin & Arman
% 12/4/2015
% Work in progress

setscreen ("graphics:800;max, title:Blob Catch - V1.0")

forward proc menuScreen
% % % % % Variables % % % % %
var randomLoc : int
var font : int := Font.New ("ariel:20")
var blob : int := Pic.FileNew ("blob.bmp")
var scoreText : int := Font.New ("impact:30")
var endText : int := Font.New ("impact:30")
var menu : int := Pic.FileNew ("Menu.bmp")
var itemPic : int := Pic.FileNew ("coin.bmp")
itemPic := Pic.Scale (itemPic, 50, 51)
var bombPic : int := Pic.FileNew ("bomb.bmp")
menu := Pic.Scale (menu, 700, 800)
var bX, bY, bX2, bY2, iX, iY, iX2, iY2, bX3, bY3, iX3, iY3, boX, boY, boX2, boY2, boX3, boY3, score, oldScore, chance, fallSpeed : int
var key : array char of boolean
var dist : real
blob := Pic.Scale (blob, 150, 80)
var sprite : int := Sprite.New (blob)
var item : int := Sprite.New (itemPic)
var bomb : int := Sprite.New (bombPic)
var hasHappened, canCount, gameOver : boolean := false
bX := 0
bY := 100
iX := 0
iY := maxy + 100
boX := 0
boY := maxy + 100
var timeAmount : int := 60
var timeString, scoreString, gameOverMessage : string
var itemDelay : int := 0
score := 0
oldScore := 0
fallSpeed := 5
% % % % % % % % % % % % % % %

% % % % % Instructions Screen % % % % %

procedure instructions
    delay (100)
    cls

    drawfillbox (0, maxy, maxx, 0, 54)
    drawfillbox (0, 200, maxx, 0, 2)

    Draw.Text ("1. Move The Blob To Catch All The Falling Pieces!", maxx div 2 - 370, maxy div 2 + 200, font, 0)
    Draw.Text ("2. The More You Collect The More Points You Get!", maxx div 2 - 370, maxy div 2 + 160, font, 0)
    Draw.Text ("3. Once Time Runs Out You Will Receive Your Final Results!", maxx div 2 - 370, maxy div 2 + 120, font, 0)
    Draw.Text ("Press 'R' To Return To The Menu", maxx div 2 - 370, maxy div 2 + 40, font, 0)

    loop
	Input.KeyDown (key)
	exit when key ('r')
    end loop

    if key ('r') then
	menuScreen
    end if

end instructions

% % % % % % % % % % % % % % % % % % % %

% % % % % Reset Game % % % % %

proc resetGame

    score := 0
    fallSpeed := 5
    timeAmount := 60
    canCount := false
    gameOver := true

end resetGame

% % % % % % % % % % % % % % %

% % % % % Game Over % % % % %

proc gameEnd
    Sprite.Hide (bomb)
    Sprite.Hide (item)
    gameOver := true
    canCount := false

    bY := 100
    bX := maxx div 2

    Sprite.SetPosition (sprite, bX, bY, true)

    cls

    drawfillbox (0, maxy, maxx, 0, 54)
    drawfillbox (0, 200, maxx, 0, 2)

    Draw.Text (gameOverMessage, maxx div 2 - 100, maxy div 2, endText, 0)
    Draw.Text (scoreString, maxx div 2 - 10, maxy div 2 - 100, font, 0)

    Draw.Text ("Press 'E' To Exit!", 10, 10, font, 0)
    Draw.Text ("Press 'S' To Play Again!", maxx - 300, 10, font, 0)

    loop
	Input.KeyDown (key)
	exit when key ('s')
    end loop

    delay (100)
    resetGame
    menuScreen

end gameEnd

% % % % % % % % % % % % % % %

% % % % % Update Score % % % % %

proc updateScore

    oldScore := score
    score += 1

    scoreString := intstr (score)

    drawfillbox (maxx - 200, maxy, maxx, maxy - 100, 54)
    Draw.Text ("SCORE: " + scoreString, maxx - 180, maxy - 80, scoreText, white)
end updateScore

% % % % % % % % % % % % % % % % %

% % % % % Credits % % % % %

proc credits
    delay (100)
    cls

    drawfillbox (0, maxy, maxx, 0, 54)
    drawfillbox (0, 200, maxx, 0, 2)

    Draw.Text ("Game Created By: Justin & Arman", maxx div 2 - 200, maxy div 2 + 200, font, 0)
    Draw.Text ("Press 'R' To Return To The Menu!", maxx div 2 - 200, maxy div 2 + 40, font, 0)

    loop
	Input.KeyDown (key)
	exit when key ('r')
    end loop

    if key ('r') then
	menuScreen
    end if

end credits

% % % % % % % % % % % % % %

% % % % % Exit % % % % %

proc exitGame
    bY := 100
    bX := maxx div 2
    delay (1000)
    cls

    drawfillbox (0, 0, maxx, maxy, 54)
    drawfillbox (0, 200, maxx, 0, 2)

    for i : 1 .. 200
	bY += 2
	Sprite.SetPosition (sprite, bX, bY, true)
	delay (5)
    end for

    Draw.Text ("Thanks For Playing!", maxx div 2 - 100, maxy div 2 + 50, font, 0)

    delay (2000)
    Window.Close (defWinID)
end exitGame

% % % % % % % % % % % %

% % % % % Timer % % % % %

process startTimer

    loop
	if gameOver = true then
	    exit
	end if
	if canCount = true then
	    timeAmount -= 1
	    delay (1000)

	    timeString := intstr (timeAmount)

	    drawfillbox (0, maxy, maxx - 200, maxy - 100, 54)
	    Draw.Text (timeString, maxx div 2, maxy - 80, font, brightred)

	    exit when timeAmount = 0
	end if
    end loop

    if timeAmount = 0 then
	gameOverMessage := "Time's Up!"
	gameEnd
    end if

end startTimer

% % % % % % % % % % % % %

% % % % % Exit Any Time % % % % %

process exitAny
    loop
	Input.KeyDown (key)
	exit when key ('e')
    end loop
    canCount := false
    exitGame
end exitAny

% % % % % % % % % % % % % % % % %

% % % % % Check For Collision % % % % %

process collide

    bX2 := bX + 45
    bY2 := bY + 16
    iX2 := iX + 25
    iY2 := iY + 25
    boX2 := boX + 25
    boY2 := boY + 25

    bX3 := bX - 45
    bY3 := bY - 16
    iX3 := iX - 25
    iY3 := iY - 25
    boX3 := boX - 25
    boY3 := boY - 25

    if gameOver = false then
	if bX3 < iX2 and bX2 > iX3 and bY3 < iY2 and bY2 > iY3 then
	    Sprite.Hide (item)
	    Sprite.SetPosition (item, maxx + 100, maxy, true)
	    if iY >= bY + 40 then
		updateScore
	    end if
	    return
	else
	    if bX3 < boX2 and bX2 > boX3 and bY3 < boY2 and bY2 > boY3 then
		Sprite.Hide (bomb)
		Sprite.SetPosition (bomb, maxx + 100, maxy, true)
		gameOverMessage := "Game Over!"
		gameEnd
	    end if
	end if
    end if
end collide

% % % % % % % % % % % % % % % % % % % %

% % % % % Drop Items % % % % %

process dropItem
    loop
	if gameOver = true then
	    exit
	end if
	if gameOver = false then
	    randint (iX, 0, maxx)
	    randint (boX, 0, maxx)
	    randint (chance, 1, 5)

	    if iX > 790 or iX < 10 or boX > 790 or boX < 10 then
		randint (iX, 0, maxx)
		randint (boX, 0, maxx)
	    end if

	    if chance = 5 then
		Sprite.Show (bomb)
		Sprite.SetPosition (bomb, boX, boY, true)
		for decreasing i : maxy + 100 .. 0 - 40
		    boY -= 2
		    fork collide
		    Sprite.SetPosition (bomb, boX, boY, true)
		    delay (fallSpeed)
		end for

	    end if


	    if chance not= 5 then
		Sprite.Show (item)
		Sprite.SetPosition (item, iX, iY, true)
		for decreasing i : maxy + 100 .. 0 - 40
		    iY -= 2
		    fork collide
		    Sprite.SetPosition (item, iX, iY, true)
		    delay (fallSpeed)
		end for
	    end if

	    iY := maxy + 100
	    boY := maxy + 100
	    Sprite.SetPosition (bomb, boX, boY, true)
	    Sprite.SetPosition (item, iX, iY, true)

	end if
    end loop
end dropItem

% % % % % % % % % % % % % % % %

% % % % % Move Blob % % % % %

process moveBlob
    if gameOver = true then
	return
    end if
    loop
	loop
	    if gameOver = false then
		Input.KeyDown (key)

		if key (KEY_LEFT_ARROW) then

		    if bX > 40 then
			for x : 1 .. 2
			    bX -= 2
			    Sprite.SetPosition (sprite, bX, bY, true)
			    delay (5)
			end for
		    end if
		    exit
		end if

		if key (KEY_RIGHT_ARROW) then
		    if bX < 760 then

			for x : 1 .. 2
			    bX += 2
			    Sprite.SetPosition (sprite, bX, bY, true)
			    delay (5)
			end for
		    end if

		    exit
		end if

	    end if
	end loop
    end loop
end moveBlob

% % % % % % % % % % % % % % %

% % % % % Game % % % % %

proc startGame
    timeAmount := 60
    delay (100)
    cls

    drawfillbox (0, 0, maxx, maxy, 54)
    drawfillbox (0, 200, maxx, 0, 2)
    scoreString := intstr (score)
    Draw.Text ("SCORE: " + scoreString, maxx - 180, maxy - 80, scoreText, white)

    fork exitAny
    fork startTimer
    canCount := true
    gameOver := false
    fork dropItem
    fork moveBlob

end startGame

% % % % % % % % % % % % %

% % % % % Menu Screen % % % % %

body procedure menuScreen
    cls

    Sprite.Show (sprite)

    % Creates background
    drawfillbox (0, maxy, maxx, 0, 54)
    drawfillbox (0, 200, maxx, 0, 2)

    % Move character to center of the screen
    if hasHappened = false then
	for decreasing i : maxx div 2 - 190 .. 1
	    bX += 2
	    Sprite.SetPosition (sprite, bX, bY, true)
	    delay (2)
	end for
    end if

    hasHappened := true

    delay (500)
    Pic.Draw (menu, 50, 250, picMerge)

    Draw.Text ("Press 'I' To Learn How To Play!", maxx div 2 - 200, maxy div 2 + 200, font, 0)
    delay (100)
    Draw.Text ("Press 'S' To Start Playing!", maxx div 2 - 200, maxy div 2 + 160, font, 0)
    delay (100)
    Draw.Text ("Press 'C' To View Credits!", maxx div 2 - 200, maxy div 2 + 120, font, 0)
    delay (100)
    Draw.Text ("Press 'E' To Exit Any Time!", maxx div 2 - 200, maxy div 2 + 80, font, 0)

    loop
	Input.KeyDown (key)
	exit when key ('i') or key ('s') or key ('c') or key ('e')
    end loop

    if key ('i') then
	instructions
    end if

    if key ('s') then
	startGame
    end if

    if key ('c') then
	credits
    end if

    if key ('e') then
	exitGame
    end if

end menuScreen

% % % % % % % % % % % % % % % %

menuScreen
