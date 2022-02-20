// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Components/StaticMeshComponent.h"
#include "Components/BoxComponent.h"
#include "../bigluluGameModeBase.h"
#include "Mover.generated.h"

UCLASS()
class BIGLULU_API AMover : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AMover();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	UFUNCTION()
	void OnCollision(class UPrimitiveComponent* HitComp, class AActor* OtherActor, class UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult);

	UFUNCTION()
	void EndCollision(class UPrimitiveComponent* HitComp, class AActor* OtherActor, class UPrimitiveComponent* OtherComp, int OtherBodyIndex);

	UPROPERTY(EditAnywhere, Category = Mover)
	UBoxComponent* CollisionMesh;

	UPROPERTY(EditAnywhere, Category = Mover)
	UStaticMeshComponent* MoverMesh;

	UPROPERTY(EditAnywhere, Category = Mover)
	bool canMove;

private:
	AbigluluGameModeBase* GameMode;
	FVector Locc;
};
