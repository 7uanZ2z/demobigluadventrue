// Fill out your copyright notice in the Description page of Project Settings.


#include "DeadLine.h"
#include "lulu.h"

// Sets default values
ADeadLine::ADeadLine()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	CollisionMesh = CreateDefaultSubobject<UBoxComponent>(TEXT("BaseCollisionComponent"));
	CollisionMesh->SetBoxExtent(FVector(10000.0f, 10000.0f, 10.0f));

	DeadMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("StaticMesh"));
	DeadMesh->SetupAttachment(CollisionMesh);

	SetActorEnableCollision(true);
}

// Called when the game starts or when spawned
void ADeadLine::BeginPlay()
{
	Super::BeginPlay();
	CollisionMesh->OnComponentBeginOverlap.AddDynamic(this, &ADeadLine::OnCollision);
}

// Called every frame
void ADeadLine::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

void ADeadLine::OnCollision(UPrimitiveComponent* HitComp, AActor* OtherActor, UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	ACharacter* myPawn = UGameplayStatics::GetPlayerCharacter(GetWorld(), 0);
	Alulu* hero = Cast<Alulu>(myPawn);
	if (OtherActor->IsA(Alulu::StaticClass())) {
		Alulu* Hero2 = Cast<Alulu>(OtherActor);
		if (Hero2 == hero) {
			AbigluluGameModeBase* GameMode = Cast<AbigluluGameModeBase>(UGameplayStatics::GetGameMode(this));
			GameMode->SetNowPower(-9999999);
		}
	}
}

