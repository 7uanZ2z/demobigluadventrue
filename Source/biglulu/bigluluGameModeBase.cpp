// Copyright Epic Games, Inc. All Rights Reserved.


#include "bigluluGameModeBase.h"
#include "Kismet/GameplayStatics.h"
#include "Public/LuluPlayerController.h"
#include "Sound/SoundCue.h"

AbigluluGameModeBase::AbigluluGameModeBase() {
    NowType = LuluType::SMA;
    nowPower = 0;
	FrogTimes = 0;
	BearTimes = 0;

	tips = FString("");
	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump1(TEXT("SoundCue'/Game/Sound/eat_cue.eat_cue'"));
	HitSound1 = SoundMoJump1.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump2(TEXT("SoundCue'/Game/Sound/hello_cue.hello_cue'"));
	HitSound2 = SoundMoJump2.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump3(TEXT("SoundCue'/Game/Sound/jiaoyi_cue.jiaoyi_cue'"));
	HitSound3 = SoundMoJump3.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump4(TEXT("SoundCue'/Game/Sound/Jump_cue.Jump_cue'"));
	HitSound4 = SoundMoJump4.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump5(TEXT("SoundCue'/Game/Sound/lu_cue.lu_cue'"));
	HitSound5 = SoundMoJump5.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump6(TEXT("SoundCue'/Game/Sound/qingwa_cue.qingwa_cue'"));
	HitSound6 = SoundMoJump6.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump7(TEXT("SoundCue'/Game/Sound/shui_cue.shui_cue'"));
	HitSound7 = SoundMoJump7.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump8(TEXT("SoundCue'/Game/Sound/tiao2_cue.tiao2_cue'"));
	HitSound8 = SoundMoJump8.Object;

	static ConstructorHelpers::FObjectFinder<USoundCue>SoundMoJump9(TEXT("SoundCue'/Game/Sound/xiong_cue.xiong_cue'"));
	HitSound9 = SoundMoJump9.Object;
}

LuluType AbigluluGameModeBase::GetType() const
{
    return NowType;
}

void AbigluluGameModeBase::SetType(LuluType Value)
{
	APlayerController* PCler = UGameplayStatics::GetPlayerController(GWorld, 0);
	ALuluPlayerController* MPCler = Cast<ALuluPlayerController>(PCler);
	ACharacter* myPawn = UGameplayStatics::GetPlayerCharacter(GetWorld(), 0);
	Alulu* lu = Cast<Alulu>(myPawn);
	LuluType realPose = lu->GetDeType();

	LuluType shod = GetShouldType(GetNowPower());
	if (Value == LuluType::CHANGE) {
		if (NowType != shod)
			if (realPose == LuluType::LU)
				MPCler->ChangeCharacter(shod);
	}
	else if (Value == LuluType::LU) {
		if (realPose != LuluType::LU)
			MPCler->ChangeCharacter(shod);
	}
	else if (Value == LuluType::FROG) {
		if (FrogTimes > 0 && realPose != LuluType::FROG)
			MPCler->ChangeCharacter(LuluType::FROG);
	}
	else if (Value == LuluType::BEAR) {
		if (BearTimes > 0 && realPose != LuluType::BEAR)
			MPCler->ChangeCharacter(LuluType::BEAR);
	}
}

void AbigluluGameModeBase::SetNowType(LuluType Value)
{
	NowType = Value;
}

void AbigluluGameModeBase::SetNowPower(int v)
{
    nowPower = v;
	if (v < 0) {
		UGameplayStatics::OpenLevel(GetWorld(), FName(UGameplayStatics::GetCurrentLevelName(GetWorld())));
	}
}

int AbigluluGameModeBase::GetTypeTimes(LuluType tt)
{
	if (tt == LuluType::FROG) {
		return FrogTimes;
	}
	else if (tt == LuluType::BEAR) {
		return BearTimes;
	}
	return -1;
}

void AbigluluGameModeBase::SetTypeTimes(LuluType tt, int times)
{
	if (tt == LuluType::FROG) {
		FrogTimes = times;
	}
	else if (tt == LuluType::BEAR) {
		BearTimes = times;
	}
}

void AbigluluGameModeBase::Settips(FString ss)
{
	tips = ss;
}

void AbigluluGameModeBase::Sound_eat()
{
	if (HitSound1)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound1);
	}
}

void AbigluluGameModeBase::Sound_hello()
{
	if (HitSound2)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound2);
	}
}

void AbigluluGameModeBase::Sound_jiaoyi()
{
	if (HitSound3)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound3);
	}
}

void AbigluluGameModeBase::Sound_jump()
{
	if (HitSound4)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound4);
	}
}

void AbigluluGameModeBase::Sound_lu()
{
	if (HitSound5)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound5);
	}
}

void AbigluluGameModeBase::Sound_frog()
{
	if (HitSound6)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound6);
	}
}

void AbigluluGameModeBase::Sound_water()
{
	if (HitSound7)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound7);
	}
}

void AbigluluGameModeBase::Sound_jumpxiong()
{
	if (HitSound8)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound8);
	}
}

void AbigluluGameModeBase::Sound_bear()
{
	if (HitSound9)
	{
		UGameplayStatics::PlaySound2D(GetWorld(), HitSound9);
	}
}


LuluType AbigluluGameModeBase::GetShouldType(int line)
{
	if (line < 3) {
		return LuluType::SMA;
	}
	else {
		return LuluType::BIG;
	}
}

