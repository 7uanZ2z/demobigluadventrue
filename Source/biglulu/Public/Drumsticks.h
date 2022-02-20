// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Components/StaticMeshComponent.h"
#include "Components/CapsuleComponent.h"
#include "Drumsticks.generated.h"

UCLASS()
class BIGLULU_API ADrumsticks : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ADrumsticks();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	UPROPERTY(EditAnywhere, Category = Drumsticks)
	int iPower;

	//colision∂‘œÛ

	UPROPERTY(EditAnywhere, Category = Drumsticks)
	UCapsuleComponent* CollisionMesh;

	UPROPERTY(EditAnywhere, Category = Drumsticks)
	UStaticMeshComponent* DrumsticksMesh;

	UPROPERTY(EditAnywhere, Category = Drumsticks)
	bool canDestryooo;

	int GetPower();
};
