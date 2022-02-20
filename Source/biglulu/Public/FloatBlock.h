// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Components/BoxComponent.h"
#include "FloatBlock.generated.h"

UCLASS()
class BIGLULU_API AFloatBlock : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AFloatBlock();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;
	//Box����
	UPROPERTY(EditAnywhere, Category = FloatBlock)
	UBoxComponent* CollisionMesh;

	UPROPERTY(EditAnywhere, Category = FloatBlock)
	UStaticMeshComponent* FloatMesh;

	UPROPERTY(EditAnywhere, Category = FloatBlock)
	float initPI;

	UPROPERTY(EditAnywhere, Category = FloatBlock)
	float initwavelength;
};
