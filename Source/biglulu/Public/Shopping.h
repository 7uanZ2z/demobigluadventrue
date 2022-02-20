// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "../bigluluGameModeBase.h"
#include "Components/StaticMeshComponent.h"
#include "Components/CapsuleComponent.h"
#include "Shopping.generated.h"


UCLASS()
class BIGLULU_API AShopping : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AShopping();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	UPROPERTY(EditAnywhere, Category = Shop)
	UCapsuleComponent* CollisionMesh;

	UPROPERTY(EditAnywhere, Category = Shop)
	UStaticMeshComponent* ShopMesh;

	FORCEINLINE LuluType GetssType() const { return ssType; }

	FORCEINLINE FString Getstring() const { return ssss; }
private:

	UPROPERTY(EditAnywhere, Category = Shop)
	LuluType ssType;
	UPROPERTY(EditAnywhere, Category = Shop)
	FString ssss;
};
