declare external ccc ptr @malloc(i32)

declare external ccc void @free(ptr)

declare external ccc void @llvm.memset.p0i8.i64(ptr, i8, i64, i1)

declare external ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr, ptr, i64, i1)

declare external ccc i32 @memcmp(ptr, ptr, i64)

declare external ccc ptr @mmap(ptr, i64, i32, i32, i32, i32)

declare external ccc i32 @munmap(ptr, i64)

%node_data_t_0 = type {ptr, i16, i16, i1}

%node_t_0 = type {%node_data_t_0, [20 x [3 x i32]]}

%inner_node_t_0 = type {%node_t_0, [21 x ptr]}

%btree_iterator_t_0 = type {ptr, i16}

%btree_t_0 = type {ptr, ptr}

define external ccc i8 @eclair_btree_value_compare_0(i32 %lhs_0, i32 %rhs_0) {
start:
  %0 = icmp ult i32 %lhs_0, %rhs_0
  br i1 %0, label %if_0, label %end_if_0
if_0:
  ret i8 -1
end_if_0:
  %1 = icmp ugt i32 %lhs_0, %rhs_0
  %2 = select i1 %1, i8 1, i8 0
  ret i8 %2
}

define external ccc i8 @eclair_btree_value_compare_values_0(ptr %lhs_0, ptr %rhs_0) {
start:
  br label %comparison_0
comparison_0:
  %0 = getelementptr [3 x i32], ptr %lhs_0, i32 0, i32 0
  %1 = getelementptr [3 x i32], ptr %rhs_0, i32 0, i32 0
  %2 = load i32, ptr %0
  %3 = load i32, ptr %1
  %4 = call ccc i8 @eclair_btree_value_compare_0(i32 %2, i32 %3)
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %comparison_2, label %end_0
comparison_1:
  %6 = getelementptr [3 x i32], ptr %lhs_0, i32 0, i32 1
  %7 = getelementptr [3 x i32], ptr %rhs_0, i32 0, i32 1
  %8 = load i32, ptr %6
  %9 = load i32, ptr %7
  %10 = call ccc i8 @eclair_btree_value_compare_0(i32 %8, i32 %9)
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %comparison_2, label %end_0
comparison_2:
  %12 = getelementptr [3 x i32], ptr %lhs_0, i32 0, i32 2
  %13 = getelementptr [3 x i32], ptr %rhs_0, i32 0, i32 2
  %14 = load i32, ptr %12
  %15 = load i32, ptr %13
  %16 = call ccc i8 @eclair_btree_value_compare_0(i32 %14, i32 %15)
  br label %end_0
end_0:
  %17 = phi i8 [%4, %comparison_0], [%10, %comparison_1], [%16, %comparison_2]
  ret i8 %17
}

define external ccc ptr @eclair_btree_node_new_0(i1 %type_0) {
start:
  %0 = select i1 %type_0, i32 424, i32 256
  %1 = call ccc ptr @malloc(i32 %0)
  %2 = getelementptr %node_t_0, ptr %1, i32 0, i32 0, i32 0
  store ptr zeroinitializer, ptr %2
  %3 = getelementptr %node_t_0, ptr %1, i32 0, i32 0, i32 1
  store i16 0, ptr %3
  %4 = getelementptr %node_t_0, ptr %1, i32 0, i32 0, i32 2
  store i16 0, ptr %4
  %5 = getelementptr %node_t_0, ptr %1, i32 0, i32 0, i32 3
  store i1 %type_0, ptr %5
  %6 = getelementptr %node_t_0, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %6, i8 0, i64 240, i1 0)
  %7 = icmp eq i1 %type_0, 1
  br i1 %7, label %if_0, label %end_if_0
if_0:
  %8 = getelementptr %inner_node_t_0, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %8, i8 0, i64 168, i1 0)
  br label %end_if_0
end_if_0:
  ret ptr %1
}

define external ccc i64 @eclair_btree_node_count_entries_0(ptr %node_0) {
start:
  %stack.ptr_0 = alloca i64
  %0 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 0
  %5 = zext i16 %1 to i64
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i64 %5
end_if_0:
  store i64 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  br label %for_begin_0
for_begin_0:
  %8 = phi i16 [0, %end_if_0], [%15, %for_body_0]
  %9 = icmp ule i16 %8, %7
  br i1 %9, label %for_body_0, label %for_end_0
for_body_0:
  %10 = load i64, ptr %stack.ptr_0
  %11 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %8
  %12 = load ptr, ptr %11
  %13 = call ccc i64 @eclair_btree_node_count_entries_0(ptr %12)
  %14 = add i64 %10, %13
  store i64 %14, ptr %stack.ptr_0
  %15 = add i16 1, %8
  br label %for_begin_0
for_end_0:
  %16 = load i64, ptr %stack.ptr_0
  ret i64 %16
}

define external ccc void @eclair_btree_iterator_init_0(ptr %iter_0, ptr %cur_0, i16 %pos_0) {
start:
  %0 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  store ptr %cur_0, ptr %0
  %1 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  store i16 %pos_0, ptr %1
  ret void
}

define external ccc void @eclair_btree_iterator_end_init_0(ptr %iter_0) {
start:
  call ccc void @eclair_btree_iterator_init_0(ptr %iter_0, ptr zeroinitializer, i16 0)
  ret void
}

define external ccc i1 @eclair_btree_iterator_is_equal_0(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_iterator_t_0, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_0, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = icmp ne ptr %1, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i1 0
end_if_0:
  %5 = getelementptr %btree_iterator_t_0, ptr %lhs_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = getelementptr %btree_iterator_t_0, ptr %rhs_0, i32 0, i32 1
  %8 = load i16, ptr %7
  %9 = icmp eq i16 %6, %8
  ret i1 %9
}

define external ccc ptr @eclair_btree_iterator_current_0(ptr %iter_0) {
start:
  %0 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  %1 = load i16, ptr %0
  %2 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %node_t_0, ptr %3, i32 0, i32 1, i16 %1
  ret ptr %4
}

define external ccc void @eclair_btree_iterator_next_0(ptr %iter_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_0, ptr %1, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 1
  br i1 %4, label %if_0, label %end_if_1
if_0:
  %5 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = add i16 1, %6
  %8 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  %9 = load ptr, ptr %8
  %10 = getelementptr %inner_node_t_0, ptr %9, i32 0, i32 1, i16 %7
  %11 = load ptr, ptr %10
  store ptr %11, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %12 = load ptr, ptr %stack.ptr_0
  %13 = getelementptr %node_t_0, ptr %12, i32 0, i32 0, i32 3
  %14 = load i1, ptr %13
  %15 = icmp eq i1 %14, 1
  br i1 %15, label %while_body_0, label %while_end_0
while_body_0:
  %16 = load ptr, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_0, ptr %16, i32 0, i32 1, i16 0
  %18 = load ptr, ptr %17
  store ptr %18, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  %19 = load ptr, ptr %stack.ptr_0
  %20 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  store i16 0, ptr %21
  %22 = getelementptr %node_t_0, ptr %19, i32 0, i32 0, i32 2
  %23 = load i16, ptr %22
  %24 = icmp ne i16 %23, 0
  br i1 %24, label %if_1, label %end_if_0
if_1:
  ret void
end_if_0:
  br label %leaf.next_0
end_if_1:
  br label %leaf.next_0
leaf.next_0:
  %25 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  %26 = load i16, ptr %25
  %27 = add i16 1, %26
  store i16 %27, ptr %25
  %28 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  %29 = load i16, ptr %28
  %30 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  %31 = load ptr, ptr %30
  %32 = getelementptr %node_t_0, ptr %31, i32 0, i32 0, i32 2
  %33 = load i16, ptr %32
  %34 = icmp ult i16 %29, %33
  br i1 %34, label %if_2, label %end_if_2
if_2:
  ret void
end_if_2:
  br label %while_begin_1
while_begin_1:
  %35 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  %36 = load ptr, ptr %35
  %37 = icmp eq ptr %36, zeroinitializer
  br i1 %37, label %leaf.no_parent_0, label %leaf.has_parent_0
leaf.no_parent_0:
  br label %loop.condition.end_0
leaf.has_parent_0:
  %38 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  %39 = load i16, ptr %38
  %40 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  %41 = load ptr, ptr %40
  %42 = getelementptr %node_t_0, ptr %41, i32 0, i32 0, i32 2
  %43 = load i16, ptr %42
  %44 = icmp eq i16 %39, %43
  br label %loop.condition.end_0
loop.condition.end_0:
  %45 = phi i1 [0, %leaf.no_parent_0], [%44, %leaf.has_parent_0]
  br i1 %45, label %while_body_1, label %while_end_1
while_body_1:
  %46 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  %47 = load ptr, ptr %46
  %48 = getelementptr %node_t_0, ptr %47, i32 0, i32 0, i32 1
  %49 = load i16, ptr %48
  %50 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 1
  store i16 %49, ptr %50
  %51 = getelementptr %node_t_0, ptr %47, i32 0, i32 0, i32 0
  %52 = load ptr, ptr %51
  %53 = getelementptr %btree_iterator_t_0, ptr %iter_0, i32 0, i32 0
  store ptr %52, ptr %53
  br label %while_begin_1
while_end_1:
  ret void
}

define external ccc ptr @eclair_btree_linear_search_lower_bound_0(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_0(ptr %2, ptr %val_0)
  %4 = icmp ne i8 %3, -1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [3 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc ptr @eclair_btree_linear_search_upper_bound_0(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_0(ptr %2, ptr %val_0)
  %4 = icmp eq i8 %3, 1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [3 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc void @eclair_btree_init_empty_0(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %0
  %1 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %1
  ret void
}

define external ccc void @eclair_btree_init_0(ptr %tree_0, ptr %start_0, ptr %end_0) {
start:
  call ccc void @eclair_btree_insert_range__0(ptr %tree_0, ptr %start_0, ptr %end_0)
  ret void
}

define external ccc void @eclair_btree_destroy_0(ptr %tree_0) {
start:
  call ccc void @eclair_btree_clear_0(ptr %tree_0)
  ret void
}

define external ccc i1 @eclair_btree_is_empty_0(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  ret i1 %2
}

define external ccc i64 @eclair_btree_size_0(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  br i1 %2, label %null_0, label %not_null_0
null_0:
  ret i64 0
not_null_0:
  %3 = call ccc i64 @eclair_btree_node_count_entries_0(ptr %1)
  ret i64 %3
}

define external ccc i16 @eclair_btree_node_split_point_0() {
start:
  %0 = mul i16 3, 20
  %1 = udiv i16 %0, 4
  %2 = sub i16 20, 2
  %3 = icmp ult i16 %1, %2
  %4 = select i1 %3, i16 %1, i16 %2
  ret i16 %4
}

define external ccc void @eclair_btree_node_split_0(ptr %node_0, ptr %root_0) {
start:
  %stack.ptr_0 = alloca i16
  %0 = call ccc i16 @eclair_btree_node_split_point_0()
  %1 = add i16 1, %0
  %2 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = call ccc ptr @eclair_btree_node_new_0(i1 %3)
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [%1, %start], [%12, %for_body_0]
  %6 = icmp ult i16 %5, 20
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = load i16, ptr %stack.ptr_0
  %8 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %5
  %9 = load [3 x i32], ptr %8
  %10 = getelementptr %node_t_0, ptr %4, i32 0, i32 1, i16 %7
  store [3 x i32] %9, ptr %10
  %11 = add i16 1, %7
  store i16 %11, ptr %stack.ptr_0
  %12 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  %13 = icmp eq i1 %3, 1
  br i1 %13, label %if_0, label %end_if_0
if_0:
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_1
for_begin_1:
  %14 = phi i16 [%1, %if_0], [%23, %for_body_1]
  %15 = icmp ule i16 %14, 20
  br i1 %15, label %for_body_1, label %for_end_1
for_body_1:
  %16 = load i16, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %14
  %18 = load ptr, ptr %17
  %19 = getelementptr %node_t_0, ptr %18, i32 0, i32 0, i32 0
  store ptr %4, ptr %19
  %20 = getelementptr %node_t_0, ptr %18, i32 0, i32 0, i32 1
  store i16 %16, ptr %20
  %21 = getelementptr %inner_node_t_0, ptr %4, i32 0, i32 1, i16 %16
  store ptr %18, ptr %21
  %22 = add i16 1, %16
  store i16 %22, ptr %stack.ptr_0
  %23 = add i16 1, %14
  br label %for_begin_1
for_end_1:
  br label %end_if_0
end_if_0:
  %24 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  store i16 %0, ptr %24
  %25 = sub i16 20, %0
  %26 = sub i16 %25, 1
  %27 = getelementptr %node_t_0, ptr %4, i32 0, i32 0, i32 2
  store i16 %26, ptr %27
  call ccc void @eclair_btree_node_grow_parent_0(ptr %node_0, ptr %root_0, ptr %4)
  ret void
}

define external ccc void @eclair_btree_node_grow_parent_0(ptr %node_0, ptr %root_0, ptr %sibling_0) {
start:
  %0 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  %3 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br i1 %2, label %create_new_root_0, label %insert_new_node_in_parent_0
create_new_root_0:
  %5 = call ccc ptr @eclair_btree_node_new_0(i1 1)
  %6 = getelementptr %node_t_0, ptr %5, i32 0, i32 0, i32 2
  store i16 1, ptr %6
  %7 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %4
  %8 = load [3 x i32], ptr %7
  %9 = getelementptr %node_t_0, ptr %5, i32 0, i32 1, i16 0
  store [3 x i32] %8, ptr %9
  %10 = getelementptr %inner_node_t_0, ptr %5, i32 0, i32 1, i16 0
  store ptr %node_0, ptr %10
  %11 = getelementptr %inner_node_t_0, ptr %5, i32 0, i32 1, i16 1
  store ptr %sibling_0, ptr %11
  %12 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %12
  %13 = getelementptr %node_t_0, ptr %sibling_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %13
  %14 = getelementptr %node_t_0, ptr %sibling_0, i32 0, i32 0, i32 1
  store i16 1, ptr %14
  store ptr %5, ptr %root_0
  ret void
insert_new_node_in_parent_0:
  %15 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 1
  %16 = load i16, ptr %15
  %17 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %4
  call ccc void @eclair_btree_node_insert_inner_0(ptr %1, ptr %root_0, i16 %16, ptr %node_0, ptr %17, ptr %sibling_0)
  ret void
}

define external ccc void @eclair_btree_node_insert_inner_0(ptr %node_0, ptr %root_0, i16 %pos_0, ptr %predecessor_0, ptr %key_0, ptr %new_node_0) {
start:
  %stack.ptr_0 = alloca i16
  store i16 %pos_0, ptr %stack.ptr_0
  %0 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = icmp uge i16 %1, 20
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = load i16, ptr %stack.ptr_0
  %4 = call ccc i16 @eclair_btree_node_rebalance_or_split_0(ptr %node_0, ptr %root_0, i16 %pos_0)
  %5 = sub i16 %3, %4
  store i16 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  %8 = icmp ugt i16 %5, %7
  br i1 %8, label %if_1, label %end_if_0
if_1:
  %9 = sub i16 %5, %7
  %10 = sub i16 %9, 1
  store i16 %10, ptr %stack.ptr_0
  %11 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 0
  %12 = load ptr, ptr %11
  %13 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 1
  %14 = load i16, ptr %13
  %15 = add i16 1, %14
  %16 = getelementptr %inner_node_t_0, ptr %12, i32 0, i32 1, i16 %15
  %17 = load ptr, ptr %16
  call ccc void @eclair_btree_node_insert_inner_0(ptr %17, ptr %root_0, i16 %10, ptr %predecessor_0, ptr %key_0, ptr %new_node_0)
  ret void
end_if_0:
  br label %end_if_1
end_if_1:
  %18 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %19 = load i16, ptr %18
  %20 = sub i16 %19, 1
  %21 = load i16, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %22 = phi i16 [%20, %end_if_1], [%37, %for_body_0]
  %23 = icmp sge i16 %22, %21
  br i1 %23, label %for_body_0, label %for_end_0
for_body_0:
  %24 = add i16 %22, 1
  %25 = add i16 %22, 2
  %26 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %22
  %27 = load [3 x i32], ptr %26
  %28 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %24
  store [3 x i32] %27, ptr %28
  %29 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %24
  %30 = load ptr, ptr %29
  %31 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %25
  store ptr %30, ptr %31
  %32 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %25
  %33 = load ptr, ptr %32
  %34 = getelementptr %node_t_0, ptr %33, i32 0, i32 0, i32 1
  %35 = load i16, ptr %34
  %36 = add i16 1, %35
  store i16 %36, ptr %34
  %37 = sub i16 %22, 1
  br label %for_begin_0
for_end_0:
  %38 = load [3 x i32], ptr %key_0
  %39 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %21
  store [3 x i32] %38, ptr %39
  %40 = add i16 %21, 1
  %41 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %40
  store ptr %new_node_0, ptr %41
  %42 = getelementptr %node_t_0, ptr %new_node_0, i32 0, i32 0, i32 0
  store ptr %node_0, ptr %42
  %43 = getelementptr %node_t_0, ptr %new_node_0, i32 0, i32 0, i32 1
  store i16 %40, ptr %43
  %44 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %45 = load i16, ptr %44
  %46 = add i16 1, %45
  store i16 %46, ptr %44
  ret void
}

define external ccc i16 @eclair_btree_node_rebalance_or_split_0(ptr %node_0, ptr %root_0, i16 %idx_0) {
start:
  %0 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 1
  %3 = load i16, ptr %2
  %4 = icmp ne ptr %1, zeroinitializer
  %5 = icmp ugt i16 %3, 0
  %6 = and i1 %4, %5
  br i1 %6, label %rebalance_0, label %split_0
rebalance_0:
  %7 = sub i16 %3, 1
  %8 = getelementptr %inner_node_t_0, ptr %1, i32 0, i32 1, i16 %7
  %9 = load ptr, ptr %8
  %10 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %11 = load i16, ptr %10
  %12 = sub i16 20, %11
  %13 = icmp slt i16 %12, %idx_0
  %14 = select i1 %13, i16 %12, i16 %idx_0
  %15 = icmp ugt i16 %14, 0
  br i1 %15, label %if_0, label %end_if_1
if_0:
  %16 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 1
  %17 = load i16, ptr %16
  %18 = sub i16 %17, 1
  %19 = getelementptr %inner_node_t_0, ptr %1, i32 0, i32 0, i32 1, i16 %18
  %20 = load [3 x i32], ptr %19
  %21 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %22 = load i16, ptr %21
  %23 = getelementptr %node_t_0, ptr %9, i32 0, i32 1, i16 %22
  store [3 x i32] %20, ptr %23
  %24 = sub i16 %14, 1
  br label %for_begin_0
for_begin_0:
  %25 = phi i16 [0, %if_0], [%32, %for_body_0]
  %26 = icmp ult i16 %25, %24
  br i1 %26, label %for_body_0, label %for_end_0
for_body_0:
  %27 = add i16 %22, 1
  %28 = add i16 %25, %27
  %29 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %25
  %30 = load [3 x i32], ptr %29
  %31 = getelementptr %node_t_0, ptr %9, i32 0, i32 1, i16 %28
  store [3 x i32] %30, ptr %31
  %32 = add i16 1, %25
  br label %for_begin_0
for_end_0:
  %33 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %24
  %34 = load [3 x i32], ptr %33
  store [3 x i32] %34, ptr %19
  %35 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %36 = load i16, ptr %35
  %37 = sub i16 %36, %14
  br label %for_begin_1
for_begin_1:
  %38 = phi i16 [0, %for_end_0], [%44, %for_body_1]
  %39 = icmp ult i16 %38, %37
  br i1 %39, label %for_body_1, label %for_end_1
for_body_1:
  %40 = add i16 %38, %14
  %41 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %40
  %42 = load [3 x i32], ptr %41
  %43 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 1, i16 %38
  store [3 x i32] %42, ptr %43
  %44 = add i16 1, %38
  br label %for_begin_1
for_end_1:
  %45 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 3
  %46 = load i1, ptr %45
  %47 = icmp eq i1 %46, 1
  br i1 %47, label %if_1, label %end_if_0
if_1:
  br label %for_begin_2
for_begin_2:
  %48 = phi i16 [0, %if_1], [%57, %for_body_2]
  %49 = icmp ult i16 %48, %14
  br i1 %49, label %for_body_2, label %for_end_2
for_body_2:
  %50 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %51 = load i16, ptr %50
  %52 = add i16 %51, 1
  %53 = add i16 %48, %52
  %54 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %48
  %55 = load ptr, ptr %54
  %56 = getelementptr %inner_node_t_0, ptr %9, i32 0, i32 1, i16 %53
  store ptr %55, ptr %56
  %57 = add i16 1, %48
  br label %for_begin_2
for_end_2:
  br label %for_begin_3
for_begin_3:
  %58 = phi i16 [0, %for_end_2], [%68, %for_body_3]
  %59 = icmp ult i16 %58, %14
  br i1 %59, label %for_body_3, label %for_end_3
for_body_3:
  %60 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %61 = load i16, ptr %60
  %62 = add i16 %61, 1
  %63 = add i16 %58, %62
  %64 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %58
  %65 = load ptr, ptr %64
  %66 = getelementptr %node_t_0, ptr %65, i32 0, i32 0, i32 0
  store ptr %9, ptr %66
  %67 = getelementptr %node_t_0, ptr %65, i32 0, i32 0, i32 1
  store i16 %63, ptr %67
  %68 = add i16 1, %58
  br label %for_begin_3
for_end_3:
  %69 = sub i16 %36, %14
  %70 = add i16 1, %69
  br label %for_begin_4
for_begin_4:
  %71 = phi i16 [0, %for_end_3], [%80, %for_body_4]
  %72 = icmp ult i16 %71, %70
  br i1 %72, label %for_body_4, label %for_end_4
for_body_4:
  %73 = add i16 %71, %14
  %74 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %73
  %75 = load ptr, ptr %74
  %76 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %71
  store ptr %75, ptr %76
  %77 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %71
  %78 = load ptr, ptr %77
  %79 = getelementptr %node_t_0, ptr %78, i32 0, i32 0, i32 1
  store i16 %71, ptr %79
  %80 = add i16 1, %71
  br label %for_begin_4
for_end_4:
  br label %end_if_0
end_if_0:
  %81 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %82 = load i16, ptr %81
  %83 = add i16 %82, %14
  store i16 %83, ptr %81
  %84 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %85 = load i16, ptr %84
  %86 = sub i16 %85, %14
  store i16 %86, ptr %84
  ret i16 %14
end_if_1:
  br label %split_0
split_0:
  call ccc void @eclair_btree_node_split_0(ptr %node_0, ptr %root_0)
  ret i16 0
}

define external ccc i1 @eclair_btree_insert_value_0(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca ptr
  %stack.ptr_1 = alloca i16
  %0 = call ccc i1 @eclair_btree_is_empty_0(ptr %tree_0)
  br i1 %0, label %empty_0, label %non_empty_0
empty_0:
  %1 = call ccc ptr @eclair_btree_node_new_0(i1 0)
  %2 = getelementptr %node_t_0, ptr %1, i32 0, i32 0, i32 2
  store i16 1, ptr %2
  %3 = load [3 x i32], ptr %val_0
  %4 = getelementptr %node_t_0, ptr %1, i32 0, i32 1, i16 0
  store [3 x i32] %3, ptr %4
  %5 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 1
  store ptr %1, ptr %6
  br label %inserted_new_value_0
non_empty_0:
  %7 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %8 = load ptr, ptr %7
  store ptr %8, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %9 = load ptr, ptr %stack.ptr_0
  %10 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 3
  %11 = load i1, ptr %10
  %12 = icmp eq i1 %11, 1
  br i1 %12, label %inner_0, label %leaf_0
inner_0:
  %13 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %14 = load i16, ptr %13
  %15 = getelementptr %node_t_0, ptr %9, i32 0, i32 1, i16 0
  %16 = getelementptr %node_t_0, ptr %9, i32 0, i32 1, i16 %14
  %17 = call ccc ptr @eclair_btree_linear_search_lower_bound_0(ptr %val_0, ptr %15, ptr %16)
  %18 = ptrtoint ptr %17 to i64
  %19 = ptrtoint ptr %15 to i64
  %20 = sub i64 %18, %19
  %21 = trunc i64 %20 to i16
  %22 = udiv i16 %21, 12
  %23 = icmp ne ptr %17, %16
  br i1 %23, label %if_0, label %end_if_0
if_0:
  %24 = call ccc i8 @eclair_btree_value_compare_values_0(ptr %17, ptr %val_0)
  %25 = icmp eq i8 0, %24
  br i1 %25, label %no_insert_0, label %inner_continue_insert_0
end_if_0:
  br label %inner_continue_insert_0
inner_continue_insert_0:
  %26 = getelementptr %inner_node_t_0, ptr %9, i32 0, i32 1, i16 %22
  %27 = load ptr, ptr %26
  store ptr %27, ptr %stack.ptr_0
  br label %loop_0
leaf_0:
  %28 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %29 = load i16, ptr %28
  %30 = getelementptr %node_t_0, ptr %9, i32 0, i32 1, i16 0
  %31 = getelementptr %node_t_0, ptr %9, i32 0, i32 1, i16 %29
  %32 = call ccc ptr @eclair_btree_linear_search_upper_bound_0(ptr %val_0, ptr %30, ptr %31)
  %33 = ptrtoint ptr %32 to i64
  %34 = ptrtoint ptr %30 to i64
  %35 = sub i64 %33, %34
  %36 = trunc i64 %35 to i16
  %37 = udiv i16 %36, 12
  store i16 %37, ptr %stack.ptr_1
  %38 = icmp ne ptr %32, %30
  br i1 %38, label %if_1, label %end_if_1
if_1:
  %39 = getelementptr [3 x i32], ptr %32, i32 -1
  %40 = call ccc i8 @eclair_btree_value_compare_values_0(ptr %39, ptr %val_0)
  %41 = icmp eq i8 0, %40
  br i1 %41, label %no_insert_0, label %leaf_continue_insert_0
end_if_1:
  br label %leaf_continue_insert_0
leaf_continue_insert_0:
  %42 = icmp uge i16 %29, 20
  br i1 %42, label %split_0, label %no_split_0
split_0:
  %43 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %44 = load i16, ptr %stack.ptr_1
  %45 = call ccc i16 @eclair_btree_node_rebalance_or_split_0(ptr %9, ptr %43, i16 %44)
  %46 = sub i16 %44, %45
  store i16 %46, ptr %stack.ptr_1
  %47 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 2
  %48 = load i16, ptr %47
  %49 = icmp ugt i16 %46, %48
  br i1 %49, label %if_2, label %end_if_2
if_2:
  %50 = add i16 %48, 1
  %51 = sub i16 %46, %50
  store i16 %51, ptr %stack.ptr_1
  %52 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 0
  %53 = load ptr, ptr %52
  %54 = getelementptr %node_t_0, ptr %9, i32 0, i32 0, i32 1
  %55 = load i16, ptr %54
  %56 = add i16 1, %55
  %57 = getelementptr %inner_node_t_0, ptr %53, i32 0, i32 1, i16 %56
  %58 = load ptr, ptr %57
  store ptr %58, ptr %stack.ptr_0
  br label %end_if_2
end_if_2:
  br label %no_split_0
no_split_0:
  %59 = load ptr, ptr %stack.ptr_0
  %60 = load i16, ptr %stack.ptr_1
  %61 = getelementptr %node_t_0, ptr %59, i32 0, i32 0, i32 2
  %62 = load i16, ptr %61
  br label %for_begin_0
for_begin_0:
  %63 = phi i16 [%62, %no_split_0], [%69, %for_body_0]
  %64 = icmp ugt i16 %63, %60
  br i1 %64, label %for_body_0, label %for_end_0
for_body_0:
  %65 = sub i16 %63, 1
  %66 = getelementptr %node_t_0, ptr %59, i32 0, i32 1, i16 %65
  %67 = load [3 x i32], ptr %66
  %68 = getelementptr %node_t_0, ptr %59, i32 0, i32 1, i16 %63
  store [3 x i32] %67, ptr %68
  %69 = sub i16 %63, 1
  br label %for_begin_0
for_end_0:
  %70 = load [3 x i32], ptr %val_0
  %71 = getelementptr %node_t_0, ptr %59, i32 0, i32 1, i16 %60
  store [3 x i32] %70, ptr %71
  %72 = getelementptr %node_t_0, ptr %59, i32 0, i32 0, i32 2
  %73 = load i16, ptr %72
  %74 = add i16 1, %73
  store i16 %74, ptr %72
  br label %inserted_new_value_0
no_insert_0:
  ret i1 0
inserted_new_value_0:
  ret i1 1
}

define external ccc void @eclair_btree_insert_range__0(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_0(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_0(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_0(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_begin_0(ptr %tree_0, ptr %result_0) {
start:
  %0 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 1
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_0, ptr %result_0, i32 0, i32 0
  store ptr %1, ptr %2
  %3 = getelementptr %btree_iterator_t_0, ptr %result_0, i32 0, i32 1
  store i16 0, ptr %3
  ret void
}

define external ccc void @eclair_btree_end_0(ptr %tree_0, ptr %result_0) {
start:
  call ccc void @eclair_btree_iterator_end_init_0(ptr %result_0)
  ret void
}

define external ccc i1 @eclair_btree_contains_0(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_1 = alloca %btree_iterator_t_0, i32 1
  call ccc void @eclair_btree_find_0(ptr %tree_0, ptr %val_0, ptr %stack.ptr_0)
  call ccc void @eclair_btree_end_0(ptr %tree_0, ptr %stack.ptr_1)
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_0, ptr %stack.ptr_1)
  %1 = select i1 %0, i1 0, i1 1
  ret i1 %1
}

define external ccc void @eclair_btree_find_0(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_0(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_0(ptr %result_0)
  ret void
end_if_0:
  %1 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_0
  %4 = getelementptr %node_t_0, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_0, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_0, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_0(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 12
  %14 = icmp ult ptr %8, %7
  br i1 %14, label %if_1, label %end_if_2
if_1:
  %15 = call ccc i8 @eclair_btree_value_compare_values_0(ptr %8, ptr %val_0)
  %16 = icmp eq i8 0, %15
  br i1 %16, label %if_2, label %end_if_1
if_2:
  call ccc void @eclair_btree_iterator_init_0(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  br label %end_if_2
end_if_2:
  %17 = getelementptr %node_t_0, ptr %3, i32 0, i32 0, i32 3
  %18 = load i1, ptr %17
  %19 = icmp eq i1 %18, 0
  br i1 %19, label %if_3, label %end_if_3
if_3:
  call ccc void @eclair_btree_iterator_end_init_0(ptr %result_0)
  ret void
end_if_3:
  %20 = getelementptr %inner_node_t_0, ptr %3, i32 0, i32 1, i16 %13
  %21 = load ptr, ptr %20
  store ptr %21, ptr %stack.ptr_0
  br label %loop_0
}

define external ccc void @eclair_btree_lower_bound_0(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_0(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_0(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_0(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_0, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_0, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_0, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_0(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 12
  %14 = getelementptr %node_t_0, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_0, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_0, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_0, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_0, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_0(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_3
if_2:
  %25 = call ccc i8 @eclair_btree_value_compare_values_0(ptr %8, ptr %val_0)
  %26 = icmp eq i8 0, %25
  br i1 %26, label %if_3, label %end_if_2
if_3:
  call ccc void @eclair_btree_iterator_init_0(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_2:
  br label %end_if_3
end_if_3:
  br i1 %24, label %if_4, label %end_if_4
if_4:
  call ccc void @eclair_btree_iterator_init_0(ptr %stack.ptr_0, ptr %3, i16 %13)
  br label %end_if_4
end_if_4:
  %27 = getelementptr %inner_node_t_0, ptr %3, i32 0, i32 1, i16 %13
  %28 = load ptr, ptr %27
  store ptr %28, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_upper_bound_0(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_0(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_0(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_0(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_0, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_0, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_0, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_upper_bound_0(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 12
  %14 = getelementptr %node_t_0, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_0, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_0, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_0, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_0, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_0(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_2
if_2:
  call ccc void @eclair_btree_iterator_init_0(ptr %result_0, ptr %3, i16 %13)
  br label %end_if_2
end_if_2:
  %25 = getelementptr %inner_node_t_0, ptr %3, i32 0, i32 1, i16 %13
  %26 = load ptr, ptr %25
  store ptr %26, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_node_delete_0(ptr %node_0) {
start:
  %0 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 3
  %1 = load i1, ptr %0
  %2 = icmp eq i1 %1, 1
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = getelementptr %node_t_0, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [0, %if_0], [%10, %end_if_0]
  %6 = icmp ule i16 %5, %4
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = getelementptr %inner_node_t_0, ptr %node_0, i32 0, i32 1, i16 %5
  %8 = load ptr, ptr %7
  %9 = icmp ne ptr %8, zeroinitializer
  br i1 %9, label %if_1, label %end_if_0
if_1:
  call ccc void @eclair_btree_node_delete_0(ptr %8)
  br label %end_if_0
end_if_0:
  %10 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  br label %end_if_1
end_if_1:
  call ccc void @free(ptr %node_0)
  ret void
}

define external ccc void @eclair_btree_clear_0(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp ne ptr %1, zeroinitializer
  br i1 %2, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_node_delete_0(ptr %1)
  %3 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %3
  %4 = getelementptr %btree_t_0, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %4
  br label %end_if_0
end_if_0:
  ret void
}

define external ccc void @eclair_btree_swap_0(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_t_0, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_t_0, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %btree_t_0, ptr %lhs_0, i32 0, i32 0
  store ptr %3, ptr %4
  %5 = getelementptr %btree_t_0, ptr %rhs_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_0, ptr %lhs_0, i32 0, i32 1
  %7 = load ptr, ptr %6
  %8 = getelementptr %btree_t_0, ptr %rhs_0, i32 0, i32 1
  %9 = load ptr, ptr %8
  %10 = getelementptr %btree_t_0, ptr %lhs_0, i32 0, i32 1
  store ptr %9, ptr %10
  %11 = getelementptr %btree_t_0, ptr %rhs_0, i32 0, i32 1
  store ptr %7, ptr %11
  ret void
}

%node_data_t_1 = type {ptr, i16, i16, i1}

%node_t_1 = type {%node_data_t_1, [30 x [2 x i32]]}

%inner_node_t_1 = type {%node_t_1, [31 x ptr]}

%btree_iterator_t_1 = type {ptr, i16}

%btree_t_1 = type {ptr, ptr}

define external ccc i8 @eclair_btree_value_compare_1(i32 %lhs_0, i32 %rhs_0) {
start:
  %0 = icmp ult i32 %lhs_0, %rhs_0
  br i1 %0, label %if_0, label %end_if_0
if_0:
  ret i8 -1
end_if_0:
  %1 = icmp ugt i32 %lhs_0, %rhs_0
  %2 = select i1 %1, i8 1, i8 0
  ret i8 %2
}

define external ccc i8 @eclair_btree_value_compare_values_1(ptr %lhs_0, ptr %rhs_0) {
start:
  br label %comparison_0
comparison_0:
  %0 = getelementptr [2 x i32], ptr %lhs_0, i32 0, i32 0
  %1 = getelementptr [2 x i32], ptr %rhs_0, i32 0, i32 0
  %2 = load i32, ptr %0
  %3 = load i32, ptr %1
  %4 = call ccc i8 @eclair_btree_value_compare_1(i32 %2, i32 %3)
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %comparison_1, label %end_0
comparison_1:
  %6 = getelementptr [2 x i32], ptr %lhs_0, i32 0, i32 1
  %7 = getelementptr [2 x i32], ptr %rhs_0, i32 0, i32 1
  %8 = load i32, ptr %6
  %9 = load i32, ptr %7
  %10 = call ccc i8 @eclair_btree_value_compare_1(i32 %8, i32 %9)
  br label %end_0
end_0:
  %11 = phi i8 [%4, %comparison_0], [%10, %comparison_1]
  ret i8 %11
}

define external ccc ptr @eclair_btree_node_new_1(i1 %type_0) {
start:
  %0 = select i1 %type_0, i32 504, i32 256
  %1 = call ccc ptr @malloc(i32 %0)
  %2 = getelementptr %node_t_1, ptr %1, i32 0, i32 0, i32 0
  store ptr zeroinitializer, ptr %2
  %3 = getelementptr %node_t_1, ptr %1, i32 0, i32 0, i32 1
  store i16 0, ptr %3
  %4 = getelementptr %node_t_1, ptr %1, i32 0, i32 0, i32 2
  store i16 0, ptr %4
  %5 = getelementptr %node_t_1, ptr %1, i32 0, i32 0, i32 3
  store i1 %type_0, ptr %5
  %6 = getelementptr %node_t_1, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %6, i8 0, i64 240, i1 0)
  %7 = icmp eq i1 %type_0, 1
  br i1 %7, label %if_0, label %end_if_0
if_0:
  %8 = getelementptr %inner_node_t_1, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %8, i8 0, i64 248, i1 0)
  br label %end_if_0
end_if_0:
  ret ptr %1
}

define external ccc i64 @eclair_btree_node_count_entries_1(ptr %node_0) {
start:
  %stack.ptr_0 = alloca i64
  %0 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 0
  %5 = zext i16 %1 to i64
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i64 %5
end_if_0:
  store i64 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  br label %for_begin_0
for_begin_0:
  %8 = phi i16 [0, %end_if_0], [%15, %for_body_0]
  %9 = icmp ule i16 %8, %7
  br i1 %9, label %for_body_0, label %for_end_0
for_body_0:
  %10 = load i64, ptr %stack.ptr_0
  %11 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %8
  %12 = load ptr, ptr %11
  %13 = call ccc i64 @eclair_btree_node_count_entries_1(ptr %12)
  %14 = add i64 %10, %13
  store i64 %14, ptr %stack.ptr_0
  %15 = add i16 1, %8
  br label %for_begin_0
for_end_0:
  %16 = load i64, ptr %stack.ptr_0
  ret i64 %16
}

define external ccc void @eclair_btree_iterator_init_1(ptr %iter_0, ptr %cur_0, i16 %pos_0) {
start:
  %0 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  store ptr %cur_0, ptr %0
  %1 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  store i16 %pos_0, ptr %1
  ret void
}

define external ccc void @eclair_btree_iterator_end_init_1(ptr %iter_0) {
start:
  call ccc void @eclair_btree_iterator_init_1(ptr %iter_0, ptr zeroinitializer, i16 0)
  ret void
}

define external ccc i1 @eclair_btree_iterator_is_equal_1(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_iterator_t_1, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_1, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = icmp ne ptr %1, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i1 0
end_if_0:
  %5 = getelementptr %btree_iterator_t_1, ptr %lhs_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = getelementptr %btree_iterator_t_1, ptr %rhs_0, i32 0, i32 1
  %8 = load i16, ptr %7
  %9 = icmp eq i16 %6, %8
  ret i1 %9
}

define external ccc ptr @eclair_btree_iterator_current_1(ptr %iter_0) {
start:
  %0 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  %1 = load i16, ptr %0
  %2 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %node_t_1, ptr %3, i32 0, i32 1, i16 %1
  ret ptr %4
}

define external ccc void @eclair_btree_iterator_next_1(ptr %iter_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_1, ptr %1, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 1
  br i1 %4, label %if_0, label %end_if_1
if_0:
  %5 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = add i16 1, %6
  %8 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  %9 = load ptr, ptr %8
  %10 = getelementptr %inner_node_t_1, ptr %9, i32 0, i32 1, i16 %7
  %11 = load ptr, ptr %10
  store ptr %11, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %12 = load ptr, ptr %stack.ptr_0
  %13 = getelementptr %node_t_1, ptr %12, i32 0, i32 0, i32 3
  %14 = load i1, ptr %13
  %15 = icmp eq i1 %14, 1
  br i1 %15, label %while_body_0, label %while_end_0
while_body_0:
  %16 = load ptr, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_1, ptr %16, i32 0, i32 1, i16 0
  %18 = load ptr, ptr %17
  store ptr %18, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  %19 = load ptr, ptr %stack.ptr_0
  %20 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  store i16 0, ptr %21
  %22 = getelementptr %node_t_1, ptr %19, i32 0, i32 0, i32 2
  %23 = load i16, ptr %22
  %24 = icmp ne i16 %23, 0
  br i1 %24, label %if_1, label %end_if_0
if_1:
  ret void
end_if_0:
  br label %leaf.next_0
end_if_1:
  br label %leaf.next_0
leaf.next_0:
  %25 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  %26 = load i16, ptr %25
  %27 = add i16 1, %26
  store i16 %27, ptr %25
  %28 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  %29 = load i16, ptr %28
  %30 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  %31 = load ptr, ptr %30
  %32 = getelementptr %node_t_1, ptr %31, i32 0, i32 0, i32 2
  %33 = load i16, ptr %32
  %34 = icmp ult i16 %29, %33
  br i1 %34, label %if_2, label %end_if_2
if_2:
  ret void
end_if_2:
  br label %while_begin_1
while_begin_1:
  %35 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  %36 = load ptr, ptr %35
  %37 = icmp eq ptr %36, zeroinitializer
  br i1 %37, label %leaf.no_parent_0, label %leaf.has_parent_0
leaf.no_parent_0:
  br label %loop.condition.end_0
leaf.has_parent_0:
  %38 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  %39 = load i16, ptr %38
  %40 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  %41 = load ptr, ptr %40
  %42 = getelementptr %node_t_1, ptr %41, i32 0, i32 0, i32 2
  %43 = load i16, ptr %42
  %44 = icmp eq i16 %39, %43
  br label %loop.condition.end_0
loop.condition.end_0:
  %45 = phi i1 [0, %leaf.no_parent_0], [%44, %leaf.has_parent_0]
  br i1 %45, label %while_body_1, label %while_end_1
while_body_1:
  %46 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  %47 = load ptr, ptr %46
  %48 = getelementptr %node_t_1, ptr %47, i32 0, i32 0, i32 1
  %49 = load i16, ptr %48
  %50 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 1
  store i16 %49, ptr %50
  %51 = getelementptr %node_t_1, ptr %47, i32 0, i32 0, i32 0
  %52 = load ptr, ptr %51
  %53 = getelementptr %btree_iterator_t_1, ptr %iter_0, i32 0, i32 0
  store ptr %52, ptr %53
  br label %while_begin_1
while_end_1:
  ret void
}

define external ccc ptr @eclair_btree_linear_search_lower_bound_1(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_1(ptr %2, ptr %val_0)
  %4 = icmp ne i8 %3, -1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [2 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc ptr @eclair_btree_linear_search_upper_bound_1(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_1(ptr %2, ptr %val_0)
  %4 = icmp eq i8 %3, 1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [2 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc void @eclair_btree_init_empty_1(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %0
  %1 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %1
  ret void
}

define external ccc void @eclair_btree_init_1(ptr %tree_0, ptr %start_0, ptr %end_0) {
start:
  call ccc void @eclair_btree_insert_range__1(ptr %tree_0, ptr %start_0, ptr %end_0)
  ret void
}

define external ccc void @eclair_btree_destroy_1(ptr %tree_0) {
start:
  call ccc void @eclair_btree_clear_1(ptr %tree_0)
  ret void
}

define external ccc i1 @eclair_btree_is_empty_1(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  ret i1 %2
}

define external ccc i64 @eclair_btree_size_1(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  br i1 %2, label %null_0, label %not_null_0
null_0:
  ret i64 0
not_null_0:
  %3 = call ccc i64 @eclair_btree_node_count_entries_1(ptr %1)
  ret i64 %3
}

define external ccc i16 @eclair_btree_node_split_point_1() {
start:
  %0 = mul i16 3, 30
  %1 = udiv i16 %0, 4
  %2 = sub i16 30, 2
  %3 = icmp ult i16 %1, %2
  %4 = select i1 %3, i16 %1, i16 %2
  ret i16 %4
}

define external ccc void @eclair_btree_node_split_1(ptr %node_0, ptr %root_0) {
start:
  %stack.ptr_0 = alloca i16
  %0 = call ccc i16 @eclair_btree_node_split_point_1()
  %1 = add i16 1, %0
  %2 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = call ccc ptr @eclair_btree_node_new_1(i1 %3)
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [%1, %start], [%12, %for_body_0]
  %6 = icmp ult i16 %5, 30
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = load i16, ptr %stack.ptr_0
  %8 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %5
  %9 = load [2 x i32], ptr %8
  %10 = getelementptr %node_t_1, ptr %4, i32 0, i32 1, i16 %7
  store [2 x i32] %9, ptr %10
  %11 = add i16 1, %7
  store i16 %11, ptr %stack.ptr_0
  %12 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  %13 = icmp eq i1 %3, 1
  br i1 %13, label %if_0, label %end_if_0
if_0:
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_1
for_begin_1:
  %14 = phi i16 [%1, %if_0], [%23, %for_body_1]
  %15 = icmp ule i16 %14, 30
  br i1 %15, label %for_body_1, label %for_end_1
for_body_1:
  %16 = load i16, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %14
  %18 = load ptr, ptr %17
  %19 = getelementptr %node_t_1, ptr %18, i32 0, i32 0, i32 0
  store ptr %4, ptr %19
  %20 = getelementptr %node_t_1, ptr %18, i32 0, i32 0, i32 1
  store i16 %16, ptr %20
  %21 = getelementptr %inner_node_t_1, ptr %4, i32 0, i32 1, i16 %16
  store ptr %18, ptr %21
  %22 = add i16 1, %16
  store i16 %22, ptr %stack.ptr_0
  %23 = add i16 1, %14
  br label %for_begin_1
for_end_1:
  br label %end_if_0
end_if_0:
  %24 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  store i16 %0, ptr %24
  %25 = sub i16 30, %0
  %26 = sub i16 %25, 1
  %27 = getelementptr %node_t_1, ptr %4, i32 0, i32 0, i32 2
  store i16 %26, ptr %27
  call ccc void @eclair_btree_node_grow_parent_1(ptr %node_0, ptr %root_0, ptr %4)
  ret void
}

define external ccc void @eclair_btree_node_grow_parent_1(ptr %node_0, ptr %root_0, ptr %sibling_0) {
start:
  %0 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  %3 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br i1 %2, label %create_new_root_0, label %insert_new_node_in_parent_0
create_new_root_0:
  %5 = call ccc ptr @eclair_btree_node_new_1(i1 1)
  %6 = getelementptr %node_t_1, ptr %5, i32 0, i32 0, i32 2
  store i16 1, ptr %6
  %7 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %4
  %8 = load [2 x i32], ptr %7
  %9 = getelementptr %node_t_1, ptr %5, i32 0, i32 1, i16 0
  store [2 x i32] %8, ptr %9
  %10 = getelementptr %inner_node_t_1, ptr %5, i32 0, i32 1, i16 0
  store ptr %node_0, ptr %10
  %11 = getelementptr %inner_node_t_1, ptr %5, i32 0, i32 1, i16 1
  store ptr %sibling_0, ptr %11
  %12 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %12
  %13 = getelementptr %node_t_1, ptr %sibling_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %13
  %14 = getelementptr %node_t_1, ptr %sibling_0, i32 0, i32 0, i32 1
  store i16 1, ptr %14
  store ptr %5, ptr %root_0
  ret void
insert_new_node_in_parent_0:
  %15 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 1
  %16 = load i16, ptr %15
  %17 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %4
  call ccc void @eclair_btree_node_insert_inner_1(ptr %1, ptr %root_0, i16 %16, ptr %node_0, ptr %17, ptr %sibling_0)
  ret void
}

define external ccc void @eclair_btree_node_insert_inner_1(ptr %node_0, ptr %root_0, i16 %pos_0, ptr %predecessor_0, ptr %key_0, ptr %new_node_0) {
start:
  %stack.ptr_0 = alloca i16
  store i16 %pos_0, ptr %stack.ptr_0
  %0 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = icmp uge i16 %1, 30
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = load i16, ptr %stack.ptr_0
  %4 = call ccc i16 @eclair_btree_node_rebalance_or_split_1(ptr %node_0, ptr %root_0, i16 %pos_0)
  %5 = sub i16 %3, %4
  store i16 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  %8 = icmp ugt i16 %5, %7
  br i1 %8, label %if_1, label %end_if_0
if_1:
  %9 = sub i16 %5, %7
  %10 = sub i16 %9, 1
  store i16 %10, ptr %stack.ptr_0
  %11 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 0
  %12 = load ptr, ptr %11
  %13 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 1
  %14 = load i16, ptr %13
  %15 = add i16 1, %14
  %16 = getelementptr %inner_node_t_1, ptr %12, i32 0, i32 1, i16 %15
  %17 = load ptr, ptr %16
  call ccc void @eclair_btree_node_insert_inner_1(ptr %17, ptr %root_0, i16 %10, ptr %predecessor_0, ptr %key_0, ptr %new_node_0)
  ret void
end_if_0:
  br label %end_if_1
end_if_1:
  %18 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %19 = load i16, ptr %18
  %20 = sub i16 %19, 1
  %21 = load i16, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %22 = phi i16 [%20, %end_if_1], [%37, %for_body_0]
  %23 = icmp sge i16 %22, %21
  br i1 %23, label %for_body_0, label %for_end_0
for_body_0:
  %24 = add i16 %22, 1
  %25 = add i16 %22, 2
  %26 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %22
  %27 = load [2 x i32], ptr %26
  %28 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %24
  store [2 x i32] %27, ptr %28
  %29 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %24
  %30 = load ptr, ptr %29
  %31 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %25
  store ptr %30, ptr %31
  %32 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %25
  %33 = load ptr, ptr %32
  %34 = getelementptr %node_t_1, ptr %33, i32 0, i32 0, i32 1
  %35 = load i16, ptr %34
  %36 = add i16 1, %35
  store i16 %36, ptr %34
  %37 = sub i16 %22, 1
  br label %for_begin_0
for_end_0:
  %38 = load [2 x i32], ptr %key_0
  %39 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %21
  store [2 x i32] %38, ptr %39
  %40 = add i16 %21, 1
  %41 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %40
  store ptr %new_node_0, ptr %41
  %42 = getelementptr %node_t_1, ptr %new_node_0, i32 0, i32 0, i32 0
  store ptr %node_0, ptr %42
  %43 = getelementptr %node_t_1, ptr %new_node_0, i32 0, i32 0, i32 1
  store i16 %40, ptr %43
  %44 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %45 = load i16, ptr %44
  %46 = add i16 1, %45
  store i16 %46, ptr %44
  ret void
}

define external ccc i16 @eclair_btree_node_rebalance_or_split_1(ptr %node_0, ptr %root_0, i16 %idx_0) {
start:
  %0 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 1
  %3 = load i16, ptr %2
  %4 = icmp ne ptr %1, zeroinitializer
  %5 = icmp ugt i16 %3, 0
  %6 = and i1 %4, %5
  br i1 %6, label %rebalance_0, label %split_0
rebalance_0:
  %7 = sub i16 %3, 1
  %8 = getelementptr %inner_node_t_1, ptr %1, i32 0, i32 1, i16 %7
  %9 = load ptr, ptr %8
  %10 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %11 = load i16, ptr %10
  %12 = sub i16 30, %11
  %13 = icmp slt i16 %12, %idx_0
  %14 = select i1 %13, i16 %12, i16 %idx_0
  %15 = icmp ugt i16 %14, 0
  br i1 %15, label %if_0, label %end_if_1
if_0:
  %16 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 1
  %17 = load i16, ptr %16
  %18 = sub i16 %17, 1
  %19 = getelementptr %inner_node_t_1, ptr %1, i32 0, i32 0, i32 1, i16 %18
  %20 = load [2 x i32], ptr %19
  %21 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %22 = load i16, ptr %21
  %23 = getelementptr %node_t_1, ptr %9, i32 0, i32 1, i16 %22
  store [2 x i32] %20, ptr %23
  %24 = sub i16 %14, 1
  br label %for_begin_0
for_begin_0:
  %25 = phi i16 [0, %if_0], [%32, %for_body_0]
  %26 = icmp ult i16 %25, %24
  br i1 %26, label %for_body_0, label %for_end_0
for_body_0:
  %27 = add i16 %22, 1
  %28 = add i16 %25, %27
  %29 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %25
  %30 = load [2 x i32], ptr %29
  %31 = getelementptr %node_t_1, ptr %9, i32 0, i32 1, i16 %28
  store [2 x i32] %30, ptr %31
  %32 = add i16 1, %25
  br label %for_begin_0
for_end_0:
  %33 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %24
  %34 = load [2 x i32], ptr %33
  store [2 x i32] %34, ptr %19
  %35 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %36 = load i16, ptr %35
  %37 = sub i16 %36, %14
  br label %for_begin_1
for_begin_1:
  %38 = phi i16 [0, %for_end_0], [%44, %for_body_1]
  %39 = icmp ult i16 %38, %37
  br i1 %39, label %for_body_1, label %for_end_1
for_body_1:
  %40 = add i16 %38, %14
  %41 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %40
  %42 = load [2 x i32], ptr %41
  %43 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 1, i16 %38
  store [2 x i32] %42, ptr %43
  %44 = add i16 1, %38
  br label %for_begin_1
for_end_1:
  %45 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 3
  %46 = load i1, ptr %45
  %47 = icmp eq i1 %46, 1
  br i1 %47, label %if_1, label %end_if_0
if_1:
  br label %for_begin_2
for_begin_2:
  %48 = phi i16 [0, %if_1], [%57, %for_body_2]
  %49 = icmp ult i16 %48, %14
  br i1 %49, label %for_body_2, label %for_end_2
for_body_2:
  %50 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %51 = load i16, ptr %50
  %52 = add i16 %51, 1
  %53 = add i16 %48, %52
  %54 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %48
  %55 = load ptr, ptr %54
  %56 = getelementptr %inner_node_t_1, ptr %9, i32 0, i32 1, i16 %53
  store ptr %55, ptr %56
  %57 = add i16 1, %48
  br label %for_begin_2
for_end_2:
  br label %for_begin_3
for_begin_3:
  %58 = phi i16 [0, %for_end_2], [%68, %for_body_3]
  %59 = icmp ult i16 %58, %14
  br i1 %59, label %for_body_3, label %for_end_3
for_body_3:
  %60 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %61 = load i16, ptr %60
  %62 = add i16 %61, 1
  %63 = add i16 %58, %62
  %64 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %58
  %65 = load ptr, ptr %64
  %66 = getelementptr %node_t_1, ptr %65, i32 0, i32 0, i32 0
  store ptr %9, ptr %66
  %67 = getelementptr %node_t_1, ptr %65, i32 0, i32 0, i32 1
  store i16 %63, ptr %67
  %68 = add i16 1, %58
  br label %for_begin_3
for_end_3:
  %69 = sub i16 %36, %14
  %70 = add i16 1, %69
  br label %for_begin_4
for_begin_4:
  %71 = phi i16 [0, %for_end_3], [%80, %for_body_4]
  %72 = icmp ult i16 %71, %70
  br i1 %72, label %for_body_4, label %for_end_4
for_body_4:
  %73 = add i16 %71, %14
  %74 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %73
  %75 = load ptr, ptr %74
  %76 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %71
  store ptr %75, ptr %76
  %77 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %71
  %78 = load ptr, ptr %77
  %79 = getelementptr %node_t_1, ptr %78, i32 0, i32 0, i32 1
  store i16 %71, ptr %79
  %80 = add i16 1, %71
  br label %for_begin_4
for_end_4:
  br label %end_if_0
end_if_0:
  %81 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %82 = load i16, ptr %81
  %83 = add i16 %82, %14
  store i16 %83, ptr %81
  %84 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %85 = load i16, ptr %84
  %86 = sub i16 %85, %14
  store i16 %86, ptr %84
  ret i16 %14
end_if_1:
  br label %split_0
split_0:
  call ccc void @eclair_btree_node_split_1(ptr %node_0, ptr %root_0)
  ret i16 0
}

define external ccc i1 @eclair_btree_insert_value_1(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca ptr
  %stack.ptr_1 = alloca i16
  %0 = call ccc i1 @eclair_btree_is_empty_1(ptr %tree_0)
  br i1 %0, label %empty_0, label %non_empty_0
empty_0:
  %1 = call ccc ptr @eclair_btree_node_new_1(i1 0)
  %2 = getelementptr %node_t_1, ptr %1, i32 0, i32 0, i32 2
  store i16 1, ptr %2
  %3 = load [2 x i32], ptr %val_0
  %4 = getelementptr %node_t_1, ptr %1, i32 0, i32 1, i16 0
  store [2 x i32] %3, ptr %4
  %5 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 1
  store ptr %1, ptr %6
  br label %inserted_new_value_0
non_empty_0:
  %7 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %8 = load ptr, ptr %7
  store ptr %8, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %9 = load ptr, ptr %stack.ptr_0
  %10 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 3
  %11 = load i1, ptr %10
  %12 = icmp eq i1 %11, 1
  br i1 %12, label %inner_0, label %leaf_0
inner_0:
  %13 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %14 = load i16, ptr %13
  %15 = getelementptr %node_t_1, ptr %9, i32 0, i32 1, i16 0
  %16 = getelementptr %node_t_1, ptr %9, i32 0, i32 1, i16 %14
  %17 = call ccc ptr @eclair_btree_linear_search_lower_bound_1(ptr %val_0, ptr %15, ptr %16)
  %18 = ptrtoint ptr %17 to i64
  %19 = ptrtoint ptr %15 to i64
  %20 = sub i64 %18, %19
  %21 = trunc i64 %20 to i16
  %22 = udiv i16 %21, 8
  %23 = icmp ne ptr %17, %16
  br i1 %23, label %if_0, label %end_if_0
if_0:
  %24 = call ccc i8 @eclair_btree_value_compare_values_1(ptr %17, ptr %val_0)
  %25 = icmp eq i8 0, %24
  br i1 %25, label %no_insert_0, label %inner_continue_insert_0
end_if_0:
  br label %inner_continue_insert_0
inner_continue_insert_0:
  %26 = getelementptr %inner_node_t_1, ptr %9, i32 0, i32 1, i16 %22
  %27 = load ptr, ptr %26
  store ptr %27, ptr %stack.ptr_0
  br label %loop_0
leaf_0:
  %28 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %29 = load i16, ptr %28
  %30 = getelementptr %node_t_1, ptr %9, i32 0, i32 1, i16 0
  %31 = getelementptr %node_t_1, ptr %9, i32 0, i32 1, i16 %29
  %32 = call ccc ptr @eclair_btree_linear_search_upper_bound_1(ptr %val_0, ptr %30, ptr %31)
  %33 = ptrtoint ptr %32 to i64
  %34 = ptrtoint ptr %30 to i64
  %35 = sub i64 %33, %34
  %36 = trunc i64 %35 to i16
  %37 = udiv i16 %36, 8
  store i16 %37, ptr %stack.ptr_1
  %38 = icmp ne ptr %32, %30
  br i1 %38, label %if_1, label %end_if_1
if_1:
  %39 = getelementptr [2 x i32], ptr %32, i32 -1
  %40 = call ccc i8 @eclair_btree_value_compare_values_1(ptr %39, ptr %val_0)
  %41 = icmp eq i8 0, %40
  br i1 %41, label %no_insert_0, label %leaf_continue_insert_0
end_if_1:
  br label %leaf_continue_insert_0
leaf_continue_insert_0:
  %42 = icmp uge i16 %29, 30
  br i1 %42, label %split_0, label %no_split_0
split_0:
  %43 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %44 = load i16, ptr %stack.ptr_1
  %45 = call ccc i16 @eclair_btree_node_rebalance_or_split_1(ptr %9, ptr %43, i16 %44)
  %46 = sub i16 %44, %45
  store i16 %46, ptr %stack.ptr_1
  %47 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 2
  %48 = load i16, ptr %47
  %49 = icmp ugt i16 %46, %48
  br i1 %49, label %if_2, label %end_if_2
if_2:
  %50 = add i16 %48, 1
  %51 = sub i16 %46, %50
  store i16 %51, ptr %stack.ptr_1
  %52 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 0
  %53 = load ptr, ptr %52
  %54 = getelementptr %node_t_1, ptr %9, i32 0, i32 0, i32 1
  %55 = load i16, ptr %54
  %56 = add i16 1, %55
  %57 = getelementptr %inner_node_t_1, ptr %53, i32 0, i32 1, i16 %56
  %58 = load ptr, ptr %57
  store ptr %58, ptr %stack.ptr_0
  br label %end_if_2
end_if_2:
  br label %no_split_0
no_split_0:
  %59 = load ptr, ptr %stack.ptr_0
  %60 = load i16, ptr %stack.ptr_1
  %61 = getelementptr %node_t_1, ptr %59, i32 0, i32 0, i32 2
  %62 = load i16, ptr %61
  br label %for_begin_0
for_begin_0:
  %63 = phi i16 [%62, %no_split_0], [%69, %for_body_0]
  %64 = icmp ugt i16 %63, %60
  br i1 %64, label %for_body_0, label %for_end_0
for_body_0:
  %65 = sub i16 %63, 1
  %66 = getelementptr %node_t_1, ptr %59, i32 0, i32 1, i16 %65
  %67 = load [2 x i32], ptr %66
  %68 = getelementptr %node_t_1, ptr %59, i32 0, i32 1, i16 %63
  store [2 x i32] %67, ptr %68
  %69 = sub i16 %63, 1
  br label %for_begin_0
for_end_0:
  %70 = load [2 x i32], ptr %val_0
  %71 = getelementptr %node_t_1, ptr %59, i32 0, i32 1, i16 %60
  store [2 x i32] %70, ptr %71
  %72 = getelementptr %node_t_1, ptr %59, i32 0, i32 0, i32 2
  %73 = load i16, ptr %72
  %74 = add i16 1, %73
  store i16 %74, ptr %72
  br label %inserted_new_value_0
no_insert_0:
  ret i1 0
inserted_new_value_0:
  ret i1 1
}

define external ccc void @eclair_btree_insert_range__1(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_1(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_1(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_1(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_begin_1(ptr %tree_0, ptr %result_0) {
start:
  %0 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 1
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_1, ptr %result_0, i32 0, i32 0
  store ptr %1, ptr %2
  %3 = getelementptr %btree_iterator_t_1, ptr %result_0, i32 0, i32 1
  store i16 0, ptr %3
  ret void
}

define external ccc void @eclair_btree_end_1(ptr %tree_0, ptr %result_0) {
start:
  call ccc void @eclair_btree_iterator_end_init_1(ptr %result_0)
  ret void
}

define external ccc i1 @eclair_btree_contains_1(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_1 = alloca %btree_iterator_t_1, i32 1
  call ccc void @eclair_btree_find_1(ptr %tree_0, ptr %val_0, ptr %stack.ptr_0)
  call ccc void @eclair_btree_end_1(ptr %tree_0, ptr %stack.ptr_1)
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_0, ptr %stack.ptr_1)
  %1 = select i1 %0, i1 0, i1 1
  ret i1 %1
}

define external ccc void @eclair_btree_find_1(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_1(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_1(ptr %result_0)
  ret void
end_if_0:
  %1 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_0
  %4 = getelementptr %node_t_1, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_1, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_1, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_1(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 8
  %14 = icmp ult ptr %8, %7
  br i1 %14, label %if_1, label %end_if_2
if_1:
  %15 = call ccc i8 @eclair_btree_value_compare_values_1(ptr %8, ptr %val_0)
  %16 = icmp eq i8 0, %15
  br i1 %16, label %if_2, label %end_if_1
if_2:
  call ccc void @eclair_btree_iterator_init_1(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  br label %end_if_2
end_if_2:
  %17 = getelementptr %node_t_1, ptr %3, i32 0, i32 0, i32 3
  %18 = load i1, ptr %17
  %19 = icmp eq i1 %18, 0
  br i1 %19, label %if_3, label %end_if_3
if_3:
  call ccc void @eclair_btree_iterator_end_init_1(ptr %result_0)
  ret void
end_if_3:
  %20 = getelementptr %inner_node_t_1, ptr %3, i32 0, i32 1, i16 %13
  %21 = load ptr, ptr %20
  store ptr %21, ptr %stack.ptr_0
  br label %loop_0
}

define external ccc void @eclair_btree_lower_bound_1(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_1(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_1(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_1(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_1, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_1, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_1, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_1(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 8
  %14 = getelementptr %node_t_1, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_1, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_1, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_1, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_1, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_1(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_3
if_2:
  %25 = call ccc i8 @eclair_btree_value_compare_values_1(ptr %8, ptr %val_0)
  %26 = icmp eq i8 0, %25
  br i1 %26, label %if_3, label %end_if_2
if_3:
  call ccc void @eclair_btree_iterator_init_1(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_2:
  br label %end_if_3
end_if_3:
  br i1 %24, label %if_4, label %end_if_4
if_4:
  call ccc void @eclair_btree_iterator_init_1(ptr %stack.ptr_0, ptr %3, i16 %13)
  br label %end_if_4
end_if_4:
  %27 = getelementptr %inner_node_t_1, ptr %3, i32 0, i32 1, i16 %13
  %28 = load ptr, ptr %27
  store ptr %28, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_upper_bound_1(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_1(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_1(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_1(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_1, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_1, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_1, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_upper_bound_1(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 8
  %14 = getelementptr %node_t_1, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_1, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_1, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_1, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_1, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_1(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_2
if_2:
  call ccc void @eclair_btree_iterator_init_1(ptr %result_0, ptr %3, i16 %13)
  br label %end_if_2
end_if_2:
  %25 = getelementptr %inner_node_t_1, ptr %3, i32 0, i32 1, i16 %13
  %26 = load ptr, ptr %25
  store ptr %26, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_node_delete_1(ptr %node_0) {
start:
  %0 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 3
  %1 = load i1, ptr %0
  %2 = icmp eq i1 %1, 1
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = getelementptr %node_t_1, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [0, %if_0], [%10, %end_if_0]
  %6 = icmp ule i16 %5, %4
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = getelementptr %inner_node_t_1, ptr %node_0, i32 0, i32 1, i16 %5
  %8 = load ptr, ptr %7
  %9 = icmp ne ptr %8, zeroinitializer
  br i1 %9, label %if_1, label %end_if_0
if_1:
  call ccc void @eclair_btree_node_delete_1(ptr %8)
  br label %end_if_0
end_if_0:
  %10 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  br label %end_if_1
end_if_1:
  call ccc void @free(ptr %node_0)
  ret void
}

define external ccc void @eclair_btree_clear_1(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp ne ptr %1, zeroinitializer
  br i1 %2, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_node_delete_1(ptr %1)
  %3 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %3
  %4 = getelementptr %btree_t_1, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %4
  br label %end_if_0
end_if_0:
  ret void
}

define external ccc void @eclair_btree_swap_1(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_t_1, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_t_1, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %btree_t_1, ptr %lhs_0, i32 0, i32 0
  store ptr %3, ptr %4
  %5 = getelementptr %btree_t_1, ptr %rhs_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_1, ptr %lhs_0, i32 0, i32 1
  %7 = load ptr, ptr %6
  %8 = getelementptr %btree_t_1, ptr %rhs_0, i32 0, i32 1
  %9 = load ptr, ptr %8
  %10 = getelementptr %btree_t_1, ptr %lhs_0, i32 0, i32 1
  store ptr %9, ptr %10
  %11 = getelementptr %btree_t_1, ptr %rhs_0, i32 0, i32 1
  store ptr %7, ptr %11
  ret void
}

%node_data_t_2 = type {ptr, i16, i16, i1}

%node_t_2 = type {%node_data_t_2, [30 x [2 x i32]]}

%inner_node_t_2 = type {%node_t_2, [31 x ptr]}

%btree_iterator_t_2 = type {ptr, i16}

%btree_t_2 = type {ptr, ptr}

define external ccc i8 @eclair_btree_value_compare_2(i32 %lhs_0, i32 %rhs_0) {
start:
  %0 = icmp ult i32 %lhs_0, %rhs_0
  br i1 %0, label %if_0, label %end_if_0
if_0:
  ret i8 -1
end_if_0:
  %1 = icmp ugt i32 %lhs_0, %rhs_0
  %2 = select i1 %1, i8 1, i8 0
  ret i8 %2
}

define external ccc i8 @eclair_btree_value_compare_values_2(ptr %lhs_0, ptr %rhs_0) {
start:
  br label %comparison_0
comparison_0:
  %0 = getelementptr [2 x i32], ptr %lhs_0, i32 0, i32 1
  %1 = getelementptr [2 x i32], ptr %rhs_0, i32 0, i32 1
  %2 = load i32, ptr %0
  %3 = load i32, ptr %1
  %4 = call ccc i8 @eclair_btree_value_compare_2(i32 %2, i32 %3)
  br label %end_0
end_0:
  %5 = phi i8 [%4, %comparison_0]
  ret i8 %5
}

define external ccc ptr @eclair_btree_node_new_2(i1 %type_0) {
start:
  %0 = select i1 %type_0, i32 504, i32 256
  %1 = call ccc ptr @malloc(i32 %0)
  %2 = getelementptr %node_t_2, ptr %1, i32 0, i32 0, i32 0
  store ptr zeroinitializer, ptr %2
  %3 = getelementptr %node_t_2, ptr %1, i32 0, i32 0, i32 1
  store i16 0, ptr %3
  %4 = getelementptr %node_t_2, ptr %1, i32 0, i32 0, i32 2
  store i16 0, ptr %4
  %5 = getelementptr %node_t_2, ptr %1, i32 0, i32 0, i32 3
  store i1 %type_0, ptr %5
  %6 = getelementptr %node_t_2, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %6, i8 0, i64 240, i1 0)
  %7 = icmp eq i1 %type_0, 1
  br i1 %7, label %if_0, label %end_if_0
if_0:
  %8 = getelementptr %inner_node_t_2, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %8, i8 0, i64 248, i1 0)
  br label %end_if_0
end_if_0:
  ret ptr %1
}

define external ccc i64 @eclair_btree_node_count_entries_2(ptr %node_0) {
start:
  %stack.ptr_0 = alloca i64
  %0 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 0
  %5 = zext i16 %1 to i64
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i64 %5
end_if_0:
  store i64 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  br label %for_begin_0
for_begin_0:
  %8 = phi i16 [0, %end_if_0], [%15, %for_body_0]
  %9 = icmp ule i16 %8, %7
  br i1 %9, label %for_body_0, label %for_end_0
for_body_0:
  %10 = load i64, ptr %stack.ptr_0
  %11 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %8
  %12 = load ptr, ptr %11
  %13 = call ccc i64 @eclair_btree_node_count_entries_2(ptr %12)
  %14 = add i64 %10, %13
  store i64 %14, ptr %stack.ptr_0
  %15 = add i16 1, %8
  br label %for_begin_0
for_end_0:
  %16 = load i64, ptr %stack.ptr_0
  ret i64 %16
}

define external ccc void @eclair_btree_iterator_init_2(ptr %iter_0, ptr %cur_0, i16 %pos_0) {
start:
  %0 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  store ptr %cur_0, ptr %0
  %1 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  store i16 %pos_0, ptr %1
  ret void
}

define external ccc void @eclair_btree_iterator_end_init_2(ptr %iter_0) {
start:
  call ccc void @eclair_btree_iterator_init_2(ptr %iter_0, ptr zeroinitializer, i16 0)
  ret void
}

define external ccc i1 @eclair_btree_iterator_is_equal_2(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_iterator_t_2, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_2, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = icmp ne ptr %1, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i1 0
end_if_0:
  %5 = getelementptr %btree_iterator_t_2, ptr %lhs_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = getelementptr %btree_iterator_t_2, ptr %rhs_0, i32 0, i32 1
  %8 = load i16, ptr %7
  %9 = icmp eq i16 %6, %8
  ret i1 %9
}

define external ccc ptr @eclair_btree_iterator_current_2(ptr %iter_0) {
start:
  %0 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  %1 = load i16, ptr %0
  %2 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %node_t_2, ptr %3, i32 0, i32 1, i16 %1
  ret ptr %4
}

define external ccc void @eclair_btree_iterator_next_2(ptr %iter_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_2, ptr %1, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 1
  br i1 %4, label %if_0, label %end_if_1
if_0:
  %5 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = add i16 1, %6
  %8 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  %9 = load ptr, ptr %8
  %10 = getelementptr %inner_node_t_2, ptr %9, i32 0, i32 1, i16 %7
  %11 = load ptr, ptr %10
  store ptr %11, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %12 = load ptr, ptr %stack.ptr_0
  %13 = getelementptr %node_t_2, ptr %12, i32 0, i32 0, i32 3
  %14 = load i1, ptr %13
  %15 = icmp eq i1 %14, 1
  br i1 %15, label %while_body_0, label %while_end_0
while_body_0:
  %16 = load ptr, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_2, ptr %16, i32 0, i32 1, i16 0
  %18 = load ptr, ptr %17
  store ptr %18, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  %19 = load ptr, ptr %stack.ptr_0
  %20 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  store i16 0, ptr %21
  %22 = getelementptr %node_t_2, ptr %19, i32 0, i32 0, i32 2
  %23 = load i16, ptr %22
  %24 = icmp ne i16 %23, 0
  br i1 %24, label %if_1, label %end_if_0
if_1:
  ret void
end_if_0:
  br label %leaf.next_0
end_if_1:
  br label %leaf.next_0
leaf.next_0:
  %25 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  %26 = load i16, ptr %25
  %27 = add i16 1, %26
  store i16 %27, ptr %25
  %28 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  %29 = load i16, ptr %28
  %30 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  %31 = load ptr, ptr %30
  %32 = getelementptr %node_t_2, ptr %31, i32 0, i32 0, i32 2
  %33 = load i16, ptr %32
  %34 = icmp ult i16 %29, %33
  br i1 %34, label %if_2, label %end_if_2
if_2:
  ret void
end_if_2:
  br label %while_begin_1
while_begin_1:
  %35 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  %36 = load ptr, ptr %35
  %37 = icmp eq ptr %36, zeroinitializer
  br i1 %37, label %leaf.no_parent_0, label %leaf.has_parent_0
leaf.no_parent_0:
  br label %loop.condition.end_0
leaf.has_parent_0:
  %38 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  %39 = load i16, ptr %38
  %40 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  %41 = load ptr, ptr %40
  %42 = getelementptr %node_t_2, ptr %41, i32 0, i32 0, i32 2
  %43 = load i16, ptr %42
  %44 = icmp eq i16 %39, %43
  br label %loop.condition.end_0
loop.condition.end_0:
  %45 = phi i1 [0, %leaf.no_parent_0], [%44, %leaf.has_parent_0]
  br i1 %45, label %while_body_1, label %while_end_1
while_body_1:
  %46 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  %47 = load ptr, ptr %46
  %48 = getelementptr %node_t_2, ptr %47, i32 0, i32 0, i32 1
  %49 = load i16, ptr %48
  %50 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 1
  store i16 %49, ptr %50
  %51 = getelementptr %node_t_2, ptr %47, i32 0, i32 0, i32 0
  %52 = load ptr, ptr %51
  %53 = getelementptr %btree_iterator_t_2, ptr %iter_0, i32 0, i32 0
  store ptr %52, ptr %53
  br label %while_begin_1
while_end_1:
  ret void
}

define external ccc ptr @eclair_btree_linear_search_lower_bound_2(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_2(ptr %2, ptr %val_0)
  %4 = icmp ne i8 %3, -1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [2 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc ptr @eclair_btree_linear_search_upper_bound_2(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_2(ptr %2, ptr %val_0)
  %4 = icmp eq i8 %3, 1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [2 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc void @eclair_btree_init_empty_2(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %0
  %1 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %1
  ret void
}

define external ccc void @eclair_btree_init_2(ptr %tree_0, ptr %start_0, ptr %end_0) {
start:
  call ccc void @eclair_btree_insert_range__2(ptr %tree_0, ptr %start_0, ptr %end_0)
  ret void
}

define external ccc void @eclair_btree_destroy_2(ptr %tree_0) {
start:
  call ccc void @eclair_btree_clear_2(ptr %tree_0)
  ret void
}

define external ccc i1 @eclair_btree_is_empty_2(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  ret i1 %2
}

define external ccc i64 @eclair_btree_size_2(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  br i1 %2, label %null_0, label %not_null_0
null_0:
  ret i64 0
not_null_0:
  %3 = call ccc i64 @eclair_btree_node_count_entries_2(ptr %1)
  ret i64 %3
}

define external ccc i16 @eclair_btree_node_split_point_2() {
start:
  %0 = mul i16 3, 30
  %1 = udiv i16 %0, 4
  %2 = sub i16 30, 2
  %3 = icmp ult i16 %1, %2
  %4 = select i1 %3, i16 %1, i16 %2
  ret i16 %4
}

define external ccc void @eclair_btree_node_split_2(ptr %node_0, ptr %root_0) {
start:
  %stack.ptr_0 = alloca i16
  %0 = call ccc i16 @eclair_btree_node_split_point_2()
  %1 = add i16 1, %0
  %2 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = call ccc ptr @eclair_btree_node_new_2(i1 %3)
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [%1, %start], [%12, %for_body_0]
  %6 = icmp ult i16 %5, 30
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = load i16, ptr %stack.ptr_0
  %8 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %5
  %9 = load [2 x i32], ptr %8
  %10 = getelementptr %node_t_2, ptr %4, i32 0, i32 1, i16 %7
  store [2 x i32] %9, ptr %10
  %11 = add i16 1, %7
  store i16 %11, ptr %stack.ptr_0
  %12 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  %13 = icmp eq i1 %3, 1
  br i1 %13, label %if_0, label %end_if_0
if_0:
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_1
for_begin_1:
  %14 = phi i16 [%1, %if_0], [%23, %for_body_1]
  %15 = icmp ule i16 %14, 30
  br i1 %15, label %for_body_1, label %for_end_1
for_body_1:
  %16 = load i16, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %14
  %18 = load ptr, ptr %17
  %19 = getelementptr %node_t_2, ptr %18, i32 0, i32 0, i32 0
  store ptr %4, ptr %19
  %20 = getelementptr %node_t_2, ptr %18, i32 0, i32 0, i32 1
  store i16 %16, ptr %20
  %21 = getelementptr %inner_node_t_2, ptr %4, i32 0, i32 1, i16 %16
  store ptr %18, ptr %21
  %22 = add i16 1, %16
  store i16 %22, ptr %stack.ptr_0
  %23 = add i16 1, %14
  br label %for_begin_1
for_end_1:
  br label %end_if_0
end_if_0:
  %24 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  store i16 %0, ptr %24
  %25 = sub i16 30, %0
  %26 = sub i16 %25, 1
  %27 = getelementptr %node_t_2, ptr %4, i32 0, i32 0, i32 2
  store i16 %26, ptr %27
  call ccc void @eclair_btree_node_grow_parent_2(ptr %node_0, ptr %root_0, ptr %4)
  ret void
}

define external ccc void @eclair_btree_node_grow_parent_2(ptr %node_0, ptr %root_0, ptr %sibling_0) {
start:
  %0 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  %3 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br i1 %2, label %create_new_root_0, label %insert_new_node_in_parent_0
create_new_root_0:
  %5 = call ccc ptr @eclair_btree_node_new_2(i1 1)
  %6 = getelementptr %node_t_2, ptr %5, i32 0, i32 0, i32 2
  store i16 1, ptr %6
  %7 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %4
  %8 = load [2 x i32], ptr %7
  %9 = getelementptr %node_t_2, ptr %5, i32 0, i32 1, i16 0
  store [2 x i32] %8, ptr %9
  %10 = getelementptr %inner_node_t_2, ptr %5, i32 0, i32 1, i16 0
  store ptr %node_0, ptr %10
  %11 = getelementptr %inner_node_t_2, ptr %5, i32 0, i32 1, i16 1
  store ptr %sibling_0, ptr %11
  %12 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %12
  %13 = getelementptr %node_t_2, ptr %sibling_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %13
  %14 = getelementptr %node_t_2, ptr %sibling_0, i32 0, i32 0, i32 1
  store i16 1, ptr %14
  store ptr %5, ptr %root_0
  ret void
insert_new_node_in_parent_0:
  %15 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 1
  %16 = load i16, ptr %15
  %17 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %4
  call ccc void @eclair_btree_node_insert_inner_2(ptr %1, ptr %root_0, i16 %16, ptr %node_0, ptr %17, ptr %sibling_0)
  ret void
}

define external ccc void @eclair_btree_node_insert_inner_2(ptr %node_0, ptr %root_0, i16 %pos_0, ptr %predecessor_0, ptr %key_0, ptr %new_node_0) {
start:
  %stack.ptr_0 = alloca i16
  store i16 %pos_0, ptr %stack.ptr_0
  %0 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = icmp uge i16 %1, 30
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = load i16, ptr %stack.ptr_0
  %4 = call ccc i16 @eclair_btree_node_rebalance_or_split_2(ptr %node_0, ptr %root_0, i16 %pos_0)
  %5 = sub i16 %3, %4
  store i16 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  %8 = icmp ugt i16 %5, %7
  br i1 %8, label %if_1, label %end_if_0
if_1:
  %9 = sub i16 %5, %7
  %10 = sub i16 %9, 1
  store i16 %10, ptr %stack.ptr_0
  %11 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 0
  %12 = load ptr, ptr %11
  %13 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 1
  %14 = load i16, ptr %13
  %15 = add i16 1, %14
  %16 = getelementptr %inner_node_t_2, ptr %12, i32 0, i32 1, i16 %15
  %17 = load ptr, ptr %16
  call ccc void @eclair_btree_node_insert_inner_2(ptr %17, ptr %root_0, i16 %10, ptr %predecessor_0, ptr %key_0, ptr %new_node_0)
  ret void
end_if_0:
  br label %end_if_1
end_if_1:
  %18 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %19 = load i16, ptr %18
  %20 = sub i16 %19, 1
  %21 = load i16, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %22 = phi i16 [%20, %end_if_1], [%37, %for_body_0]
  %23 = icmp sge i16 %22, %21
  br i1 %23, label %for_body_0, label %for_end_0
for_body_0:
  %24 = add i16 %22, 1
  %25 = add i16 %22, 2
  %26 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %22
  %27 = load [2 x i32], ptr %26
  %28 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %24
  store [2 x i32] %27, ptr %28
  %29 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %24
  %30 = load ptr, ptr %29
  %31 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %25
  store ptr %30, ptr %31
  %32 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %25
  %33 = load ptr, ptr %32
  %34 = getelementptr %node_t_2, ptr %33, i32 0, i32 0, i32 1
  %35 = load i16, ptr %34
  %36 = add i16 1, %35
  store i16 %36, ptr %34
  %37 = sub i16 %22, 1
  br label %for_begin_0
for_end_0:
  %38 = load [2 x i32], ptr %key_0
  %39 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %21
  store [2 x i32] %38, ptr %39
  %40 = add i16 %21, 1
  %41 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %40
  store ptr %new_node_0, ptr %41
  %42 = getelementptr %node_t_2, ptr %new_node_0, i32 0, i32 0, i32 0
  store ptr %node_0, ptr %42
  %43 = getelementptr %node_t_2, ptr %new_node_0, i32 0, i32 0, i32 1
  store i16 %40, ptr %43
  %44 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %45 = load i16, ptr %44
  %46 = add i16 1, %45
  store i16 %46, ptr %44
  ret void
}

define external ccc i16 @eclair_btree_node_rebalance_or_split_2(ptr %node_0, ptr %root_0, i16 %idx_0) {
start:
  %0 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 1
  %3 = load i16, ptr %2
  %4 = icmp ne ptr %1, zeroinitializer
  %5 = icmp ugt i16 %3, 0
  %6 = and i1 %4, %5
  br i1 %6, label %rebalance_0, label %split_0
rebalance_0:
  %7 = sub i16 %3, 1
  %8 = getelementptr %inner_node_t_2, ptr %1, i32 0, i32 1, i16 %7
  %9 = load ptr, ptr %8
  %10 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %11 = load i16, ptr %10
  %12 = sub i16 30, %11
  %13 = icmp slt i16 %12, %idx_0
  %14 = select i1 %13, i16 %12, i16 %idx_0
  %15 = icmp ugt i16 %14, 0
  br i1 %15, label %if_0, label %end_if_1
if_0:
  %16 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 1
  %17 = load i16, ptr %16
  %18 = sub i16 %17, 1
  %19 = getelementptr %inner_node_t_2, ptr %1, i32 0, i32 0, i32 1, i16 %18
  %20 = load [2 x i32], ptr %19
  %21 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %22 = load i16, ptr %21
  %23 = getelementptr %node_t_2, ptr %9, i32 0, i32 1, i16 %22
  store [2 x i32] %20, ptr %23
  %24 = sub i16 %14, 1
  br label %for_begin_0
for_begin_0:
  %25 = phi i16 [0, %if_0], [%32, %for_body_0]
  %26 = icmp ult i16 %25, %24
  br i1 %26, label %for_body_0, label %for_end_0
for_body_0:
  %27 = add i16 %22, 1
  %28 = add i16 %25, %27
  %29 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %25
  %30 = load [2 x i32], ptr %29
  %31 = getelementptr %node_t_2, ptr %9, i32 0, i32 1, i16 %28
  store [2 x i32] %30, ptr %31
  %32 = add i16 1, %25
  br label %for_begin_0
for_end_0:
  %33 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %24
  %34 = load [2 x i32], ptr %33
  store [2 x i32] %34, ptr %19
  %35 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %36 = load i16, ptr %35
  %37 = sub i16 %36, %14
  br label %for_begin_1
for_begin_1:
  %38 = phi i16 [0, %for_end_0], [%44, %for_body_1]
  %39 = icmp ult i16 %38, %37
  br i1 %39, label %for_body_1, label %for_end_1
for_body_1:
  %40 = add i16 %38, %14
  %41 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %40
  %42 = load [2 x i32], ptr %41
  %43 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 1, i16 %38
  store [2 x i32] %42, ptr %43
  %44 = add i16 1, %38
  br label %for_begin_1
for_end_1:
  %45 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 3
  %46 = load i1, ptr %45
  %47 = icmp eq i1 %46, 1
  br i1 %47, label %if_1, label %end_if_0
if_1:
  br label %for_begin_2
for_begin_2:
  %48 = phi i16 [0, %if_1], [%57, %for_body_2]
  %49 = icmp ult i16 %48, %14
  br i1 %49, label %for_body_2, label %for_end_2
for_body_2:
  %50 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %51 = load i16, ptr %50
  %52 = add i16 %51, 1
  %53 = add i16 %48, %52
  %54 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %48
  %55 = load ptr, ptr %54
  %56 = getelementptr %inner_node_t_2, ptr %9, i32 0, i32 1, i16 %53
  store ptr %55, ptr %56
  %57 = add i16 1, %48
  br label %for_begin_2
for_end_2:
  br label %for_begin_3
for_begin_3:
  %58 = phi i16 [0, %for_end_2], [%68, %for_body_3]
  %59 = icmp ult i16 %58, %14
  br i1 %59, label %for_body_3, label %for_end_3
for_body_3:
  %60 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %61 = load i16, ptr %60
  %62 = add i16 %61, 1
  %63 = add i16 %58, %62
  %64 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %58
  %65 = load ptr, ptr %64
  %66 = getelementptr %node_t_2, ptr %65, i32 0, i32 0, i32 0
  store ptr %9, ptr %66
  %67 = getelementptr %node_t_2, ptr %65, i32 0, i32 0, i32 1
  store i16 %63, ptr %67
  %68 = add i16 1, %58
  br label %for_begin_3
for_end_3:
  %69 = sub i16 %36, %14
  %70 = add i16 1, %69
  br label %for_begin_4
for_begin_4:
  %71 = phi i16 [0, %for_end_3], [%80, %for_body_4]
  %72 = icmp ult i16 %71, %70
  br i1 %72, label %for_body_4, label %for_end_4
for_body_4:
  %73 = add i16 %71, %14
  %74 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %73
  %75 = load ptr, ptr %74
  %76 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %71
  store ptr %75, ptr %76
  %77 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %71
  %78 = load ptr, ptr %77
  %79 = getelementptr %node_t_2, ptr %78, i32 0, i32 0, i32 1
  store i16 %71, ptr %79
  %80 = add i16 1, %71
  br label %for_begin_4
for_end_4:
  br label %end_if_0
end_if_0:
  %81 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %82 = load i16, ptr %81
  %83 = add i16 %82, %14
  store i16 %83, ptr %81
  %84 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %85 = load i16, ptr %84
  %86 = sub i16 %85, %14
  store i16 %86, ptr %84
  ret i16 %14
end_if_1:
  br label %split_0
split_0:
  call ccc void @eclair_btree_node_split_2(ptr %node_0, ptr %root_0)
  ret i16 0
}

define external ccc i1 @eclair_btree_insert_value_2(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca ptr
  %stack.ptr_1 = alloca i16
  %0 = call ccc i1 @eclair_btree_is_empty_2(ptr %tree_0)
  br i1 %0, label %empty_0, label %non_empty_0
empty_0:
  %1 = call ccc ptr @eclair_btree_node_new_2(i1 0)
  %2 = getelementptr %node_t_2, ptr %1, i32 0, i32 0, i32 2
  store i16 1, ptr %2
  %3 = load [2 x i32], ptr %val_0
  %4 = getelementptr %node_t_2, ptr %1, i32 0, i32 1, i16 0
  store [2 x i32] %3, ptr %4
  %5 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 1
  store ptr %1, ptr %6
  br label %inserted_new_value_0
non_empty_0:
  %7 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %8 = load ptr, ptr %7
  store ptr %8, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %9 = load ptr, ptr %stack.ptr_0
  %10 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 3
  %11 = load i1, ptr %10
  %12 = icmp eq i1 %11, 1
  br i1 %12, label %inner_0, label %leaf_0
inner_0:
  %13 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %14 = load i16, ptr %13
  %15 = getelementptr %node_t_2, ptr %9, i32 0, i32 1, i16 0
  %16 = getelementptr %node_t_2, ptr %9, i32 0, i32 1, i16 %14
  %17 = call ccc ptr @eclair_btree_linear_search_lower_bound_2(ptr %val_0, ptr %15, ptr %16)
  %18 = ptrtoint ptr %17 to i64
  %19 = ptrtoint ptr %15 to i64
  %20 = sub i64 %18, %19
  %21 = trunc i64 %20 to i16
  %22 = udiv i16 %21, 8
  %23 = icmp ne ptr %17, %16
  br i1 %23, label %if_0, label %end_if_0
if_0:
  %24 = call ccc i8 @eclair_btree_value_compare_values_2(ptr %17, ptr %val_0)
  %25 = icmp eq i8 0, %24
  br i1 %25, label %no_insert_0, label %inner_continue_insert_0
end_if_0:
  br label %inner_continue_insert_0
inner_continue_insert_0:
  %26 = getelementptr %inner_node_t_2, ptr %9, i32 0, i32 1, i16 %22
  %27 = load ptr, ptr %26
  store ptr %27, ptr %stack.ptr_0
  br label %loop_0
leaf_0:
  %28 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %29 = load i16, ptr %28
  %30 = getelementptr %node_t_2, ptr %9, i32 0, i32 1, i16 0
  %31 = getelementptr %node_t_2, ptr %9, i32 0, i32 1, i16 %29
  %32 = call ccc ptr @eclair_btree_linear_search_upper_bound_2(ptr %val_0, ptr %30, ptr %31)
  %33 = ptrtoint ptr %32 to i64
  %34 = ptrtoint ptr %30 to i64
  %35 = sub i64 %33, %34
  %36 = trunc i64 %35 to i16
  %37 = udiv i16 %36, 8
  store i16 %37, ptr %stack.ptr_1
  %38 = icmp ne ptr %32, %30
  br i1 %38, label %if_1, label %end_if_1
if_1:
  %39 = getelementptr [2 x i32], ptr %32, i32 -1
  %40 = call ccc i8 @eclair_btree_value_compare_values_2(ptr %39, ptr %val_0)
  %41 = icmp eq i8 0, %40
  br i1 %41, label %no_insert_0, label %leaf_continue_insert_0
end_if_1:
  br label %leaf_continue_insert_0
leaf_continue_insert_0:
  %42 = icmp uge i16 %29, 30
  br i1 %42, label %split_0, label %no_split_0
split_0:
  %43 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %44 = load i16, ptr %stack.ptr_1
  %45 = call ccc i16 @eclair_btree_node_rebalance_or_split_2(ptr %9, ptr %43, i16 %44)
  %46 = sub i16 %44, %45
  store i16 %46, ptr %stack.ptr_1
  %47 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 2
  %48 = load i16, ptr %47
  %49 = icmp ugt i16 %46, %48
  br i1 %49, label %if_2, label %end_if_2
if_2:
  %50 = add i16 %48, 1
  %51 = sub i16 %46, %50
  store i16 %51, ptr %stack.ptr_1
  %52 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 0
  %53 = load ptr, ptr %52
  %54 = getelementptr %node_t_2, ptr %9, i32 0, i32 0, i32 1
  %55 = load i16, ptr %54
  %56 = add i16 1, %55
  %57 = getelementptr %inner_node_t_2, ptr %53, i32 0, i32 1, i16 %56
  %58 = load ptr, ptr %57
  store ptr %58, ptr %stack.ptr_0
  br label %end_if_2
end_if_2:
  br label %no_split_0
no_split_0:
  %59 = load ptr, ptr %stack.ptr_0
  %60 = load i16, ptr %stack.ptr_1
  %61 = getelementptr %node_t_2, ptr %59, i32 0, i32 0, i32 2
  %62 = load i16, ptr %61
  br label %for_begin_0
for_begin_0:
  %63 = phi i16 [%62, %no_split_0], [%69, %for_body_0]
  %64 = icmp ugt i16 %63, %60
  br i1 %64, label %for_body_0, label %for_end_0
for_body_0:
  %65 = sub i16 %63, 1
  %66 = getelementptr %node_t_2, ptr %59, i32 0, i32 1, i16 %65
  %67 = load [2 x i32], ptr %66
  %68 = getelementptr %node_t_2, ptr %59, i32 0, i32 1, i16 %63
  store [2 x i32] %67, ptr %68
  %69 = sub i16 %63, 1
  br label %for_begin_0
for_end_0:
  %70 = load [2 x i32], ptr %val_0
  %71 = getelementptr %node_t_2, ptr %59, i32 0, i32 1, i16 %60
  store [2 x i32] %70, ptr %71
  %72 = getelementptr %node_t_2, ptr %59, i32 0, i32 0, i32 2
  %73 = load i16, ptr %72
  %74 = add i16 1, %73
  store i16 %74, ptr %72
  br label %inserted_new_value_0
no_insert_0:
  ret i1 0
inserted_new_value_0:
  ret i1 1
}

define external ccc void @eclair_btree_insert_range__2(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_2(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_2(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_2(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_2(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_begin_2(ptr %tree_0, ptr %result_0) {
start:
  %0 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 1
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_2, ptr %result_0, i32 0, i32 0
  store ptr %1, ptr %2
  %3 = getelementptr %btree_iterator_t_2, ptr %result_0, i32 0, i32 1
  store i16 0, ptr %3
  ret void
}

define external ccc void @eclair_btree_end_2(ptr %tree_0, ptr %result_0) {
start:
  call ccc void @eclair_btree_iterator_end_init_2(ptr %result_0)
  ret void
}

define external ccc i1 @eclair_btree_contains_2(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_1 = alloca %btree_iterator_t_2, i32 1
  call ccc void @eclair_btree_find_2(ptr %tree_0, ptr %val_0, ptr %stack.ptr_0)
  call ccc void @eclair_btree_end_2(ptr %tree_0, ptr %stack.ptr_1)
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_2(ptr %stack.ptr_0, ptr %stack.ptr_1)
  %1 = select i1 %0, i1 0, i1 1
  ret i1 %1
}

define external ccc void @eclair_btree_find_2(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_2(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_2(ptr %result_0)
  ret void
end_if_0:
  %1 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_0
  %4 = getelementptr %node_t_2, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_2, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_2, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_2(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 8
  %14 = icmp ult ptr %8, %7
  br i1 %14, label %if_1, label %end_if_2
if_1:
  %15 = call ccc i8 @eclair_btree_value_compare_values_2(ptr %8, ptr %val_0)
  %16 = icmp eq i8 0, %15
  br i1 %16, label %if_2, label %end_if_1
if_2:
  call ccc void @eclair_btree_iterator_init_2(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  br label %end_if_2
end_if_2:
  %17 = getelementptr %node_t_2, ptr %3, i32 0, i32 0, i32 3
  %18 = load i1, ptr %17
  %19 = icmp eq i1 %18, 0
  br i1 %19, label %if_3, label %end_if_3
if_3:
  call ccc void @eclair_btree_iterator_end_init_2(ptr %result_0)
  ret void
end_if_3:
  %20 = getelementptr %inner_node_t_2, ptr %3, i32 0, i32 1, i16 %13
  %21 = load ptr, ptr %20
  store ptr %21, ptr %stack.ptr_0
  br label %loop_0
}

define external ccc void @eclair_btree_lower_bound_2(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_2(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_2(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_2(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_2, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_2, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_2, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_2(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 8
  %14 = getelementptr %node_t_2, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_2, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_2, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_2, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_2, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_2(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_3
if_2:
  %25 = call ccc i8 @eclair_btree_value_compare_values_2(ptr %8, ptr %val_0)
  %26 = icmp eq i8 0, %25
  br i1 %26, label %if_3, label %end_if_2
if_3:
  call ccc void @eclair_btree_iterator_init_2(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_2:
  br label %end_if_3
end_if_3:
  br i1 %24, label %if_4, label %end_if_4
if_4:
  call ccc void @eclair_btree_iterator_init_2(ptr %stack.ptr_0, ptr %3, i16 %13)
  br label %end_if_4
end_if_4:
  %27 = getelementptr %inner_node_t_2, ptr %3, i32 0, i32 1, i16 %13
  %28 = load ptr, ptr %27
  store ptr %28, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_upper_bound_2(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_2(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_2(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_2(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_2, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_2, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_2, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_upper_bound_2(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 8
  %14 = getelementptr %node_t_2, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_2, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_2, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_2, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_2, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_2(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_2
if_2:
  call ccc void @eclair_btree_iterator_init_2(ptr %result_0, ptr %3, i16 %13)
  br label %end_if_2
end_if_2:
  %25 = getelementptr %inner_node_t_2, ptr %3, i32 0, i32 1, i16 %13
  %26 = load ptr, ptr %25
  store ptr %26, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_node_delete_2(ptr %node_0) {
start:
  %0 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 3
  %1 = load i1, ptr %0
  %2 = icmp eq i1 %1, 1
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = getelementptr %node_t_2, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [0, %if_0], [%10, %end_if_0]
  %6 = icmp ule i16 %5, %4
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = getelementptr %inner_node_t_2, ptr %node_0, i32 0, i32 1, i16 %5
  %8 = load ptr, ptr %7
  %9 = icmp ne ptr %8, zeroinitializer
  br i1 %9, label %if_1, label %end_if_0
if_1:
  call ccc void @eclair_btree_node_delete_2(ptr %8)
  br label %end_if_0
end_if_0:
  %10 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  br label %end_if_1
end_if_1:
  call ccc void @free(ptr %node_0)
  ret void
}

define external ccc void @eclair_btree_clear_2(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp ne ptr %1, zeroinitializer
  br i1 %2, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_node_delete_2(ptr %1)
  %3 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %3
  %4 = getelementptr %btree_t_2, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %4
  br label %end_if_0
end_if_0:
  ret void
}

define external ccc void @eclair_btree_swap_2(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_t_2, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_t_2, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %btree_t_2, ptr %lhs_0, i32 0, i32 0
  store ptr %3, ptr %4
  %5 = getelementptr %btree_t_2, ptr %rhs_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_2, ptr %lhs_0, i32 0, i32 1
  %7 = load ptr, ptr %6
  %8 = getelementptr %btree_t_2, ptr %rhs_0, i32 0, i32 1
  %9 = load ptr, ptr %8
  %10 = getelementptr %btree_t_2, ptr %lhs_0, i32 0, i32 1
  store ptr %9, ptr %10
  %11 = getelementptr %btree_t_2, ptr %rhs_0, i32 0, i32 1
  store ptr %7, ptr %11
  ret void
}

%node_data_t_3 = type {ptr, i16, i16, i1}

%node_t_3 = type {%node_data_t_3, [20 x [3 x i32]]}

%inner_node_t_3 = type {%node_t_3, [21 x ptr]}

%btree_iterator_t_3 = type {ptr, i16}

%btree_t_3 = type {ptr, ptr}

define external ccc i8 @eclair_btree_value_compare_3(i32 %lhs_0, i32 %rhs_0) {
start:
  %0 = icmp ult i32 %lhs_0, %rhs_0
  br i1 %0, label %if_0, label %end_if_0
if_0:
  ret i8 -1
end_if_0:
  %1 = icmp ugt i32 %lhs_0, %rhs_0
  %2 = select i1 %1, i8 1, i8 0
  ret i8 %2
}

define external ccc i8 @eclair_btree_value_compare_values_3(ptr %lhs_0, ptr %rhs_0) {
start:
  br label %comparison_0
comparison_0:
  %0 = getelementptr [3 x i32], ptr %lhs_0, i32 0, i32 1
  %1 = getelementptr [3 x i32], ptr %rhs_0, i32 0, i32 1
  %2 = load i32, ptr %0
  %3 = load i32, ptr %1
  %4 = call ccc i8 @eclair_btree_value_compare_3(i32 %2, i32 %3)
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %comparison_1, label %end_0
comparison_1:
  %6 = getelementptr [3 x i32], ptr %lhs_0, i32 0, i32 2
  %7 = getelementptr [3 x i32], ptr %rhs_0, i32 0, i32 2
  %8 = load i32, ptr %6
  %9 = load i32, ptr %7
  %10 = call ccc i8 @eclair_btree_value_compare_3(i32 %8, i32 %9)
  br label %end_0
end_0:
  %11 = phi i8 [%4, %comparison_0], [%10, %comparison_1]
  ret i8 %11
}

define external ccc ptr @eclair_btree_node_new_3(i1 %type_0) {
start:
  %0 = select i1 %type_0, i32 424, i32 256
  %1 = call ccc ptr @malloc(i32 %0)
  %2 = getelementptr %node_t_3, ptr %1, i32 0, i32 0, i32 0
  store ptr zeroinitializer, ptr %2
  %3 = getelementptr %node_t_3, ptr %1, i32 0, i32 0, i32 1
  store i16 0, ptr %3
  %4 = getelementptr %node_t_3, ptr %1, i32 0, i32 0, i32 2
  store i16 0, ptr %4
  %5 = getelementptr %node_t_3, ptr %1, i32 0, i32 0, i32 3
  store i1 %type_0, ptr %5
  %6 = getelementptr %node_t_3, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %6, i8 0, i64 240, i1 0)
  %7 = icmp eq i1 %type_0, 1
  br i1 %7, label %if_0, label %end_if_0
if_0:
  %8 = getelementptr %inner_node_t_3, ptr %1, i32 0, i32 1
  call ccc void @llvm.memset.p0i8.i64(ptr %8, i8 0, i64 168, i1 0)
  br label %end_if_0
end_if_0:
  ret ptr %1
}

define external ccc i64 @eclair_btree_node_count_entries_3(ptr %node_0) {
start:
  %stack.ptr_0 = alloca i64
  %0 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 0
  %5 = zext i16 %1 to i64
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i64 %5
end_if_0:
  store i64 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  br label %for_begin_0
for_begin_0:
  %8 = phi i16 [0, %end_if_0], [%15, %for_body_0]
  %9 = icmp ule i16 %8, %7
  br i1 %9, label %for_body_0, label %for_end_0
for_body_0:
  %10 = load i64, ptr %stack.ptr_0
  %11 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %8
  %12 = load ptr, ptr %11
  %13 = call ccc i64 @eclair_btree_node_count_entries_3(ptr %12)
  %14 = add i64 %10, %13
  store i64 %14, ptr %stack.ptr_0
  %15 = add i16 1, %8
  br label %for_begin_0
for_end_0:
  %16 = load i64, ptr %stack.ptr_0
  ret i64 %16
}

define external ccc void @eclair_btree_iterator_init_3(ptr %iter_0, ptr %cur_0, i16 %pos_0) {
start:
  %0 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  store ptr %cur_0, ptr %0
  %1 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  store i16 %pos_0, ptr %1
  ret void
}

define external ccc void @eclair_btree_iterator_end_init_3(ptr %iter_0) {
start:
  call ccc void @eclair_btree_iterator_init_3(ptr %iter_0, ptr zeroinitializer, i16 0)
  ret void
}

define external ccc i1 @eclair_btree_iterator_is_equal_3(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_iterator_t_3, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_3, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = icmp ne ptr %1, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i1 0
end_if_0:
  %5 = getelementptr %btree_iterator_t_3, ptr %lhs_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = getelementptr %btree_iterator_t_3, ptr %rhs_0, i32 0, i32 1
  %8 = load i16, ptr %7
  %9 = icmp eq i16 %6, %8
  ret i1 %9
}

define external ccc ptr @eclair_btree_iterator_current_3(ptr %iter_0) {
start:
  %0 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  %1 = load i16, ptr %0
  %2 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %node_t_3, ptr %3, i32 0, i32 1, i16 %1
  ret ptr %4
}

define external ccc void @eclair_btree_iterator_next_3(ptr %iter_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_3, ptr %1, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = icmp eq i1 %3, 1
  br i1 %4, label %if_0, label %end_if_1
if_0:
  %5 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  %6 = load i16, ptr %5
  %7 = add i16 1, %6
  %8 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  %9 = load ptr, ptr %8
  %10 = getelementptr %inner_node_t_3, ptr %9, i32 0, i32 1, i16 %7
  %11 = load ptr, ptr %10
  store ptr %11, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %12 = load ptr, ptr %stack.ptr_0
  %13 = getelementptr %node_t_3, ptr %12, i32 0, i32 0, i32 3
  %14 = load i1, ptr %13
  %15 = icmp eq i1 %14, 1
  br i1 %15, label %while_body_0, label %while_end_0
while_body_0:
  %16 = load ptr, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_3, ptr %16, i32 0, i32 1, i16 0
  %18 = load ptr, ptr %17
  store ptr %18, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  %19 = load ptr, ptr %stack.ptr_0
  %20 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  store i16 0, ptr %21
  %22 = getelementptr %node_t_3, ptr %19, i32 0, i32 0, i32 2
  %23 = load i16, ptr %22
  %24 = icmp ne i16 %23, 0
  br i1 %24, label %if_1, label %end_if_0
if_1:
  ret void
end_if_0:
  br label %leaf.next_0
end_if_1:
  br label %leaf.next_0
leaf.next_0:
  %25 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  %26 = load i16, ptr %25
  %27 = add i16 1, %26
  store i16 %27, ptr %25
  %28 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  %29 = load i16, ptr %28
  %30 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  %31 = load ptr, ptr %30
  %32 = getelementptr %node_t_3, ptr %31, i32 0, i32 0, i32 2
  %33 = load i16, ptr %32
  %34 = icmp ult i16 %29, %33
  br i1 %34, label %if_2, label %end_if_2
if_2:
  ret void
end_if_2:
  br label %while_begin_1
while_begin_1:
  %35 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  %36 = load ptr, ptr %35
  %37 = icmp eq ptr %36, zeroinitializer
  br i1 %37, label %leaf.no_parent_0, label %leaf.has_parent_0
leaf.no_parent_0:
  br label %loop.condition.end_0
leaf.has_parent_0:
  %38 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  %39 = load i16, ptr %38
  %40 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  %41 = load ptr, ptr %40
  %42 = getelementptr %node_t_3, ptr %41, i32 0, i32 0, i32 2
  %43 = load i16, ptr %42
  %44 = icmp eq i16 %39, %43
  br label %loop.condition.end_0
loop.condition.end_0:
  %45 = phi i1 [0, %leaf.no_parent_0], [%44, %leaf.has_parent_0]
  br i1 %45, label %while_body_1, label %while_end_1
while_body_1:
  %46 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  %47 = load ptr, ptr %46
  %48 = getelementptr %node_t_3, ptr %47, i32 0, i32 0, i32 1
  %49 = load i16, ptr %48
  %50 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 1
  store i16 %49, ptr %50
  %51 = getelementptr %node_t_3, ptr %47, i32 0, i32 0, i32 0
  %52 = load ptr, ptr %51
  %53 = getelementptr %btree_iterator_t_3, ptr %iter_0, i32 0, i32 0
  store ptr %52, ptr %53
  br label %while_begin_1
while_end_1:
  ret void
}

define external ccc ptr @eclair_btree_linear_search_lower_bound_3(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_3(ptr %2, ptr %val_0)
  %4 = icmp ne i8 %3, -1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [3 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc ptr @eclair_btree_linear_search_upper_bound_3(ptr %val_0, ptr %current_0, ptr %end_0) {
start:
  %stack.ptr_0 = alloca ptr
  store ptr %current_0, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %0 = load ptr, ptr %stack.ptr_0
  %1 = icmp ne ptr %0, %end_0
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = call ccc i8 @eclair_btree_value_compare_values_3(ptr %2, ptr %val_0)
  %4 = icmp eq i8 %3, 1
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret ptr %2
end_if_0:
  %5 = getelementptr [3 x i32], ptr %2, i32 1
  store ptr %5, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  ret ptr %end_0
}

define external ccc void @eclair_btree_init_empty_3(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %0
  %1 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %1
  ret void
}

define external ccc void @eclair_btree_init_3(ptr %tree_0, ptr %start_0, ptr %end_0) {
start:
  call ccc void @eclair_btree_insert_range__3(ptr %tree_0, ptr %start_0, ptr %end_0)
  ret void
}

define external ccc void @eclair_btree_destroy_3(ptr %tree_0) {
start:
  call ccc void @eclair_btree_clear_3(ptr %tree_0)
  ret void
}

define external ccc i1 @eclair_btree_is_empty_3(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  ret i1 %2
}

define external ccc i64 @eclair_btree_size_3(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  br i1 %2, label %null_0, label %not_null_0
null_0:
  ret i64 0
not_null_0:
  %3 = call ccc i64 @eclair_btree_node_count_entries_3(ptr %1)
  ret i64 %3
}

define external ccc i16 @eclair_btree_node_split_point_3() {
start:
  %0 = mul i16 3, 20
  %1 = udiv i16 %0, 4
  %2 = sub i16 20, 2
  %3 = icmp ult i16 %1, %2
  %4 = select i1 %3, i16 %1, i16 %2
  ret i16 %4
}

define external ccc void @eclair_btree_node_split_3(ptr %node_0, ptr %root_0) {
start:
  %stack.ptr_0 = alloca i16
  %0 = call ccc i16 @eclair_btree_node_split_point_3()
  %1 = add i16 1, %0
  %2 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 3
  %3 = load i1, ptr %2
  %4 = call ccc ptr @eclair_btree_node_new_3(i1 %3)
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [%1, %start], [%12, %for_body_0]
  %6 = icmp ult i16 %5, 20
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = load i16, ptr %stack.ptr_0
  %8 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %5
  %9 = load [3 x i32], ptr %8
  %10 = getelementptr %node_t_3, ptr %4, i32 0, i32 1, i16 %7
  store [3 x i32] %9, ptr %10
  %11 = add i16 1, %7
  store i16 %11, ptr %stack.ptr_0
  %12 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  %13 = icmp eq i1 %3, 1
  br i1 %13, label %if_0, label %end_if_0
if_0:
  store i16 0, ptr %stack.ptr_0
  br label %for_begin_1
for_begin_1:
  %14 = phi i16 [%1, %if_0], [%23, %for_body_1]
  %15 = icmp ule i16 %14, 20
  br i1 %15, label %for_body_1, label %for_end_1
for_body_1:
  %16 = load i16, ptr %stack.ptr_0
  %17 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %14
  %18 = load ptr, ptr %17
  %19 = getelementptr %node_t_3, ptr %18, i32 0, i32 0, i32 0
  store ptr %4, ptr %19
  %20 = getelementptr %node_t_3, ptr %18, i32 0, i32 0, i32 1
  store i16 %16, ptr %20
  %21 = getelementptr %inner_node_t_3, ptr %4, i32 0, i32 1, i16 %16
  store ptr %18, ptr %21
  %22 = add i16 1, %16
  store i16 %22, ptr %stack.ptr_0
  %23 = add i16 1, %14
  br label %for_begin_1
for_end_1:
  br label %end_if_0
end_if_0:
  %24 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  store i16 %0, ptr %24
  %25 = sub i16 20, %0
  %26 = sub i16 %25, 1
  %27 = getelementptr %node_t_3, ptr %4, i32 0, i32 0, i32 2
  store i16 %26, ptr %27
  call ccc void @eclair_btree_node_grow_parent_3(ptr %node_0, ptr %root_0, ptr %4)
  ret void
}

define external ccc void @eclair_btree_node_grow_parent_3(ptr %node_0, ptr %root_0, ptr %sibling_0) {
start:
  %0 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp eq ptr %1, zeroinitializer
  %3 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br i1 %2, label %create_new_root_0, label %insert_new_node_in_parent_0
create_new_root_0:
  %5 = call ccc ptr @eclair_btree_node_new_3(i1 1)
  %6 = getelementptr %node_t_3, ptr %5, i32 0, i32 0, i32 2
  store i16 1, ptr %6
  %7 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %4
  %8 = load [3 x i32], ptr %7
  %9 = getelementptr %node_t_3, ptr %5, i32 0, i32 1, i16 0
  store [3 x i32] %8, ptr %9
  %10 = getelementptr %inner_node_t_3, ptr %5, i32 0, i32 1, i16 0
  store ptr %node_0, ptr %10
  %11 = getelementptr %inner_node_t_3, ptr %5, i32 0, i32 1, i16 1
  store ptr %sibling_0, ptr %11
  %12 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %12
  %13 = getelementptr %node_t_3, ptr %sibling_0, i32 0, i32 0, i32 0
  store ptr %5, ptr %13
  %14 = getelementptr %node_t_3, ptr %sibling_0, i32 0, i32 0, i32 1
  store i16 1, ptr %14
  store ptr %5, ptr %root_0
  ret void
insert_new_node_in_parent_0:
  %15 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 1
  %16 = load i16, ptr %15
  %17 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %4
  call ccc void @eclair_btree_node_insert_inner_3(ptr %1, ptr %root_0, i16 %16, ptr %node_0, ptr %17, ptr %sibling_0)
  ret void
}

define external ccc void @eclair_btree_node_insert_inner_3(ptr %node_0, ptr %root_0, i16 %pos_0, ptr %predecessor_0, ptr %key_0, ptr %new_node_0) {
start:
  %stack.ptr_0 = alloca i16
  store i16 %pos_0, ptr %stack.ptr_0
  %0 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %1 = load i16, ptr %0
  %2 = icmp uge i16 %1, 20
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = load i16, ptr %stack.ptr_0
  %4 = call ccc i16 @eclair_btree_node_rebalance_or_split_3(ptr %node_0, ptr %root_0, i16 %pos_0)
  %5 = sub i16 %3, %4
  store i16 %5, ptr %stack.ptr_0
  %6 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %7 = load i16, ptr %6
  %8 = icmp ugt i16 %5, %7
  br i1 %8, label %if_1, label %end_if_0
if_1:
  %9 = sub i16 %5, %7
  %10 = sub i16 %9, 1
  store i16 %10, ptr %stack.ptr_0
  %11 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 0
  %12 = load ptr, ptr %11
  %13 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 1
  %14 = load i16, ptr %13
  %15 = add i16 1, %14
  %16 = getelementptr %inner_node_t_3, ptr %12, i32 0, i32 1, i16 %15
  %17 = load ptr, ptr %16
  call ccc void @eclair_btree_node_insert_inner_3(ptr %17, ptr %root_0, i16 %10, ptr %predecessor_0, ptr %key_0, ptr %new_node_0)
  ret void
end_if_0:
  br label %end_if_1
end_if_1:
  %18 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %19 = load i16, ptr %18
  %20 = sub i16 %19, 1
  %21 = load i16, ptr %stack.ptr_0
  br label %for_begin_0
for_begin_0:
  %22 = phi i16 [%20, %end_if_1], [%37, %for_body_0]
  %23 = icmp sge i16 %22, %21
  br i1 %23, label %for_body_0, label %for_end_0
for_body_0:
  %24 = add i16 %22, 1
  %25 = add i16 %22, 2
  %26 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %22
  %27 = load [3 x i32], ptr %26
  %28 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %24
  store [3 x i32] %27, ptr %28
  %29 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %24
  %30 = load ptr, ptr %29
  %31 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %25
  store ptr %30, ptr %31
  %32 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %25
  %33 = load ptr, ptr %32
  %34 = getelementptr %node_t_3, ptr %33, i32 0, i32 0, i32 1
  %35 = load i16, ptr %34
  %36 = add i16 1, %35
  store i16 %36, ptr %34
  %37 = sub i16 %22, 1
  br label %for_begin_0
for_end_0:
  %38 = load [3 x i32], ptr %key_0
  %39 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %21
  store [3 x i32] %38, ptr %39
  %40 = add i16 %21, 1
  %41 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %40
  store ptr %new_node_0, ptr %41
  %42 = getelementptr %node_t_3, ptr %new_node_0, i32 0, i32 0, i32 0
  store ptr %node_0, ptr %42
  %43 = getelementptr %node_t_3, ptr %new_node_0, i32 0, i32 0, i32 1
  store i16 %40, ptr %43
  %44 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %45 = load i16, ptr %44
  %46 = add i16 1, %45
  store i16 %46, ptr %44
  ret void
}

define external ccc i16 @eclair_btree_node_rebalance_or_split_3(ptr %node_0, ptr %root_0, i16 %idx_0) {
start:
  %0 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 1
  %3 = load i16, ptr %2
  %4 = icmp ne ptr %1, zeroinitializer
  %5 = icmp ugt i16 %3, 0
  %6 = and i1 %4, %5
  br i1 %6, label %rebalance_0, label %split_0
rebalance_0:
  %7 = sub i16 %3, 1
  %8 = getelementptr %inner_node_t_3, ptr %1, i32 0, i32 1, i16 %7
  %9 = load ptr, ptr %8
  %10 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %11 = load i16, ptr %10
  %12 = sub i16 20, %11
  %13 = icmp slt i16 %12, %idx_0
  %14 = select i1 %13, i16 %12, i16 %idx_0
  %15 = icmp ugt i16 %14, 0
  br i1 %15, label %if_0, label %end_if_1
if_0:
  %16 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 1
  %17 = load i16, ptr %16
  %18 = sub i16 %17, 1
  %19 = getelementptr %inner_node_t_3, ptr %1, i32 0, i32 0, i32 1, i16 %18
  %20 = load [3 x i32], ptr %19
  %21 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %22 = load i16, ptr %21
  %23 = getelementptr %node_t_3, ptr %9, i32 0, i32 1, i16 %22
  store [3 x i32] %20, ptr %23
  %24 = sub i16 %14, 1
  br label %for_begin_0
for_begin_0:
  %25 = phi i16 [0, %if_0], [%32, %for_body_0]
  %26 = icmp ult i16 %25, %24
  br i1 %26, label %for_body_0, label %for_end_0
for_body_0:
  %27 = add i16 %22, 1
  %28 = add i16 %25, %27
  %29 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %25
  %30 = load [3 x i32], ptr %29
  %31 = getelementptr %node_t_3, ptr %9, i32 0, i32 1, i16 %28
  store [3 x i32] %30, ptr %31
  %32 = add i16 1, %25
  br label %for_begin_0
for_end_0:
  %33 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %24
  %34 = load [3 x i32], ptr %33
  store [3 x i32] %34, ptr %19
  %35 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %36 = load i16, ptr %35
  %37 = sub i16 %36, %14
  br label %for_begin_1
for_begin_1:
  %38 = phi i16 [0, %for_end_0], [%44, %for_body_1]
  %39 = icmp ult i16 %38, %37
  br i1 %39, label %for_body_1, label %for_end_1
for_body_1:
  %40 = add i16 %38, %14
  %41 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %40
  %42 = load [3 x i32], ptr %41
  %43 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 1, i16 %38
  store [3 x i32] %42, ptr %43
  %44 = add i16 1, %38
  br label %for_begin_1
for_end_1:
  %45 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 3
  %46 = load i1, ptr %45
  %47 = icmp eq i1 %46, 1
  br i1 %47, label %if_1, label %end_if_0
if_1:
  br label %for_begin_2
for_begin_2:
  %48 = phi i16 [0, %if_1], [%57, %for_body_2]
  %49 = icmp ult i16 %48, %14
  br i1 %49, label %for_body_2, label %for_end_2
for_body_2:
  %50 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %51 = load i16, ptr %50
  %52 = add i16 %51, 1
  %53 = add i16 %48, %52
  %54 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %48
  %55 = load ptr, ptr %54
  %56 = getelementptr %inner_node_t_3, ptr %9, i32 0, i32 1, i16 %53
  store ptr %55, ptr %56
  %57 = add i16 1, %48
  br label %for_begin_2
for_end_2:
  br label %for_begin_3
for_begin_3:
  %58 = phi i16 [0, %for_end_2], [%68, %for_body_3]
  %59 = icmp ult i16 %58, %14
  br i1 %59, label %for_body_3, label %for_end_3
for_body_3:
  %60 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %61 = load i16, ptr %60
  %62 = add i16 %61, 1
  %63 = add i16 %58, %62
  %64 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %58
  %65 = load ptr, ptr %64
  %66 = getelementptr %node_t_3, ptr %65, i32 0, i32 0, i32 0
  store ptr %9, ptr %66
  %67 = getelementptr %node_t_3, ptr %65, i32 0, i32 0, i32 1
  store i16 %63, ptr %67
  %68 = add i16 1, %58
  br label %for_begin_3
for_end_3:
  %69 = sub i16 %36, %14
  %70 = add i16 1, %69
  br label %for_begin_4
for_begin_4:
  %71 = phi i16 [0, %for_end_3], [%80, %for_body_4]
  %72 = icmp ult i16 %71, %70
  br i1 %72, label %for_body_4, label %for_end_4
for_body_4:
  %73 = add i16 %71, %14
  %74 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %73
  %75 = load ptr, ptr %74
  %76 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %71
  store ptr %75, ptr %76
  %77 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %71
  %78 = load ptr, ptr %77
  %79 = getelementptr %node_t_3, ptr %78, i32 0, i32 0, i32 1
  store i16 %71, ptr %79
  %80 = add i16 1, %71
  br label %for_begin_4
for_end_4:
  br label %end_if_0
end_if_0:
  %81 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %82 = load i16, ptr %81
  %83 = add i16 %82, %14
  store i16 %83, ptr %81
  %84 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %85 = load i16, ptr %84
  %86 = sub i16 %85, %14
  store i16 %86, ptr %84
  ret i16 %14
end_if_1:
  br label %split_0
split_0:
  call ccc void @eclair_btree_node_split_3(ptr %node_0, ptr %root_0)
  ret i16 0
}

define external ccc i1 @eclair_btree_insert_value_3(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca ptr
  %stack.ptr_1 = alloca i16
  %0 = call ccc i1 @eclair_btree_is_empty_3(ptr %tree_0)
  br i1 %0, label %empty_0, label %non_empty_0
empty_0:
  %1 = call ccc ptr @eclair_btree_node_new_3(i1 0)
  %2 = getelementptr %node_t_3, ptr %1, i32 0, i32 0, i32 2
  store i16 1, ptr %2
  %3 = load [3 x i32], ptr %val_0
  %4 = getelementptr %node_t_3, ptr %1, i32 0, i32 1, i16 0
  store [3 x i32] %3, ptr %4
  %5 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 1
  store ptr %1, ptr %6
  br label %inserted_new_value_0
non_empty_0:
  %7 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %8 = load ptr, ptr %7
  store ptr %8, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %9 = load ptr, ptr %stack.ptr_0
  %10 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 3
  %11 = load i1, ptr %10
  %12 = icmp eq i1 %11, 1
  br i1 %12, label %inner_0, label %leaf_0
inner_0:
  %13 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %14 = load i16, ptr %13
  %15 = getelementptr %node_t_3, ptr %9, i32 0, i32 1, i16 0
  %16 = getelementptr %node_t_3, ptr %9, i32 0, i32 1, i16 %14
  %17 = call ccc ptr @eclair_btree_linear_search_lower_bound_3(ptr %val_0, ptr %15, ptr %16)
  %18 = ptrtoint ptr %17 to i64
  %19 = ptrtoint ptr %15 to i64
  %20 = sub i64 %18, %19
  %21 = trunc i64 %20 to i16
  %22 = udiv i16 %21, 12
  %23 = icmp ne ptr %17, %16
  br i1 %23, label %if_0, label %end_if_0
if_0:
  %24 = call ccc i8 @eclair_btree_value_compare_values_3(ptr %17, ptr %val_0)
  %25 = icmp eq i8 0, %24
  br i1 %25, label %no_insert_0, label %inner_continue_insert_0
end_if_0:
  br label %inner_continue_insert_0
inner_continue_insert_0:
  %26 = getelementptr %inner_node_t_3, ptr %9, i32 0, i32 1, i16 %22
  %27 = load ptr, ptr %26
  store ptr %27, ptr %stack.ptr_0
  br label %loop_0
leaf_0:
  %28 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %29 = load i16, ptr %28
  %30 = getelementptr %node_t_3, ptr %9, i32 0, i32 1, i16 0
  %31 = getelementptr %node_t_3, ptr %9, i32 0, i32 1, i16 %29
  %32 = call ccc ptr @eclair_btree_linear_search_upper_bound_3(ptr %val_0, ptr %30, ptr %31)
  %33 = ptrtoint ptr %32 to i64
  %34 = ptrtoint ptr %30 to i64
  %35 = sub i64 %33, %34
  %36 = trunc i64 %35 to i16
  %37 = udiv i16 %36, 12
  store i16 %37, ptr %stack.ptr_1
  %38 = icmp ne ptr %32, %30
  br i1 %38, label %if_1, label %end_if_1
if_1:
  %39 = getelementptr [3 x i32], ptr %32, i32 -1
  %40 = call ccc i8 @eclair_btree_value_compare_values_3(ptr %39, ptr %val_0)
  %41 = icmp eq i8 0, %40
  br i1 %41, label %no_insert_0, label %leaf_continue_insert_0
end_if_1:
  br label %leaf_continue_insert_0
leaf_continue_insert_0:
  %42 = icmp uge i16 %29, 20
  br i1 %42, label %split_0, label %no_split_0
split_0:
  %43 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %44 = load i16, ptr %stack.ptr_1
  %45 = call ccc i16 @eclair_btree_node_rebalance_or_split_3(ptr %9, ptr %43, i16 %44)
  %46 = sub i16 %44, %45
  store i16 %46, ptr %stack.ptr_1
  %47 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 2
  %48 = load i16, ptr %47
  %49 = icmp ugt i16 %46, %48
  br i1 %49, label %if_2, label %end_if_2
if_2:
  %50 = add i16 %48, 1
  %51 = sub i16 %46, %50
  store i16 %51, ptr %stack.ptr_1
  %52 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 0
  %53 = load ptr, ptr %52
  %54 = getelementptr %node_t_3, ptr %9, i32 0, i32 0, i32 1
  %55 = load i16, ptr %54
  %56 = add i16 1, %55
  %57 = getelementptr %inner_node_t_3, ptr %53, i32 0, i32 1, i16 %56
  %58 = load ptr, ptr %57
  store ptr %58, ptr %stack.ptr_0
  br label %end_if_2
end_if_2:
  br label %no_split_0
no_split_0:
  %59 = load ptr, ptr %stack.ptr_0
  %60 = load i16, ptr %stack.ptr_1
  %61 = getelementptr %node_t_3, ptr %59, i32 0, i32 0, i32 2
  %62 = load i16, ptr %61
  br label %for_begin_0
for_begin_0:
  %63 = phi i16 [%62, %no_split_0], [%69, %for_body_0]
  %64 = icmp ugt i16 %63, %60
  br i1 %64, label %for_body_0, label %for_end_0
for_body_0:
  %65 = sub i16 %63, 1
  %66 = getelementptr %node_t_3, ptr %59, i32 0, i32 1, i16 %65
  %67 = load [3 x i32], ptr %66
  %68 = getelementptr %node_t_3, ptr %59, i32 0, i32 1, i16 %63
  store [3 x i32] %67, ptr %68
  %69 = sub i16 %63, 1
  br label %for_begin_0
for_end_0:
  %70 = load [3 x i32], ptr %val_0
  %71 = getelementptr %node_t_3, ptr %59, i32 0, i32 1, i16 %60
  store [3 x i32] %70, ptr %71
  %72 = getelementptr %node_t_3, ptr %59, i32 0, i32 0, i32 2
  %73 = load i16, ptr %72
  %74 = add i16 1, %73
  store i16 %74, ptr %72
  br label %inserted_new_value_0
no_insert_0:
  ret i1 0
inserted_new_value_0:
  ret i1 1
}

define external ccc void @eclair_btree_insert_range__3(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_3(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_3(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_3(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_3(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_begin_3(ptr %tree_0, ptr %result_0) {
start:
  %0 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 1
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_iterator_t_3, ptr %result_0, i32 0, i32 0
  store ptr %1, ptr %2
  %3 = getelementptr %btree_iterator_t_3, ptr %result_0, i32 0, i32 1
  store i16 0, ptr %3
  ret void
}

define external ccc void @eclair_btree_end_3(ptr %tree_0, ptr %result_0) {
start:
  call ccc void @eclair_btree_iterator_end_init_3(ptr %result_0)
  ret void
}

define external ccc i1 @eclair_btree_contains_3(ptr %tree_0, ptr %val_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_1 = alloca %btree_iterator_t_3, i32 1
  call ccc void @eclair_btree_find_3(ptr %tree_0, ptr %val_0, ptr %stack.ptr_0)
  call ccc void @eclair_btree_end_3(ptr %tree_0, ptr %stack.ptr_1)
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_3(ptr %stack.ptr_0, ptr %stack.ptr_1)
  %1 = select i1 %0, i1 0, i1 1
  ret i1 %1
}

define external ccc void @eclair_btree_find_3(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_3(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_3(ptr %result_0)
  ret void
end_if_0:
  %1 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_0
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_0
  %4 = getelementptr %node_t_3, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_3, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_3, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_3(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 12
  %14 = icmp ult ptr %8, %7
  br i1 %14, label %if_1, label %end_if_2
if_1:
  %15 = call ccc i8 @eclair_btree_value_compare_values_3(ptr %8, ptr %val_0)
  %16 = icmp eq i8 0, %15
  br i1 %16, label %if_2, label %end_if_1
if_2:
  call ccc void @eclair_btree_iterator_init_3(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  br label %end_if_2
end_if_2:
  %17 = getelementptr %node_t_3, ptr %3, i32 0, i32 0, i32 3
  %18 = load i1, ptr %17
  %19 = icmp eq i1 %18, 0
  br i1 %19, label %if_3, label %end_if_3
if_3:
  call ccc void @eclair_btree_iterator_end_init_3(ptr %result_0)
  ret void
end_if_3:
  %20 = getelementptr %inner_node_t_3, ptr %3, i32 0, i32 1, i16 %13
  %21 = load ptr, ptr %20
  store ptr %21, ptr %stack.ptr_0
  br label %loop_0
}

define external ccc void @eclair_btree_lower_bound_3(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_3(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_3(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_3(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_3, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_3, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_3, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_lower_bound_3(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 12
  %14 = getelementptr %node_t_3, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_3, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_3, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_3, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_3, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_3(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_3
if_2:
  %25 = call ccc i8 @eclair_btree_value_compare_values_3(ptr %8, ptr %val_0)
  %26 = icmp eq i8 0, %25
  br i1 %26, label %if_3, label %end_if_2
if_3:
  call ccc void @eclair_btree_iterator_init_3(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_2:
  br label %end_if_3
end_if_3:
  br i1 %24, label %if_4, label %end_if_4
if_4:
  call ccc void @eclair_btree_iterator_init_3(ptr %stack.ptr_0, ptr %3, i16 %13)
  br label %end_if_4
end_if_4:
  %27 = getelementptr %inner_node_t_3, ptr %3, i32 0, i32 1, i16 %13
  %28 = load ptr, ptr %27
  store ptr %28, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_upper_bound_3(ptr %tree_0, ptr %val_0, ptr %result_0) {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_1 = alloca ptr
  %0 = call ccc i1 @eclair_btree_is_empty_3(ptr %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_iterator_end_init_3(ptr %result_0)
  ret void
end_if_0:
  call ccc void @eclair_btree_iterator_end_init_3(ptr %stack.ptr_0)
  %1 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %2 = load ptr, ptr %1
  store ptr %2, ptr %stack.ptr_1
  br label %loop_0
loop_0:
  %3 = load ptr, ptr %stack.ptr_1
  %4 = getelementptr %node_t_3, ptr %3, i32 0, i32 0, i32 2
  %5 = load i16, ptr %4
  %6 = getelementptr %node_t_3, ptr %3, i32 0, i32 1, i16 0
  %7 = getelementptr %node_t_3, ptr %3, i32 0, i32 1, i16 %5
  %8 = call ccc ptr @eclair_btree_linear_search_upper_bound_3(ptr %val_0, ptr %6, ptr %7)
  %9 = ptrtoint ptr %8 to i64
  %10 = ptrtoint ptr %6 to i64
  %11 = sub i64 %9, %10
  %12 = trunc i64 %11 to i16
  %13 = udiv i16 %12, 12
  %14 = getelementptr %node_t_3, ptr %3, i32 0, i32 0, i32 3
  %15 = load i1, ptr %14
  %16 = icmp eq i1 %15, 0
  br i1 %16, label %if_1, label %end_if_1
if_1:
  %17 = icmp eq ptr %8, %7
  br i1 %17, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %18 = getelementptr %btree_iterator_t_3, ptr %stack.ptr_0, i32 0, i32 0
  %19 = load ptr, ptr %18
  %20 = getelementptr %btree_iterator_t_3, ptr %result_0, i32 0, i32 0
  store ptr %19, ptr %20
  %21 = getelementptr %btree_iterator_t_3, ptr %stack.ptr_0, i32 0, i32 1
  %22 = load i16, ptr %21
  %23 = getelementptr %btree_iterator_t_3, ptr %result_0, i32 0, i32 1
  store i16 %22, ptr %23
  ret void
handle_not_last_0:
  call ccc void @eclair_btree_iterator_init_3(ptr %result_0, ptr %3, i16 %13)
  ret void
end_if_1:
  %24 = icmp ne ptr %8, %7
  br i1 %24, label %if_2, label %end_if_2
if_2:
  call ccc void @eclair_btree_iterator_init_3(ptr %result_0, ptr %3, i16 %13)
  br label %end_if_2
end_if_2:
  %25 = getelementptr %inner_node_t_3, ptr %3, i32 0, i32 1, i16 %13
  %26 = load ptr, ptr %25
  store ptr %26, ptr %stack.ptr_1
  br label %loop_0
}

define external ccc void @eclair_btree_node_delete_3(ptr %node_0) {
start:
  %0 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 3
  %1 = load i1, ptr %0
  %2 = icmp eq i1 %1, 1
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = getelementptr %node_t_3, ptr %node_0, i32 0, i32 0, i32 2
  %4 = load i16, ptr %3
  br label %for_begin_0
for_begin_0:
  %5 = phi i16 [0, %if_0], [%10, %end_if_0]
  %6 = icmp ule i16 %5, %4
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = getelementptr %inner_node_t_3, ptr %node_0, i32 0, i32 1, i16 %5
  %8 = load ptr, ptr %7
  %9 = icmp ne ptr %8, zeroinitializer
  br i1 %9, label %if_1, label %end_if_0
if_1:
  call ccc void @eclair_btree_node_delete_3(ptr %8)
  br label %end_if_0
end_if_0:
  %10 = add i16 1, %5
  br label %for_begin_0
for_end_0:
  br label %end_if_1
end_if_1:
  call ccc void @free(ptr %node_0)
  ret void
}

define external ccc void @eclair_btree_clear_3(ptr %tree_0) {
start:
  %0 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = icmp ne ptr %1, zeroinitializer
  br i1 %2, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_btree_node_delete_3(ptr %1)
  %3 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 0
  store ptr zeroinitializer, ptr %3
  %4 = getelementptr %btree_t_3, ptr %tree_0, i32 0, i32 1
  store ptr zeroinitializer, ptr %4
  br label %end_if_0
end_if_0:
  ret void
}

define external ccc void @eclair_btree_swap_3(ptr %lhs_0, ptr %rhs_0) {
start:
  %0 = getelementptr %btree_t_3, ptr %lhs_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %btree_t_3, ptr %rhs_0, i32 0, i32 0
  %3 = load ptr, ptr %2
  %4 = getelementptr %btree_t_3, ptr %lhs_0, i32 0, i32 0
  store ptr %3, ptr %4
  %5 = getelementptr %btree_t_3, ptr %rhs_0, i32 0, i32 0
  store ptr %1, ptr %5
  %6 = getelementptr %btree_t_3, ptr %lhs_0, i32 0, i32 1
  %7 = load ptr, ptr %6
  %8 = getelementptr %btree_t_3, ptr %rhs_0, i32 0, i32 1
  %9 = load ptr, ptr %8
  %10 = getelementptr %btree_t_3, ptr %lhs_0, i32 0, i32 1
  store ptr %9, ptr %10
  %11 = getelementptr %btree_t_3, ptr %rhs_0, i32 0, i32 1
  store ptr %7, ptr %11
  ret void
}

@specialize_debug_info.btree__2__0_1__256__linear = global i32 1

@specialize_debug_info.btree__2__1__256__linear = global i32 2

@specialize_debug_info.btree__3__0_1_2__256__linear = global i32 0

@specialize_debug_info.btree__3__1_2__256__linear = global i32 3

%symbol_t = type <{i32, ptr}>

define external ccc void @eclair_symbol_init(ptr %symbol_0, i32 %size_0, ptr %data_0) {
start:
  %0 = getelementptr %symbol_t, ptr %symbol_0, i32 0, i32 0
  store i32 %size_0, ptr %0
  %1 = getelementptr %symbol_t, ptr %symbol_0, i32 0, i32 1
  store ptr %data_0, ptr %1
  ret void
}

define external ccc void @eclair_symbol_destroy(ptr %symbol_0) {
start:
  %0 = getelementptr %symbol_t, ptr %symbol_0, i32 0, i32 1
  %1 = load ptr, ptr %0
  call ccc void @free(ptr %1)
  ret void
}

define external ccc i1 @eclair_symbol_is_equal(ptr %symbol1_0, ptr %symbol2_0) {
start:
  %0 = getelementptr %symbol_t, ptr %symbol1_0, i32 0, i32 0
  %1 = load i32, ptr %0
  %2 = getelementptr %symbol_t, ptr %symbol2_0, i32 0, i32 0
  %3 = load i32, ptr %2
  %4 = icmp ne i32 %1, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i1 0
end_if_0:
  %5 = getelementptr %symbol_t, ptr %symbol1_0, i32 0, i32 1
  %6 = load ptr, ptr %5
  %7 = getelementptr %symbol_t, ptr %symbol2_0, i32 0, i32 1
  %8 = load ptr, ptr %7
  %9 = zext i32 %1 to i64
  %10 = call ccc i32 @memcmp(ptr %6, ptr %8, i64 %9)
  %11 = icmp eq i32 %10, 0
  ret i1 %11
}

%vector_t_symbol = type {ptr, ptr, i32}

define external ccc void @eclair_vector_init_symbol(ptr %vec_0) {
start:
  %0 = call ccc ptr @malloc(i32 192)
  %1 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 0
  store ptr %0, ptr %1
  %2 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 1
  store ptr %0, ptr %2
  %3 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 2
  store i32 16, ptr %3
  ret void
}

define external ccc void @eclair_vector_destroy_symbol(ptr %vec_0) {
start:
  %stack.ptr_0 = alloca ptr
  %0 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  store ptr %1, ptr %stack.ptr_0
  br label %while_begin_0
while_begin_0:
  %2 = load ptr, ptr %stack.ptr_0
  %3 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 1
  %4 = load ptr, ptr %3
  %5 = icmp ne ptr %2, %4
  br i1 %5, label %while_body_0, label %while_end_0
while_body_0:
  %6 = load ptr, ptr %stack.ptr_0
  call ccc void @eclair_symbol_destroy(ptr %6)
  %7 = getelementptr %symbol_t, ptr %6, i32 1
  store ptr %7, ptr %stack.ptr_0
  br label %while_begin_0
while_end_0:
  %8 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 0
  %9 = load ptr, ptr %8
  call ccc void @free(ptr %9)
  ret void
}

define external ccc i32 @eclair_vector_size_symbol(ptr %vec_0) {
start:
  %0 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 1
  %3 = load ptr, ptr %2
  %4 = ptrtoint ptr %3 to i64
  %5 = ptrtoint ptr %1 to i64
  %6 = sub i64 %4, %5
  %7 = trunc i64 %6 to i32
  %8 = udiv i32 %7, 12
  ret i32 %8
}

define external ccc void @eclair_vector_grow_symbol(ptr %vec_0) {
start:
  %0 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 2
  %1 = load i32, ptr %0
  %2 = mul i32 %1, 12
  %3 = zext i32 %2 to i64
  %4 = mul i32 %1, 2
  %5 = mul i32 %4, 12
  %6 = call ccc ptr @malloc(i32 %5)
  %7 = getelementptr %symbol_t, ptr %6, i32 %1
  %8 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 0
  %9 = load ptr, ptr %8
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %6, ptr %9, i64 %3, i1 0)
  call ccc void @free(ptr %9)
  %10 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 0
  store ptr %6, ptr %10
  %11 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 1
  store ptr %7, ptr %11
  %12 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 2
  store i32 %4, ptr %12
  ret void
}

define external ccc i32 @eclair_vector_push_symbol(ptr %vec_0, ptr %elem_0) {
start:
  %0 = call ccc i32 @eclair_vector_size_symbol(ptr %vec_0)
  %1 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 2
  %2 = load i32, ptr %1
  %3 = icmp eq i32 %0, %2
  br i1 %3, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_vector_grow_symbol(ptr %vec_0)
  br label %end_if_0
end_if_0:
  %4 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 1
  %5 = load ptr, ptr %4
  %6 = load %symbol_t, ptr %elem_0
  store %symbol_t %6, ptr %5
  %7 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 1
  %8 = load ptr, ptr %7
  %9 = getelementptr %symbol_t, ptr %8, i32 1
  store ptr %9, ptr %7
  ret i32 %0
}

define external ccc ptr @eclair_vector_get_value_symbol(ptr %vec_0, i32 %idx_0) {
start:
  %0 = getelementptr %vector_t_symbol, ptr %vec_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %symbol_t, ptr %1, i32 %idx_0
  ret ptr %2
}

%entry_t = type {%symbol_t, i32}

%vector_t_entry = type {ptr, ptr, i32}

define external ccc void @eclair_vector_init_entry(ptr %vec_0) {
start:
  %0 = call ccc ptr @malloc(i32 256)
  %1 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 0
  store ptr %0, ptr %1
  %2 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 1
  store ptr %0, ptr %2
  %3 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 2
  store i32 16, ptr %3
  ret void
}

define external ccc void @eclair_vector_destroy_entry(ptr %vec_0) {
start:
  %0 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  call ccc void @free(ptr %1)
  ret void
}

define external ccc i32 @eclair_vector_size_entry(ptr %vec_0) {
start:
  %0 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 1
  %3 = load ptr, ptr %2
  %4 = ptrtoint ptr %3 to i64
  %5 = ptrtoint ptr %1 to i64
  %6 = sub i64 %4, %5
  %7 = trunc i64 %6 to i32
  %8 = udiv i32 %7, 16
  ret i32 %8
}

define external ccc void @eclair_vector_grow_entry(ptr %vec_0) {
start:
  %0 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 2
  %1 = load i32, ptr %0
  %2 = mul i32 %1, 16
  %3 = zext i32 %2 to i64
  %4 = mul i32 %1, 2
  %5 = mul i32 %4, 16
  %6 = call ccc ptr @malloc(i32 %5)
  %7 = getelementptr %entry_t, ptr %6, i32 %1
  %8 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 0
  %9 = load ptr, ptr %8
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %6, ptr %9, i64 %3, i1 0)
  call ccc void @free(ptr %9)
  %10 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 0
  store ptr %6, ptr %10
  %11 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 1
  store ptr %7, ptr %11
  %12 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 2
  store i32 %4, ptr %12
  ret void
}

define external ccc i32 @eclair_vector_push_entry(ptr %vec_0, ptr %elem_0) {
start:
  %0 = call ccc i32 @eclair_vector_size_entry(ptr %vec_0)
  %1 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 2
  %2 = load i32, ptr %1
  %3 = icmp eq i32 %0, %2
  br i1 %3, label %if_0, label %end_if_0
if_0:
  call ccc void @eclair_vector_grow_entry(ptr %vec_0)
  br label %end_if_0
end_if_0:
  %4 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 1
  %5 = load ptr, ptr %4
  %6 = load %entry_t, ptr %elem_0
  store %entry_t %6, ptr %5
  %7 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 1
  %8 = load ptr, ptr %7
  %9 = getelementptr %entry_t, ptr %8, i32 1
  store ptr %9, ptr %7
  ret i32 %0
}

define external ccc ptr @eclair_vector_get_value_entry(ptr %vec_0, i32 %idx_0) {
start:
  %0 = getelementptr %vector_t_entry, ptr %vec_0, i32 0, i32 0
  %1 = load ptr, ptr %0
  %2 = getelementptr %entry_t, ptr %1, i32 %idx_0
  ret ptr %2
}

%hashmap_t = type {[64 x %vector_t_entry]}

define external ccc i32 @eclair_symbol_hash(ptr %symbol_0) {
start:
  %stack.ptr_0 = alloca i32
  store i32 0, ptr %stack.ptr_0
  %0 = getelementptr %symbol_t, ptr %symbol_0, i32 0, i32 0
  %1 = load i32, ptr %0
  %2 = getelementptr %symbol_t, ptr %symbol_0, i32 0, i32 1
  %3 = load ptr, ptr %2
  br label %for_begin_0
for_begin_0:
  %4 = phi i32 [0, %start], [%12, %for_body_0]
  %5 = icmp ult i32 %4, %1
  br i1 %5, label %for_body_0, label %for_end_0
for_body_0:
  %6 = getelementptr i8, ptr %3, i32 %4
  %7 = load i8, ptr %6
  %8 = zext i8 %7 to i32
  %9 = load i32, ptr %stack.ptr_0
  %10 = mul i32 31, %9
  %11 = add i32 %8, %10
  store i32 %11, ptr %stack.ptr_0
  %12 = add i32 1, %4
  br label %for_begin_0
for_end_0:
  %13 = load i32, ptr %stack.ptr_0
  %14 = and i32 %13, 63
  ret i32 %14
}

define external ccc void @eclair_hashmap_init(ptr %hashmap_0) {
start:
  br label %for_begin_0
for_begin_0:
  %0 = phi i32 [0, %start], [%3, %for_body_0]
  %1 = icmp ult i32 %0, 64
  br i1 %1, label %for_body_0, label %for_end_0
for_body_0:
  %2 = getelementptr %hashmap_t, ptr %hashmap_0, i32 0, i32 0, i32 %0
  call ccc void @eclair_vector_init_entry(ptr %2)
  %3 = add i32 1, %0
  br label %for_begin_0
for_end_0:
  ret void
}

define external ccc void @eclair_hashmap_destroy(ptr %hashmap_0) {
start:
  br label %for_begin_0
for_begin_0:
  %0 = phi i32 [0, %start], [%3, %for_body_0]
  %1 = icmp ult i32 %0, 64
  br i1 %1, label %for_body_0, label %for_end_0
for_body_0:
  %2 = getelementptr %hashmap_t, ptr %hashmap_0, i32 0, i32 0, i32 %0
  call ccc void @eclair_vector_destroy_entry(ptr %2)
  %3 = add i32 1, %0
  br label %for_begin_0
for_end_0:
  ret void
}

define external ccc i32 @eclair_hashmap_get_or_put_value(ptr %hashmap_0, ptr %symbol_0, i32 %value_0) {
start:
  %stack.ptr_0 = alloca %entry_t
  %0 = call ccc i32 @eclair_symbol_hash(ptr %symbol_0)
  %1 = and i32 %0, 63
  %2 = getelementptr %hashmap_t, ptr %hashmap_0, i32 0, i32 0, i32 %1
  %3 = call ccc i32 @eclair_vector_size_entry(ptr %2)
  br label %for_begin_0
for_begin_0:
  %4 = phi i32 [0, %start], [%11, %end_if_0]
  %5 = icmp ult i32 %4, %3
  br i1 %5, label %for_body_0, label %for_end_0
for_body_0:
  %6 = call ccc ptr @eclair_vector_get_value_entry(ptr %2, i32 %4)
  %7 = getelementptr %entry_t, ptr %6, i32 0, i32 0
  %8 = call ccc i1 @eclair_symbol_is_equal(ptr %7, ptr %symbol_0)
  br i1 %8, label %if_0, label %end_if_0
if_0:
  %9 = getelementptr %entry_t, ptr %6, i32 0, i32 1
  %10 = load i32, ptr %9
  ret i32 %10
end_if_0:
  %11 = add i32 1, %4
  br label %for_begin_0
for_end_0:
  %12 = load %symbol_t, ptr %symbol_0
  %13 = getelementptr %entry_t, ptr %stack.ptr_0, i32 0, i32 0
  store %symbol_t %12, ptr %13
  %14 = getelementptr %entry_t, ptr %stack.ptr_0, i32 0, i32 1
  store i32 %value_0, ptr %14
  %15 = call ccc i32 @eclair_vector_push_entry(ptr %2, ptr %stack.ptr_0)
  ret i32 %value_0
}

define external ccc i32 @eclair_hashmap_lookup(ptr %hashmap_0, ptr %symbol_0) {
start:
  %0 = call ccc i32 @eclair_symbol_hash(ptr %symbol_0)
  %1 = and i32 %0, 63
  %2 = getelementptr %hashmap_t, ptr %hashmap_0, i32 0, i32 0, i32 %1
  %3 = call ccc i32 @eclair_vector_size_entry(ptr %2)
  br label %for_begin_0
for_begin_0:
  %4 = phi i32 [0, %start], [%11, %end_if_0]
  %5 = icmp ult i32 %4, %3
  br i1 %5, label %for_body_0, label %for_end_0
for_body_0:
  %6 = call ccc ptr @eclair_vector_get_value_entry(ptr %2, i32 %4)
  %7 = getelementptr %entry_t, ptr %6, i32 0, i32 0
  %8 = call ccc i1 @eclair_symbol_is_equal(ptr %7, ptr %symbol_0)
  br i1 %8, label %if_0, label %end_if_0
if_0:
  %9 = getelementptr %entry_t, ptr %6, i32 0, i32 1
  %10 = load i32, ptr %9
  ret i32 %10
end_if_0:
  %11 = add i32 1, %4
  br label %for_begin_0
for_end_0:
  ret i32 4294967295
}

define external ccc i1 @eclair_hashmap_contains(ptr %hashmap_0, ptr %symbol_0) {
start:
  %0 = call ccc i32 @eclair_symbol_hash(ptr %symbol_0)
  %1 = and i32 %0, 63
  %2 = getelementptr %hashmap_t, ptr %hashmap_0, i32 0, i32 0, i32 %1
  %3 = call ccc i32 @eclair_vector_size_entry(ptr %2)
  br label %for_begin_0
for_begin_0:
  %4 = phi i32 [0, %start], [%9, %end_if_0]
  %5 = icmp ult i32 %4, %3
  br i1 %5, label %for_body_0, label %for_end_0
for_body_0:
  %6 = call ccc ptr @eclair_vector_get_value_entry(ptr %2, i32 %4)
  %7 = getelementptr %entry_t, ptr %6, i32 0, i32 0
  %8 = call ccc i1 @eclair_symbol_is_equal(ptr %7, ptr %symbol_0)
  br i1 %8, label %if_0, label %end_if_0
if_0:
  ret i1 1
end_if_0:
  %9 = add i32 1, %4
  br label %for_begin_0
for_end_0:
  ret i1 0
}

%symbol_table = type {%vector_t_symbol, %hashmap_t}

define external ccc void @eclair_symbol_table_init(ptr %table_0) {
start:
  %0 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 0
  %1 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 1
  call ccc void @eclair_vector_init_symbol(ptr %0)
  call ccc void @eclair_hashmap_init(ptr %1)
  ret void
}

define external ccc void @eclair_symbol_table_destroy(ptr %table_0) {
start:
  %0 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 0
  %1 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 1
  call ccc void @eclair_vector_destroy_symbol(ptr %0)
  call ccc void @eclair_hashmap_destroy(ptr %1)
  ret void
}

define external ccc i32 @eclair_symbol_table_find_or_insert(ptr %table_0, ptr %symbol_0) {
start:
  %0 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 0
  %1 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 1
  %2 = call ccc i32 @eclair_vector_size_symbol(ptr %0)
  %3 = call ccc i32 @eclair_hashmap_get_or_put_value(ptr %1, ptr %symbol_0, i32 %2)
  %4 = icmp eq i32 %2, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  %5 = call ccc i32 @eclair_vector_push_symbol(ptr %0, ptr %symbol_0)
  br label %end_if_0
end_if_0:
  ret i32 %3
}

define external ccc i1 @eclair_symbol_table_contains_index(ptr %table_0, i32 %index_0) {
start:
  %0 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 0
  %1 = call ccc i32 @eclair_vector_size_symbol(ptr %0)
  %2 = icmp ult i32 %index_0, %1
  ret i1 %2
}

define external ccc i1 @eclair_symbol_table_contains_symbol(ptr %table_0, ptr %symbol_0) {
start:
  %0 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 1
  %1 = call ccc i1 @eclair_hashmap_contains(ptr %0, ptr %symbol_0)
  ret i1 %1
}

define external ccc i32 @eclair_symbol_table_lookup_index(ptr %table_0, ptr %symbol_0) {
start:
  %0 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 1
  %1 = call ccc i32 @eclair_hashmap_lookup(ptr %0, ptr %symbol_0)
  ret i32 %1
}

define external ccc ptr @eclair_symbol_table_lookup_symbol(ptr %table_0, i32 %index_0) {
start:
  %0 = getelementptr %symbol_table, ptr %table_0, i32 0, i32 0
  %1 = call ccc ptr @eclair_vector_get_value_symbol(ptr %0, i32 %index_0)
  ret ptr %1
}

%program = type {%symbol_table, %btree_t_0, %btree_t_1, %btree_t_2, %btree_t_0, %btree_t_3, %btree_t_1, %btree_t_2, %btree_t_0, %btree_t_3, %btree_t_1, %btree_t_2, %btree_t_0, %btree_t_3, %btree_t_0, %btree_t_1, %btree_t_0}

@string_literal_0 = global [2 x i8] [i8 112, i8 0]

@string_literal_1 = global [2 x i8] [i8 113, i8 0]

@string_literal_2 = global [2 x i8] [i8 114, i8 0]

@string_literal_3 = global [2 x i8] [i8 99, i8 0]

@string_literal_4 = global [2 x i8] [i8 117, i8 0]

@string_literal_5 = global [2 x i8] [i8 115, i8 0]

define external ccc ptr @eclair_program_init() "wasm-export-name"="eclair_program_init" {
start:
  %stack.ptr_0 = alloca %symbol_t, i32 1
  %stack.ptr_1 = alloca %symbol_t, i32 1
  %stack.ptr_2 = alloca %symbol_t, i32 1
  %stack.ptr_3 = alloca %symbol_t, i32 1
  %stack.ptr_4 = alloca %symbol_t, i32 1
  %stack.ptr_5 = alloca %symbol_t, i32 1
  %0 = call ccc ptr @malloc(i32 1816)
  %1 = getelementptr %program, ptr %0, i32 0, i32 0
  call ccc void @eclair_symbol_table_init(ptr %1)
  %2 = getelementptr %program, ptr %0, i32 0, i32 1
  call ccc void @eclair_btree_init_empty_0(ptr %2)
  %3 = getelementptr %program, ptr %0, i32 0, i32 2
  call ccc void @eclair_btree_init_empty_1(ptr %3)
  %4 = getelementptr %program, ptr %0, i32 0, i32 3
  call ccc void @eclair_btree_init_empty_2(ptr %4)
  %5 = getelementptr %program, ptr %0, i32 0, i32 4
  call ccc void @eclair_btree_init_empty_0(ptr %5)
  %6 = getelementptr %program, ptr %0, i32 0, i32 5
  call ccc void @eclair_btree_init_empty_3(ptr %6)
  %7 = getelementptr %program, ptr %0, i32 0, i32 6
  call ccc void @eclair_btree_init_empty_1(ptr %7)
  %8 = getelementptr %program, ptr %0, i32 0, i32 7
  call ccc void @eclair_btree_init_empty_2(ptr %8)
  %9 = getelementptr %program, ptr %0, i32 0, i32 8
  call ccc void @eclair_btree_init_empty_0(ptr %9)
  %10 = getelementptr %program, ptr %0, i32 0, i32 9
  call ccc void @eclair_btree_init_empty_3(ptr %10)
  %11 = getelementptr %program, ptr %0, i32 0, i32 10
  call ccc void @eclair_btree_init_empty_1(ptr %11)
  %12 = getelementptr %program, ptr %0, i32 0, i32 11
  call ccc void @eclair_btree_init_empty_2(ptr %12)
  %13 = getelementptr %program, ptr %0, i32 0, i32 12
  call ccc void @eclair_btree_init_empty_0(ptr %13)
  %14 = getelementptr %program, ptr %0, i32 0, i32 13
  call ccc void @eclair_btree_init_empty_3(ptr %14)
  %15 = getelementptr %program, ptr %0, i32 0, i32 14
  call ccc void @eclair_btree_init_empty_0(ptr %15)
  %16 = getelementptr %program, ptr %0, i32 0, i32 15
  call ccc void @eclair_btree_init_empty_1(ptr %16)
  %17 = getelementptr %program, ptr %0, i32 0, i32 16
  call ccc void @eclair_btree_init_empty_0(ptr %17)
  %18 = getelementptr %program, ptr %0, i32 0, i32 0
  %19 = getelementptr inbounds [2 x i8], ptr @string_literal_0, i32 0, i32 0
  %20 = zext i32 1 to i64
  %21 = call ccc ptr @malloc(i32 1)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %21, ptr %19, i64 %20, i1 0)
  call ccc void @eclair_symbol_init(ptr %stack.ptr_0, i32 1, ptr %21)
  %22 = call ccc i32 @eclair_symbol_table_find_or_insert(ptr %18, ptr %stack.ptr_0)
  %23 = getelementptr %program, ptr %0, i32 0, i32 0
  %24 = getelementptr inbounds [2 x i8], ptr @string_literal_1, i32 0, i32 0
  %25 = zext i32 1 to i64
  %26 = call ccc ptr @malloc(i32 1)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %26, ptr %24, i64 %25, i1 0)
  call ccc void @eclair_symbol_init(ptr %stack.ptr_1, i32 1, ptr %26)
  %27 = call ccc i32 @eclair_symbol_table_find_or_insert(ptr %23, ptr %stack.ptr_1)
  %28 = getelementptr %program, ptr %0, i32 0, i32 0
  %29 = getelementptr inbounds [2 x i8], ptr @string_literal_2, i32 0, i32 0
  %30 = zext i32 1 to i64
  %31 = call ccc ptr @malloc(i32 1)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %31, ptr %29, i64 %30, i1 0)
  call ccc void @eclair_symbol_init(ptr %stack.ptr_2, i32 1, ptr %31)
  %32 = call ccc i32 @eclair_symbol_table_find_or_insert(ptr %28, ptr %stack.ptr_2)
  %33 = getelementptr %program, ptr %0, i32 0, i32 0
  %34 = getelementptr inbounds [2 x i8], ptr @string_literal_3, i32 0, i32 0
  %35 = zext i32 1 to i64
  %36 = call ccc ptr @malloc(i32 1)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %36, ptr %34, i64 %35, i1 0)
  call ccc void @eclair_symbol_init(ptr %stack.ptr_3, i32 1, ptr %36)
  %37 = call ccc i32 @eclair_symbol_table_find_or_insert(ptr %33, ptr %stack.ptr_3)
  %38 = getelementptr %program, ptr %0, i32 0, i32 0
  %39 = getelementptr inbounds [2 x i8], ptr @string_literal_4, i32 0, i32 0
  %40 = zext i32 1 to i64
  %41 = call ccc ptr @malloc(i32 1)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %41, ptr %39, i64 %40, i1 0)
  call ccc void @eclair_symbol_init(ptr %stack.ptr_4, i32 1, ptr %41)
  %42 = call ccc i32 @eclair_symbol_table_find_or_insert(ptr %38, ptr %stack.ptr_4)
  %43 = getelementptr %program, ptr %0, i32 0, i32 0
  %44 = getelementptr inbounds [2 x i8], ptr @string_literal_5, i32 0, i32 0
  %45 = zext i32 1 to i64
  %46 = call ccc ptr @malloc(i32 1)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %46, ptr %44, i64 %45, i1 0)
  call ccc void @eclair_symbol_init(ptr %stack.ptr_5, i32 1, ptr %46)
  %47 = call ccc i32 @eclair_symbol_table_find_or_insert(ptr %43, ptr %stack.ptr_5)
  ret ptr %0
}

define external ccc void @eclair_program_destroy(ptr %arg_0) "wasm-export-name"="eclair_program_destroy" {
start:
  %0 = getelementptr %program, ptr %arg_0, i32 0, i32 0
  call ccc void @eclair_symbol_table_destroy(ptr %0)
  %1 = getelementptr %program, ptr %arg_0, i32 0, i32 1
  call ccc void @eclair_btree_destroy_0(ptr %1)
  %2 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_destroy_1(ptr %2)
  %3 = getelementptr %program, ptr %arg_0, i32 0, i32 3
  call ccc void @eclair_btree_destroy_2(ptr %3)
  %4 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_destroy_0(ptr %4)
  %5 = getelementptr %program, ptr %arg_0, i32 0, i32 5
  call ccc void @eclair_btree_destroy_3(ptr %5)
  %6 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  call ccc void @eclair_btree_destroy_1(ptr %6)
  %7 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  call ccc void @eclair_btree_destroy_2(ptr %7)
  %8 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  call ccc void @eclair_btree_destroy_0(ptr %8)
  %9 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  call ccc void @eclair_btree_destroy_3(ptr %9)
  %10 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_destroy_1(ptr %10)
  %11 = getelementptr %program, ptr %arg_0, i32 0, i32 11
  call ccc void @eclair_btree_destroy_2(ptr %11)
  %12 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_destroy_0(ptr %12)
  %13 = getelementptr %program, ptr %arg_0, i32 0, i32 13
  call ccc void @eclair_btree_destroy_3(ptr %13)
  %14 = getelementptr %program, ptr %arg_0, i32 0, i32 14
  call ccc void @eclair_btree_destroy_0(ptr %14)
  %15 = getelementptr %program, ptr %arg_0, i32 0, i32 15
  call ccc void @eclair_btree_destroy_1(ptr %15)
  %16 = getelementptr %program, ptr %arg_0, i32 0, i32 16
  call ccc void @eclair_btree_destroy_0(ptr %16)
  call ccc void @free(ptr %arg_0)
  ret void
}

define external ccc void @eclair_btree_insert_range_delta_p_p(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_1(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_1(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_1(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_insert_range_delta_p_p_1(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_1(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_2(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_1(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_insert_range_delta_q_q(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_0(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_0(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_0(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_insert_range_delta_q_q_1(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_0(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_3(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_0(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_insert_range_p_new_p(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_1(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_1(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_1(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_insert_range_p_new_p_1(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_1(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_2(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_1(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_insert_range_q_new_q(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_0(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_0(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_0(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_btree_insert_range_q_new_q_1(ptr %tree_0, ptr %begin_0, ptr %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %begin_0, ptr %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc ptr @eclair_btree_iterator_current_0(ptr %begin_0)
  %3 = call ccc i1 @eclair_btree_insert_value_3(ptr %tree_0, ptr %2)
  call ccc void @eclair_btree_iterator_next_0(ptr %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_program_run(ptr %arg_0) "wasm-export-name"="eclair_program_run" {
start:
  %stack.ptr_0 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_1 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_2 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_3 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_4 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_5 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_6 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_7 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_8 = alloca [2 x i32], i32 1
  %stack.ptr_9 = alloca [2 x i32], i32 1
  %stack.ptr_10 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_11 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_12 = alloca [2 x i32], i32 1
  %stack.ptr_13 = alloca [2 x i32], i32 1
  %stack.ptr_14 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_15 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_16 = alloca [2 x i32], i32 1
  %stack.ptr_17 = alloca [2 x i32], i32 1
  %stack.ptr_18 = alloca [2 x i32], i32 1
  %stack.ptr_19 = alloca [2 x i32], i32 1
  %stack.ptr_20 = alloca [2 x i32], i32 1
  %stack.ptr_21 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_22 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_23 = alloca [2 x i32], i32 1
  %stack.ptr_24 = alloca [2 x i32], i32 1
  %stack.ptr_25 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_26 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_27 = alloca [2 x i32], i32 1
  %stack.ptr_28 = alloca [2 x i32], i32 1
  %stack.ptr_29 = alloca [3 x i32], i32 1
  %stack.ptr_30 = alloca [3 x i32], i32 1
  %stack.ptr_31 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_32 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_33 = alloca [2 x i32], i32 1
  %stack.ptr_34 = alloca [2 x i32], i32 1
  %stack.ptr_35 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_36 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_37 = alloca [2 x i32], i32 1
  %stack.ptr_38 = alloca [2 x i32], i32 1
  %stack.ptr_39 = alloca [2 x i32], i32 1
  %stack.ptr_40 = alloca [2 x i32], i32 1
  %stack.ptr_41 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_42 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_43 = alloca [2 x i32], i32 1
  %stack.ptr_44 = alloca [3 x i32], i32 1
  %stack.ptr_45 = alloca [3 x i32], i32 1
  %stack.ptr_46 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_47 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_48 = alloca [2 x i32], i32 1
  %stack.ptr_49 = alloca [2 x i32], i32 1
  %stack.ptr_50 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_51 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_52 = alloca [2 x i32], i32 1
  %stack.ptr_53 = alloca [2 x i32], i32 1
  %stack.ptr_54 = alloca [2 x i32], i32 1
  %stack.ptr_55 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_56 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_57 = alloca [2 x i32], i32 1
  %stack.ptr_58 = alloca [2 x i32], i32 1
  %stack.ptr_59 = alloca [2 x i32], i32 1
  %stack.ptr_60 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_61 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_62 = alloca [3 x i32], i32 1
  %stack.ptr_63 = alloca [3 x i32], i32 1
  %stack.ptr_64 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_65 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_66 = alloca [3 x i32], i32 1
  %stack.ptr_67 = alloca [3 x i32], i32 1
  %stack.ptr_68 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_69 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_70 = alloca [3 x i32], i32 1
  %stack.ptr_71 = alloca [2 x i32], i32 1
  %stack.ptr_72 = alloca [2 x i32], i32 1
  %stack.ptr_73 = alloca [2 x i32], i32 1
  %stack.ptr_74 = alloca [2 x i32], i32 1
  %stack.ptr_75 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_76 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_77 = alloca [3 x i32], i32 1
  %stack.ptr_78 = alloca [3 x i32], i32 1
  %stack.ptr_79 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_80 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_81 = alloca [3 x i32], i32 1
  %stack.ptr_82 = alloca [3 x i32], i32 1
  %stack.ptr_83 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_84 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_85 = alloca [2 x i32], i32 1
  %stack.ptr_86 = alloca [2 x i32], i32 1
  %stack.ptr_87 = alloca [3 x i32], i32 1
  %stack.ptr_88 = alloca [3 x i32], i32 1
  %stack.ptr_89 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_90 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_91 = alloca [3 x i32], i32 1
  %stack.ptr_92 = alloca [3 x i32], i32 1
  %stack.ptr_93 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_94 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_95 = alloca [3 x i32], i32 1
  %stack.ptr_96 = alloca [3 x i32], i32 1
  %stack.ptr_97 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_98 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_99 = alloca [3 x i32], i32 1
  %stack.ptr_100 = alloca [3 x i32], i32 1
  %stack.ptr_101 = alloca [3 x i32], i32 1
  %stack.ptr_102 = alloca [3 x i32], i32 1
  %stack.ptr_103 = alloca [3 x i32], i32 1
  %stack.ptr_104 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_105 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_106 = alloca [3 x i32], i32 1
  %stack.ptr_107 = alloca [3 x i32], i32 1
  %stack.ptr_108 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_109 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_110 = alloca [3 x i32], i32 1
  %stack.ptr_111 = alloca [3 x i32], i32 1
  %stack.ptr_112 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_113 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_114 = alloca [3 x i32], i32 1
  %stack.ptr_115 = alloca [3 x i32], i32 1
  %stack.ptr_116 = alloca [3 x i32], i32 1
  %stack.ptr_117 = alloca [3 x i32], i32 1
  %stack.ptr_118 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_119 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_120 = alloca [2 x i32], i32 1
  %stack.ptr_121 = alloca [2 x i32], i32 1
  %stack.ptr_122 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_123 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_124 = alloca [3 x i32], i32 1
  %stack.ptr_125 = alloca [3 x i32], i32 1
  %stack.ptr_126 = alloca [2 x i32], i32 1
  %stack.ptr_127 = alloca [2 x i32], i32 1
  %stack.ptr_128 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_129 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_130 = alloca [3 x i32], i32 1
  %stack.ptr_131 = alloca [3 x i32], i32 1
  %stack.ptr_132 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_133 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_134 = alloca [3 x i32], i32 1
  %stack.ptr_135 = alloca [3 x i32], i32 1
  %stack.ptr_136 = alloca [3 x i32], i32 1
  %stack.ptr_137 = alloca [2 x i32], i32 1
  %stack.ptr_138 = alloca [2 x i32], i32 1
  %stack.ptr_139 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_140 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_141 = alloca [3 x i32], i32 1
  %stack.ptr_142 = alloca [3 x i32], i32 1
  %stack.ptr_143 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_144 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_145 = alloca [3 x i32], i32 1
  %stack.ptr_146 = alloca [3 x i32], i32 1
  %stack.ptr_147 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_148 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_149 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_150 = alloca %btree_iterator_t_1, i32 1
  %stack.ptr_151 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_152 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_153 = alloca %btree_iterator_t_0, i32 1
  %stack.ptr_154 = alloca %btree_iterator_t_0, i32 1
  %0 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_begin_1(ptr %0, ptr %stack.ptr_0)
  %1 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_end_1(ptr %1, ptr %stack.ptr_1)
  %2 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_insert_range_delta_p_p_1(ptr %2, ptr %stack.ptr_0, ptr %stack.ptr_1)
  %3 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_begin_1(ptr %3, ptr %stack.ptr_2)
  %4 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_end_1(ptr %4, ptr %stack.ptr_3)
  %5 = getelementptr %program, ptr %arg_0, i32 0, i32 3
  call ccc void @eclair_btree_insert_range_delta_p_p(ptr %5, ptr %stack.ptr_2, ptr %stack.ptr_3)
  %6 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_begin_0(ptr %6, ptr %stack.ptr_4)
  %7 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_end_0(ptr %7, ptr %stack.ptr_5)
  %8 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_insert_range_delta_q_q_1(ptr %8, ptr %stack.ptr_4, ptr %stack.ptr_5)
  %9 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_begin_0(ptr %9, ptr %stack.ptr_6)
  %10 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_end_0(ptr %10, ptr %stack.ptr_7)
  %11 = getelementptr %program, ptr %arg_0, i32 0, i32 5
  call ccc void @eclair_btree_insert_range_delta_q_q_1(ptr %11, ptr %stack.ptr_6, ptr %stack.ptr_7)
  br label %loop_0
loop_0:
  %12 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  call ccc void @eclair_btree_clear_1(ptr %12)
  %13 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  call ccc void @eclair_btree_clear_2(ptr %13)
  %14 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  call ccc void @eclair_btree_clear_0(ptr %14)
  %15 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  call ccc void @eclair_btree_clear_3(ptr %15)
  %16 = getelementptr [2 x i32], ptr %stack.ptr_8, i32 0, i32 0
  store i32 0, ptr %16
  %17 = getelementptr [2 x i32], ptr %stack.ptr_8, i32 0, i32 1
  store i32 0, ptr %17
  %18 = getelementptr [2 x i32], ptr %stack.ptr_9, i32 0, i32 0
  store i32 4294967295, ptr %18
  %19 = getelementptr [2 x i32], ptr %stack.ptr_9, i32 0, i32 1
  store i32 4294967295, ptr %19
  %20 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_lower_bound_1(ptr %20, ptr %stack.ptr_8, ptr %stack.ptr_10)
  %21 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_upper_bound_1(ptr %21, ptr %stack.ptr_9, ptr %stack.ptr_11)
  br label %loop_1
loop_1:
  %22 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_10, ptr %stack.ptr_11)
  br i1 %22, label %if_0, label %end_if_0
if_0:
  br label %range_query.end
end_if_0:
  %23 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_10)
  %24 = getelementptr [2 x i32], ptr %stack.ptr_12, i32 0, i32 0
  %25 = getelementptr [2 x i32], ptr %23, i32 0, i32 1
  %26 = load i32, ptr %25
  store i32 %26, ptr %24
  %27 = getelementptr [2 x i32], ptr %stack.ptr_12, i32 0, i32 1
  store i32 0, ptr %27
  %28 = getelementptr [2 x i32], ptr %stack.ptr_13, i32 0, i32 0
  %29 = getelementptr [2 x i32], ptr %23, i32 0, i32 1
  %30 = load i32, ptr %29
  store i32 %30, ptr %28
  %31 = getelementptr [2 x i32], ptr %stack.ptr_13, i32 0, i32 1
  store i32 4294967295, ptr %31
  %32 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_lower_bound_1(ptr %32, ptr %stack.ptr_12, ptr %stack.ptr_14)
  %33 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_upper_bound_1(ptr %33, ptr %stack.ptr_13, ptr %stack.ptr_15)
  br label %loop_2
loop_2:
  %34 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_14, ptr %stack.ptr_15)
  br i1 %34, label %if_1, label %end_if_1
if_1:
  br label %range_query.end_1
end_if_1:
  %35 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_14)
  %36 = getelementptr [2 x i32], ptr %stack.ptr_16, i32 0, i32 0
  %37 = getelementptr [2 x i32], ptr %23, i32 0, i32 1
  %38 = load i32, ptr %37
  store i32 %38, ptr %36
  %39 = getelementptr [2 x i32], ptr %stack.ptr_16, i32 0, i32 1
  %40 = getelementptr [2 x i32], ptr %35, i32 0, i32 1
  %41 = load i32, ptr %40
  store i32 %41, ptr %39
  %42 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  %43 = call ccc i1 @eclair_btree_contains_1(ptr %42, ptr %stack.ptr_16)
  %44 = select i1 %43, i1 0, i1 1
  br i1 %44, label %if_2, label %end_if_3
if_2:
  %45 = getelementptr [2 x i32], ptr %stack.ptr_17, i32 0, i32 0
  %46 = getelementptr [2 x i32], ptr %23, i32 0, i32 0
  %47 = load i32, ptr %46
  store i32 %47, ptr %45
  %48 = getelementptr [2 x i32], ptr %stack.ptr_17, i32 0, i32 1
  %49 = getelementptr [2 x i32], ptr %35, i32 0, i32 1
  %50 = load i32, ptr %49
  store i32 %50, ptr %48
  %51 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  %52 = call ccc i1 @eclair_btree_contains_1(ptr %51, ptr %stack.ptr_17)
  %53 = select i1 %52, i1 0, i1 1
  br i1 %53, label %if_3, label %end_if_2
if_3:
  %54 = getelementptr [2 x i32], ptr %stack.ptr_18, i32 0, i32 0
  %55 = getelementptr [2 x i32], ptr %23, i32 0, i32 0
  %56 = load i32, ptr %55
  store i32 %56, ptr %54
  %57 = getelementptr [2 x i32], ptr %stack.ptr_18, i32 0, i32 1
  %58 = getelementptr [2 x i32], ptr %35, i32 0, i32 1
  %59 = load i32, ptr %58
  store i32 %59, ptr %57
  %60 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %61 = call ccc i1 @eclair_btree_insert_value_1(ptr %60, ptr %stack.ptr_18)
  %62 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  %63 = call ccc i1 @eclair_btree_insert_value_2(ptr %62, ptr %stack.ptr_18)
  br label %end_if_2
end_if_2:
  br label %end_if_3
end_if_3:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_14)
  br label %loop_2
range_query.end_1:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_10)
  br label %loop_1
range_query.end:
  %64 = getelementptr [2 x i32], ptr %stack.ptr_19, i32 0, i32 0
  store i32 0, ptr %64
  %65 = getelementptr [2 x i32], ptr %stack.ptr_19, i32 0, i32 1
  store i32 0, ptr %65
  %66 = getelementptr [2 x i32], ptr %stack.ptr_20, i32 0, i32 0
  store i32 4294967295, ptr %66
  %67 = getelementptr [2 x i32], ptr %stack.ptr_20, i32 0, i32 1
  store i32 4294967295, ptr %67
  %68 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_lower_bound_1(ptr %68, ptr %stack.ptr_19, ptr %stack.ptr_21)
  %69 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_upper_bound_1(ptr %69, ptr %stack.ptr_20, ptr %stack.ptr_22)
  br label %loop_3
loop_3:
  %70 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_21, ptr %stack.ptr_22)
  br i1 %70, label %if_4, label %end_if_4
if_4:
  br label %range_query.end_2
end_if_4:
  %71 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_21)
  %72 = getelementptr [2 x i32], ptr %stack.ptr_23, i32 0, i32 0
  %73 = getelementptr [2 x i32], ptr %71, i32 0, i32 1
  %74 = load i32, ptr %73
  store i32 %74, ptr %72
  %75 = getelementptr [2 x i32], ptr %stack.ptr_23, i32 0, i32 1
  store i32 0, ptr %75
  %76 = getelementptr [2 x i32], ptr %stack.ptr_24, i32 0, i32 0
  %77 = getelementptr [2 x i32], ptr %71, i32 0, i32 1
  %78 = load i32, ptr %77
  store i32 %78, ptr %76
  %79 = getelementptr [2 x i32], ptr %stack.ptr_24, i32 0, i32 1
  store i32 4294967295, ptr %79
  %80 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_lower_bound_1(ptr %80, ptr %stack.ptr_23, ptr %stack.ptr_25)
  %81 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_upper_bound_1(ptr %81, ptr %stack.ptr_24, ptr %stack.ptr_26)
  br label %loop_4
loop_4:
  %82 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_25, ptr %stack.ptr_26)
  br i1 %82, label %if_5, label %end_if_5
if_5:
  br label %range_query.end_3
end_if_5:
  %83 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_25)
  %84 = getelementptr [2 x i32], ptr %stack.ptr_27, i32 0, i32 0
  %85 = getelementptr [2 x i32], ptr %71, i32 0, i32 0
  %86 = load i32, ptr %85
  store i32 %86, ptr %84
  %87 = getelementptr [2 x i32], ptr %stack.ptr_27, i32 0, i32 1
  %88 = getelementptr [2 x i32], ptr %83, i32 0, i32 1
  %89 = load i32, ptr %88
  store i32 %89, ptr %87
  %90 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  %91 = call ccc i1 @eclair_btree_contains_1(ptr %90, ptr %stack.ptr_27)
  %92 = select i1 %91, i1 0, i1 1
  br i1 %92, label %if_6, label %end_if_6
if_6:
  %93 = getelementptr [2 x i32], ptr %stack.ptr_28, i32 0, i32 0
  %94 = getelementptr [2 x i32], ptr %71, i32 0, i32 0
  %95 = load i32, ptr %94
  store i32 %95, ptr %93
  %96 = getelementptr [2 x i32], ptr %stack.ptr_28, i32 0, i32 1
  %97 = getelementptr [2 x i32], ptr %83, i32 0, i32 1
  %98 = load i32, ptr %97
  store i32 %98, ptr %96
  %99 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %100 = call ccc i1 @eclair_btree_insert_value_1(ptr %99, ptr %stack.ptr_28)
  %101 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  %102 = call ccc i1 @eclair_btree_insert_value_2(ptr %101, ptr %stack.ptr_28)
  br label %end_if_6
end_if_6:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_25)
  br label %loop_4
range_query.end_3:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_21)
  br label %loop_3
range_query.end_2:
  %103 = getelementptr [3 x i32], ptr %stack.ptr_29, i32 0, i32 0
  store i32 0, ptr %103
  %104 = getelementptr [3 x i32], ptr %stack.ptr_29, i32 0, i32 1
  store i32 0, ptr %104
  %105 = getelementptr [3 x i32], ptr %stack.ptr_29, i32 0, i32 2
  store i32 0, ptr %105
  %106 = getelementptr [3 x i32], ptr %stack.ptr_30, i32 0, i32 0
  store i32 4294967295, ptr %106
  %107 = getelementptr [3 x i32], ptr %stack.ptr_30, i32 0, i32 1
  store i32 4294967295, ptr %107
  %108 = getelementptr [3 x i32], ptr %stack.ptr_30, i32 0, i32 2
  store i32 4294967295, ptr %108
  %109 = getelementptr %program, ptr %arg_0, i32 0, i32 1
  call ccc void @eclair_btree_lower_bound_0(ptr %109, ptr %stack.ptr_29, ptr %stack.ptr_31)
  %110 = getelementptr %program, ptr %arg_0, i32 0, i32 1
  call ccc void @eclair_btree_upper_bound_0(ptr %110, ptr %stack.ptr_30, ptr %stack.ptr_32)
  br label %loop_5
loop_5:
  %111 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_31, ptr %stack.ptr_32)
  br i1 %111, label %if_7, label %end_if_7
if_7:
  br label %range_query.end_4
end_if_7:
  %112 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_31)
  %113 = getelementptr [2 x i32], ptr %stack.ptr_33, i32 0, i32 0
  store i32 0, ptr %113
  %114 = getelementptr [2 x i32], ptr %stack.ptr_33, i32 0, i32 1
  %115 = getelementptr [3 x i32], ptr %112, i32 0, i32 1
  %116 = load i32, ptr %115
  store i32 %116, ptr %114
  %117 = getelementptr [2 x i32], ptr %stack.ptr_34, i32 0, i32 0
  store i32 4294967295, ptr %117
  %118 = getelementptr [2 x i32], ptr %stack.ptr_34, i32 0, i32 1
  %119 = getelementptr [3 x i32], ptr %112, i32 0, i32 1
  %120 = load i32, ptr %119
  store i32 %120, ptr %118
  %121 = getelementptr %program, ptr %arg_0, i32 0, i32 3
  call ccc void @eclair_btree_lower_bound_2(ptr %121, ptr %stack.ptr_33, ptr %stack.ptr_35)
  %122 = getelementptr %program, ptr %arg_0, i32 0, i32 3
  call ccc void @eclair_btree_upper_bound_2(ptr %122, ptr %stack.ptr_34, ptr %stack.ptr_36)
  br label %loop_6
loop_6:
  %123 = call ccc i1 @eclair_btree_iterator_is_equal_2(ptr %stack.ptr_35, ptr %stack.ptr_36)
  br i1 %123, label %if_8, label %end_if_8
if_8:
  br label %range_query.end_5
end_if_8:
  %124 = call ccc ptr @eclair_btree_iterator_current_2(ptr %stack.ptr_35)
  %125 = getelementptr [2 x i32], ptr %stack.ptr_37, i32 0, i32 0
  %126 = getelementptr [2 x i32], ptr %124, i32 0, i32 0
  %127 = load i32, ptr %126
  store i32 %127, ptr %125
  %128 = getelementptr [2 x i32], ptr %stack.ptr_37, i32 0, i32 1
  %129 = getelementptr [3 x i32], ptr %112, i32 0, i32 0
  %130 = load i32, ptr %129
  store i32 %130, ptr %128
  %131 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  %132 = call ccc i1 @eclair_btree_contains_1(ptr %131, ptr %stack.ptr_37)
  %133 = select i1 %132, i1 0, i1 1
  br i1 %133, label %if_9, label %end_if_11
if_9:
  %134 = getelementptr [2 x i32], ptr %stack.ptr_38, i32 0, i32 0
  %135 = getelementptr [2 x i32], ptr %124, i32 0, i32 0
  %136 = load i32, ptr %135
  store i32 %136, ptr %134
  %137 = getelementptr [2 x i32], ptr %stack.ptr_38, i32 0, i32 1
  %138 = getelementptr [3 x i32], ptr %112, i32 0, i32 2
  %139 = load i32, ptr %138
  store i32 %139, ptr %137
  %140 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  %141 = call ccc i1 @eclair_btree_contains_1(ptr %140, ptr %stack.ptr_38)
  %142 = select i1 %141, i1 0, i1 1
  br i1 %142, label %if_10, label %end_if_10
if_10:
  %143 = getelementptr [2 x i32], ptr %stack.ptr_39, i32 0, i32 0
  %144 = getelementptr [2 x i32], ptr %124, i32 0, i32 0
  %145 = load i32, ptr %144
  store i32 %145, ptr %143
  %146 = getelementptr [2 x i32], ptr %stack.ptr_39, i32 0, i32 1
  %147 = getelementptr [3 x i32], ptr %112, i32 0, i32 0
  %148 = load i32, ptr %147
  store i32 %148, ptr %146
  %149 = getelementptr [2 x i32], ptr %stack.ptr_40, i32 0, i32 0
  %150 = getelementptr [2 x i32], ptr %124, i32 0, i32 0
  %151 = load i32, ptr %150
  store i32 %151, ptr %149
  %152 = getelementptr [2 x i32], ptr %stack.ptr_40, i32 0, i32 1
  %153 = getelementptr [3 x i32], ptr %112, i32 0, i32 0
  %154 = load i32, ptr %153
  store i32 %154, ptr %152
  %155 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_lower_bound_1(ptr %155, ptr %stack.ptr_39, ptr %stack.ptr_41)
  %156 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_upper_bound_1(ptr %156, ptr %stack.ptr_40, ptr %stack.ptr_42)
  br label %loop_7
loop_7:
  %157 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_41, ptr %stack.ptr_42)
  br i1 %157, label %if_11, label %end_if_9
if_11:
  br label %range_query.end_6
end_if_9:
  %158 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_41)
  %159 = getelementptr [2 x i32], ptr %stack.ptr_43, i32 0, i32 0
  %160 = getelementptr [2 x i32], ptr %124, i32 0, i32 0
  %161 = load i32, ptr %160
  store i32 %161, ptr %159
  %162 = getelementptr [2 x i32], ptr %stack.ptr_43, i32 0, i32 1
  %163 = getelementptr [3 x i32], ptr %112, i32 0, i32 2
  %164 = load i32, ptr %163
  store i32 %164, ptr %162
  %165 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %166 = call ccc i1 @eclair_btree_insert_value_1(ptr %165, ptr %stack.ptr_43)
  %167 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  %168 = call ccc i1 @eclair_btree_insert_value_2(ptr %167, ptr %stack.ptr_43)
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_41)
  br label %loop_7
range_query.end_6:
  br label %end_if_10
end_if_10:
  br label %end_if_11
end_if_11:
  call ccc void @eclair_btree_iterator_next_2(ptr %stack.ptr_35)
  br label %loop_6
range_query.end_5:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_31)
  br label %loop_5
range_query.end_4:
  %169 = getelementptr [3 x i32], ptr %stack.ptr_44, i32 0, i32 0
  store i32 0, ptr %169
  %170 = getelementptr [3 x i32], ptr %stack.ptr_44, i32 0, i32 1
  store i32 0, ptr %170
  %171 = getelementptr [3 x i32], ptr %stack.ptr_44, i32 0, i32 2
  store i32 0, ptr %171
  %172 = getelementptr [3 x i32], ptr %stack.ptr_45, i32 0, i32 0
  store i32 4294967295, ptr %172
  %173 = getelementptr [3 x i32], ptr %stack.ptr_45, i32 0, i32 1
  store i32 4294967295, ptr %173
  %174 = getelementptr [3 x i32], ptr %stack.ptr_45, i32 0, i32 2
  store i32 4294967295, ptr %174
  %175 = getelementptr %program, ptr %arg_0, i32 0, i32 1
  call ccc void @eclair_btree_lower_bound_0(ptr %175, ptr %stack.ptr_44, ptr %stack.ptr_46)
  %176 = getelementptr %program, ptr %arg_0, i32 0, i32 1
  call ccc void @eclair_btree_upper_bound_0(ptr %176, ptr %stack.ptr_45, ptr %stack.ptr_47)
  br label %loop_8
loop_8:
  %177 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_46, ptr %stack.ptr_47)
  br i1 %177, label %if_12, label %end_if_12
if_12:
  br label %range_query.end_7
end_if_12:
  %178 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_46)
  %179 = getelementptr [2 x i32], ptr %stack.ptr_48, i32 0, i32 0
  store i32 0, ptr %179
  %180 = getelementptr [2 x i32], ptr %stack.ptr_48, i32 0, i32 1
  %181 = getelementptr [3 x i32], ptr %178, i32 0, i32 1
  %182 = load i32, ptr %181
  store i32 %182, ptr %180
  %183 = getelementptr [2 x i32], ptr %stack.ptr_49, i32 0, i32 0
  store i32 4294967295, ptr %183
  %184 = getelementptr [2 x i32], ptr %stack.ptr_49, i32 0, i32 1
  %185 = getelementptr [3 x i32], ptr %178, i32 0, i32 1
  %186 = load i32, ptr %185
  store i32 %186, ptr %184
  %187 = getelementptr %program, ptr %arg_0, i32 0, i32 11
  call ccc void @eclair_btree_lower_bound_2(ptr %187, ptr %stack.ptr_48, ptr %stack.ptr_50)
  %188 = getelementptr %program, ptr %arg_0, i32 0, i32 11
  call ccc void @eclair_btree_upper_bound_2(ptr %188, ptr %stack.ptr_49, ptr %stack.ptr_51)
  br label %loop_9
loop_9:
  %189 = call ccc i1 @eclair_btree_iterator_is_equal_2(ptr %stack.ptr_50, ptr %stack.ptr_51)
  br i1 %189, label %if_13, label %end_if_13
if_13:
  br label %range_query.end_8
end_if_13:
  %190 = call ccc ptr @eclair_btree_iterator_current_2(ptr %stack.ptr_50)
  %191 = getelementptr [2 x i32], ptr %stack.ptr_52, i32 0, i32 0
  %192 = getelementptr [2 x i32], ptr %190, i32 0, i32 0
  %193 = load i32, ptr %192
  store i32 %193, ptr %191
  %194 = getelementptr [2 x i32], ptr %stack.ptr_52, i32 0, i32 1
  %195 = getelementptr [3 x i32], ptr %178, i32 0, i32 2
  %196 = load i32, ptr %195
  store i32 %196, ptr %194
  %197 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  %198 = call ccc i1 @eclair_btree_contains_1(ptr %197, ptr %stack.ptr_52)
  %199 = select i1 %198, i1 0, i1 1
  br i1 %199, label %if_14, label %end_if_15
if_14:
  %200 = getelementptr [2 x i32], ptr %stack.ptr_53, i32 0, i32 0
  %201 = getelementptr [2 x i32], ptr %190, i32 0, i32 0
  %202 = load i32, ptr %201
  store i32 %202, ptr %200
  %203 = getelementptr [2 x i32], ptr %stack.ptr_53, i32 0, i32 1
  %204 = getelementptr [3 x i32], ptr %178, i32 0, i32 0
  %205 = load i32, ptr %204
  store i32 %205, ptr %203
  %206 = getelementptr [2 x i32], ptr %stack.ptr_54, i32 0, i32 0
  %207 = getelementptr [2 x i32], ptr %190, i32 0, i32 0
  %208 = load i32, ptr %207
  store i32 %208, ptr %206
  %209 = getelementptr [2 x i32], ptr %stack.ptr_54, i32 0, i32 1
  %210 = getelementptr [3 x i32], ptr %178, i32 0, i32 0
  %211 = load i32, ptr %210
  store i32 %211, ptr %209
  %212 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_lower_bound_1(ptr %212, ptr %stack.ptr_53, ptr %stack.ptr_55)
  %213 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_upper_bound_1(ptr %213, ptr %stack.ptr_54, ptr %stack.ptr_56)
  br label %loop_10
loop_10:
  %214 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_55, ptr %stack.ptr_56)
  br i1 %214, label %if_15, label %end_if_14
if_15:
  br label %range_query.end_9
end_if_14:
  %215 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_55)
  %216 = getelementptr [2 x i32], ptr %stack.ptr_57, i32 0, i32 0
  %217 = getelementptr [2 x i32], ptr %190, i32 0, i32 0
  %218 = load i32, ptr %217
  store i32 %218, ptr %216
  %219 = getelementptr [2 x i32], ptr %stack.ptr_57, i32 0, i32 1
  %220 = getelementptr [3 x i32], ptr %178, i32 0, i32 2
  %221 = load i32, ptr %220
  store i32 %221, ptr %219
  %222 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %223 = call ccc i1 @eclair_btree_insert_value_1(ptr %222, ptr %stack.ptr_57)
  %224 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  %225 = call ccc i1 @eclair_btree_insert_value_2(ptr %224, ptr %stack.ptr_57)
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_55)
  br label %loop_10
range_query.end_9:
  br label %end_if_15
end_if_15:
  call ccc void @eclair_btree_iterator_next_2(ptr %stack.ptr_50)
  br label %loop_9
range_query.end_8:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_46)
  br label %loop_8
range_query.end_7:
  %226 = getelementptr [2 x i32], ptr %stack.ptr_58, i32 0, i32 0
  store i32 0, ptr %226
  %227 = getelementptr [2 x i32], ptr %stack.ptr_58, i32 0, i32 1
  store i32 0, ptr %227
  %228 = getelementptr [2 x i32], ptr %stack.ptr_59, i32 0, i32 0
  store i32 4294967295, ptr %228
  %229 = getelementptr [2 x i32], ptr %stack.ptr_59, i32 0, i32 1
  store i32 4294967295, ptr %229
  %230 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_lower_bound_1(ptr %230, ptr %stack.ptr_58, ptr %stack.ptr_60)
  %231 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_upper_bound_1(ptr %231, ptr %stack.ptr_59, ptr %stack.ptr_61)
  br label %loop_11
loop_11:
  %232 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_60, ptr %stack.ptr_61)
  br i1 %232, label %if_16, label %end_if_16
if_16:
  br label %range_query.end_10
end_if_16:
  %233 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_60)
  %234 = getelementptr [3 x i32], ptr %stack.ptr_62, i32 0, i32 0
  %235 = getelementptr [2 x i32], ptr %233, i32 0, i32 1
  %236 = load i32, ptr %235
  store i32 %236, ptr %234
  %237 = getelementptr [3 x i32], ptr %stack.ptr_62, i32 0, i32 1
  store i32 0, ptr %237
  %238 = getelementptr [3 x i32], ptr %stack.ptr_62, i32 0, i32 2
  store i32 0, ptr %238
  %239 = getelementptr [3 x i32], ptr %stack.ptr_63, i32 0, i32 0
  %240 = getelementptr [2 x i32], ptr %233, i32 0, i32 1
  %241 = load i32, ptr %240
  store i32 %241, ptr %239
  %242 = getelementptr [3 x i32], ptr %stack.ptr_63, i32 0, i32 1
  store i32 4294967295, ptr %242
  %243 = getelementptr [3 x i32], ptr %stack.ptr_63, i32 0, i32 2
  store i32 4294967295, ptr %243
  %244 = getelementptr %program, ptr %arg_0, i32 0, i32 16
  call ccc void @eclair_btree_lower_bound_0(ptr %244, ptr %stack.ptr_62, ptr %stack.ptr_64)
  %245 = getelementptr %program, ptr %arg_0, i32 0, i32 16
  call ccc void @eclair_btree_upper_bound_0(ptr %245, ptr %stack.ptr_63, ptr %stack.ptr_65)
  br label %loop_12
loop_12:
  %246 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_64, ptr %stack.ptr_65)
  br i1 %246, label %if_17, label %end_if_17
if_17:
  br label %range_query.end_11
end_if_17:
  %247 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_64)
  %248 = getelementptr [3 x i32], ptr %stack.ptr_66, i32 0, i32 0
  store i32 0, ptr %248
  %249 = getelementptr [3 x i32], ptr %stack.ptr_66, i32 0, i32 1
  %250 = getelementptr [3 x i32], ptr %247, i32 0, i32 1
  %251 = load i32, ptr %250
  store i32 %251, ptr %249
  %252 = getelementptr [3 x i32], ptr %stack.ptr_66, i32 0, i32 2
  %253 = getelementptr [2 x i32], ptr %233, i32 0, i32 0
  %254 = load i32, ptr %253
  store i32 %254, ptr %252
  %255 = getelementptr [3 x i32], ptr %stack.ptr_67, i32 0, i32 0
  store i32 4294967295, ptr %255
  %256 = getelementptr [3 x i32], ptr %stack.ptr_67, i32 0, i32 1
  %257 = getelementptr [3 x i32], ptr %247, i32 0, i32 1
  %258 = load i32, ptr %257
  store i32 %258, ptr %256
  %259 = getelementptr [3 x i32], ptr %stack.ptr_67, i32 0, i32 2
  %260 = getelementptr [2 x i32], ptr %233, i32 0, i32 0
  %261 = load i32, ptr %260
  store i32 %261, ptr %259
  %262 = getelementptr %program, ptr %arg_0, i32 0, i32 13
  call ccc void @eclair_btree_lower_bound_3(ptr %262, ptr %stack.ptr_66, ptr %stack.ptr_68)
  %263 = getelementptr %program, ptr %arg_0, i32 0, i32 13
  call ccc void @eclair_btree_upper_bound_3(ptr %263, ptr %stack.ptr_67, ptr %stack.ptr_69)
  br label %loop_13
loop_13:
  %264 = call ccc i1 @eclair_btree_iterator_is_equal_3(ptr %stack.ptr_68, ptr %stack.ptr_69)
  br i1 %264, label %if_18, label %end_if_18
if_18:
  br label %range_query.end_12
end_if_18:
  %265 = call ccc ptr @eclair_btree_iterator_current_3(ptr %stack.ptr_68)
  %266 = getelementptr [3 x i32], ptr %stack.ptr_70, i32 0, i32 0
  %267 = getelementptr [3 x i32], ptr %265, i32 0, i32 0
  %268 = load i32, ptr %267
  store i32 %268, ptr %266
  %269 = getelementptr [3 x i32], ptr %stack.ptr_70, i32 0, i32 1
  %270 = getelementptr [3 x i32], ptr %247, i32 0, i32 1
  %271 = load i32, ptr %270
  store i32 %271, ptr %269
  %272 = getelementptr [3 x i32], ptr %stack.ptr_70, i32 0, i32 2
  %273 = getelementptr [2 x i32], ptr %233, i32 0, i32 0
  %274 = load i32, ptr %273
  store i32 %274, ptr %272
  %275 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  %276 = call ccc i1 @eclair_btree_contains_0(ptr %275, ptr %stack.ptr_70)
  %277 = select i1 %276, i1 0, i1 1
  br i1 %277, label %if_19, label %end_if_20
if_19:
  %278 = getelementptr [2 x i32], ptr %stack.ptr_71, i32 0, i32 0
  %279 = getelementptr [3 x i32], ptr %265, i32 0, i32 0
  %280 = load i32, ptr %279
  store i32 %280, ptr %278
  %281 = getelementptr [2 x i32], ptr %stack.ptr_71, i32 0, i32 1
  %282 = getelementptr [3 x i32], ptr %247, i32 0, i32 2
  %283 = load i32, ptr %282
  store i32 %283, ptr %281
  %284 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  %285 = call ccc i1 @eclair_btree_contains_1(ptr %284, ptr %stack.ptr_71)
  %286 = select i1 %285, i1 0, i1 1
  br i1 %286, label %if_20, label %end_if_19
if_20:
  %287 = getelementptr [2 x i32], ptr %stack.ptr_72, i32 0, i32 0
  %288 = getelementptr [3 x i32], ptr %265, i32 0, i32 0
  %289 = load i32, ptr %288
  store i32 %289, ptr %287
  %290 = getelementptr [2 x i32], ptr %stack.ptr_72, i32 0, i32 1
  %291 = getelementptr [3 x i32], ptr %247, i32 0, i32 2
  %292 = load i32, ptr %291
  store i32 %292, ptr %290
  %293 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %294 = call ccc i1 @eclair_btree_insert_value_1(ptr %293, ptr %stack.ptr_72)
  %295 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  %296 = call ccc i1 @eclair_btree_insert_value_2(ptr %295, ptr %stack.ptr_72)
  br label %end_if_19
end_if_19:
  br label %end_if_20
end_if_20:
  call ccc void @eclair_btree_iterator_next_3(ptr %stack.ptr_68)
  br label %loop_13
range_query.end_12:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_64)
  br label %loop_12
range_query.end_11:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_60)
  br label %loop_11
range_query.end_10:
  %297 = getelementptr [2 x i32], ptr %stack.ptr_73, i32 0, i32 0
  store i32 0, ptr %297
  %298 = getelementptr [2 x i32], ptr %stack.ptr_73, i32 0, i32 1
  store i32 0, ptr %298
  %299 = getelementptr [2 x i32], ptr %stack.ptr_74, i32 0, i32 0
  store i32 4294967295, ptr %299
  %300 = getelementptr [2 x i32], ptr %stack.ptr_74, i32 0, i32 1
  store i32 4294967295, ptr %300
  %301 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_lower_bound_1(ptr %301, ptr %stack.ptr_73, ptr %stack.ptr_75)
  %302 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_upper_bound_1(ptr %302, ptr %stack.ptr_74, ptr %stack.ptr_76)
  br label %loop_14
loop_14:
  %303 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_75, ptr %stack.ptr_76)
  br i1 %303, label %if_21, label %end_if_21
if_21:
  br label %range_query.end_13
end_if_21:
  %304 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_75)
  %305 = getelementptr [3 x i32], ptr %stack.ptr_77, i32 0, i32 0
  %306 = getelementptr [2 x i32], ptr %304, i32 0, i32 1
  %307 = load i32, ptr %306
  store i32 %307, ptr %305
  %308 = getelementptr [3 x i32], ptr %stack.ptr_77, i32 0, i32 1
  store i32 0, ptr %308
  %309 = getelementptr [3 x i32], ptr %stack.ptr_77, i32 0, i32 2
  store i32 0, ptr %309
  %310 = getelementptr [3 x i32], ptr %stack.ptr_78, i32 0, i32 0
  %311 = getelementptr [2 x i32], ptr %304, i32 0, i32 1
  %312 = load i32, ptr %311
  store i32 %312, ptr %310
  %313 = getelementptr [3 x i32], ptr %stack.ptr_78, i32 0, i32 1
  store i32 4294967295, ptr %313
  %314 = getelementptr [3 x i32], ptr %stack.ptr_78, i32 0, i32 2
  store i32 4294967295, ptr %314
  %315 = getelementptr %program, ptr %arg_0, i32 0, i32 16
  call ccc void @eclair_btree_lower_bound_0(ptr %315, ptr %stack.ptr_77, ptr %stack.ptr_79)
  %316 = getelementptr %program, ptr %arg_0, i32 0, i32 16
  call ccc void @eclair_btree_upper_bound_0(ptr %316, ptr %stack.ptr_78, ptr %stack.ptr_80)
  br label %loop_15
loop_15:
  %317 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_79, ptr %stack.ptr_80)
  br i1 %317, label %if_22, label %end_if_22
if_22:
  br label %range_query.end_14
end_if_22:
  %318 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_79)
  %319 = getelementptr [3 x i32], ptr %stack.ptr_81, i32 0, i32 0
  store i32 0, ptr %319
  %320 = getelementptr [3 x i32], ptr %stack.ptr_81, i32 0, i32 1
  %321 = getelementptr [3 x i32], ptr %318, i32 0, i32 1
  %322 = load i32, ptr %321
  store i32 %322, ptr %320
  %323 = getelementptr [3 x i32], ptr %stack.ptr_81, i32 0, i32 2
  %324 = getelementptr [2 x i32], ptr %304, i32 0, i32 0
  %325 = load i32, ptr %324
  store i32 %325, ptr %323
  %326 = getelementptr [3 x i32], ptr %stack.ptr_82, i32 0, i32 0
  store i32 4294967295, ptr %326
  %327 = getelementptr [3 x i32], ptr %stack.ptr_82, i32 0, i32 1
  %328 = getelementptr [3 x i32], ptr %318, i32 0, i32 1
  %329 = load i32, ptr %328
  store i32 %329, ptr %327
  %330 = getelementptr [3 x i32], ptr %stack.ptr_82, i32 0, i32 2
  %331 = getelementptr [2 x i32], ptr %304, i32 0, i32 0
  %332 = load i32, ptr %331
  store i32 %332, ptr %330
  %333 = getelementptr %program, ptr %arg_0, i32 0, i32 5
  call ccc void @eclair_btree_lower_bound_3(ptr %333, ptr %stack.ptr_81, ptr %stack.ptr_83)
  %334 = getelementptr %program, ptr %arg_0, i32 0, i32 5
  call ccc void @eclair_btree_upper_bound_3(ptr %334, ptr %stack.ptr_82, ptr %stack.ptr_84)
  br label %loop_16
loop_16:
  %335 = call ccc i1 @eclair_btree_iterator_is_equal_3(ptr %stack.ptr_83, ptr %stack.ptr_84)
  br i1 %335, label %if_23, label %end_if_23
if_23:
  br label %range_query.end_15
end_if_23:
  %336 = call ccc ptr @eclair_btree_iterator_current_3(ptr %stack.ptr_83)
  %337 = getelementptr [2 x i32], ptr %stack.ptr_85, i32 0, i32 0
  %338 = getelementptr [3 x i32], ptr %336, i32 0, i32 0
  %339 = load i32, ptr %338
  store i32 %339, ptr %337
  %340 = getelementptr [2 x i32], ptr %stack.ptr_85, i32 0, i32 1
  %341 = getelementptr [3 x i32], ptr %318, i32 0, i32 2
  %342 = load i32, ptr %341
  store i32 %342, ptr %340
  %343 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  %344 = call ccc i1 @eclair_btree_contains_1(ptr %343, ptr %stack.ptr_85)
  %345 = select i1 %344, i1 0, i1 1
  br i1 %345, label %if_24, label %end_if_24
if_24:
  %346 = getelementptr [2 x i32], ptr %stack.ptr_86, i32 0, i32 0
  %347 = getelementptr [3 x i32], ptr %336, i32 0, i32 0
  %348 = load i32, ptr %347
  store i32 %348, ptr %346
  %349 = getelementptr [2 x i32], ptr %stack.ptr_86, i32 0, i32 1
  %350 = getelementptr [3 x i32], ptr %318, i32 0, i32 2
  %351 = load i32, ptr %350
  store i32 %351, ptr %349
  %352 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %353 = call ccc i1 @eclair_btree_insert_value_1(ptr %352, ptr %stack.ptr_86)
  %354 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  %355 = call ccc i1 @eclair_btree_insert_value_2(ptr %354, ptr %stack.ptr_86)
  br label %end_if_24
end_if_24:
  call ccc void @eclair_btree_iterator_next_3(ptr %stack.ptr_83)
  br label %loop_16
range_query.end_15:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_79)
  br label %loop_15
range_query.end_14:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_75)
  br label %loop_14
range_query.end_13:
  %356 = getelementptr [3 x i32], ptr %stack.ptr_87, i32 0, i32 0
  store i32 0, ptr %356
  %357 = getelementptr [3 x i32], ptr %stack.ptr_87, i32 0, i32 1
  store i32 0, ptr %357
  %358 = getelementptr [3 x i32], ptr %stack.ptr_87, i32 0, i32 2
  store i32 0, ptr %358
  %359 = getelementptr [3 x i32], ptr %stack.ptr_88, i32 0, i32 0
  store i32 4294967295, ptr %359
  %360 = getelementptr [3 x i32], ptr %stack.ptr_88, i32 0, i32 1
  store i32 4294967295, ptr %360
  %361 = getelementptr [3 x i32], ptr %stack.ptr_88, i32 0, i32 2
  store i32 4294967295, ptr %361
  %362 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_lower_bound_0(ptr %362, ptr %stack.ptr_87, ptr %stack.ptr_89)
  %363 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_upper_bound_0(ptr %363, ptr %stack.ptr_88, ptr %stack.ptr_90)
  br label %loop_17
loop_17:
  %364 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_89, ptr %stack.ptr_90)
  br i1 %364, label %if_25, label %end_if_25
if_25:
  br label %range_query.end_16
end_if_25:
  %365 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_89)
  %366 = getelementptr [3 x i32], ptr %stack.ptr_91, i32 0, i32 0
  %367 = getelementptr [3 x i32], ptr %365, i32 0, i32 1
  %368 = load i32, ptr %367
  store i32 %368, ptr %366
  %369 = getelementptr [3 x i32], ptr %stack.ptr_91, i32 0, i32 1
  store i32 0, ptr %369
  %370 = getelementptr [3 x i32], ptr %stack.ptr_91, i32 0, i32 2
  store i32 0, ptr %370
  %371 = getelementptr [3 x i32], ptr %stack.ptr_92, i32 0, i32 0
  %372 = getelementptr [3 x i32], ptr %365, i32 0, i32 1
  %373 = load i32, ptr %372
  store i32 %373, ptr %371
  %374 = getelementptr [3 x i32], ptr %stack.ptr_92, i32 0, i32 1
  store i32 4294967295, ptr %374
  %375 = getelementptr [3 x i32], ptr %stack.ptr_92, i32 0, i32 2
  store i32 4294967295, ptr %375
  %376 = getelementptr %program, ptr %arg_0, i32 0, i32 14
  call ccc void @eclair_btree_lower_bound_0(ptr %376, ptr %stack.ptr_91, ptr %stack.ptr_93)
  %377 = getelementptr %program, ptr %arg_0, i32 0, i32 14
  call ccc void @eclair_btree_upper_bound_0(ptr %377, ptr %stack.ptr_92, ptr %stack.ptr_94)
  br label %loop_18
loop_18:
  %378 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_93, ptr %stack.ptr_94)
  br i1 %378, label %if_26, label %end_if_26
if_26:
  br label %range_query.end_17
end_if_26:
  %379 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_93)
  %380 = getelementptr [3 x i32], ptr %stack.ptr_95, i32 0, i32 0
  %381 = getelementptr [3 x i32], ptr %365, i32 0, i32 2
  %382 = load i32, ptr %381
  store i32 %382, ptr %380
  %383 = getelementptr [3 x i32], ptr %stack.ptr_95, i32 0, i32 1
  %384 = getelementptr [3 x i32], ptr %379, i32 0, i32 1
  %385 = load i32, ptr %384
  store i32 %385, ptr %383
  %386 = getelementptr [3 x i32], ptr %stack.ptr_95, i32 0, i32 2
  store i32 0, ptr %386
  %387 = getelementptr [3 x i32], ptr %stack.ptr_96, i32 0, i32 0
  %388 = getelementptr [3 x i32], ptr %365, i32 0, i32 2
  %389 = load i32, ptr %388
  store i32 %389, ptr %387
  %390 = getelementptr [3 x i32], ptr %stack.ptr_96, i32 0, i32 1
  %391 = getelementptr [3 x i32], ptr %379, i32 0, i32 1
  %392 = load i32, ptr %391
  store i32 %392, ptr %390
  %393 = getelementptr [3 x i32], ptr %stack.ptr_96, i32 0, i32 2
  store i32 4294967295, ptr %393
  %394 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_lower_bound_0(ptr %394, ptr %stack.ptr_95, ptr %stack.ptr_97)
  %395 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_upper_bound_0(ptr %395, ptr %stack.ptr_96, ptr %stack.ptr_98)
  br label %loop_19
loop_19:
  %396 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_97, ptr %stack.ptr_98)
  br i1 %396, label %if_27, label %end_if_27
if_27:
  br label %range_query.end_18
end_if_27:
  %397 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_97)
  %398 = getelementptr [3 x i32], ptr %stack.ptr_99, i32 0, i32 0
  %399 = getelementptr [3 x i32], ptr %365, i32 0, i32 2
  %400 = load i32, ptr %399
  store i32 %400, ptr %398
  %401 = getelementptr [3 x i32], ptr %stack.ptr_99, i32 0, i32 1
  %402 = getelementptr [3 x i32], ptr %379, i32 0, i32 1
  %403 = load i32, ptr %402
  store i32 %403, ptr %401
  %404 = getelementptr [3 x i32], ptr %stack.ptr_99, i32 0, i32 2
  %405 = getelementptr [3 x i32], ptr %397, i32 0, i32 2
  %406 = load i32, ptr %405
  store i32 %406, ptr %404
  %407 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  %408 = call ccc i1 @eclair_btree_contains_0(ptr %407, ptr %stack.ptr_99)
  %409 = select i1 %408, i1 0, i1 1
  br i1 %409, label %if_28, label %end_if_29
if_28:
  %410 = getelementptr [3 x i32], ptr %stack.ptr_100, i32 0, i32 0
  %411 = getelementptr [3 x i32], ptr %365, i32 0, i32 0
  %412 = load i32, ptr %411
  store i32 %412, ptr %410
  %413 = getelementptr [3 x i32], ptr %stack.ptr_100, i32 0, i32 1
  %414 = getelementptr [3 x i32], ptr %379, i32 0, i32 2
  %415 = load i32, ptr %414
  store i32 %415, ptr %413
  %416 = getelementptr [3 x i32], ptr %stack.ptr_100, i32 0, i32 2
  %417 = getelementptr [3 x i32], ptr %397, i32 0, i32 2
  %418 = load i32, ptr %417
  store i32 %418, ptr %416
  %419 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  %420 = call ccc i1 @eclair_btree_contains_0(ptr %419, ptr %stack.ptr_100)
  %421 = select i1 %420, i1 0, i1 1
  br i1 %421, label %if_29, label %end_if_28
if_29:
  %422 = getelementptr [3 x i32], ptr %stack.ptr_101, i32 0, i32 0
  %423 = getelementptr [3 x i32], ptr %365, i32 0, i32 0
  %424 = load i32, ptr %423
  store i32 %424, ptr %422
  %425 = getelementptr [3 x i32], ptr %stack.ptr_101, i32 0, i32 1
  %426 = getelementptr [3 x i32], ptr %379, i32 0, i32 2
  %427 = load i32, ptr %426
  store i32 %427, ptr %425
  %428 = getelementptr [3 x i32], ptr %stack.ptr_101, i32 0, i32 2
  %429 = getelementptr [3 x i32], ptr %397, i32 0, i32 2
  %430 = load i32, ptr %429
  store i32 %430, ptr %428
  %431 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  %432 = call ccc i1 @eclair_btree_insert_value_0(ptr %431, ptr %stack.ptr_101)
  %433 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  %434 = call ccc i1 @eclair_btree_insert_value_3(ptr %433, ptr %stack.ptr_101)
  br label %end_if_28
end_if_28:
  br label %end_if_29
end_if_29:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_97)
  br label %loop_19
range_query.end_18:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_93)
  br label %loop_18
range_query.end_17:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_89)
  br label %loop_17
range_query.end_16:
  %435 = getelementptr [3 x i32], ptr %stack.ptr_102, i32 0, i32 0
  store i32 0, ptr %435
  %436 = getelementptr [3 x i32], ptr %stack.ptr_102, i32 0, i32 1
  store i32 0, ptr %436
  %437 = getelementptr [3 x i32], ptr %stack.ptr_102, i32 0, i32 2
  store i32 0, ptr %437
  %438 = getelementptr [3 x i32], ptr %stack.ptr_103, i32 0, i32 0
  store i32 4294967295, ptr %438
  %439 = getelementptr [3 x i32], ptr %stack.ptr_103, i32 0, i32 1
  store i32 4294967295, ptr %439
  %440 = getelementptr [3 x i32], ptr %stack.ptr_103, i32 0, i32 2
  store i32 4294967295, ptr %440
  %441 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_lower_bound_0(ptr %441, ptr %stack.ptr_102, ptr %stack.ptr_104)
  %442 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_upper_bound_0(ptr %442, ptr %stack.ptr_103, ptr %stack.ptr_105)
  br label %loop_20
loop_20:
  %443 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_104, ptr %stack.ptr_105)
  br i1 %443, label %if_30, label %end_if_30
if_30:
  br label %range_query.end_19
end_if_30:
  %444 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_104)
  %445 = getelementptr [3 x i32], ptr %stack.ptr_106, i32 0, i32 0
  %446 = getelementptr [3 x i32], ptr %444, i32 0, i32 1
  %447 = load i32, ptr %446
  store i32 %447, ptr %445
  %448 = getelementptr [3 x i32], ptr %stack.ptr_106, i32 0, i32 1
  store i32 0, ptr %448
  %449 = getelementptr [3 x i32], ptr %stack.ptr_106, i32 0, i32 2
  store i32 0, ptr %449
  %450 = getelementptr [3 x i32], ptr %stack.ptr_107, i32 0, i32 0
  %451 = getelementptr [3 x i32], ptr %444, i32 0, i32 1
  %452 = load i32, ptr %451
  store i32 %452, ptr %450
  %453 = getelementptr [3 x i32], ptr %stack.ptr_107, i32 0, i32 1
  store i32 4294967295, ptr %453
  %454 = getelementptr [3 x i32], ptr %stack.ptr_107, i32 0, i32 2
  store i32 4294967295, ptr %454
  %455 = getelementptr %program, ptr %arg_0, i32 0, i32 14
  call ccc void @eclair_btree_lower_bound_0(ptr %455, ptr %stack.ptr_106, ptr %stack.ptr_108)
  %456 = getelementptr %program, ptr %arg_0, i32 0, i32 14
  call ccc void @eclair_btree_upper_bound_0(ptr %456, ptr %stack.ptr_107, ptr %stack.ptr_109)
  br label %loop_21
loop_21:
  %457 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_108, ptr %stack.ptr_109)
  br i1 %457, label %if_31, label %end_if_31
if_31:
  br label %range_query.end_20
end_if_31:
  %458 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_108)
  %459 = getelementptr [3 x i32], ptr %stack.ptr_110, i32 0, i32 0
  %460 = getelementptr [3 x i32], ptr %444, i32 0, i32 2
  %461 = load i32, ptr %460
  store i32 %461, ptr %459
  %462 = getelementptr [3 x i32], ptr %stack.ptr_110, i32 0, i32 1
  %463 = getelementptr [3 x i32], ptr %458, i32 0, i32 1
  %464 = load i32, ptr %463
  store i32 %464, ptr %462
  %465 = getelementptr [3 x i32], ptr %stack.ptr_110, i32 0, i32 2
  store i32 0, ptr %465
  %466 = getelementptr [3 x i32], ptr %stack.ptr_111, i32 0, i32 0
  %467 = getelementptr [3 x i32], ptr %444, i32 0, i32 2
  %468 = load i32, ptr %467
  store i32 %468, ptr %466
  %469 = getelementptr [3 x i32], ptr %stack.ptr_111, i32 0, i32 1
  %470 = getelementptr [3 x i32], ptr %458, i32 0, i32 1
  %471 = load i32, ptr %470
  store i32 %471, ptr %469
  %472 = getelementptr [3 x i32], ptr %stack.ptr_111, i32 0, i32 2
  store i32 4294967295, ptr %472
  %473 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_lower_bound_0(ptr %473, ptr %stack.ptr_110, ptr %stack.ptr_112)
  %474 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_upper_bound_0(ptr %474, ptr %stack.ptr_111, ptr %stack.ptr_113)
  br label %loop_22
loop_22:
  %475 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_112, ptr %stack.ptr_113)
  br i1 %475, label %if_32, label %end_if_32
if_32:
  br label %range_query.end_21
end_if_32:
  %476 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_112)
  %477 = getelementptr [3 x i32], ptr %stack.ptr_114, i32 0, i32 0
  %478 = getelementptr [3 x i32], ptr %444, i32 0, i32 0
  %479 = load i32, ptr %478
  store i32 %479, ptr %477
  %480 = getelementptr [3 x i32], ptr %stack.ptr_114, i32 0, i32 1
  %481 = getelementptr [3 x i32], ptr %458, i32 0, i32 2
  %482 = load i32, ptr %481
  store i32 %482, ptr %480
  %483 = getelementptr [3 x i32], ptr %stack.ptr_114, i32 0, i32 2
  %484 = getelementptr [3 x i32], ptr %476, i32 0, i32 2
  %485 = load i32, ptr %484
  store i32 %485, ptr %483
  %486 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  %487 = call ccc i1 @eclair_btree_contains_0(ptr %486, ptr %stack.ptr_114)
  %488 = select i1 %487, i1 0, i1 1
  br i1 %488, label %if_33, label %end_if_33
if_33:
  %489 = getelementptr [3 x i32], ptr %stack.ptr_115, i32 0, i32 0
  %490 = getelementptr [3 x i32], ptr %444, i32 0, i32 0
  %491 = load i32, ptr %490
  store i32 %491, ptr %489
  %492 = getelementptr [3 x i32], ptr %stack.ptr_115, i32 0, i32 1
  %493 = getelementptr [3 x i32], ptr %458, i32 0, i32 2
  %494 = load i32, ptr %493
  store i32 %494, ptr %492
  %495 = getelementptr [3 x i32], ptr %stack.ptr_115, i32 0, i32 2
  %496 = getelementptr [3 x i32], ptr %476, i32 0, i32 2
  %497 = load i32, ptr %496
  store i32 %497, ptr %495
  %498 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  %499 = call ccc i1 @eclair_btree_insert_value_0(ptr %498, ptr %stack.ptr_115)
  %500 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  %501 = call ccc i1 @eclair_btree_insert_value_3(ptr %500, ptr %stack.ptr_115)
  br label %end_if_33
end_if_33:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_112)
  br label %loop_22
range_query.end_21:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_108)
  br label %loop_21
range_query.end_20:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_104)
  br label %loop_20
range_query.end_19:
  %502 = getelementptr [3 x i32], ptr %stack.ptr_116, i32 0, i32 0
  store i32 0, ptr %502
  %503 = getelementptr [3 x i32], ptr %stack.ptr_116, i32 0, i32 1
  store i32 0, ptr %503
  %504 = getelementptr [3 x i32], ptr %stack.ptr_116, i32 0, i32 2
  store i32 0, ptr %504
  %505 = getelementptr [3 x i32], ptr %stack.ptr_117, i32 0, i32 0
  store i32 4294967295, ptr %505
  %506 = getelementptr [3 x i32], ptr %stack.ptr_117, i32 0, i32 1
  store i32 4294967295, ptr %506
  %507 = getelementptr [3 x i32], ptr %stack.ptr_117, i32 0, i32 2
  store i32 4294967295, ptr %507
  %508 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_lower_bound_0(ptr %508, ptr %stack.ptr_116, ptr %stack.ptr_118)
  %509 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_upper_bound_0(ptr %509, ptr %stack.ptr_117, ptr %stack.ptr_119)
  br label %loop_23
loop_23:
  %510 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_118, ptr %stack.ptr_119)
  br i1 %510, label %if_34, label %end_if_34
if_34:
  br label %range_query.end_22
end_if_34:
  %511 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_118)
  %512 = getelementptr [2 x i32], ptr %stack.ptr_120, i32 0, i32 0
  %513 = getelementptr [3 x i32], ptr %511, i32 0, i32 1
  %514 = load i32, ptr %513
  store i32 %514, ptr %512
  %515 = getelementptr [2 x i32], ptr %stack.ptr_120, i32 0, i32 1
  store i32 0, ptr %515
  %516 = getelementptr [2 x i32], ptr %stack.ptr_121, i32 0, i32 0
  %517 = getelementptr [3 x i32], ptr %511, i32 0, i32 1
  %518 = load i32, ptr %517
  store i32 %518, ptr %516
  %519 = getelementptr [2 x i32], ptr %stack.ptr_121, i32 0, i32 1
  store i32 4294967295, ptr %519
  %520 = getelementptr %program, ptr %arg_0, i32 0, i32 15
  call ccc void @eclair_btree_lower_bound_1(ptr %520, ptr %stack.ptr_120, ptr %stack.ptr_122)
  %521 = getelementptr %program, ptr %arg_0, i32 0, i32 15
  call ccc void @eclair_btree_upper_bound_1(ptr %521, ptr %stack.ptr_121, ptr %stack.ptr_123)
  br label %loop_24
loop_24:
  %522 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_122, ptr %stack.ptr_123)
  br i1 %522, label %if_35, label %end_if_35
if_35:
  br label %range_query.end_23
end_if_35:
  %523 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_122)
  %524 = getelementptr [3 x i32], ptr %stack.ptr_124, i32 0, i32 0
  %525 = getelementptr [3 x i32], ptr %511, i32 0, i32 0
  %526 = load i32, ptr %525
  store i32 %526, ptr %524
  %527 = getelementptr [3 x i32], ptr %stack.ptr_124, i32 0, i32 1
  %528 = getelementptr [2 x i32], ptr %523, i32 0, i32 1
  %529 = load i32, ptr %528
  store i32 %529, ptr %527
  %530 = getelementptr [3 x i32], ptr %stack.ptr_124, i32 0, i32 2
  %531 = getelementptr [3 x i32], ptr %511, i32 0, i32 2
  %532 = load i32, ptr %531
  store i32 %532, ptr %530
  %533 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  %534 = call ccc i1 @eclair_btree_contains_0(ptr %533, ptr %stack.ptr_124)
  %535 = select i1 %534, i1 0, i1 1
  br i1 %535, label %if_36, label %end_if_36
if_36:
  %536 = getelementptr [3 x i32], ptr %stack.ptr_125, i32 0, i32 0
  %537 = getelementptr [3 x i32], ptr %511, i32 0, i32 0
  %538 = load i32, ptr %537
  store i32 %538, ptr %536
  %539 = getelementptr [3 x i32], ptr %stack.ptr_125, i32 0, i32 1
  %540 = getelementptr [2 x i32], ptr %523, i32 0, i32 1
  %541 = load i32, ptr %540
  store i32 %541, ptr %539
  %542 = getelementptr [3 x i32], ptr %stack.ptr_125, i32 0, i32 2
  %543 = getelementptr [3 x i32], ptr %511, i32 0, i32 2
  %544 = load i32, ptr %543
  store i32 %544, ptr %542
  %545 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  %546 = call ccc i1 @eclair_btree_insert_value_0(ptr %545, ptr %stack.ptr_125)
  %547 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  %548 = call ccc i1 @eclair_btree_insert_value_3(ptr %547, ptr %stack.ptr_125)
  br label %end_if_36
end_if_36:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_122)
  br label %loop_24
range_query.end_23:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_118)
  br label %loop_23
range_query.end_22:
  %549 = getelementptr [2 x i32], ptr %stack.ptr_126, i32 0, i32 0
  store i32 0, ptr %549
  %550 = getelementptr [2 x i32], ptr %stack.ptr_126, i32 0, i32 1
  store i32 0, ptr %550
  %551 = getelementptr [2 x i32], ptr %stack.ptr_127, i32 0, i32 0
  store i32 4294967295, ptr %551
  %552 = getelementptr [2 x i32], ptr %stack.ptr_127, i32 0, i32 1
  store i32 4294967295, ptr %552
  %553 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_lower_bound_1(ptr %553, ptr %stack.ptr_126, ptr %stack.ptr_128)
  %554 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_upper_bound_1(ptr %554, ptr %stack.ptr_127, ptr %stack.ptr_129)
  br label %loop_25
loop_25:
  %555 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_128, ptr %stack.ptr_129)
  br i1 %555, label %if_37, label %end_if_37
if_37:
  br label %range_query.end_24
end_if_37:
  %556 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_128)
  %557 = getelementptr [3 x i32], ptr %stack.ptr_130, i32 0, i32 0
  %558 = getelementptr [2 x i32], ptr %556, i32 0, i32 1
  %559 = load i32, ptr %558
  store i32 %559, ptr %557
  %560 = getelementptr [3 x i32], ptr %stack.ptr_130, i32 0, i32 1
  store i32 0, ptr %560
  %561 = getelementptr [3 x i32], ptr %stack.ptr_130, i32 0, i32 2
  store i32 0, ptr %561
  %562 = getelementptr [3 x i32], ptr %stack.ptr_131, i32 0, i32 0
  %563 = getelementptr [2 x i32], ptr %556, i32 0, i32 1
  %564 = load i32, ptr %563
  store i32 %564, ptr %562
  %565 = getelementptr [3 x i32], ptr %stack.ptr_131, i32 0, i32 1
  store i32 4294967295, ptr %565
  %566 = getelementptr [3 x i32], ptr %stack.ptr_131, i32 0, i32 2
  store i32 4294967295, ptr %566
  %567 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_lower_bound_0(ptr %567, ptr %stack.ptr_130, ptr %stack.ptr_132)
  %568 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_upper_bound_0(ptr %568, ptr %stack.ptr_131, ptr %stack.ptr_133)
  br label %loop_26
loop_26:
  %569 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_132, ptr %stack.ptr_133)
  br i1 %569, label %if_38, label %end_if_38
if_38:
  br label %range_query.end_25
end_if_38:
  %570 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_132)
  %571 = getelementptr [3 x i32], ptr %stack.ptr_134, i32 0, i32 0
  %572 = getelementptr [2 x i32], ptr %556, i32 0, i32 1
  %573 = load i32, ptr %572
  store i32 %573, ptr %571
  %574 = getelementptr [3 x i32], ptr %stack.ptr_134, i32 0, i32 1
  %575 = getelementptr [3 x i32], ptr %570, i32 0, i32 1
  %576 = load i32, ptr %575
  store i32 %576, ptr %574
  %577 = getelementptr [3 x i32], ptr %stack.ptr_134, i32 0, i32 2
  %578 = getelementptr [3 x i32], ptr %570, i32 0, i32 2
  %579 = load i32, ptr %578
  store i32 %579, ptr %577
  %580 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  %581 = call ccc i1 @eclair_btree_contains_0(ptr %580, ptr %stack.ptr_134)
  %582 = select i1 %581, i1 0, i1 1
  br i1 %582, label %if_39, label %end_if_40
if_39:
  %583 = getelementptr [3 x i32], ptr %stack.ptr_135, i32 0, i32 0
  %584 = getelementptr [2 x i32], ptr %556, i32 0, i32 0
  %585 = load i32, ptr %584
  store i32 %585, ptr %583
  %586 = getelementptr [3 x i32], ptr %stack.ptr_135, i32 0, i32 1
  %587 = getelementptr [3 x i32], ptr %570, i32 0, i32 1
  %588 = load i32, ptr %587
  store i32 %588, ptr %586
  %589 = getelementptr [3 x i32], ptr %stack.ptr_135, i32 0, i32 2
  %590 = getelementptr [3 x i32], ptr %570, i32 0, i32 2
  %591 = load i32, ptr %590
  store i32 %591, ptr %589
  %592 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  %593 = call ccc i1 @eclair_btree_contains_0(ptr %592, ptr %stack.ptr_135)
  %594 = select i1 %593, i1 0, i1 1
  br i1 %594, label %if_40, label %end_if_39
if_40:
  %595 = getelementptr [3 x i32], ptr %stack.ptr_136, i32 0, i32 0
  %596 = getelementptr [2 x i32], ptr %556, i32 0, i32 0
  %597 = load i32, ptr %596
  store i32 %597, ptr %595
  %598 = getelementptr [3 x i32], ptr %stack.ptr_136, i32 0, i32 1
  %599 = getelementptr [3 x i32], ptr %570, i32 0, i32 1
  %600 = load i32, ptr %599
  store i32 %600, ptr %598
  %601 = getelementptr [3 x i32], ptr %stack.ptr_136, i32 0, i32 2
  %602 = getelementptr [3 x i32], ptr %570, i32 0, i32 2
  %603 = load i32, ptr %602
  store i32 %603, ptr %601
  %604 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  %605 = call ccc i1 @eclair_btree_insert_value_0(ptr %604, ptr %stack.ptr_136)
  %606 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  %607 = call ccc i1 @eclair_btree_insert_value_3(ptr %606, ptr %stack.ptr_136)
  br label %end_if_39
end_if_39:
  br label %end_if_40
end_if_40:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_132)
  br label %loop_26
range_query.end_25:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_128)
  br label %loop_25
range_query.end_24:
  %608 = getelementptr [2 x i32], ptr %stack.ptr_137, i32 0, i32 0
  store i32 0, ptr %608
  %609 = getelementptr [2 x i32], ptr %stack.ptr_137, i32 0, i32 1
  store i32 0, ptr %609
  %610 = getelementptr [2 x i32], ptr %stack.ptr_138, i32 0, i32 0
  store i32 4294967295, ptr %610
  %611 = getelementptr [2 x i32], ptr %stack.ptr_138, i32 0, i32 1
  store i32 4294967295, ptr %611
  %612 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_lower_bound_1(ptr %612, ptr %stack.ptr_137, ptr %stack.ptr_139)
  %613 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_upper_bound_1(ptr %613, ptr %stack.ptr_138, ptr %stack.ptr_140)
  br label %loop_27
loop_27:
  %614 = call ccc i1 @eclair_btree_iterator_is_equal_1(ptr %stack.ptr_139, ptr %stack.ptr_140)
  br i1 %614, label %if_41, label %end_if_41
if_41:
  br label %range_query.end_26
end_if_41:
  %615 = call ccc ptr @eclair_btree_iterator_current_1(ptr %stack.ptr_139)
  %616 = getelementptr [3 x i32], ptr %stack.ptr_141, i32 0, i32 0
  %617 = getelementptr [2 x i32], ptr %615, i32 0, i32 1
  %618 = load i32, ptr %617
  store i32 %618, ptr %616
  %619 = getelementptr [3 x i32], ptr %stack.ptr_141, i32 0, i32 1
  store i32 0, ptr %619
  %620 = getelementptr [3 x i32], ptr %stack.ptr_141, i32 0, i32 2
  store i32 0, ptr %620
  %621 = getelementptr [3 x i32], ptr %stack.ptr_142, i32 0, i32 0
  %622 = getelementptr [2 x i32], ptr %615, i32 0, i32 1
  %623 = load i32, ptr %622
  store i32 %623, ptr %621
  %624 = getelementptr [3 x i32], ptr %stack.ptr_142, i32 0, i32 1
  store i32 4294967295, ptr %624
  %625 = getelementptr [3 x i32], ptr %stack.ptr_142, i32 0, i32 2
  store i32 4294967295, ptr %625
  %626 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_lower_bound_0(ptr %626, ptr %stack.ptr_141, ptr %stack.ptr_143)
  %627 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_upper_bound_0(ptr %627, ptr %stack.ptr_142, ptr %stack.ptr_144)
  br label %loop_28
loop_28:
  %628 = call ccc i1 @eclair_btree_iterator_is_equal_0(ptr %stack.ptr_143, ptr %stack.ptr_144)
  br i1 %628, label %if_42, label %end_if_42
if_42:
  br label %range_query.end_27
end_if_42:
  %629 = call ccc ptr @eclair_btree_iterator_current_0(ptr %stack.ptr_143)
  %630 = getelementptr [3 x i32], ptr %stack.ptr_145, i32 0, i32 0
  %631 = getelementptr [2 x i32], ptr %615, i32 0, i32 0
  %632 = load i32, ptr %631
  store i32 %632, ptr %630
  %633 = getelementptr [3 x i32], ptr %stack.ptr_145, i32 0, i32 1
  %634 = getelementptr [3 x i32], ptr %629, i32 0, i32 1
  %635 = load i32, ptr %634
  store i32 %635, ptr %633
  %636 = getelementptr [3 x i32], ptr %stack.ptr_145, i32 0, i32 2
  %637 = getelementptr [3 x i32], ptr %629, i32 0, i32 2
  %638 = load i32, ptr %637
  store i32 %638, ptr %636
  %639 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  %640 = call ccc i1 @eclair_btree_contains_0(ptr %639, ptr %stack.ptr_145)
  %641 = select i1 %640, i1 0, i1 1
  br i1 %641, label %if_43, label %end_if_43
if_43:
  %642 = getelementptr [3 x i32], ptr %stack.ptr_146, i32 0, i32 0
  %643 = getelementptr [2 x i32], ptr %615, i32 0, i32 0
  %644 = load i32, ptr %643
  store i32 %644, ptr %642
  %645 = getelementptr [3 x i32], ptr %stack.ptr_146, i32 0, i32 1
  %646 = getelementptr [3 x i32], ptr %629, i32 0, i32 1
  %647 = load i32, ptr %646
  store i32 %647, ptr %645
  %648 = getelementptr [3 x i32], ptr %stack.ptr_146, i32 0, i32 2
  %649 = getelementptr [3 x i32], ptr %629, i32 0, i32 2
  %650 = load i32, ptr %649
  store i32 %650, ptr %648
  %651 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  %652 = call ccc i1 @eclair_btree_insert_value_0(ptr %651, ptr %stack.ptr_146)
  %653 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  %654 = call ccc i1 @eclair_btree_insert_value_3(ptr %653, ptr %stack.ptr_146)
  br label %end_if_43
end_if_43:
  call ccc void @eclair_btree_iterator_next_0(ptr %stack.ptr_143)
  br label %loop_28
range_query.end_27:
  call ccc void @eclair_btree_iterator_next_1(ptr %stack.ptr_139)
  br label %loop_27
range_query.end_26:
  %655 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  %656 = call ccc i1 @eclair_btree_is_empty_0(ptr %655)
  br i1 %656, label %if_44, label %end_if_45
if_44:
  %657 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %658 = call ccc i1 @eclair_btree_is_empty_1(ptr %657)
  br i1 %658, label %if_45, label %end_if_44
if_45:
  br label %loop.end
end_if_44:
  br label %end_if_45
end_if_45:
  %659 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  call ccc void @eclair_btree_begin_1(ptr %659, ptr %stack.ptr_147)
  %660 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  call ccc void @eclair_btree_end_1(ptr %660, ptr %stack.ptr_148)
  %661 = getelementptr %program, ptr %arg_0, i32 0, i32 10
  call ccc void @eclair_btree_insert_range_p_new_p(ptr %661, ptr %stack.ptr_147, ptr %stack.ptr_148)
  %662 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  call ccc void @eclair_btree_begin_1(ptr %662, ptr %stack.ptr_149)
  %663 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  call ccc void @eclair_btree_end_1(ptr %663, ptr %stack.ptr_150)
  %664 = getelementptr %program, ptr %arg_0, i32 0, i32 11
  call ccc void @eclair_btree_insert_range_p_new_p(ptr %664, ptr %stack.ptr_149, ptr %stack.ptr_150)
  %665 = getelementptr %program, ptr %arg_0, i32 0, i32 6
  %666 = getelementptr %program, ptr %arg_0, i32 0, i32 2
  call ccc void @eclair_btree_swap_1(ptr %665, ptr %666)
  %667 = getelementptr %program, ptr %arg_0, i32 0, i32 7
  %668 = getelementptr %program, ptr %arg_0, i32 0, i32 3
  call ccc void @eclair_btree_swap_2(ptr %667, ptr %668)
  %669 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  call ccc void @eclair_btree_begin_0(ptr %669, ptr %stack.ptr_151)
  %670 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  call ccc void @eclair_btree_end_0(ptr %670, ptr %stack.ptr_152)
  %671 = getelementptr %program, ptr %arg_0, i32 0, i32 12
  call ccc void @eclair_btree_insert_range_q_new_q_1(ptr %671, ptr %stack.ptr_151, ptr %stack.ptr_152)
  %672 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  call ccc void @eclair_btree_begin_0(ptr %672, ptr %stack.ptr_153)
  %673 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  call ccc void @eclair_btree_end_0(ptr %673, ptr %stack.ptr_154)
  %674 = getelementptr %program, ptr %arg_0, i32 0, i32 13
  call ccc void @eclair_btree_insert_range_q_new_q_1(ptr %674, ptr %stack.ptr_153, ptr %stack.ptr_154)
  %675 = getelementptr %program, ptr %arg_0, i32 0, i32 8
  %676 = getelementptr %program, ptr %arg_0, i32 0, i32 4
  call ccc void @eclair_btree_swap_0(ptr %675, ptr %676)
  %677 = getelementptr %program, ptr %arg_0, i32 0, i32 9
  %678 = getelementptr %program, ptr %arg_0, i32 0, i32 5
  call ccc void @eclair_btree_swap_3(ptr %677, ptr %678)
  br label %loop_0
loop.end:
  ret void
}

define external ccc void @eclair_add_facts(ptr %eclair_program_0, i32 %fact_type_0, ptr %memory_0, i32 %fact_count_0) "wasm-export-name"="eclair_add_facts" {
start:
  switch i32 %fact_type_0, label %switch.default_0 [i32 3, label %c_0 i32 0, label %p_0 i32 1, label %q_0 i32 2, label %r_0 i32 5, label %s_0 i32 4, label %u_0]
c_0:
  %0 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 1
  br label %for_begin_0
for_begin_0:
  %1 = phi i32 [0, %c_0], [%5, %for_body_0]
  %2 = icmp ult i32 %1, %fact_count_0
  br i1 %2, label %for_body_0, label %for_end_0
for_body_0:
  %3 = getelementptr [3 x i32], ptr %memory_0, i32 %1
  %4 = call ccc i1 @eclair_btree_insert_value_0(ptr %0, ptr %3)
  %5 = add i32 1, %1
  br label %for_begin_0
for_end_0:
  br label %end_0
p_0:
  %6 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 11
  br label %for_begin_1
for_begin_1:
  %7 = phi i32 [0, %p_0], [%11, %for_body_1]
  %8 = icmp ult i32 %7, %fact_count_0
  br i1 %8, label %for_body_1, label %for_end_1
for_body_1:
  %9 = getelementptr [2 x i32], ptr %memory_0, i32 %7
  %10 = call ccc i1 @eclair_btree_insert_value_2(ptr %6, ptr %9)
  %11 = add i32 1, %7
  br label %for_begin_1
for_end_1:
  %12 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 10
  br label %for_begin_2
for_begin_2:
  %13 = phi i32 [0, %for_end_1], [%17, %for_body_2]
  %14 = icmp ult i32 %13, %fact_count_0
  br i1 %14, label %for_body_2, label %for_end_2
for_body_2:
  %15 = getelementptr [2 x i32], ptr %memory_0, i32 %13
  %16 = call ccc i1 @eclair_btree_insert_value_1(ptr %12, ptr %15)
  %17 = add i32 1, %13
  br label %for_begin_2
for_end_2:
  br label %end_0
q_0:
  %18 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 13
  br label %for_begin_3
for_begin_3:
  %19 = phi i32 [0, %q_0], [%23, %for_body_3]
  %20 = icmp ult i32 %19, %fact_count_0
  br i1 %20, label %for_body_3, label %for_end_3
for_body_3:
  %21 = getelementptr [3 x i32], ptr %memory_0, i32 %19
  %22 = call ccc i1 @eclair_btree_insert_value_3(ptr %18, ptr %21)
  %23 = add i32 1, %19
  br label %for_begin_3
for_end_3:
  %24 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 12
  br label %for_begin_4
for_begin_4:
  %25 = phi i32 [0, %for_end_3], [%29, %for_body_4]
  %26 = icmp ult i32 %25, %fact_count_0
  br i1 %26, label %for_body_4, label %for_end_4
for_body_4:
  %27 = getelementptr [3 x i32], ptr %memory_0, i32 %25
  %28 = call ccc i1 @eclair_btree_insert_value_0(ptr %24, ptr %27)
  %29 = add i32 1, %25
  br label %for_begin_4
for_end_4:
  br label %end_0
r_0:
  %30 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 14
  br label %for_begin_5
for_begin_5:
  %31 = phi i32 [0, %r_0], [%35, %for_body_5]
  %32 = icmp ult i32 %31, %fact_count_0
  br i1 %32, label %for_body_5, label %for_end_5
for_body_5:
  %33 = getelementptr [3 x i32], ptr %memory_0, i32 %31
  %34 = call ccc i1 @eclair_btree_insert_value_0(ptr %30, ptr %33)
  %35 = add i32 1, %31
  br label %for_begin_5
for_end_5:
  br label %end_0
s_0:
  %36 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 15
  br label %for_begin_6
for_begin_6:
  %37 = phi i32 [0, %s_0], [%41, %for_body_6]
  %38 = icmp ult i32 %37, %fact_count_0
  br i1 %38, label %for_body_6, label %for_end_6
for_body_6:
  %39 = getelementptr [2 x i32], ptr %memory_0, i32 %37
  %40 = call ccc i1 @eclair_btree_insert_value_1(ptr %36, ptr %39)
  %41 = add i32 1, %37
  br label %for_begin_6
for_end_6:
  br label %end_0
u_0:
  %42 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 16
  br label %for_begin_7
for_begin_7:
  %43 = phi i32 [0, %u_0], [%47, %for_body_7]
  %44 = icmp ult i32 %43, %fact_count_0
  br i1 %44, label %for_body_7, label %for_end_7
for_body_7:
  %45 = getelementptr [3 x i32], ptr %memory_0, i32 %43
  %46 = call ccc i1 @eclair_btree_insert_value_0(ptr %42, ptr %45)
  %47 = add i32 1, %43
  br label %for_begin_7
for_end_7:
  br label %end_0
switch.default_0:
  ret void
end_0:
  ret void
}

define external ccc void @eclair_add_fact(ptr %eclair_program_0, i32 %fact_type_0, ptr %memory_0) "wasm-export-name"="eclair_add_fact" {
start:
  call ccc void @eclair_add_facts(ptr %eclair_program_0, i32 %fact_type_0, ptr %memory_0, i32 1)
  ret void
}

define external ccc ptr @eclair_get_facts(ptr %eclair_program_0, i32 %fact_type_0) "wasm-export-name"="eclair_get_facts" {
start:
  %stack.ptr_0 = alloca i32, i32 1
  %stack.ptr_1 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_2 = alloca %btree_iterator_t_2, i32 1
  %stack.ptr_3 = alloca i32, i32 1
  %stack.ptr_4 = alloca %btree_iterator_t_3, i32 1
  %stack.ptr_5 = alloca %btree_iterator_t_3, i32 1
  switch i32 %fact_type_0, label %switch.default_0 [i32 0, label %p_0 i32 1, label %q_0]
p_0:
  %0 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 11
  %1 = call ccc i64 @eclair_btree_size_2(ptr %0)
  %2 = trunc i64 %1 to i32
  %3 = mul i32 %2, 8
  %4 = call ccc ptr @malloc(i32 %3)
  store i32 0, ptr %stack.ptr_0
  call ccc void @eclair_btree_begin_2(ptr %0, ptr %stack.ptr_1)
  call ccc void @eclair_btree_end_2(ptr %0, ptr %stack.ptr_2)
  br label %while_begin_0
while_begin_0:
  %5 = call ccc i1 @eclair_btree_iterator_is_equal_2(ptr %stack.ptr_1, ptr %stack.ptr_2)
  %6 = select i1 %5, i1 0, i1 1
  br i1 %6, label %while_body_0, label %while_end_0
while_body_0:
  %7 = load i32, ptr %stack.ptr_0
  %8 = getelementptr [2 x i32], ptr %4, i32 %7
  %9 = call ccc ptr @eclair_btree_iterator_current_2(ptr %stack.ptr_1)
  %10 = getelementptr [2 x i32], ptr %9, i32 0
  %11 = load [2 x i32], ptr %10
  %12 = getelementptr [2 x i32], ptr %8, i32 0
  store [2 x i32] %11, ptr %12
  %13 = add i32 %7, 1
  store i32 %13, ptr %stack.ptr_0
  call ccc void @eclair_btree_iterator_next_2(ptr %stack.ptr_1)
  br label %while_begin_0
while_end_0:
  ret ptr %4
q_0:
  %14 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 13
  %15 = call ccc i64 @eclair_btree_size_3(ptr %14)
  %16 = trunc i64 %15 to i32
  %17 = mul i32 %16, 12
  %18 = call ccc ptr @malloc(i32 %17)
  store i32 0, ptr %stack.ptr_3
  call ccc void @eclair_btree_begin_3(ptr %14, ptr %stack.ptr_4)
  call ccc void @eclair_btree_end_3(ptr %14, ptr %stack.ptr_5)
  br label %while_begin_1
while_begin_1:
  %19 = call ccc i1 @eclair_btree_iterator_is_equal_3(ptr %stack.ptr_4, ptr %stack.ptr_5)
  %20 = select i1 %19, i1 0, i1 1
  br i1 %20, label %while_body_1, label %while_end_1
while_body_1:
  %21 = load i32, ptr %stack.ptr_3
  %22 = getelementptr [3 x i32], ptr %18, i32 %21
  %23 = call ccc ptr @eclair_btree_iterator_current_3(ptr %stack.ptr_4)
  %24 = getelementptr [3 x i32], ptr %23, i32 0
  %25 = load [3 x i32], ptr %24
  %26 = getelementptr [3 x i32], ptr %22, i32 0
  store [3 x i32] %25, ptr %26
  %27 = add i32 %21, 1
  store i32 %27, ptr %stack.ptr_3
  call ccc void @eclair_btree_iterator_next_3(ptr %stack.ptr_4)
  br label %while_begin_1
while_end_1:
  ret ptr %18
switch.default_0:
  ret ptr zeroinitializer
}

define external ccc void @eclair_free_buffer(ptr %buffer_0) "wasm-export-name"="eclair_free_buffer" {
start:
  call ccc void @free(ptr %buffer_0)
  ret void
}

define external ccc i32 @eclair_fact_count(ptr %eclair_program_0, i32 %fact_type_0) "wasm-export-name"="eclair_fact_count" {
start:
  switch i32 %fact_type_0, label %switch.default_0 [i32 0, label %p_0 i32 1, label %q_0]
p_0:
  %0 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 11
  %1 = call ccc i64 @eclair_btree_size_2(ptr %0)
  %2 = trunc i64 %1 to i32
  ret i32 %2
q_0:
  %3 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 13
  %4 = call ccc i64 @eclair_btree_size_3(ptr %3)
  %5 = trunc i64 %4 to i32
  ret i32 %5
switch.default_0:
  ret i32 0
}

define external ccc i32 @eclair_encode_string(ptr %eclair_program_0, i32 %string_length_0, ptr %string_data_0) "wasm-export-name"="eclair_encode_string" {
start:
  %stack.ptr_0 = alloca %symbol_t, i32 1
  %0 = call ccc ptr @malloc(i32 %string_length_0)
  %1 = zext i32 %string_length_0 to i64
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(ptr %0, ptr %string_data_0, i64 %1, i1 0)
  call ccc void @eclair_symbol_init(ptr %stack.ptr_0, i32 %string_length_0, ptr %0)
  %2 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 0
  %3 = call ccc i32 @eclair_symbol_table_lookup_index(ptr %2, ptr %stack.ptr_0)
  %4 = icmp ne i32 %3, 4294967295
  br i1 %4, label %if_0, label %end_if_0
if_0:
  call ccc void @free(ptr %0)
  ret i32 %3
end_if_0:
  %5 = call ccc i32 @eclair_symbol_table_find_or_insert(ptr %2, ptr %stack.ptr_0)
  ret i32 %5
}

define external ccc ptr @eclair_decode_string(ptr %eclair_program_0, i32 %string_index_0) "wasm-export-name"="eclair_decode_string" {
start:
  %0 = getelementptr %program, ptr %eclair_program_0, i32 0, i32 0
  %1 = call ccc i1 @eclair_symbol_table_contains_index(ptr %0, i32 %string_index_0)
  br i1 %1, label %if_0, label %end_if_0
if_0:
  %2 = call ccc ptr @eclair_symbol_table_lookup_symbol(ptr %0, i32 %string_index_0)
  ret ptr %2
end_if_0:
  ret ptr zeroinitializer
}
