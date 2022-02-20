// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Components/StaticMeshComponent.h"
#include "Components/BoxComponent.h"
#include "Water.generated.h"

UCLASS()
class BIGLULU_API AWater : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AWater();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	UPROPERTY(EditAnywhere, Category = water)
	UBoxComponent* CollisionMesh;

	UPROPERTY(EditAnywhere, Category = water)
	UStaticMeshComponent* WaterMesh;
};
