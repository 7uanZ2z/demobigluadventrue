// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Components/BoxComponent.h"
#include "lulu.h"
#include "SandBlock.generated.h"

UCLASS()
class BIGLULU_API ASandBlock : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ASandBlock();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;
	//Box∂‘œÛ
	UPROPERTY(EditAnywhere, Category = SandBlock)
	UBoxComponent* CollisionMesh;

	UPROPERTY(EditAnywhere, Category = SandBlock)
	UStaticMeshComponent* SandMesh;
	void SandDestroy();
	float rand_P(float Min, float Max);

	UFUNCTION()
	void OnCollision(class UPrimitiveComponent* HitComp, class AActor* OtherActor, class UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult);
private:
	//int x = 0;
	bool BeginDestroy;
	FVector NowLocation;
	FTimerHandle TimeSand;
};
