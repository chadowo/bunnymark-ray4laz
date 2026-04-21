{$mode ObjFPC}{$H+}{$J-}
unit Bunny;

interface
uses Raylib;

type
  { A Bunny has a position, speed and a reference to its texture. It doesn't dynamically allocate
    any memory, that is done within the class with LoadTextures and UnloadTextures, the textures
    are in the cBunnyTextureVariants static field. Thus you must call LoadTextures after you call
    Raylib's InitWindow and UnloadTextures before you destroy the window. Between the call of these
    functions you can create your bunnies (yay!) }
  TBunnyClass = class
  private
    FX, FY: integer;
    FSpeedX, FSpeedY: integer;
    FTex: TTexture2D;

    // Static field (pertaining to class, and all instances)
    cBunnyTextureVariants: array[0..11] of TTexture2D; static;
  public
    constructor Create(X, Y, SpeedX, SpeedY: integer);
    destructor Destroy; override;
    
    procedure Tick;
    procedure Render;

    class procedure TickBunnies(ABunnies: array of TBunnyClass);
    class procedure RenderBunnies(ABunnies: array of TBunnyClass);

    class procedure LoadTextures;
    class procedure UnloadTextures;
  end;

implementation

constructor TBunnyClass.Create(X, Y, SpeedX, SpeedY: integer);
begin
  FX := X;
  FY := Y;
  FSpeedX := SpeedX;
  FSpeedY := SpeedY;

  FTex := cBunnyTextureVariants[Random(High(cBunnyTextureVariants))];
end;

destructor TBunnyClass.Destroy;
begin
  WriteLn('The bunny says goodbye!');
end;

procedure TBunnyClass.Tick;
begin
  FX += FSpeedX;
  FY += FSpeedY;

  // Horizontal collision
  if FX + FTex.Width >= 800 then
  begin
    FSpeedX *= -1;
    FX := 800 - FTex.Width;
  end
  else if FX <= 0 then
  begin
    FSpeedX *= -1;
    FX := 0;
  end;

  // Vertical collision
  if FY + FTex.Height >= 570 then
  begin
    FSpeedY *= -1;
    FY := 570 - FTex.Height;
  end
  else if FY <= 30 then
  begin
    FSpeedY *= -1;
    FY := 30;
  end;
end;

procedure TBunnyClass.Render;
begin
  DrawTexture(FTex, FX, FY, RAYWHITE);
end;

class procedure TBunnyClass.TickBunnies(ABunnies: array of TBunnyClass);
var
  Bunny: TBunnyClass;
begin
  for Bunny in ABunnies do
    Bunny.Tick;
end;

class procedure TBunnyClass.RenderBunnies(ABunnies: array of TBunnyClass);
var
  Bunny: TBunnyClass;
begin
  for Bunny in ABunnies do
    Bunny.Render;
end;

{ Here we'll create all textures for all the variants of Bunny, this way we don't have to create a new texture
  per Bunny class instance. }
class procedure TBunnyClass.LoadTextures;
begin
  // TODO: possibly load all files in sprites dir instead of hardcoding like this
  cBunnyTextureVariants[0]  := LoadTexture('sprites/rabbitv3.png');
  cBunnyTextureVariants[1]  := LoadTexture('sprites/rabbitv3_ash.png');
  cBunnyTextureVariants[2]  := LoadTexture('sprites/rabbitv3_batman.png');
  cBunnyTextureVariants[3]  := LoadTexture('sprites/rabbitv3_bb8.png');
  cBunnyTextureVariants[4]  := LoadTexture('sprites/rabbitv3_frankenstein.png');
  cBunnyTextureVariants[5]  := LoadTexture('sprites/rabbitv3_neo.png');
  cBunnyTextureVariants[6]  := LoadTexture('sprites/rabbitv3_sonic.png');
  cBunnyTextureVariants[7]  := LoadTexture('sprites/rabbitv3_spidey.png');
  cBunnyTextureVariants[8]  := LoadTexture('sprites/rabbitv3_stormtrooper.png');
  cBunnyTextureVariants[9]  := LoadTexture('sprites/rabbitv3_superman.png');
  cBunnyTextureVariants[10] := LoadTexture('sprites/rabbitv3_tron.png');
  cBunnyTextureVariants[11] := LoadTexture('sprites/rabbitv3_wolverine.png');
end;

class procedure TBunnyClass.UnloadTextures;
var
  i: integer;
begin
  for i := Low(cBunnyTextureVariants) to High(cBunnyTextureVariants) do
    UnloadTexture(cBunnyTextureVariants[i])
end;

end.
