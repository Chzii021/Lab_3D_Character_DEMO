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

## เปิดและแก้ไขใน Godot

1. เปิด Godot 4.7 แล้วเลือก **Import** และไฟล์ `project.godot` ในโฟลเดอร์นี้
2. เปิด `main.tscn` เพื่อแก้ฉาก หรือกด **Run Project** เพื่อดูแอนิเมชัน
3. ในแถบ Scene เลือก `Ground`, `Trees` หรือ `Characters` เพื่อแก้พื้น ต้นไม้ และตัวละครตามลำดับ โหนดตัวละครแต่ละตัวเป็น `Node3D` ที่ปรับ **Position / Rotation / Scale** ใน Inspector ได้
4. เลือก Gojo ใต้ `Characters` แล้วแก้ `animation_set` เป็น `Shooter`, `Melee` หรือ `Punch` และ `animation_name` เป็นชื่อท่าที่ต้องการ จากนั้นรันฉากเพื่อดูผล
   หากไม่ต้องการให้ท่าที่เล่นครั้งเดียววนซ้ำ ให้ปิด `repeat_once_clips` ใน Inspector
5. เปิด `GojoCharacter.tscn` ถ้าต้องการแก้โมเดลโดยตรง: ขยาย `GeneralSkeleton` เพื่อดู `BoneAttachment3D` และชิ้นส่วน `MeshInstance3D` หรือเลือก `AnimationPlayer` เพื่อดูและทดลองท่าในแถบ Animation

แขนแต่ละข้างและขาแต่ละข้างเป็น `MeshInstance3D` ชิ้นเดียว รวมชั้นสกินหลักกับชั้นตกแต่งไว้ใน mesh เดียว จึงไม่มีรอยแยกระหว่างท่อนบนกับท่อนล่าง กระดูกส่วนปลายยังคงอยู่เพื่อให้ไฟล์แอนิเมชัน Humanoid โหลดได้ แต่ไม่ได้แยก mesh ที่ข้อศอกหรือหัวเข่า

ตัวอย่างชื่อท่า: `Shooter/idle`, `Shooter/walk`, `Melee/LightRunning`, `Punch/right`, `Punch/left` ชื่อท่าต้องตรงกับรายการใน `AnimationPlayer` ทุกตัวอักษร เปิด `GojoCharacter.tscn` และ `AnimationPlayer` เพื่อปรับคีย์เฟรมของท่าต่อยเองได้

`StudioDemo.tscn` คือฉากสตูดิโอเดิม ใช้ `LegacyGojoCharacter.tscn` เพื่อรักษาตัวอย่างท่าเดิมไว้

## แอนิเมชันจาก GitHub

`GojoCharacter.tscn` มี `Skeleton3D` ชื่อ `GeneralSkeleton` พร้อม `AnimationPlayer` ที่ผูกคลังแอนิเมชันจริงจาก [Godot4-OpenAnimationLibraries ของ catprisbrey](https://github.com/catprisbrey/Godot4-OpenAnimationLibraries):

- `assets/animations/MeleeLib.res` — 121 ท่า
- `assets/animations/ShooterLib.res` — 180 ท่า
- `assets/animations/Mixamo BoneMap.tres` — ไฟล์อ้างอิงสำหรับโมเดลที่ใส่กระดูกด้วย Mixamo ในอนาคต ฉากนี้ใช้โครงกระดูก Humanoid ใน Godot และเล่นสองไลบรารีด้านบนโดยตรง
- `assets/animations/GojoPunch.tres` — ท่าต่อยซ้าย/ขวาที่ปรับให้แขนบล็อกของ Gojo อยู่ติดกับหัวไหล่

บางท่ามี root motion และอาจย้ายตัวละครออกจากจุดตั้งต้น แม้ชื่อไม่ขึ้นต้น `root-` เช่น `Shooter/run_067` ท่าที่ตั้งไว้ในฉากนี้เลือกแบบอยู่กับที่ แขนและขาเป็นชิ้นแข็งจึงไม่พับที่ข้อศอกหรือหัวเข่า ท่าที่หมุนข้อมาก ๆ อาจยังไม่เหมาะกับโมเดลแบบนี้

## ต้นไม้และเครดิต

ไฟล์ `.glb` ทั้งสี่จากชุด [Tree Collection](https://poly.pizza/bundle/Tree-Collection-zdry8l7ugJ) อยู่ใน `assets/trees/` ฉากใช้ **Simple Tree** และ **Birch Tree**

**Attribution:** [Tree Collection](https://poly.pizza/bundle/Tree-Collection-zdry8l7ugJ) by [NicolasBrueckner](https://poly.pizza/u/NicolasBrueckner), [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/), via Poly Pizza.

## ไฟล์ Blender / Mixamo เดิม

`mixamo_upload/gojo.obj`, `gojo.mtl`, `gojo.png` และ `Gojo_Mixamo_Upload.zip` ยังอยู่สำหรับนำเข้า Blender หรืออัปโหลดไป Mixamo หากต้องการทำรุ่นอื่น โมเดล OBJ นี้ยังไม่ได้ใส่กระดูกผ่าน Mixamo ส่วนฉาก Godot ที่ส่งนี้ใช้โครงกระดูกที่สร้างไว้ใน `GojoCharacter.tscn` แล้ว
