/*
#|
LambdaNative - a cross-platform Scheme framework
Copyright (c) 2025, John Agoe
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the
following conditions are met:

* Redistributions of source code must retain the above
copyright notice, this list of conditions and the following
disclaimer.

* Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following
disclaimer in the documentation and/or other materials
provided with the distribution.

* Neither the name of the University of British Columbia nor
the names of its contributors may be used to endorse or
promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
|#

*/

#include <stdio.h>
#include <stdlib.h>
#include <gd.h>
#include <math.h>
#include "tinymaix/tinymaix.h"
#include "tomato.h"
#define IMG_WIDTH 128
#define IMG_HEIGHT 128
#define IMG_CHANNELS 3

static const char *classes[] = {
    "Bacterial Spot",
    "Early Blight",
    "Late Blight",
    "Leaf Mold",
    "Septoria Leaf Spot",
    "Spider Mites",
    "Target Spot",
    "Yellow Leaf Curl Virus",
    "Mosaic Virus",
    "Healthy",
    "Powdery Mildew"
};

float probabilities[11];
int best = 0;
double max = 0;

void softmax(const float *logits, float *prob, int n)
{
    float max = logits[0];
    /* Find maximum logit */
    for (int i = 1; i < n; i++) {
        if (logits[i] > max)
            max = logits[i];
    }
    
    /* Compute exp(x - max) */
    float sum = 0.0f;
    for (int i = 0; i < n; i++) {
        prob[i] = expf(logits[i] - max);
        sum += prob[i];
    }
    
    /* Normalize */
    for (int i = 0; i < n; i++) {
        prob[i] /= sum;
    }
}

int classify(gdImagePtr image)
{
    tm_mdl_t mdl;
    tm_mat_t outs[1];
    tm_err_t res;
    printf("Original image: %d x %d\n",
           gdImageSX(image),
           gdImageSY(image));

    //Load the model
    tm_mat_t model_in = {0};

    res = tm_load(
        &mdl,
        tomato_data,
        NULL,
        NULL,
        &model_in
    );

    if (res != TM_OK) {
        printf("ERROR: tm_load failed: %d\n", res);
        return -1;
    }

    printf("TinyMaix model loaded successfully\n");
    printf("Model input: h=%d w=%d c=%d\n",
           model_in.h,
           model_in.w,
           model_in.c);

    //Create the new resized image
    gdImagePtr resized =
        gdImageCreateTrueColor(IMG_WIDTH, IMG_HEIGHT);

    if (!resized) {
        printf("ERROR: Could not create resized image\n");
        tm_unload(&mdl);
        return -1;
    }

    //Resize the entire source image, just in case.
    gdImageCopyResampled(
        resized,
        image,
        0, 0,                         /* destination x,y */
        0, 0,                         /* source x,y */
        IMG_WIDTH, IMG_HEIGHT,        /* destination size */
        gdImageSX(image),             /* source width */
        gdImageSY(image)              /* source height */
    );

    //Create the input
    size_t input_count = IMG_WIDTH * IMG_HEIGHT * IMG_CHANNELS;

    float *input_data = malloc(input_count * sizeof(float));

    if (!input_data) {
        printf("ERROR: Failed to allocate input buffer\n");
        gdImageDestroy(resized);
        tm_unload(&mdl);
        return -1;
    }

    for (int y = 0; y < IMG_HEIGHT; y++) {
        for (int x = 0; x < IMG_WIDTH; x++) {
            int pixel =
                gdImageGetTrueColorPixel(resized, x, y);
            int i =
                (y * IMG_WIDTH + x) * IMG_CHANNELS;
            float r =
                (float)gdTrueColorGetRed(pixel);
            float g =
                (float)gdTrueColorGetGreen(pixel);
            float b =
                (float)gdTrueColorGetBlue(pixel);
            input_data[i + 0] = r;
            input_data[i + 1] = g;
            input_data[i + 2] = b;
        }
    }

    tm_mat_t in_fp32 = {
        3,
        IMG_WIDTH,
        IMG_HEIGHT,
        IMG_CHANNELS,
        {(mtype_t *)input_data}
    };

    //Run the model
    res = tm_run(
        &mdl,
        &in_fp32,
        outs
    );

    if (res != TM_OK) {
        printf("ERROR: tm_run failed: %d\n", res);
        free(input_data);
        gdImageDestroy(resized);
        tm_unload(&mdl);
        return -1;
    }

    //Time for output
    tm_mat_t out = outs[0];

    printf("\nOutput:\n");
    printf("h = %d\n", out.h);
    printf("w = %d\n", out.w);
    printf("c = %d\n", out.c);

    float logits[11];

    printf("\nRaw TinyMaix logits:\n");

    for (int i = 0; i < 11; i++) {

        logits[i] = out.dataf[i];

        printf(
            "%2d %-25s %f\n",
            i,
            classes[i],
            logits[i]
        );
    }

    //Softmax
    softmax(
        logits,
        probabilities,
        11
    );

    //Find the highest probalility
    best = 0;
    for (int i = 1; i < 11; i++) {
        if (probabilities[i] >
            probabilities[best]) {
            best = i;
        }
    }

    max = probabilities[best];

    printf("\n========================================\n");
    printf("PREDICTION\n");
    printf("========================================\n");

    printf(
        "Class index: %d\n",
        best
    );

    printf(
        "Class: %s\n",
        classes[best]
    );

    printf(
        "Confidence: %.6f%%\n",
        max * 100.0f
    );
    //Print all probabilities.
    printf("\nAll probabilities:\n");
    for (int i = 0; i < 11; i++) {
        printf(
            "%2d %-25s %.9f (%.6f%%)\n",
            i,
            classes[i],
            probabilities[i],
            probabilities[i] * 100.0f
        );
    }

    //Cleanup
    free(input_data);
    gdImageDestroy(resized);
    tm_unload(&mdl);
    return best;
}

double getMax(){
    int d = (int)(max * 10000);
    return d/100.0;
}

int getMaxClass(){
    return best;
}

/*float go(){
    FILE *file = fopen("/home/john/Downloads/archive/valid/Target_Spot/0b6c4305-0cdc-4150-914b-5d7a5acb7881___Com.G_TgS_FL 8257_180deg.JPG","rb");
    if (!file){
        puts("File not found");
        return -1;
    }
        
    gdImagePtr image = gdImageCreateFromJpeg(file);
    fclose(file);
    if (!image){
        puts("Image could not be created");
        return -2;
    }
    classify(image); puts("Done");

    gdImageDestroy(image);
    return max;
}*/