#ifndef FONT_C
#define FONT_C

#define STB_RECT_PACK_IMPLEMENTATION
#include "stb_rect_pack.h"
#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"

#include "olive.c"

#include "stdio.h"
#include "stdint.h"
#include "unistd.h"
#include "limits.h"
#include "string.h"

#define FONT_DEFAULT "UbuntuMono.ttf"

static uint32_t mapRGBA(uint8_t r, uint8_t g, uint8_t b, uint8_t a);

typedef struct Font {
    stbtt_fontinfo *info;
    stbtt_packedchar chars[96];
    Olivec_Canvas atlas;
    uint32_t texture_size;
    float size;
    float scale;
    int32_t ascent;
    int32_t descent;
    int32_t line_gap;
    uint32_t baseline;
    float y_advance;
} Font;

Font *font_create(const char *path, float size) {
    Font *font = (Font*)calloc(1, sizeof(Font));
    *font = (Font){
        .texture_size = 32,
        .size = size,
        .info = (stbtt_fontinfo*)malloc(sizeof(stbtt_fontinfo)),
    };

    char cwd[PATH_MAX] = {0};

    getcwd(cwd, sizeof(cwd));

    char font_absolute_path[PATH_MAX] = {0};
    strncat(font_absolute_path, cwd, strlen(cwd));
    strncat(font_absolute_path, "/", 1);
    strncat(font_absolute_path, path, strlen(path));

    fprintf(stdout, "Loading font: %s\n", font_absolute_path);

    FILE *fd = fopen(font_absolute_path, "r");
    if (!fd) {
        fprintf(stderr, "Cannot open file: %s\n", font_absolute_path);
        free(font->info);
        free(font);
        return NULL;
    }

#define BUFFER_SIZE 1024 * 1024
    uint8_t buffer[BUFFER_SIZE] = {0};

    fseek(fd, 0, SEEK_END);
    int file_size = (int)ftell(fd);
    if (file_size >= BUFFER_SIZE) {
        fprintf(stderr, "Buffer too small to read font file\n");
        free(font->info);
        free(font);
        fclose(fd);
        return NULL;
    }
    rewind(fd);

    int bytes_read = fread(buffer, 1, file_size, fd);

    if (!stbtt_InitFont(font->info, buffer, 0)) {
        fprintf(stderr, "Error initializing font\n");
        free(font->info);
        free(font);
        fclose(fd);
        return NULL;
    }

    uint8_t *bitmap = NULL;
    for (;;) {
        bitmap = (uint8_t*)malloc(font->texture_size * font->texture_size);
        if (!bitmap) {
            fprintf(stderr, "Bitmap alloc failed\n");
            return NULL;
        }

        stbtt_pack_context pack_ctx;
        stbtt_PackBegin(&pack_ctx, bitmap, font->texture_size, font->texture_size, 0, 1, NULL);
        stbtt_PackSetOversampling(&pack_ctx, 2, 2);
        if (!stbtt_PackFontRange(&pack_ctx, buffer, 0, size, 32, 95, font->chars)) {
            free(bitmap);
            stbtt_PackEnd(&pack_ctx);
            font->texture_size *= 2;
        } else {
            stbtt_PackEnd(&pack_ctx);
            break;
        }
    }

    // create olivec canvas from bitmap
    uint32_t *pixels = (uint32_t*)malloc(font->texture_size * font->texture_size * sizeof(uint32_t));
    for (int i = 0; i < font->texture_size * font->texture_size; ++i) {
        pixels[i] = mapRGBA(0xff, 0xff, 0xff, bitmap[i]);
    }
    font->atlas = olivec_canvas(pixels, font->texture_size, font->texture_size, font->texture_size);

    free(bitmap);

    font->scale = stbtt_ScaleForPixelHeight(font->info, size);
    stbtt_GetFontVMetrics(font->info, &font->ascent, &font->descent, &font->line_gap);
    font->baseline = (int)(font->ascent * font->scale);
    font->y_advance = font->scale * (float)(font->ascent - font->descent + font->line_gap);
    
    fclose(fd);

    return font;
}

void font_destroy(Font *font) {
    free(font->info);
    free(font);
}

static uint32_t mapRGBA(uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
    return ((uint32_t)a << 24) | ((uint32_t)b << 16) | ((uint32_t)g << 8) | r;
}

#endif
