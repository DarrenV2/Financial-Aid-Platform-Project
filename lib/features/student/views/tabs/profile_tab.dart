import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:financial_aid_project/features/student/controllers/profile_controller.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Modern Header with Profile Picture
              _buildProfileHeader(controller),
              const SizedBox(height: 20),
              // Profile Content
              _buildPersonalInfoSection(controller),
              const SizedBox(height: 20),
              _buildAcademicInfoSection(controller),
              const SizedBox(height: 20),
              _buildFinancialScholarshipSection(controller),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColors.primary,
            TColors.primary.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withAlpha(77),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Image
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 15),
          // Name display
          Text(
            "${controller.firstNameController.text} ${controller.lastNameController.text}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(ProfileController controller) {
    return Obx(() {
      final isEditing = controller.editingSection.value == 'profile';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, color: TColors.primary),
                    const SizedBox(width: 10),
                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (!isEditing)
                  ElevatedButton.icon(
                    onPressed: () => controller.setEditingSection('profile'),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
              ],
            ),
            const Divider(height: 25),
            const SizedBox(height: 10),

            // Personal Info Form Fields
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "First Name",
                    controller.firstNameController,
                    enabled: isEditing,
                    hintText: "Your first name",
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    "Last Name",
                    controller.lastNameController,
                    enabled: isEditing,
                    hintText: "Your last name",
                    icon: Icons.person,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Builder(
                    builder: (BuildContext context) => _buildDatePickerField(
                      "Date of Birth",
                      controller.dobController,
                      enabled: isEditing,
                      hintText: "DD / MM / YYYY",
                      context: context,
                      icon: Icons.calendar_today,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    "Gender",
                    ["Select Gender", "Male", "Female", "Other"],
                    controller.selectedGender.value.isEmpty
                        ? null
                        : controller.selectedGender.value,
                    enabled: isEditing,
                    icon: Icons.people,
                    onChanged: isEditing
                        ? (value) {
                            if (value != null) {
                              controller.selectedGender.value = value;
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildTextField(
              "Address",
              controller.addressController,
              enabled: isEditing,
              hintText: "Your address",
              icon: Icons.location_on,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildPhoneField(
                    controller.phoneController,
                    enabled: isEditing,
                    hintText: "Your phone number",
                    icon: Icons.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    "Email",
                    controller.emailController,
                    enabled: isEditing,
                    hintText: "youremail@example.com",
                    icon: Icons.email,
                  ),
                ),
              ],
            ),

            // Action buttons for editing
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => controller.cancelEditing(),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => controller.updateUserData(),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text("Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildAcademicInfoSection(ProfileController controller) {
    return Obx(() {
      final isEditing = controller.editingSection.value == 'academic';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.school, color: TColors.primary),
                    const SizedBox(width: 10),
                    const Text(
                      "Academic Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (!isEditing)
                  ElevatedButton.icon(
                    onPressed: () => controller.setEditingSection('academic'),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
              ],
            ),
            const Divider(height: 25),
            const SizedBox(height: 10),

            // Academic Info Form Fields
            _buildDropdownField(
              "Degree Level",
              [
                "Select Degree Level",
                "Professional Certification",
                "Undergraduate",
                "Postgraduate",
              ],
              controller.selectedDegreeLevel.value.isEmpty
                  ? null
                  : controller.selectedDegreeLevel.value,
              enabled: isEditing,
              icon: Icons.workspace_premium,
              onChanged: isEditing
                  ? (value) {
                      if (value != null) {
                        controller.selectedDegreeLevel.value = value;
                      }
                    }
                  : null,
            ),
            const SizedBox(height: 15),
            _buildDropdownField(
              "Faculty",
              [
                "Select Faculty",
                "College of Business & Management (COBAM)",
                "College of Health Sciences (COHS)",
                "Faculty of Education & Liberal Studies (FELS)",
                "Faculty of Engineering & Computing (FENC)",
                "Faculty of Law (FOL)",
                "Faculty of Science & Sport (FOSS)",
                "Faculty of The Built Environment (FOBE)",
                "Joint Colleges of Medicine, Oral Health & Veterinary Sciences",
              ],
              controller.selectedFaculty.value.isEmpty
                  ? null
                  : controller.selectedFaculty.value,
              enabled: isEditing,
              icon: Icons.account_balance,
              onChanged: isEditing
                  ? (value) {
                      if (value != null) {
                        controller.selectedFaculty.value = value;
                      }
                    }
                  : null,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    "College",
                    ["Select College", "UTech"],
                    controller.selectedCollege.value.isEmpty
                        ? null
                        : controller.selectedCollege.value,
                    enabled: isEditing,
                    icon: Icons.account_balance,
                    onChanged: isEditing
                        ? (value) {
                            if (value != null) {
                              controller.selectedCollege.value = value;
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    "Degree Program/Major",
                    [
                      "Select Program",
                      "Computer Science",
                      "Business Administration",
                      "Mechanical Engineering",
                      "Nursing",
                      "Architecture",
                    ],
                    controller.selectedDegreeProgram.value.isEmpty
                        ? null
                        : controller.selectedDegreeProgram.value,
                    enabled: isEditing,
                    icon: Icons.school,
                    onChanged: isEditing
                        ? (value) {
                            if (value != null) {
                              controller.selectedDegreeProgram.value = value;
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildDropdownField(
              "Current Year of Study",
              ["Select Year", "1st", "2nd", "3rd", "4th"],
              controller.selectedYearOfStudy.value.isEmpty
                  ? null
                  : controller.selectedYearOfStudy.value,
              enabled: isEditing,
              icon: Icons.calendar_today,
              onChanged: isEditing
                  ? (value) {
                      if (value != null) {
                        controller.selectedYearOfStudy.value = value;
                      }
                    }
                  : null,
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.grade, color: TColors.primary),
                    const SizedBox(width: 10),
                    const Text(
                      "GPA",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (isEditing)
                  Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(controller.gpa.value.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Slider(
                                  value: controller.gpa.value,
                                  min: 0.0,
                                  max: 4.0,
                                  divisions: 40,
                                  activeColor: TColors.primary,
                                  inactiveColor: Colors.grey.shade300,
                                  label:
                                      controller.gpa.value.toStringAsFixed(2),
                                  onChanged: isEditing
                                      ? (value) {
                                          controller.updateGPA(value);
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                _buildTextField(
                  "GPA (Manual Entry)",
                  controller.gpaController,
                  enabled: isEditing,
                  hintText: "Enter your GPA",
                  icon: Icons.edit,
                ),
              ],
            ),

            // Action buttons for editing
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => controller.cancelEditing(),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => controller.updateUserData(),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text("Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFinancialScholarshipSection(ProfileController controller) {
    return Obx(() {
      final isEditing = controller.editingSection.value == 'scholarship';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: TColors.primary),
                    const SizedBox(width: 10),
                    const Text(
                      "Financial & Scholarship Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (!isEditing)
                  ElevatedButton.icon(
                    onPressed: () =>
                        controller.setEditingSection('scholarship'),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
              ],
            ),
            const Divider(height: 25),
            const SizedBox(height: 10),

            // Financial & Scholarship Form Fields
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    "Scholarship Type",
                    [
                      "Select Type",
                      "Merit-Based",
                      "Need-Based",
                      "Athletic",
                      "Creative Arts",
                    ],
                    controller.selectedScholarshipType.value.isEmpty
                        ? null
                        : controller.selectedScholarshipType.value,
                    enabled: isEditing,
                    icon: Icons.card_membership,
                    onChanged: isEditing
                        ? (value) {
                            if (value != null) {
                              controller.selectedScholarshipType.value = value;
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    "Financial Status",
                    [
                      "Select Status",
                      "Self-funded",
                      "Government Assistance",
                      "Scholarship",
                      "Other",
                    ],
                    controller.selectedFinancialStatus.value.isEmpty
                        ? null
                        : controller.selectedFinancialStatus.value,
                    enabled: isEditing,
                    icon: Icons.account_balance_wallet,
                    onChanged: isEditing
                        ? (value) {
                            if (value != null) {
                              controller.selectedFinancialStatus.value = value;
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),

            // Action buttons for editing
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => controller.cancelEditing(),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => controller.updateUserData(),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text("Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  // Helper methods for form fields
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    String? hintText,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon, color: TColors.primary) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.primary, width: 2),
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    String? hintText,
    required BuildContext context,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        readOnly: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon, color: TColors.primary) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.primary, width: 2),
          ),
          suffixIcon: enabled
              ? IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.grey),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.text =
                          "${pickedDate.day.toString().padLeft(2, '0')} / ${pickedDate.month.toString().padLeft(2, '0')} / ${pickedDate.year}";
                    }
                  },
                )
              : null,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildPhoneField(
    TextEditingController controller, {
    bool enabled = true,
    String? hintText,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IntlPhoneField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: "Phone Number",
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon, color: TColors.primary) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.primary, width: 2),
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
        initialCountryCode: 'JM', // Jamaica
        onChanged: (phone) {
          controller.text = phone.completeNumber;
        },
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> options,
    String? value, {
    bool enabled = true,
    ValueChanged<String?>? onChanged,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        isDense: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: "Select an option",
          prefixIcon: icon != null ? Icon(icon, color: TColors.primary) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.primary, width: 2),
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
        items: options
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
