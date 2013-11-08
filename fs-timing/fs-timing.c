/*
 * Tool for check timing attacks on fs
 *
 * Usage: gcc fs-timing.c -o fs-timing -lm && ./fs-timing /path/to/directory
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/resource.h>

#define MAX_PATH_LENGTH 1000
#define FILENAME_PREFIX "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"


void make_files( int count) {
  int i;
  char path[MAX_PATH_LENGTH];

  for (i=0; i<count; i++) {
    snprintf( path, MAX_PATH_LENGTH, "%s_%016d_log", FILENAME_PREFIX, i);
    creat( path, 0644);
  }
}

void print_timings( char *msg, unsigned long *timings, int count) {
  int i;
  double average = 0.0, deviation = 0.0;
  unsigned long min = timings[0], max = 0;

  for( i=0; i<count; i++) if( timings[i] > max) max = timings[i];
  for( i=0; i<count; i++) if( timings[i] < min) min = timings[i];

  for( i=0; i<count; i++) average = average + timings[i];
  average = average / count;

  for( i=0; i<count; i++)
    deviation = deviation + (average - timings[i]) * (average - timings[i]);
  deviation = sqrt( deviation / count);

  printf( "%s: %7dms min, %7dms max, %7.2fms avg, %4.2fms deviation\n",
    msg, min/1000, max/1000, average/1000, deviation/1000);
}

void check_exists( unsigned long *timings, int rounds, int measures) {
  int i,j;
  char path[MAX_PATH_LENGTH];
  struct stat st;
  struct rusage ru_prev, ru_curr;

  for( i=0; i<measures; i++) {
    getrusage( RUSAGE_SELF, &ru_prev);
    for( j=i*rounds; j<(i+1)*rounds; j++) {
      snprintf( path, MAX_PATH_LENGTH, "%s_%016d_log", FILENAME_PREFIX, j);
      stat( path, &st);
    }
    getrusage( RUSAGE_SELF, &ru_curr);
    timings[i] = 1000000 * (ru_curr.ru_stime.tv_sec - ru_prev.ru_stime.tv_sec) + (ru_curr.ru_stime.tv_usec - ru_prev.ru_stime.tv_usec);
  }
}

void check_diff_length( unsigned long *timings, int rounds, int measures) {
  int i,j;
  char path[MAX_PATH_LENGTH];
  struct stat st;
  struct rusage ru_prev, ru_curr;

  for( i=0; i<measures; i++) {
    getrusage( RUSAGE_SELF, &ru_prev);
    for( j=i*rounds; j<(i+1)*rounds; j++) {
      snprintf( path, MAX_PATH_LENGTH, "%s_%016d_lg", FILENAME_PREFIX, j);
      stat( path, &st);
    }
    getrusage( RUSAGE_SELF, &ru_curr);
    timings[i] = 1000000 * (ru_curr.ru_stime.tv_sec - ru_prev.ru_stime.tv_sec) + (ru_curr.ru_stime.tv_usec - ru_prev.ru_stime.tv_usec);
  }
}

void check_diff_byte( unsigned long *timings, int rounds, int measures, int symidx) {
  int i,j;
  char path[MAX_PATH_LENGTH];
  struct stat st;
  struct rusage ru_prev, ru_curr;

  for( i=0; i<measures; i++) {
    getrusage( RUSAGE_SELF, &ru_prev);
    for( j=i*rounds; j<(i+1)*rounds; j++) {
      snprintf( path, MAX_PATH_LENGTH, "%s_%016d_log", FILENAME_PREFIX, j);
      path[symidx] = 'b';
      stat( path, &st);
    }
    getrusage( RUSAGE_SELF, &ru_curr);
    timings[i] = 1000000 * (ru_curr.ru_stime.tv_sec - ru_prev.ru_stime.tv_sec) + (ru_curr.ru_stime.tv_usec - ru_prev.ru_stime.tv_usec);
  }
}


int main( int argc, char **argv) {
  unsigned long *timings;
  int rounds = 100000, measures = 10;

  if( argc < 1 || chdir( argv[1]) != 0) {
    printf( "Can't change to directory '%s'\n", argv[1]);
    exit( 1);
  }

  timings = malloc( sizeof(long) * measures);

  make_files( rounds*measures);
  check_exists( timings, rounds, measures);
  print_timings( "check exists files", timings, measures);
  check_diff_length( timings, rounds, measures);
  print_timings( "check files with different name length", timings, measures);
  check_diff_byte( timings, rounds, measures, 0);
  print_timings( "check files with diffs in 1st symbol", timings, measures);
  check_diff_byte( timings, rounds, measures, 1);
  print_timings( "check files with diffs in 2nd symbol", timings, measures);
  check_diff_byte( timings, rounds, measures, 3);
  print_timings( "check files with diffs in 4rd symbol", timings, measures);
  check_diff_byte( timings, rounds, measures, 7);
  print_timings( "check files with diffs in 8th symbol", timings, measures);
  check_diff_byte( timings, rounds, measures, 99);
  print_timings( "check files with diffs in 100th symbol", timings, measures);
}
