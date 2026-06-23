package main
import res "resource"
import "core:fmt"
import "core:path/filepath"

main :: proc()
{
	defer free_all(context.temp_allocator)

	res.models = make([dynamic]res.Model, 0, context.temp_allocator)
	models_path, _ := filepath.join({"Output"}, context.temp_allocator)
	res.load_models(models_path, &res.models)
	fmt.println("Hello World")

}
