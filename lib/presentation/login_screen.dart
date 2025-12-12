import 'package:bio_secure/presentation/biometric_setup_screen.dart';
import 'package:flutter/material.dart';

/// Login screen ("Login screen") matching the provided design.
///
/// - Dark brown gradient background with subtle radial glows
/// - Center fingerprint circle with glow
/// - Title "BioSecure" and subtitle
/// - Primary orange rounded button: "Enable Biometric Login"
/// - Secondary muted rounded button: "Use PIN Instead"
class LoginScreen extends StatelessWidget {
	const LoginScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final size = MediaQuery.of(context).size;

		return Scaffold(
			// Make background extend behind system bars for nicer look
			extendBodyBehindAppBar: true,
			backgroundColor: Colors.transparent,
			body: Stack(
				children: [
					// Background gradient
					Container(
						decoration: const BoxDecoration(
							gradient: LinearGradient(
								begin: Alignment.topCenter,
								end: Alignment.bottomCenter,
								colors: [Color(0xFF2B160A), Color(0xFF1A0E08)],
								stops: [0.0, 1.0],
							),
						),
					),

					// Top radial glow
					Positioned(
						top: -size.width * 0.25,
						left: -size.width * 0.15,
						child: Container(
							width: size.width * 0.8,
							height: size.width * 0.8,
											decoration: BoxDecoration(
											shape: BoxShape.circle,
											gradient: const RadialGradient(
												colors: [Color.fromRGBO(255,122,0,0.12), Colors.transparent],
											),
										),
						),
					),

					// Bottom radial glow
					Positioned(
						bottom: -size.width * 0.35,
						right: -size.width * 0.1,
						child: Container(
							width: size.width * 1.1,
							height: size.width * 1.1,
											decoration: BoxDecoration(
											shape: BoxShape.circle,
											gradient: const RadialGradient(
												colors: [Color.fromRGBO(139,69,19,0.18), Colors.transparent],
											),
										),
						),
					),

					// Main content
					SafeArea(
						child: Padding(
							padding: const EdgeInsets.symmetric(horizontal: 24.0),
							child: Column(
								children: [
									const SizedBox(height: 40),

									// fingerprint circle + title area
									Expanded(
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												// Fingerprint circle
												Container(
													width: 140,
													height: 140,
													decoration: BoxDecoration(
														shape: BoxShape.circle,
														color: const Color.fromRGBO(0, 0, 0, 0.18),
														border: Border.all(color: Colors.white24, width: 1),
														boxShadow: [
															// soft inner glow
																							const BoxShadow(
																								color: Color.fromRGBO(255,122,0,0.08),
																								blurRadius: 28,
																								spreadRadius: 2,
																							),
															// subtle outer shadow
																							const BoxShadow(
																								color: Color.fromRGBO(0, 0, 0, 0.6),
																								blurRadius: 18,
																								offset: Offset(0, 6),
																							),
														],
													),
																				child: Center(
																				child: Icon(
																					Icons.fingerprint,
																					size: 56,
																					color: Color.fromRGBO(255, 255, 255, 0.95),
																				),
																			),
												),

												const SizedBox(height: 26),

												const Text(
													'BioSecure',
													semanticsLabel: 'Login screen title: BioSecure',
													style: TextStyle(
														color: Colors.white,
														fontSize: 34,
														fontWeight: FontWeight.w700,
														letterSpacing: 0.2,
													),
												),

												const SizedBox(height: 12),

																		Text(
																			'Unlock Smarter. Unlock Secure.',
																			textAlign: TextAlign.center,
																			style: const TextStyle(
																				color: Color.fromRGBO(255, 255, 255, 0.75),
																				fontSize: 16,
																				fontWeight: FontWeight.w400,
																			),
																		),
											],
										),
									),

									// Buttons at bottom
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											SizedBox(
												height: 58,
												child: ElevatedButton(
													onPressed: () {
														Navigator.push(context, MaterialPageRoute(builder: (context) => const BiometricSetupScreen()));
													},
													style: ElevatedButton.styleFrom(
														backgroundColor: const Color(0xFFFF7A00),
														shape: const StadiumBorder(),
														elevation: 8,
														shadowColor: const Color.fromRGBO(255,122,0,0.45),
														textStyle: const TextStyle(
															fontSize: 18,
															fontWeight: FontWeight.w600,
														),
													),
													child: const Text('Enable Biometric Login'),
												),
											),

											const SizedBox(height: 18),

											SizedBox(
												height: 56,
												child: ElevatedButton(
													onPressed: () {
														// TODO: navigate to PIN flow
													},
													style: ElevatedButton.styleFrom(
														backgroundColor: const Color.fromRGBO(139,69,19,0.48),
														shape: const StadiumBorder(),
														elevation: 2,
														shadowColor: Colors.black45,
														textStyle: const TextStyle(
															fontSize: 16,
															fontWeight: FontWeight.w600,
														),
													),
													child: const Text('Use PIN Instead', style: TextStyle(color: Colors.white)),
												),
											),

											const SizedBox(height: 28),
										],
									),
								],
							),
						),
					),
				],
			),
		);
	}
}
