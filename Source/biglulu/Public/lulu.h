// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "Components/StaticMeshComponent.h"
#include "Camera/CameraComponent.h"
#include "Drumsticks.h"
#include "../bigluluGameModeBase.h"
#include "Water.h"
#include "Shopping.h"

#include "lulu.generated.h"

UCLASS()
class BIGLULU_API Alulu : public ACharacter
{
	GENERATED_BODY()

public:
	// Sets default values for this character's properties
	Alulu();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	/** Base turn rate, in deg/sec. Other scaling may affect final turn rate. */
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = Camera)
	float BaseTurnRate;

	/** Base look up/down rate, in deg/sec. Other scaling may affect final rate. */
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = Camera)
	float BaseLookUpRate;

	// Called every frame
	virtual void Tick(float DeltaTime) override;

	// Called to bind functionality to input
	virtual void SetupPlayerInputComponent(class UInputComponent* PlayerInputComponent) override;

	//ÒÆ¶¯
	void MoveForward(float Value);
	void MoveRight(float Value);
	void Jumppp();
	void Eat();

	UFUNCTION(BlueprintCallable)
	void TogglePause();

	UFUNCTION()
	void OnCollision(class UPrimitiveComponent* HitComp, class AActor* OtherActor, class UPrimitiveComponent* OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult);

	UFUNCTION()
	void EndCollision(class UPrimitiveComponent* HitComp, class AActor* OtherActor, class UPrimitiveComponent* OtherComp, int OtherBodyIndex);

	LuluType GetDeType() const;

	//virtual void ResetJumpState() override;

	//virtual void CheckJumpInput(float DeltaTime) override;
	//ÇÐ»»½ÇÉ«
	void ChangeC1();
	void ChangeC2();
	void ChangeC3();

	virtual void ResetJumpState() override;

	virtual void CheckJumpInput(float DeltaTime) override;
private:
	AbigluluGameModeBase* GameMode;

	UPROPERTY(EditAnywhere, Category = lulu)
	UStaticMeshComponent* luluMesh;

	/** Camera boom positioning the camera behind the character */
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = Camera, meta = (AllowPrivateAccess = "true"))
	class USpringArmComponent* CameraBoom;

	/** Follow camera */
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = Camera, meta = (AllowPrivateAccess = "true"))
	class UCameraComponent* FollowCamera;

	/** Returns CameraBoom subobject **/
	FORCEINLINE class USpringArmComponent* GetCameraBoom() const { return CameraBoom; }
	/** Returns FollowCamera subobject **/
	FORCEINLINE class UCameraComponent* GetFollowCamera() const { return FollowCamera; }

	UPROPERTY(EditAnywhere, Category = lulu)
	LuluType defaultType;

	TSet<ADrumsticks*> DestSet;

	AShopping* shopActor;

	UPROPERTY(EditAnywhere, Category = Water)
	int damage;
	UPROPERTY(EditAnywhere, Category = Water)
	float AttackInterval;

	TSet<AWater*> WaterSet;

	FTimerHandle TimeAttack;
	void Attack();
};
