{ pkgs }: {
	deps = [
        pkgs.ruby_2_7
        pkgs.rubyPackages_2_7.solargraph
        pkgs.rufo
	];
}
