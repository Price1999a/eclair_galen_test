#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>

#define MAX_FILENAME 256
#define INITIAL_CAPACITY 10

#ifdef DOCKER_ENV
#define READ_DIR "/app/data"
#else
#define READ_DIR "/Users/shentianqi/Downloads/ddlogfile/basedonPaper/soufflé/galen/input/"
#endif
// The Eclair runtime is represented by an opaque pointer
// to a program struct.
struct program;

// The low-level Eclair API is accessed via extern definitions
extern struct program *eclair_program_init();

extern void eclair_program_destroy(struct program *);

extern void eclair_program_run(struct program *);

extern void eclair_add_facts(
        struct program *,
        uint32_t fact_type,
        uint32_t *data,
        size_t fact_count
);

extern void eclair_add_fact(
        struct program *,
        uint32_t fact_type,
        uint32_t *data
);

extern uint32_t *eclair_get_facts(
        struct program *,
        uint32_t fact_type
);

extern uint32_t eclair_fact_count(
        struct program *,
        uint32_t fact_type
);

extern void eclair_free_buffer(uint32_t *data);

extern uint32_t eclair_encode_string(
        struct program *,
        uint32_t length,
        const char *str
);

extern struct symbol *eclair_decode_string(
        struct program *,
        uint32_t index
);

// 以上是eclair相关内容

typedef struct {
    char filename[MAX_FILENAME];
    uint32_t *numbers;
    int count;
    int capacity;
} FileData;

void expand_array(FileData *file_data) {
    file_data->capacity *= 2;
    file_data->numbers = realloc(file_data->numbers, sizeof(uint32_t) * file_data->capacity);
    if (file_data->numbers == NULL) {
        perror("Error reallocating memory");
        exit(EXIT_FAILURE);
    }
}

FileData *read_directory(const char *directory_path, int *num_files) {
    DIR *directory = opendir(directory_path);
    if (directory == NULL) {
        perror("Error opening directory");
        return NULL;
    }

    FileData *file_data_array = NULL;
    int file_index = 0;
    int array_capacity = INITIAL_CAPACITY;

    file_data_array = malloc(sizeof(FileData) * array_capacity);
    if (file_data_array == NULL) {
        perror("Error allocating memory");
        closedir(directory);
        return NULL;
    }

    struct dirent *entry;
    while ((entry = readdir(directory)) != NULL) {
        if (entry->d_type == DT_REG) {  // 检查是否为常规文件
            char file_path[MAX_FILENAME];
            snprintf(file_path, sizeof(file_path), "%s/%s", directory_path, entry->d_name);

            FILE *file = fopen(file_path, "r");
            if (file == NULL) {
                perror("Error opening file");
                continue;
            }

            if (file_index >= array_capacity) {
                array_capacity *= 2;
                file_data_array = realloc(file_data_array, sizeof(FileData) * array_capacity);
                if (file_data_array == NULL) {
                    perror("Error reallocating memory");
                    fclose(file);
                    closedir(directory);
                    return NULL;
                }
            }

            strncpy(file_data_array[file_index].filename, entry->d_name, MAX_FILENAME);
            file_data_array[file_index].count = 0;
            file_data_array[file_index].capacity = INITIAL_CAPACITY;
            file_data_array[file_index].numbers = malloc(sizeof(uint32_t) * INITIAL_CAPACITY);
            if (file_data_array[file_index].numbers == NULL) {
                perror("Error allocating memory");
                fclose(file);
                closedir(directory);
                return NULL;
            }

            char line[256];
            while (fgets(line, sizeof(line), file) != NULL) {
                char *token = strtok(line, ",");
                while (token != NULL) {
                    if (file_data_array[file_index].count >= file_data_array[file_index].capacity) {
                        expand_array(&file_data_array[file_index]);
                    }
                    file_data_array[file_index].numbers[file_data_array[file_index].count] = (uint32_t) atoi(token);
                    file_data_array[file_index].count++;
                    token = strtok(NULL, ",");
                }
            }

            fclose(file);
            file_index++;
        }
    }

    closedir(directory);
    *num_files = file_index;
    return file_data_array;
}

void free_file_data_array(FileData *file_data_array, int num_files) {
    for (int i = 0; i < num_files; i++) {
        free(file_data_array[i].numbers);
    }
    free(file_data_array);
}

void printInputFileInfo(FileData *p, FileData *q, FileData *r, FileData *c, FileData *u, FileData *s) {
    printf("p size = %d \n",p->count/2);
    printf("q size = %d \n",q->count/3);
    printf("r size = %d \n",r->count/3);
    printf("c size = %d \n",c->count/3);
    printf("u size = %d \n",u->count/3);
    printf("s size = %d \n",s->count/2);
}

int run() {
    const char *directory_path = READ_DIR;
    int num_files;
    FileData *file_data_array = read_directory(directory_path, &num_files);
    if (file_data_array == NULL) {
        return EXIT_FAILURE;
    }
    FileData *p_input, *q_input, *r_input, *c_input, *u_input, *s_input;
    for (int i = 0; i < num_files; i++) {
        switch (file_data_array[i].filename[0]) {
            case 'p':
                p_input = &file_data_array[i];
                break;
            case 'q':
                q_input = &file_data_array[i];
                break;
            case 'r':
                r_input = &file_data_array[i];
                break;
            case 'c':
                c_input = &file_data_array[i];
                break;
            case 'u':
                u_input = &file_data_array[i];
                break;
            case 's':
                s_input = &file_data_array[i];
                break;
            default:
                continue;
        }
    }
    printInputFileInfo(p_input, q_input, r_input, c_input, u_input, s_input);


    free_file_data_array(file_data_array, num_files);
    return EXIT_SUCCESS;
}


int main() {
    struct program *prog = eclair_program_init();
    uint32_t p_fact_type = eclair_encode_string(prog, 1, "p");
    uint32_t q_fact_type = eclair_encode_string(prog, 1, "q");
    uint32_t r_fact_type = eclair_encode_string(prog, 1, "r");
    uint32_t c_fact_type = eclair_encode_string(prog, 1, "c");
    uint32_t u_fact_type = eclair_encode_string(prog, 1, "u");
    uint32_t s_fact_type = eclair_encode_string(prog, 1, "s");
    printf("Hello, World!\n");
    printf("p_fact_type %u\n", p_fact_type);
    printf("q_fact_type %u\n", q_fact_type);
    printf("r_fact_type %u\n", r_fact_type);
    printf("c_fact_type %u\n", c_fact_type);
    printf("u_fact_type %u\n", u_fact_type);
    printf("s_fact_type %u\n", s_fact_type);
    printf(READ_DIR);
    printf("\n");
    return run();
}
