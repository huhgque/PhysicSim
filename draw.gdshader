shader_type canvas_item;


const uint num_paticles = uint(12*12);
uniform vec2 points[144];
uniform float smooth_radius;
uniform float mass = 1.0;


float smooth_kernel(float rad,float dis){
	float volum = PI * pow(rad,8)/4.0;
	float val = max(0,rad * rad - dis * dis);
	return val * val * val / volum;
}

float cal_desity(vec2 sample_point){
	float dens = 0.0;
	for (int i = 0 ; i < points.length() ; i++) {
		vec2 p = points[i];
		float dis = length(sample_point - p);
		if( p != sample_point ){
			float influent = smooth_kernel(smooth_radius,dis);
			dens += mass * influent * 100.0;
		}else if (dis <= smooth_radius){
			dens = 1.0;
		}
	}
	
	return dens ;
}

void fragment() {
	// Place fragment code here.
	float dens = cal_desity(FRAGCOORD.xy);
	COLOR = vec4(dens,0,0,1);
}