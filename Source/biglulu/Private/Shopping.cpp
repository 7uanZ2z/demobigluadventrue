// Fill out your copyright notice in the Description page of Project Settings.


#include "Shopping.h"

// Sets default values
AShopping::AShopping()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

	CollisionMesh = CreateDefaultSubobject<UCapsuleComponent>(TEXT("BaseCollisionComponent"));
	CollisionMesh->SetCapsuleSize(80.0f, 80.0f);

	ShopMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("StaticMesh"));
	ShopMesh->SetupAttachment(CollisionMesh);

	SetActorEnableCollision(true);
	ssss = "";
}

// Called when the game starts or when spawned
void AShopping::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void AShopping::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

