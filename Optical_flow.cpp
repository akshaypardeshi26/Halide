//Optical Flow estimation Code
#include "Halide.h"
#include "halide_image_io.h"
using namespace Halide::Tools;

int main(int argc, char **argv) {

	//Algorithm
	//load the images
	Halide::Image<uint8_t> img1 = load_image("images/co_1.png");
	Halide::Image<uint8_t> img2 = load_image("images/co_2.png");

	Halide::Var x("x"),y("y"),c("c");
	Halide::Func gradient("gradient");
	//Halide::Expr x_gra = Halide::cast<uint8_t>(img1(x,y+1)-img1(x, y));
	Halide::Func fun_x,fun_y;
	fun_x(x,y) = (img1(x,y+1)-img1(x, y));//x_gra;

	//Halide::Expr y_gra = Halide::cast<uint8_t>(img1(x+1,y)-img1(x, y));
	fun_y(x,y) = (img1(x+1,y)-img1(x, y));//y_gra;
	//Schedule
	//Halide::Image<uint8_t> x_img1 = fun_x.Realize(img1.width(),img1.height(),img1.channels());
	//Halide::Image<uint8_t> y_img1 = fun_y.Realize(img1.width(),img1.height(),img1.channels());
	

	save_image(x_img1, "images/x_img1.png");
	save_image(x_img1, "images/y_img1.png");
	printf("Success!\n");
    return 0;
}