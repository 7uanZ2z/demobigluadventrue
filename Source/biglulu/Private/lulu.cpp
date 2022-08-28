// Fill out your copyright notice in the Description page of Project Settings.


#include "lulu.h"
#include "Kismet/GameplayStatics.h"
#include "Components/CapsuleComponent.h"
#include "EngineUtils.h"
#include "Engine/Engine.h"

#include "Camera/CameraComponent.h"
#include "Components/CapsuleComponent.h"
#include "Components/InputComponent.h"
#include "GameFramework/CharacterMovementComponent.h"
#include "GameFramework/Controller.h"
#include "GameFramework/SpringArmComponent.h"

// Sets default values
Alulu::Alulu()
{
 	// Set this character to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	// Set size for collision capsule
	GetCapsuleComponent()->InitCapsuleSize(42.f, 96.0f);
	// set our turn rates for input
	BaseTurnRate = 45.f;
	BaseLookUpRate = 45.f;
	// Don't rotate when the controller rotates. Let that just affect the camera.
	bUseControllerRotationPitch = false;
	bUseControllerRotationYaw = false;
	bUseControllerRotationRoll = false;
	// Configure character movement
	GetCharacterMovement()->bOrientRotationToMovement = true; // Character moves in the direction of input...	
	GetCharacterMovement()->RotationRate = FRotator(0.0f, 540.0f, 0.0f); // ...at this rotation rate
	GetCharacterMovement()->JumpZVelocity = 600.f;
	GetCharacterMovement()->AirControl = 0.2f;
	// Create a camera boom (pulls in towards the player if there is a collision)
	CameraBoom = CreateDefaultSubobject<USpringArmComponent>(TEXT("CameraBoom"));
	CameraBoom->SetupAttachment(RootComponent);
	CameraBoom->TargetArmLength = 500.0f; // The camera follows at this distance behind the character	
	CameraBoom->bUsePawnControlRotation = true; // Rotate the arm based on the controller
	// Create a follow camera
	FollowCamera = CreateDefaultSubobject<UCameraComponent>(TEXT("FollowCamera"));
	FollowCamera->SetupAttachment(CameraBoom, USpringArmComponent::SocketName); // Attach the camera to the end of the boom and let the boom adjust to match the controller orientation
	FollowCamera->bUsePawnControlRotation = false; // Camera does not rotate relative to arm

	//Ä£ÐÍ
	luluMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("lulu"));
	luluMesh->SetupAttachment(GetRootComponent());
	luluMesh->SetRelativeRotation((FRotator{ 0.0f, 0.0f, 90.0f }));

	GameMode = Cast<AbigluluGameModeBase>(UGameplayStatics::GetGameMode(this));

	defaultType = LuluType::LU;
	shopActor = nullptr;
	
	AttackInterval = 0.5;
	damage = 1;
}

// Called when the game starts or when spawned
void Alulu::BeginPlay()
{
	Super::BeginPlay();
	SetActorEnableCollision(true);
	GetCapsuleComponent()->OnComponentBeginOverlap.AddDynamic(this, &Alulu::OnCollision);
	GetCapsuleComponent()->OnComponentEndOverlap.AddDynamic(this, &Alulu::EndCollision);
	//GEngine->AddOnScreenDebugMessage(-1, 5.f, FColor::Red, "molemole!!!!");
}

// Called every frame
void Alulu::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

// Called to bind functionality to input
void Alulu::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);
	PlayerInputComponent->BindAction("Pause", IE_Pressed, this, &Alulu::TogglePause);
	PlayerInputComponent->BindAction("Jump", IE_Pressed, this, &Alulu::Jumppp);
	PlayerInputComponent->BindAction("MouseL", IE_Pressed, this, &Alulu::Eat);
	PlayerInputComponent->BindAction("Jump", IE_Released, this, &ACharacter::StopJumping);
	PlayerInputComponent->BindAction("C1", IE_Pressed, this, &Alulu::ChangeC1);
	PlayerInputComponent->BindAction("C2", IE_Pressed, this, &Alulu::ChangeC2);
	PlayerInputComponent->BindAction("C3", IE_Pressed, this, &Alulu::ChangeC3);
	PlayerInputComponent->BindAxis("MoveForward", this, &Alulu::MoveForward);
	PlayerInputComponent->BindAxis("MoveRight", this, &Alulu::MoveRight);
	PlayerInputComponent->BindAxis("Turn", this, &APawn::AddControllerYawInput);
	PlayerInputComponent->BindAxis("LookUp", this, &APawn::AddControllerPitchInput);
	
}

void Alulu::MoveForward(float Value)
{
	if ((Controller != nullptr) && (Value != 0.0f))
	{
		// find out which way is forward
		const FRotator Rotation = Controller->GetControlRotation();
		const FRotator YawRotation(0, Rotation.Yaw, 0);
		// get forward vector
		const FVector Direction = FRotationMatrix(YawRotation).GetUnitAxis(EAxis::X);
		AddMovementInput(Direction, Value);
	}
}

void Alulu::MoveRight(float Value)
{
	if ((Controller != nullptr) && (Value != 0.0f))
	{
		// find out which way is right
		const FRotator Rotation = Controller->GetControlRotation();
		const FRotator YawRotation(0, Rotation.Yaw, 0);
		// get right vector 
		const FVector Direction = FRotationMatrix(YawRotation).GetUnitAxis(EAxis::Y);
		// add movement in that direction
		AddMovementInput(Direction, Value);
	}
}

void Alulu::Jumppp()
{
	Jump();
}

void Alulu::Eat() 
{
	//if (shopActor == nullptr) {
		//destruction
	if (defaultType == LuluType::LU) {
		//REMOVE
		if (DestSet.Num() > 0)
			GameMode->Sound_eat();
		for (auto DestIterator = DestSet.CreateIterator(); DestIterator; ++DestIterator)
		{
			ADrumsticks* dd = *DestIterator;
			int m = GameMode->GetNowPower();
			GameMode->SetNowPower(m + dd->GetPower());
			GameMode->SetType(LuluType::CHANGE);
			dd->Destroy();
		}
		DestSet.Empty();
		
	}
	if (shopActor != nullptr) {
		int m = GameMode->GetNowPower();
		if (shopActor->GetssType() == LuluType::FROG) {
			if (m > 0) {
				//GameMode->Sound_SpendMoney();
				GameMode->SetTypeTimes(LuluType::FROG, GameMode->GetTypeTimes(LuluType::FROG) + 1);
				GameMode->SetNowPower(GameMode->GetNowPower() - 1);
				GameMode->SetType(LuluType::CHANGE);
				GameMode->Sound_jiaoyi();
			}
		}
		else if(shopActor->GetssType() == LuluType::BEAR){
			if (m > 0) {
				//GameMode->Sound_SpendMoney();
				GameMode->SetTypeTimes(LuluType::BEAR, GameMode->GetTypeTimes(LuluType::BEAR) + 1);
				GameMode->SetNowPower(GameMode->GetNowPower() - 1);
				GameMode->SetType(LuluType::CHANGE);
				GameMode->Sound_jiaoyi();
			}
		}
	}
}

void Alulu::TogglePause()
{
}

void Alulu::OnCollision(UPrimitiveComponent* HitComp, AActor* OtherActor, UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	if (OtherActor->IsA(ADrumsticks::StaticClass())) {
		ADrumsticks* NowDes = Cast<ADrumsticks>(OtherActor);
		if (NowDes->canDestryooo) {
			DestSet.Add(NowDes);
		}
	}
	if (OtherActor->IsA(AWater::StaticClass())) {
		ACharacter* myPawn = UGameplayStatics::GetPlayerCharacter(GetWorld(), 0);
		Alulu* hero = Cast<Alulu>(myPawn);
		if (hero != this) {
			int m = GameMode->GetNowPower();
			if (m - damage < 0)
				GameMode->SetNowPower(-1);
		}
		else {
			AWater* Nowwat = Cast<AWater>(OtherActor);
			int num = WaterSet.Num();
			WaterSet.Add(Nowwat);
			Attack();
			if (num == 0)
				GetWorldTimerManager().SetTimer(TimeAttack, this, &Alulu::Attack, AttackInterval, true);
		}
	}
	if (OtherActor->IsA(AShopping::StaticClass())) {
		shopActor = Cast<AShopping>(OtherActor);
		LuluType x = shopActor->GetssType();
		GameMode->Settips(shopActor->Getstring());
		if (x == LuluType::TUAN) {
			GameMode->Sound_hello();
		}
	}
	
}

void Alulu::EndCollision(UPrimitiveComponent* HitComp, AActor* OtherActor, UPrimitiveComponent* OtherComp, int OtherBodyIndex)
{
	if (OtherActor->IsA(ADrumsticks::StaticClass())) {
		ADrumsticks* NowDes = Cast<ADrumsticks>(OtherActor);
		if (NowDes->canDestryooo && DestSet.Contains(NowDes)) {
			DestSet.Remove(NowDes);
		}
	}
	if (OtherActor->IsA(AWater::StaticClass())) {
		AWater* Nowwat = Cast<AWater>(OtherActor);
		if (WaterSet.Contains(Nowwat)) {
			WaterSet.Remove(Nowwat);
			if (WaterSet.Num() == 0) {
				GetWorldTimerManager().ClearTimer(TimeAttack);
			}
		}
	}
	if (OtherActor->IsA(AShopping::StaticClass())) {
		AShopping* nowshop = Cast<AShopping>(OtherActor);
		if (shopActor == nowshop) {
			shopActor = nullptr;
			GameMode->Settips(FString(""));
		}
	}
}

LuluType Alulu::GetDeType() const
{
	return defaultType;
}

void Alulu::ChangeC1()
{
	if (defaultType == LuluType::LU) {
		GameMode->SetType(LuluType::CHANGE);
		return;
	}
	else {
		GameMode->SetType(LuluType::LU);
		return;
	}
}

void Alulu::ChangeC2()
{
	if (defaultType == LuluType::FROG || GameMode->GetTypeTimes(LuluType::FROG) <= 0) {
		return;
	}
	GameMode->SetType(LuluType::FROG);
}

void Alulu::ChangeC3()
{
	if (defaultType == LuluType::BEAR || GameMode->GetTypeTimes(LuluType::BEAR) <= 0) {
		return;
	}
	GameMode->SetType(LuluType::BEAR);
}

void Alulu::ResetJumpState()
{
	if (defaultType == LuluType::FROG)
		if (JumpCurrentCount == 2) {
			if (GetMovementComponent()) {//luodi
				if (!GetMovementComponent()->IsFalling()) {
					if (GameMode->GetTypeTimes(LuluType::FROG) == 0) {
						GameMode->SetType(LuluType::LU);
					}
				}
				else {// falling
					if (GameMode->GetTypeTimes(LuluType::FROG) > 0) {
						GameMode->SetTypeTimes(LuluType::FROG, GameMode->GetTypeTimes(LuluType::FROG) - 1);
					}
				}
			}
		}
	Super::ResetJumpState();
}

void Alulu::CheckJumpInput(float DeltaTime)
{
	JumpCurrentCountPreJump = JumpCurrentCount;
	auto charmove = GetCharacterMovement();
	if (charmove)
	{
		if (bPressedJump)
		{
			int preJump = JumpCurrentCount;
			// If this is the first jump and we're already falling,
			// then increment the JumpCount to compensate.
			const bool bFirstJump = JumpCurrentCount == 0;
			if (bFirstJump && charmove->IsFalling())
			{
				JumpCurrentCount++;
			}

			const bool bDidJump = CanJump() && charmove->DoJump(bClientUpdating);
			if (bDidJump)
			{
				// Transition from not (actively) jumping to jumping.
				if (!bWasJumping)
				{
					JumpCurrentCount++;
					JumpForceTimeRemaining = GetJumpMaxHoldTime();
					OnJumped();
				}
			}
			
			if (JumpCurrentCount == preJump + 1) {
				if (defaultType == LuluType::LU)
					GameMode->Sound_jump();
				if (defaultType == LuluType::BEAR)
					GameMode->Sound_jumpxiong();
				if (defaultType == LuluType::FROG)
					GameMode->Sound_frog();
			}
			bWasJumping = bDidJump;
		}
	}
}

void Alulu::Attack()
{
	if (WaterSet.Num() == 0) {
		GetWorldTimerManager().ClearTimer(TimeAttack);
	}

	int m = GameMode->GetNowPower();
	GameMode->Sound_water();
	GameMode->SetNowPower(m - damage);
	if (m - damage < 3)
		GameMode->SetType(LuluType::CHANGE);

	//GameMode->Sound_lucker();
}

