import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel = EditProfileViewModel()
    @SwiftUI.Environment(\.dismiss) private var dismiss

    private let gold        = Color(hex: "#F2C94C")
    private let surface     = Color(hex: "#1A1A1A")
    private let fieldBg     = Color(hex: "#2A2A2A")
    private let gray        = Color(hex: "#6B6B6B")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerBar
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 20)

                    coverSection
                        .padding(.horizontal, 20)

                    profileInfoSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    publicIdentitySection
                        .padding(.horizontal, 20)
                        .padding(.top, 32)

                    personalDetailsSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    saveButton
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                        .padding(.bottom, 48)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            Button { dismiss() } label: {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1E1E1E"))
                        .frame(width: 42, height: 42)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }

            Spacer()

            Text("Edit Profile")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            // Invisible balancing element so title stays centred
            Circle()
                .fill(.clear)
                .frame(width: 42, height: 42)
        }
    }

    // MARK: - Cover + Editable Avatar
    private var coverSection: some View {
        VStack(spacing: 0) {
            coverImageView
                .overlay(alignment: .bottomLeading) {
                    editableAvatarView
                        .offset(y: 44)
                }
                .padding(.bottom, 44)
        }
    }

    private var coverImageView: some View {
        ZStack(alignment: .trailing) {
            LinearGradient(
                colors: [Color(hex: "#EAE0CC"), Color(hex: "#C8B48C")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(alignment: .bottom, spacing: -12) {
                Image(systemName: "person.fill")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundStyle(Color(hex: "#3C3580").opacity(0.65))
                    .offset(y: 16)

                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 76))
                    .foregroundStyle(gold.opacity(0.92))
                    .offset(y: -4)

                Image(systemName: "person.2.fill")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundStyle(Color(hex: "#3C3580").opacity(0.55))
                    .offset(y: 18)
            }
            .padding(.trailing, 20)
            .clipped()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // Avatar with gold border and a pencil edit badge
    private var editableAvatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                Circle().fill(Color(hex: "#2A2A2A"))
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(gray)
            }
            .frame(width: 88, height: 88)
            .overlay(Circle().strokeBorder(gold, lineWidth: 3))

            // Pencil badge
            Button { viewModel.changeAvatar() } label: {
                ZStack {
                    Circle()
                        .fill(gold)
                        .frame(width: 28, height: 28)
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
            .offset(x: 2, y: 2)
        }
    }

    // MARK: - Profile Info (username, dob, level + progress bar)
    private var profileInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.username)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundStyle(gray)
                Text(viewModel.dateOfBirth,
                     format: .dateTime.month(.abbreviated).day().year())
                    .font(.system(size: 14))
                    .foregroundStyle(gray)
            }

            // Level badge + completion label
            HStack(spacing: 10) {
                Text("LEVEL \(viewModel.level)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(gold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#2A1800"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(gold.opacity(0.5), lineWidth: 1)
                    )

                Text("\(Int(viewModel.profileCompletion * 100))% Profile Complete")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(gray)
            }

            // Gold progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "#2A2A2A"))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(gold)
                        .frame(width: geo.size.width * viewModel.profileCompletion,
                               height: 4)
                }
            }
            .frame(height: 4)
        }
    }

    // MARK: - Public Identity
    private var publicIdentitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Public Identity")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            // Outer card
            VStack {
                HStack(spacing: 12) {
                    Text("#")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(gray)
                    Text(viewModel.username)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(16)
                .background(fieldBg)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(12)
            .background(surface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    // MARK: - Personal Details
    private var personalDetailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Personal Details")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 20) {
                ProfileFormField(label: "FIRST NAME", text: $viewModel.firstName,
                                 fieldBg: fieldBg, gray: gray)
                ProfileFormField(label: "LAST NAME",  text: $viewModel.lastName,
                                 fieldBg: fieldBg, gray: gray)
                dateOfBirthField
                genderField
            }
            .padding(20)
            .background(surface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    private var dateOfBirthField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DATE OF BIRTH")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(gray)
                .tracking(1.2)

            // Compact DatePicker styled to match the design
            DatePicker("",
                       selection: $viewModel.dateOfBirth,
                       in: ...Date(),
                       displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(gold)
                .colorScheme(.dark)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(fieldBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var genderField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("GENDER IDENTITY")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(gray)
                .tracking(1.2)

            HStack(spacing: 12) {
                ForEach(Gender.allCases, id: \.self) { option in
                    GenderChip(
                        title: option.rawValue,
                        isSelected: viewModel.gender == option,
                        gold: gold,
                        fieldBg: fieldBg,
                        gray: gray
                    ) {
                        viewModel.gender = option
                    }
                }
            }
        }
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button { viewModel.saveProfile() } label: {
            ZStack {
                if viewModel.isSaving {
                    ProgressView().tint(.black)
                } else {
                    Text("Save Changes")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(gold)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isSaving)
    }
}

// MARK: - ProfileFormField
// Reusable label + text field pair used in the Personal Details card.
private struct ProfileFormField: View {
    let label: String
    @Binding var text: String
    let fieldBg: Color
    let gray: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(gray)
                .tracking(1.2)

            TextField("", text: $text)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .tint(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(fieldBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - GenderChip
// Tappable chip with a dashed gold border when selected.
private struct GenderChip: View {
    let title: String
    let isSelected: Bool
    let gold: Color
    let fieldBg: Color
    let gray: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isSelected ? gold : gray)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(fieldBg)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            isSelected ? gold : Color.clear,
                            style: StrokeStyle(lineWidth: 1.5, dash: [5, 3])
                        )
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
