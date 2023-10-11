shader_type canvas_item;

uniform vec2 points[144];
uniform float densities ;
uniform float smooth_radius;
uniform float mass = 1.0;
uniform float radius;

//float smooth_kernel(float rad,float dis){
//	float volum = PI * pow(rad,8)/4.0;
//	float val = max(0, rad * rad - dis * dis);
//	return val * val * val / volum;
//}
//
//float cal_desity(vec2 sample_point){
//	float dens = 0.0;
//	for (int i = 0 ; i < points.length() ; i++) {
//		vec2 p = points[i];
//		float dis = length(sample_point - p);
//		if (dis > smooth_radius) continue;
//		float influent = smooth_kernel(smooth_radius,dis);
//		dens += mass * influent * 100.0;
//
//	}
//
//	return dens ;
//}

void fragment() {
	// Place fragment code here.
//	float dens = cal_desity(FRAGCOORD.xy);
	bool is_cirle = false;
	bool is_border = false;
	for (int i = 0 ; i < points.length() ; i++) {
		vec2 p = points[i];
		float dis = length(FRAGCOORD.xy - p);
		if ( dis <= radius){
			is_cirle = true;
		} 
		if (abs(dis - smooth_radius) < 1.0 ) {
			is_border = true;
		}
	}
	COLOR = vec4(0,0,0,1);
	if (is_border) COLOR = vec4(0,1,0,1);
	if (is_cirle) COLOR = vec4(0,0,1,1);
}