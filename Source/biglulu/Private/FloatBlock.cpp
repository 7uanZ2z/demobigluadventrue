// Fill out your copyright notice in the Description page of Project Settings.


#include "FloatBlock.h"

// Sets default values
AFloatBlock::AFloatBlock()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	CollisionMesh = CreateDefaultSubobject<UBoxComponent>(TEXT("BaseCollisionComponent"));
	CollisionMesh->SetBoxExtent(FVector(40.0f, 40.0f, 12.0f));

	FloatMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("StaticMesh"));
	FloatMesh->SetupAttachment(CollisionMesh);

	initPI = 0.0;
	initwavelength = 240.0f;
}

// Called when the game starts or when spawned
void AFloatBlock::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void AFloatBlock::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
	FVector NewLocation = GetActorLocation();
	FRotator NewRotation = GetActorRotation();
	float RunningTime = GetGameTimeSinceCreation();
	float DeltaHeight = (FMath::Sin(RunningTime + PI*initPI + DeltaTime) - FMath::Sin(PI * initPI + RunningTime));
	NewLocation.Z += DeltaHeight * initwavelength;       //Scale our height by a factor of 20
	//float DeltaRotation = DeltaTime * 50.0f;    //Rotate by 20 degrees per second
	//NewRotation.Yaw += DeltaRotation;
	SetActorLocationAndRotation(NewLocation, NewRotation);
}

