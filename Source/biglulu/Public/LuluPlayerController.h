// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/PlayerController.h"
#include "../bigluluGameModeBase.h"
#include "lulu.h"
#include "LuluPlayerController.generated.h"

/**
 * 
 */
UCLASS()
class BIGLULU_API ALuluPlayerController : public APlayerController
{
	
	GENERATED_BODY()
public:
	UPROPERTY(EditAnywhere, BlueprintReadWrite)
	TSubclassOf<UUserWidget> PauseMenuAsset;

	UUserWidget* PauseMenu;
	void SetPauseMenuVisibility(bool Visibility);
	
	bool bPause;
	void TogglePause();

	virtual void BeginPlay() override;

	//ÇÐ»»½ÇÉ«
	APawn* LastPawn;
	APawn* NextPlayerPawn;
	
	UPROPERTY(EditAnywhere, Category = Players, meta = (AllowPrivateAccess = "true"))
	TSubclassOf<class Alulu> Sma_Lu;
	UPROPERTY(EditAnywhere, Category = Players, meta = (AllowPrivateAccess = "true"))
	TSubclassOf<class Alulu> Big_Lu;
	UPROPERTY(EditAnywhere, Category = Players, meta = (AllowPrivateAccess = "true"))
	TSubclassOf<class Alulu> Bear_Lu;
	UPROPERTY(EditAnywhere, Category = Players, meta = (AllowPrivateAccess = "true"))
	TSubclassOf<class Alulu> Frog_Lu;

	ALuluPlayerController();
	void ChangeCharacter(LuluType v);
};
