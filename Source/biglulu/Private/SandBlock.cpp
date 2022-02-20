// Fill out your copyright notice in the Description page of Project Settings.


#include "SandBlock.h"

// Sets default values
ASandBlock::ASandBlock()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	BeginDestroy = false;

	CollisionMesh = CreateDefaultSubobject<UBoxComponent>(TEXT("BaseCollisionComponent"));
	CollisionMesh->SetBoxExtent(FVector(40.0f, 40.0f, 12.0f));

	SandMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("StaticMesh"));
	SandMesh->SetupAttachment(CollisionMesh);

	//x = 0;
}

// Called when the game starts or when spawned
void ASandBlock::BeginPlay()
{
	Super::BeginPlay();
	CollisionMesh->OnComponentBeginOverlap.AddDynamic(this, &ASandBlock::OnCollision);
}

// Called every frame
void ASandBlock::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
	static int x = 0;
	x = (x + 1) % 5;
	if (BeginDestroy && x == 0) {
		FVector NewL = NowLocation;
		float xx = rand_P(0.0, 3.0)*7;
		float yy = rand_P(0.0, 3.0)*7;
		float zz = rand_P(0.0, 10.0);
		NewL.X += xx;
		NewL.Y += yy;
		NewL.Z += zz;
		SandMesh->SetRelativeLocation(NewL);
	}
}

void ASandBlock::SandDestroy()
{
	this->Destroy();
}

float ASandBlock::rand_P(float Min, float Max)
{
	return Min + (Max - Min) * (rand() / (float)RAND_MAX);
}

void ASandBlock::OnCollision(UPrimitiveComponent* HitComp, AActor* OtherActor, UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	if (OtherActor->IsA(Alulu::StaticClass())) {
		Alulu* Hero = Cast<Alulu>(OtherActor);
		if (Hero != nullptr && BeginDestroy == false) {
			NowLocation = SandMesh->GetRelativeLocation();
			BeginDestroy = true;
			GetWorldTimerManager().SetTimer(TimeSand, this, &ASandBlock::SandDestroy, 1.5, true);
		}
	}
}

