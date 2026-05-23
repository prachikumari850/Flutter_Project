import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/common_widgets.dart';
import '../services/auth_service.dart';
import 'main_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin    = true;
  bool _obscurePwd = true;
  bool _isLoading  = false;
  String? _errorMessage;

  final _formKey    = GlobalKey<FormState>();
  final _emailCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  final _nameCtrl   = TextEditingController();

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;

  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_animCtrl);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggleMode() {
    _animCtrl.reverse().then((_) {
      setState(() { _isLogin = !_isLogin; _errorMessage = null; });
      _animCtrl.forward();
    });
  }

  // ── Real Firebase auth ─────────────────────────────────
  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    AuthResult result;
    if (_isLogin) {
      result = await _auth.signIn(
          email: _emailCtrl.text, password: _passCtrl.text);
    } else {
      result = await _auth.signUp(
          name: _nameCtrl.text,
          email: _emailCtrl.text,
          password: _passCtrl.text);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainWrapper(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      setState(() => _errorMessage = result.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // ── Gradient header ────────────────────────
              Container(
                height: size.height * 0.36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft:  Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(children: [
                  Positioned(
                    top: -40, right: -40,
                    child: Container(
                      width: 180, height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text('🔍', style: TextStyle(fontSize: 52)),
                        const SizedBox(height: 10),
                        const Text('KhojMitra.AI',
                            style: TextStyle(
                              color: Colors.white, fontSize: 28,
                              fontWeight: FontWeight.w900, letterSpacing: 0.5,
                            )),
                        const SizedBox(height: 6),
                        Text(
                          _isLogin ? 'Welcome Back! 👋' : 'Create Account 🚀',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),

              // ── Form Card ──────────────────────────────
              Positioned(
                top: size.height * 0.30,
                left: 0, right: 0,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30, offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tab switcher
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkSurface
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(children: [
                              _TabBtn(
                                  label: 'Login',
                                  isActive: _isLogin,
                                  onTap: () { if (!_isLogin) _toggleMode(); }),
                              _TabBtn(
                                  label: 'Sign Up',
                                  isActive: !_isLogin,
                                  onTap: () { if (_isLogin)  _toggleMode(); }),
                            ]),
                          ),
                          const SizedBox(height: 24),

                          // Error banner
                          if (_errorMessage != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.lost.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.lost.withOpacity(0.3)),
                              ),
                              child: Row(children: [
                                const Text('⚠️'),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(_errorMessage!,
                                      style: const TextStyle(
                                          color: AppColors.lost,
                                          fontSize: 13)),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Name (signup only)
                          if (!_isLogin) ...[
                            TextFormField(
                              controller: _nameCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline),
                                hintText: 'e.g. Arjun Sharma',
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'College Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'you@abesit.edu.in',
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter email';
                              }
                              if (!v.contains('@') || !v.contains('.')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscurePwd,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              hintText: '••••••••',
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                    () => _obscurePwd = !_obscurePwd),
                                child: Icon(_obscurePwd
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.length < 6)
                                    ? 'Password must be at least 6 characters'
                                    : null,
                          ),
                          const SizedBox(height: 8),

                          if (_isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Forgot Password?',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 13)),
                              ),
                            ),
                          const SizedBox(height: 16),

                          // Submit
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.primary))
                              : GradientButton(
                                  label: _isLogin
                                      ? 'Login' : 'Create Account',
                                  onTap: _handleAuth,
                                  icon: _isLogin
                                      ? Icons.login
                                      : Icons.person_add_outlined,
                                ),
                          const SizedBox(height: 20),

                          // OR divider
                          Row(children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              child: Text('OR',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12)),
                            ),
                            const Expanded(child: Divider()),
                          ]),
                          const SizedBox(height: 16),

                          // Google (UI only — wiring needs google_sign_in pkg)
                          _GoogleBtn(onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Add google_sign_in package to enable Google login.'),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab Button ─────────────────────────────────────────────
class _TabBtn extends StatelessWidget {
  final String label; final bool isActive; final VoidCallback onTap;
  const _TabBtn({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              )),
        ),
      ),
    );
  }
}

// ── Google Button ──────────────────────────────────────────
class _GoogleBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 54,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1) : AppColors.divider,
          ),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      '🔵',
      style: TextStyle(fontSize: 20),
    ),

    const SizedBox(width: 8),

    Flexible(
      child: Text(
        'Continue with Google',
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ],
),
      ),
    );
  }
}