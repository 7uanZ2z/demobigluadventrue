// Fill out your copyright notice in the Description page of Project Settings.


#include "Mover.h"
#include "lulu.h"
#include "Kismet/GameplayStatics.h"

// Sets default values
AMover::AMover()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

	CollisionMesh = CreateDefaultSubobject<UBoxComponent>(TEXT("BaseCollisionComponent"));
	CollisionMesh->SetBoxExtent(FVector(42.0f, 42.0f, 28.0f));

	MoverMesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("StaticMesh"));
	MoverMesh->SetupAttachment(CollisionMesh);

	canMove = false;
	SetActorEnableCollision(true);
}

// Called when the game starts or when spawned
void AMover::BeginPlay()
{
	Super::BeginPlay();
	CollisionMesh->OnComponentBeginOverlap.AddDynamic(this, &AMover::OnCollision);
	CollisionMesh->OnComponentEndOverlap.AddDynamic(this, &AMover::EndCollision);
}

// Called every frame
void AMover::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
	if (canMove == true) {
		float xo, yo;
		if (Locc.X > 0.0) xo = Locc.X;
		else xo = -Locc.X;
		if (Locc.Y > 0.0) yo = Locc.Y;
		else yo = -Locc.Y;

		FVector vv((xo >= yo ? (2 * Locc.X / xo) : 0.0), (yo >= xo ? (2 * Locc.Y / yo) : 0.0), 0.0);
		SetActorLocation(vv + GetActorLocation(), true);
		//UNavigationSystemV1::SimpleMoveToLocation(vv + GetActorLocation());
	}
}

void AMover::OnCollision(UPrimitiveComponent* HitComp, AActor* OtherActor, UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	if (OtherActor->IsA(Alulu::StaticClass())) {
		
		Alulu* Hero = Cast<Alulu>(OtherActor);
		GameMode = Cast<AbigluluGameModeBase>(UGameplayStatics::GetGameMode(this));
		Locc = GetActorLocation() - (Hero->GetActorLocation());
		if (GameMode->GetType() != LuluType::BEAR) {
			canMove = false;
		}
		else {
			canMove = true;
		}
	}
}

void AMover::EndCollision(UPrimitiveComponent* HitComp, AActor* OtherActor, UPrimitiveComponent* OtherComp, int OtherBodyIndex)
{
	if (OtherActor->IsA(Alulu::StaticClass())) {
		canMove = false;
	}
}

