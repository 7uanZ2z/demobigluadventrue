// Fill out your copyright notice in the Description page of Project Settings.


#include "LuluPlayerController.h"
#include "Blueprint/UserWidget.h"
#include "Kismet/GameplayStatics.h"

void ALuluPlayerController::SetPauseMenuVisibility(bool Visibility)
{
	if (PauseMenu) {
		if (Visibility) {
			PauseMenu->SetVisibility(ESlateVisibility::Visible);
		}
		else {
			PauseMenu->SetVisibility(ESlateVisibility::Hidden);
		}
	}
}

void ALuluPlayerController::TogglePause()
{
	bPause = !bPause;
	SetPauseMenuVisibility(bPause);
	bShowMouseCursor = bPause;
	UGameplayStatics::SetGamePaused(this, bPause);
}

void ALuluPlayerController::BeginPlay()
{
	Super::BeginPlay();
	if (PauseMenuAsset) {
		PauseMenu = CreateWidget<UUserWidget>(this, PauseMenuAsset);
	}
	if (PauseMenu) {
		PauseMenu->SetVisibility(ESlateVisibility::Hidden);
		PauseMenu->AddToViewport();
	}
}

void ALuluPlayerController::ChangeCharacter(LuluType v)
{
	FRotator rro = GetControlRotation();

	LastPawn = GetPawn();

	if (LastPawn) {
		LastPawn->SetActorEnableCollision(false);
		LastPawn->DisableInput(this);
		LastPawn->SetActorHiddenInGame(true);
		LastPawn->GetRootComponent()->SetVisibility(false, true);
		FVector loc = LastPawn->GetActorLocation();
		FRotator rot = FRotator(0.0f, LastPawn->GetActorRotation().Yaw, 0.0f);
		AbigluluGameModeBase* GameMode = Cast<AbigluluGameModeBase>(UGameplayStatics::GetGameMode(this));
		//GameMode->Sound_ChangeMan();
		if (v == LuluType::SMA) {
			NextPlayerPawn =
				GetWorld()->SpawnActor<APawn>(Sma_Lu.Get(), loc, rot);
		}
		else if (v == LuluType::BIG) {
			NextPlayerPawn =
				GetWorld()->SpawnActor<APawn>(Big_Lu.Get(), loc, rot);
		}
		else if (v == LuluType::FROG) {
			NextPlayerPawn =
				GetWorld()->SpawnActor<APawn>(Frog_Lu.Get(), loc, rot);
		}
		else if (v == LuluType::BEAR) {
			NextPlayerPawn =
				GetWorld()->SpawnActor<APawn>(Bear_Lu.Get(), loc, rot);
		}
		
		if (NextPlayerPawn)
		{
			//GEngine->AddOnScreenDebugMessage(5, 5, FColor::Green, TEXT("Get redhero!!"));
			OnPossess(NextPlayerPawn);
			LastPawn->Destroy();
			SetControlRotation(rro);
			GameMode->SetNowType(v);

			if (v == LuluType::BEAR) {
				GameMode->SetTypeTimes(LuluType::BEAR, GameMode->GetTypeTimes(LuluType::BEAR) - 1);
				GameMode->Sound_bear();
			}
			else if (v == LuluType::FROG) {
				GameMode->Sound_frog();
			}
			else {
				GameMode->Sound_lu();
			}
		}
		else {
			LastPawn->SetActorLocation(loc);
			LastPawn->SetActorEnableCollision(true);
			LastPawn->EnableInput(this);
			LastPawn->SetActorHiddenInGame(false);
			LastPawn->GetRootComponent()->SetVisibility(true, true);
		}
	}
}

ALuluPlayerController::ALuluPlayerController() {
	static ConstructorHelpers::FClassFinder<Alulu> Bp1(TEXT("/Game/BluePrint/character/BP_lulu"));
	if (Bp1.Class) {
		Sma_Lu = Bp1.Class;
	}
	static ConstructorHelpers::FClassFinder<Alulu> Bp2(TEXT("/Game/BluePrint/character/BP_biglulu"));
	if (Bp2.Class) {
		Big_Lu = Bp2.Class;
	}
	static ConstructorHelpers::FClassFinder<Alulu> Bp3(TEXT("/Game/BluePrint/character/BP_Bear"));
	if (Bp3.Class) {
		Bear_Lu = Bp3.Class;
	}
	static ConstructorHelpers::FClassFinder<Alulu> Bp4(TEXT("/Game/BluePrint/character/BP_Frog"));
	if (Bp4.Class) {
		Frog_Lu = Bp4.Class;
	}
}