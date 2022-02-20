// Fill out your copyright notice in the Description page of Project Settings.


#include "Water.h"

// Sets default values
AWater::AWater()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	CollisionMesh = CreateDefaultSubobject<UBoxComponent>(TEXT("BaseCollisionComponent"));
	CollisionMesh->SetBoxExtent(FVector(40.0f, 40.0f, 12.0f));

	WaterMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("StaticMesh"));
	WaterMesh->SetupAttachment(CollisionMesh);

	SetActorEnableCollision(true);
}

// Called when the game starts or when spawned
void AWater::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void AWater::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

