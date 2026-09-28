# Gojo Park Animation Demo

โปรเจกต์ Godot 4.7 ฉากสวนจากภาพอ้างอิง ใช้สกิน `gojo.png` ทำตัวละคร Gojo แบบบล็อก 3D จำนวน 5 ตัวบนพื้น พร้อมต้นไม้ low-poly จากชุดที่ระบุ ตัวละครที่ลอยอยู่ถูกนำออกแล้ว

## ลำดับตัวละครจากซ้ายไปขวา

| ตัวที่ | การแสดง | แอนิเมชัน |
|---|---|---|
| 1 | ยืน | `Shooter/idle` |
| 2 | เดิน | `Shooter/walk` |
| 3 | วิ่งอยู่กับที่ | `Melee/LightRunning` |
| 4 | ต่อยด้วยแขนขวา | `Punch/right` |
| 5 | ต่อยด้วยแขนซ้าย | `Punch/left` |

ท่าต่อย `Punch/right` และ `Punch/left` ทำสำหรับโมเดลบล็อกนี้โดยเฉพาะ จึงหมุนแขนทั้งชิ้นจากหัวไหล่และไม่พับข้อศอก ตรวจภาพช่วงเริ่ม ต่อย และคืนท่าแล้ว แขนขายังอยู่ติดลำตัว


ตัวอย่างชื่อท่า: `Shooter/idle`, `Shooter/walk`, `Melee/LightRunning`, `Punch/right`, `Punch/left` ชื่อท่าต้องตรงกับรายการใน `AnimationPlayer` ทุกตัวอักษร เปิด `GojoCharacter.tscn` และ `AnimationPlayer` เพื่อปรับคีย์เฟรมของท่าต่อยเองได้

`StudioDemo.tscn` คือฉากสตูดิโอเดิม ใช้ `LegacyGojoCharacter.tscn` เพื่อรักษาตัวอย่างท่าเดิมไว้

## แอนิเมชันจาก GitHub

`GojoCharacter.tscn` มี `Skeleton3D` ชื่อ `GeneralSkeleton` พร้อม `AnimationPlayer` ที่ผูกคลังแอนิเมชันจริงจาก [Godot4-OpenAnimationLibraries ของ catprisbrey](https://github.com/catprisbrey/Godot4-OpenAnimationLibraries):

- `assets/animations/MeleeLib.res` — 121 ท่า
- `assets/animations/ShooterLib.res` — 180 ท่า
- `assets/animations/Mixamo BoneMap.tres` — ไฟล์อ้างอิงสำหรับโมเดลที่ใส่กระดูกด้วย Mixamo ในอนาคต ฉากนี้ใช้โครงกระดูก Humanoid ใน Godot และเล่นสองไลบรารีด้านบนโดยตรง
- `assets/animations/GojoPunch.tres` — ท่าต่อยซ้าย/ขวาที่ปรับให้แขนบล็อกของ Gojo อยู่ติดกับหัวไหล่
