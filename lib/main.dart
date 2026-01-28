import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

void main() {
  runApp(const WarmSocialApp());
}

// --- 全局设计常量 ---
class AppColors {
  static const Color background = Color(0xFFF9F7F2); // 燕麦色背景
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFFD67D62); // 陶土红
  static const Color secondary = Color(0xFF8DA399); // 鼠尾草绿
  static const Color textDark = Color(0xFF2D2A26); // 深炭灰
  static const Color textLight = Color(0xFFA6A19C); // 浅暖灰
}

class AppTextStyles {
  static const TextStyle header = TextStyle(
    color: AppColors.textDark,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    fontFamily: 'Serif', // 如果有引入类似Playfair Display的字体效果更好
  );
  static const TextStyle subHeader = TextStyle(
    color: AppColors.textDark,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle body = TextStyle(
    color: AppColors.textLight,
    fontSize: 14,
    height: 1.5,
  );
}

// --- 主程序入口 ---
class WarmSocialApp extends StatelessWidget {
  const WarmSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warm Social',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        useMaterial3: true,
        fontFamily: 'Helvetica Neue', // 尽量使用干净的字体
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

// --- 底部导航逻辑与框架 ---
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MomentsPage(),
    const ChatListPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 关键：让body延伸到导航栏下方
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.textDark.withOpacity(0.95),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(CupertinoIcons.compass, 0),
          _navItem(CupertinoIcons.camera_on_rectangle, 1), // 朋友圈
          _navItem(CupertinoIcons.chat_bubble_2, 2),
          _navItem(CupertinoIcons.person, 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white54,
          size: 24,
        ),
      ),
    );
  }
}

// --- 1. 首页 (Discovery) ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // 头部欢迎
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("早安,", style: AppTextStyles.body.copyWith(fontSize: 16)),
                  const Text("探索·美好", style: AppTextStyles.header),
                ],
              ),
              const CircleAvatar(
                backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=32"),
                radius: 24,
              )
            ],
          ),
          const SizedBox(height: 30),
          
          // 故事栏 (Story)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=${index + 10}"),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text("User $index", style: const TextStyle(fontSize: 10, color: AppColors.textDark))
                  ],
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),
          // 瀑布流卡片 (模拟)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: const [
                    MoodCard(height: 220, imgUrl: "https://picsum.photos/300/400?random=1", title: "周末的咖啡时光"),
                    SizedBox(height: 16),
                    MoodCard(height: 180, imgUrl: "https://picsum.photos/300/300?random=2", title: "极简生活"),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: const [
                    MoodCard(height: 160, imgUrl: "https://picsum.photos/300/300?random=3", title: "秋日穿搭"),
                    SizedBox(height: 16),
                    MoodCard(height: 240, imgUrl: "https://picsum.photos/300/500?random=4", title: "室内设计灵感"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 100), // 为底部导航栏留白
        ],
      ),
    );
  }
}

class MoodCard extends StatelessWidget {
  final double height;
  final String imgUrl;
  final String title;

  const MoodCard({super.key, required this.height, required this.imgUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.network(imgUrl, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const Icon(CupertinoIcons.heart, size: 16, color: AppColors.primary),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- 2. 朋友圈页面 (Moments - 杂志风) ---
class MomentsPage extends StatelessWidget {
  const MomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            floating: true,
            title: Text("生活圈", style: AppTextStyles.header.copyWith(fontSize: 22)),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.add_circled, color: AppColors.textDark))
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildMomentItem(index);
              },
              childCount: 5,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildMomentItem(int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE5DED5).withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=${index + 20}")),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Annie 的日常", style: AppTextStyles.subHeader.copyWith(fontSize: 16)),
                  const Text("2小时前 · 杭州", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "今天的天气真好，适合出去走走。看到了很美的日落，分享给你们。✨ #生活 #日落",
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              "https://picsum.photos/600/350?random=${index + 10}",
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _interactionIcon(CupertinoIcons.heart_fill, AppColors.primary, "128"),
              const SizedBox(width: 20),
              _interactionIcon(CupertinoIcons.chat_bubble, AppColors.textDark, "34"),
              const Spacer(),
              const Icon(CupertinoIcons.bookmark, color: AppColors.textLight),
            ],
          )
        ],
      ),
    );
  }

  Widget _interactionIcon(IconData icon, Color color, String count) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(count, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}

// --- 3. 聊天页面 (Chat - 极简) ---
class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text("消息", style: AppTextStyles.header),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Dismissible(
              key: Key('$index'),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: AppColors.primary,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: index == 0 ? AppColors.secondary.withOpacity(0.1) : AppColors.cardWhite, // 置顶效果
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=$index"),
                        ),
                        if (index < 3)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 12, height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Friend $index", style: AppTextStyles.subHeader.copyWith(fontSize: 16)),
                              Text("10:3$index", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "今晚有空一起去吃饭吗？听说新开了一家...",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- 4. 个人中心 (Profile - 高级感布局) ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景装饰
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.2),
              shape: BoxShape.circle,
    
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 100),
          child: Column(
            children: [
              // 顶部栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(CupertinoIcons.settings, color: AppColors.textDark),
                  const Icon(CupertinoIcons.qrcode, color: AppColors.textDark),
                ],
              ),
              const SizedBox(height: 20),
              
              // 头像区域
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=32"),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Chloe Chen", style: AppTextStyles.header),
              const SizedBox(height: 8),
              Text("UI Designer & Photographer", style: AppTextStyles.body.copyWith(color: AppColors.primary)),
              
              const SizedBox(height: 30),
              
              // 数据统计
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatItem(label: "Post", count: "128"),
                  _StatItem(label: "Followers", count: "3.5k"),
                  _StatItem(label: "Following", count: "240"),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // 菜单卡片
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: const [
                    _MenuItem(icon: CupertinoIcons.heart, title: "我的收藏", isFirst: true),
                    _MenuItem(icon: CupertinoIcons.photo, title: "相册管理"),
                    _MenuItem(icon: CupertinoIcons.bell, title: "通知设置"),
                    _MenuItem(icon: CupertinoIcons.shield, title: "隐私与安全", isLast: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String count;
  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: AppTextStyles.subHeader.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isFirst;
  final bool isLast;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.textDark, size: 20),
          ),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(CupertinoIcons.chevron_right, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}