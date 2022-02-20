// Copyright Epic Games, Inc. All Rights Reserved.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/GameModeBase.h"
#include "Sound/SoundCue.h"
#include "bigluluGameModeBase.generated.h"

/**
 * 
 */
UENUM(BlueprintType)
enum class LuluType :uint8 {
	LU,
	SMA,
	BIG,
	FROG,
	BEAR,
	CHANGE,
	TUAN
};
UCLASS()
class BIGLULU_API AbigluluGameModeBase : public AGameModeBase
{
	GENERATED_BODY()
public:
	AbigluluGameModeBase();

	LuluType GetType() const;
	void SetType(LuluType Value);

	void SetNowType(LuluType Value);

	UFUNCTION(BlueprintCallable)
	FORCEINLINE int GetNowPower() const { return nowPower; }
	void SetNowPower(int v);

	UFUNCTION(BlueprintCallable)
	FORCEINLINE FString GetTips() const { return tips; }

	UFUNCTION(BlueprintCallable)
	int GetTypeTimes(LuluType tt);

	void SetTypeTimes(LuluType tt, int times);
	
	void Settips(FString ss);
	
	void Sound_eat();
	void Sound_hello();
	void Sound_jiaoyi();
	void Sound_jump();
	void Sound_lu();
	void Sound_frog();
	void Sound_water();
	void Sound_jumpxiong();
	void Sound_bear();
private:
	LuluType NowType;
	int nowPower;
	int FrogTimes;
	int BearTimes;

	FString tips;

	LuluType GetShouldType(int line);

	USoundCue* HitSound1;
	USoundCue* HitSound2;
	USoundCue* HitSound3;
	USoundCue* HitSound4;
	USoundCue* HitSound5;
	USoundCue* HitSound6;
	USoundCue* HitSound7;
	USoundCue* HitSound8;
	USoundCue* HitSound9;
};
