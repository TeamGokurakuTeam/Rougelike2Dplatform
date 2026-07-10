shader_type canvas_item;

// === 弧の形状 ===
uniform float start_angle : hint_range(0.0, 360.0) = 300.0;   // 弧の開始角度(度)
uniform float arc_angle : hint_range(1.0, 359.0) = 110.0;     // 弧の角度幅(度)
uniform float inner_radius : hint_range(0.0, 0.5) = 0.22;     // 内側の半径
uniform float outer_radius : hint_range(0.0, 0.5) = 0.48;     // 外側の半径
uniform float edge_softness : hint_range(0.001, 0.05) = 0.015; // リング縁のぼかし

// === アニメーション(0.0→1.0をスクリプトから渡す) ===
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float reveal_feather : hint_range(0.01, 0.5) = 0.18;  // 描画の先端のぼかし幅

// === 色 ===
uniform vec4 core_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);   // 刃の先端(白く光る部分)
uniform vec4 glow_color : source_color = vec4(0.4, 0.85, 1.0, 1.0);  // 弧本体の色

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);
	float ang = degrees(atan(uv.y, uv.x));
	if (ang < 0.0) {
		ang += 360.0;
	}

	float local_angle = mod(ang - start_angle, 360.0);
	float angle_t = local_angle / arc_angle; // 0=弧の開始端 / 1=終了端

	// 弧の角度範囲内だけ表示(端は軽くぼかしてジャギーを軽減)
	float in_arc = smoothstep(0.0, 0.01, angle_t) * (1.0 - smoothstep(0.99, 1.0, angle_t));

	// 内側〜外側のリング状マスク
	float ring = smoothstep(inner_radius - edge_softness, inner_radius + edge_softness, dist)
			   - smoothstep(outer_radius - edge_softness, outer_radius + edge_softness, dist);
	ring = clamp(ring, 0.0, 1.0);

	// progress 0.0〜0.5: 弧を開始端から終了端へ描き進める
	// progress 0.5〜1.0: 描き終えた弧を全体フェードアウト
	float draw_t = clamp(progress / 0.5, 0.0, 1.0);
	float fade_t = clamp((progress - 0.5) / 0.5, 0.0, 1.0);

	float reveal = 1.0 - smoothstep(draw_t - reveal_feather, draw_t, angle_t);
	float fade_out = 1.0 - fade_t;

	float alpha = in_arc * ring * reveal * fade_out;

	// 刃が今まさに通っている先端だけ明るく光らせる
	float leading_edge = 1.0 - smoothstep(0.0, reveal_feather, abs(angle_t - draw_t));
	vec3 color = mix(glow_color.rgb, core_color.rgb, leading_edge);

	COLOR = vec4(color, alpha * core_color.a);
}
