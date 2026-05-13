{$mode ObjFPC}{$H+}{$J-}
unit Bunny;

interface
uses SysUtils, Raylib;

type
  { A Bunny has a position, speed and a reference to its texture. It doesn't dynamically allocate
    any memory, that is done within the class with LoadTextures and UnloadTextures, the textures
    are in the SpriteVariants static field. Thus you must call LoadTextures after you call
    Raylib's InitWindow and UnloadTextures before you destroy the window. Between the call of these
    functions you can create your bunnies (yay!) }
  TBunnyClass = class
  private
    FX, FY: Integer;
    FSpeedX, FSpeedY: Integer;
    FTexture: TTexture2D;

    class var SpriteVariants: array[0..11] of TTexture2D; // Accesible to all instances
  public
    constructor Create(X, Y, SpeedX, SpeedY: Integer);
    destructor Destroy; override;

    procedure Tick;
    procedure Render;

    { These routines are used to create (and destroy) all textures for all the variant, this way we
      don't have to create a new texture per Bunny class instance.
      Call this ONLY AFTER raylib's InitWindow().}
    class procedure LoadTextures;
    class procedure UnloadTextures;

    { Helpers. }
    class procedure TickBunnies(ABunnies: array of TBunnyClass);
    class procedure RenderBunnies(ABunnies: array of TBunnyClass);
  end;

  EBunnyTexturesNotLoaded = class(Exception);

implementation

{ TBunnyClass }

constructor TBunnyClass.Create(X, Y, SpeedX, SpeedY: Integer);
begin
  FX := X;
  FY := Y;
  FSpeedX := SpeedX;
  FSpeedY := SpeedY;

  FTexture := SpriteVariants[Random(High(SpriteVariants))];
end;

destructor TBunnyClass.Destroy;
begin end;

procedure TBunnyClass.Tick;
begin
  FX += FSpeedX;
  FY += FSpeedY;

  // Horizontal collision
  if FX + FTexture.Width >= 800 then
  begin
    FSpeedX *= -1;
    FX := 800 - FTexture.Width;
  end
  else if FX <= 0 then
  begin
    FSpeedX *= -1;
    FX := 0;
  end;

  // Vertical collision
  if FY + FTexture.Height >= 570 then
  begin
    FSpeedY *= -1;
    FY := 570 - FTexture.Height;
  end
  else if FY <= 30 then
  begin
    FSpeedY *= -1;
    FY := 30;
  end;
end;

procedure TBunnyClass.Render;
begin
  DrawTexture(FTexture, FX, FY, RAYWHITE);
end;

class procedure TBunnyClass.LoadTextures;
var
  Texture: TTexture2D;
begin
  // TODO: possibly load all files in sprites dir instead of hardcoding like this
  SpriteVariants[0]  := LoadTexture('sprites/rabbitv3.png');
  SpriteVariants[1]  := LoadTexture('sprites/rabbitv3_ash.png');
  SpriteVariants[2]  := LoadTexture('sprites/rabbitv3_batman.png');
  SpriteVariants[3]  := LoadTexture('sprites/rabbitv3_bb8.png');
  SpriteVariants[4]  := LoadTexture('sprites/rabbitv3_frankenstein.png');
  SpriteVariants[5]  := LoadTexture('sprites/rabbitv3_neo.png');
  SpriteVariants[6]  := LoadTexture('sprites/rabbitv3_sonic.png');
  SpriteVariants[7]  := LoadTexture('sprites/rabbitv3_spidey.png');
  SpriteVariants[8]  := LoadTexture('sprites/rabbitv3_stormtrooper.png');
  SpriteVariants[9]  := LoadTexture('sprites/rabbitv3_superman.png');
  SpriteVariants[10] := LoadTexture('sprites/rabbitv3_tron.png');
  SpriteVariants[11] := LoadTexture('sprites/rabbitv3_wolverine.png');

  for Texture in SpriteVariants do
    if Texture.ID <= 0 then
      raise EBunnyTexturesNotLoaded.Create('Texture could not be loaded. Returned ID: ' +
                                            Texture.ID.ToString);
end;

class procedure TBunnyClass.UnloadTextures;
var
  i: Integer;
begin
  for i := 0 to High(SpriteVariants) do
    UnloadTexture(SpriteVariants[i]);
end;

class procedure TBunnyClass.TickBunnies(ABunnies: array of TBunnyClass);
var
  Bunny: TBunnyClass;
begin
  for Bunny in ABunnies do Bunny.Tick;
end;

class procedure TBunnyClass.RenderBunnies(ABunnies: array of TBunnyClass);
var
  Bunny: TBunnyClass;
begin
  for Bunny in ABunnies do Bunny.Render;
end;

end.
