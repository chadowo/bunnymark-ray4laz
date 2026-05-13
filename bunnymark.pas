{$mode ObjFPC}{$H+}
program BunnyMark;
uses
  SysUtils,
  Raylib,
  Bunny;

{ Random range.
  Returns a random number using RTL's Random between params Min and Max. }
function RanRan(Min, Max: integer): integer;
begin
  Result := Random(Max - Min) + Min;
end;

procedure TickBunnies(ABunnies: array of TBunnyClass);
var
  Bunny: TBunnyClass;
begin 
  for Bunny in ABunnies do 
    Bunny.Tick
end;

procedure DrawBunnies(ABunnies: array of TBunnyClass);
var
  Bunny: TBunnyClass;
begin
  for Bunny in ABunnies do 
    Bunny.Render;
end;

const
  cScreenWidth  = 800;
  cScreenHeight = 600;
var
  Bunnies: array of TBunnyClass; // Dynamic array
  MouseWheelMovement: TVector2;
  FPSTextColor: TColor;

  WindowIcon: TImage;
  i: Integer;
begin
  InitWindow(cScreenWidth, cScreenHeight, 'BunnyMark');
  SetTargetFPS(60);

  WindowIcon := LoadImage('sprites/rabbitv3.png');
  SetWindowIcon(WindowIcon);

  Randomize;

  TBunnyClass.LoadTextures;

  while not WindowShouldClose do
  begin
    MouseWheelMovement := GetMouseWheelMoveV;

    if (MouseWheelMovement.Y > 0) or (MouseWheelMovement.X > 0) then
      for i := 100 downto 1 do
        Insert(TBunnyClass.Create(GetMouseX, GetMouseY, RanRan(-10, 10), RanRan(-10, 10)), Bunnies, 0)
    else if (MouseWheelMovement.Y < 0) or (MouseWheelMovement.X < 0) then
      for i := 100 downto 1 do
      begin
        // Safety: make sure the array is not empty.
        if High(Bunnies) <> -1 then
        begin
          FreeAndNil(Bunnies[0]);
          Delete(Bunnies, 0, 1);
        end;
      end;

    if IsKeyPressed(KEY_ZERO) then
      Delete(Bunnies, 0, Length(Bunnies));

    if GetFPS < 20 then
      FPSTextColor := RED
    else if GetFPS < 40 then
      FPSTextColor := YELLOW
    else
      FPSTextColor := GREEN;

    TBunnyClass.TickBunnies(Bunnies);

    BeginDrawing;
    ClearBackground(RAYWHITE);
    TBunnyClass.RenderBunnies(Bunnies);

    DrawText(PChar('FPS: ' + GetFPS.ToString), 10, 10, 20, FPSTextColor);
    DrawText(PChar('Bunnies: ' + Length(Bunnies).ToString), 130, 10, 20, BLACK);
    DrawText('Use the mouse wheel to add or remove bunnies, key zero to remove ''em all', 10, 575, 16, BLACK);

    EndDrawing;
  end;

  UnloadImage(WindowIcon);
  TBunnyClass.UnloadTextures;
  CloseWindow;
end.
