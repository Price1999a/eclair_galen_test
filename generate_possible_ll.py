import itertools

# 定义需要替换的行号和对应的取值
replacements = {
    5306: ["  call ccc void @eclair_btree_insert_range_delta_p_p(ptr %2, ptr %stack.ptr_0, ptr %stack.ptr_1)", "  call ccc void @eclair_btree_insert_range_delta_p_p_1(ptr %2, ptr %stack.ptr_0, ptr %stack.ptr_1)"],
    5312: ["  call ccc void @eclair_btree_insert_range_delta_p_p(ptr %5, ptr %stack.ptr_2, ptr %stack.ptr_3)", "  call ccc void @eclair_btree_insert_range_delta_p_p_1(ptr %5, ptr %stack.ptr_2, ptr %stack.ptr_3)"],
    5318: ["  call ccc void @eclair_btree_insert_range_delta_q_q(ptr %8, ptr %stack.ptr_4, ptr %stack.ptr_5)", "  call ccc void @eclair_btree_insert_range_delta_q_q_1(ptr %8, ptr %stack.ptr_4, ptr %stack.ptr_5)"],
    5324: ["  call ccc void @eclair_btree_insert_range_delta_q_q(ptr %11, ptr %stack.ptr_6, ptr %stack.ptr_7)", "  call ccc void @eclair_btree_insert_range_delta_q_q_1(ptr %11, ptr %stack.ptr_6, ptr %stack.ptr_7)"],
    6572: ["  call ccc void @eclair_btree_insert_range_p_new_p(ptr %661, ptr %stack.ptr_147, ptr %stack.ptr_148)", "  call ccc void @eclair_btree_insert_range_p_new_p_1(ptr %661, ptr %stack.ptr_147, ptr %stack.ptr_148)"],
    6578: ["  call ccc void @eclair_btree_insert_range_p_new_p(ptr %664, ptr %stack.ptr_149, ptr %stack.ptr_150)", "  call ccc void @eclair_btree_insert_range_p_new_p_1(ptr %664, ptr %stack.ptr_149, ptr %stack.ptr_150)"],
    6590: ["  call ccc void @eclair_btree_insert_range_q_new_q(ptr %671, ptr %stack.ptr_151, ptr %stack.ptr_152)", "  call ccc void @eclair_btree_insert_range_q_new_q_1(ptr %671, ptr %stack.ptr_151, ptr %stack.ptr_152)"],
    6596: ["  call ccc void @eclair_btree_insert_range_q_new_q(ptr %674, ptr %stack.ptr_153, ptr %stack.ptr_154)", "  call ccc void @eclair_btree_insert_range_q_new_q_1(ptr %674, ptr %stack.ptr_153, ptr %stack.ptr_154)"]
}

# 读取原始文件内容
with open("query-eclair.ll", "r") as file:
    lines = file.readlines()

# 生成所有可能的组合
combinations = list(itertools.product(*replacements.values()))

# 遍历每个组合，生成对应的版本文件
for i, combination in enumerate(combinations, start=1):
    # 创建新的版本文件
    with open(f"./possible_ll/query-eclair_{i}.ll", "w") as file:
        for line_num, line in enumerate(lines, start=1):
            if line_num in replacements:
                index = list(replacements.keys()).index(line_num)
                file.write(combination[index] + "\n")
            else:
                file.write(line)