// Fill out your copyright notice in the Description page of Project Settings.


#include "Portal.h"

// Sets default values
APortal::APortal()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	Volume = CreateDefaultSubobject<UBoxComponent>("Volume");
	RootComponent = Volume;
	NextLevel = "TestMap";
}

// Called when the game starts or when spawned
void APortal::BeginPlay()
{
	Super::BeginPlay();
	Volume->OnComponentBeginOverlap.AddDynamic(this, &APortal::OnCollision);
}

// Called every frame
void APortal::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

void APortal::OnCollision(UPrimitiveComponent* HitComp, AActor* OtherActor, UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	if (OtherActor) {
		Alulu* hero = Cast<Alulu>(OtherActor);
		if (hero) {
			UWorld* World = GetWorld();
			if (World) {
				FName CurrentLevel(*World->GetMapName());
				if (CurrentLevel != NextLevel) {
					UGameplayStatics::OpenLevel(World, NextLevel);
				}
			}
		}
	}
}

