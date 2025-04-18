def look_for_key(box):
    for item in box:
        if item.is_a_box():
            look_for_key(item)
        elif item.is_a_key():
            print('Found the key!')


def countdown(i):
    print(i)
    if i <= 0:
        return
    else:
        countdown(i-1)

