#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ROWS 5
#define COLS 4

// External assembly functions
enum { HEART=0, SPADES, DIAMONDS, CLUBS };
extern void asm_move_logo(int suit, int *positions);
extern int  asm_check_win(int *positions);
extern int  asm_randf();
extern void asm_seed(int seed);

const char suits[COLS] = { 'H', 'S', 'D', 'C' };

void display_grid(int positions[COLS]) {
    for (int r = 0; r < ROWS; r++) {
        for (int s = 0; s < COLS; s++) {
            if (positions[s] == r) printf(" %c ", suits[s]);
            else                 printf(" . ");
        }
        printf("\n");
    }
    printf("\n");
}

int main() {
    int positions[COLS];
    int restart = 1;

    // Seed generator
    srand((unsigned)time(NULL));
    asm_seed((int)time(NULL));

    while (restart) {
        // Initialize all logos at bottom row
        for (int i = 0; i < COLS; i++) positions[i] = ROWS - 1;
        display_grid(positions);

        // Game loop
        while (1) {
            int rnd    = asm_rand();
            int suit   = rnd % COLS;
            int number = (rnd / COLS) % 13 + 1;
            printf("Drawn: %c%d\n", suits[suit], number);

            asm_move_logo(suit, positions);
            display_grid(positions);

            int winner = asm_check_win(positions);
            if (winner >= 0) {
                printf("Winner: %c\n", suits[winner]);
                break;
            }
        }

        printf("Restart? (1 = yes, 0 = no): ");
        if (scanf("%d", &restart) != 1) restart = 0;
    }

    return 0;
}
