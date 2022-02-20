// Fill out your copyright notice in the Description page of Project Settings.


#include "Drumsticks.h"

// Sets default values
ADrumsticks::ADrumsticks()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

	CollisionMesh = CreateDefaultSubobject<UCapsuleComponent>(TEXT("BaseCollisionComponent"));
	CollisionMesh->SetCapsuleSize(100.0f, 100.0f);

	DrumsticksMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("StaticMesh"));
	DrumsticksMesh->SetupAttachment(CollisionMesh);

	canDestryooo = true;
	SetActorEnableCollision(true);
	
	iPower = 1;
}

// Called when the game starts or when spawned
void ADrumsticks::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void ADrumsticks::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

int ADrumsticks::GetPower()
{
	return iPower;
}

