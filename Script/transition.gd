extends Node2D

func transition_in():$AnimationPlayer.play("transition_in")

func transition_out():$AnimationPlayer.play_backwards("transition_in")
