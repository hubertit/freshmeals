class Nutritionist {
  final int id;
  final String name;
  final String image;
  final String about;
  final bool availability;
  final List<String> availabilityCalendar; // List of available days

  Nutritionist({
    required this.id,
    required this.name,
    required this.image,
    required this.about,
    required this.availability,
    required this.availabilityCalendar,
  });

  // Factory constructor to create a Nutritionist from JSON
  factory Nutritionist.fromJson(Map<String, dynamic> json) {
    return Nutritionist(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      about: json['about'],
      availability: json['availability'],
      availabilityCalendar: List<String>.from(json['availabilityCalendar']),
    );
  }

  // Convert Nutritionist object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'about': about,
      'availability': availability,
      'availabilityCalendar': availabilityCalendar,
    };
  }
}

List<Nutritionist> dummyNutritionists = [
  Nutritionist(
    id: 1,
    name: "Dr. Olivia Smith",
    image: "https://randomuser.me/api/portraits/women/1.jpg",
    about: "Passionate about helping people achieve their health goals with personalized nutrition plans.",
    availability: true,
    availabilityCalendar: ["Monday", "Wednesday", "Friday"], // Available on these days
  ),
  Nutritionist(
    id: 2,
    name: "Dr. John Doe",
    image: "https://randomuser.me/api/portraits/men/1.jpg",
    about: "Expert in weight management and sports nutrition. Helping clients achieve balanced diets.",
    availability: false,
    availabilityCalendar: ["Tuesday", "Thursday"], // Available on these days
  ),
  Nutritionist(
    id: 3,
    name: "Dr. Emma Johnson",
    image: "https://randomuser.me/api/portraits/women/2.jpg",
    about: "Specialist in plant-based diets and holistic nutrition. Focused on overall wellness.",
    availability: true,
    availabilityCalendar: ["Monday", "Thursday", "Saturday"],
  ),
  Nutritionist(
    id: 4,
    name: "Dr. Mark Williams",
    image: "https://randomuser.me/api/portraits/men/2.jpg",
    about: "Certified clinical nutritionist with over 10 years of experience in disease prevention.",
    availability: true,
    availabilityCalendar: ["Wednesday", "Friday", "Sunday"],
  ),
  Nutritionist(
    id: 5,
    name: "Dr. Sophia Brown",
    image: "https://randomuser.me/api/portraits/women/3.jpg",
    about: "Passionate about family nutrition, guiding parents and children toward healthy lifestyles.",
    availability: false,
    availabilityCalendar: ["Tuesday", "Thursday", "Saturday"],
  ),
];
