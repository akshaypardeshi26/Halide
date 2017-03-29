// The only Halide header file you need is Halide.h. It includes all of Halide.
#include "Halide.h"
#include <stdio.h>

// Include some support code for loading pngs.
#include "halide_image_io.h"
using namespace Halide::Tools;

int main(int argc, char **argv) {


	   // First we'll load the input image we wish to brighten.
    Halide::Image<uint8_t> input = load_image("images/coins_gr.png");
    Halide::Image<uint8_t> t = load_image("images/coin_gr.png");
	Halide::Var x, y, xt, yt;
	Halide::RDom r(0, t.width(), 0, t.height());
	Halide::Func limit, compare;
	limit = Halide::BoundaryConditions::constant_exterior(input,255);
	printf("Success!\n");
	compare(x, y) = limit(x,y);
	printf("Success!\n");
	compare(x, y) = Halide::cast<uint8_t>(sum(Halide::pow(t(r.x, r.y) - limit(x + r.x - t.width()/2, (y + r.y - t.height()/2),2))/(t.width()*t.height())));
printf("Success!\n");
	Halide::Image<uint8_t> output(input.width(),input.height());
	output = compare.realize(input.width(),input.height());

	//Halide::Image<uint8_t> output =
      //  brighter.realize(input.width(), input.height(), input.channels());

    // Save the output for inspection. It should look like a bright parrot.
    save_image(output, "coin_result.png");

    // See figures/lesson_02_output.jpg for a small version of the output.

    printf("Success!\n");
    return 0;
}