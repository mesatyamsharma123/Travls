import SwiftUI
import Combine

// MARK: - Gender
enum Gender: String, CaseIterable {
    case male   = "Male"
    case female = "Female"
    case other  = "Other"
}

// MARK: - EditProfileViewModel
@MainActor
final class EditProfileViewModel: ObservableObject {

    // MARK: - Editable form fields (bind directly to UI)
    @Published var firstName: String = "Sumit"
    @Published var lastName: String  = "Raj"
    @Published var dateOfBirth: Date = Calendar.current.date(
        from: DateComponents(year: 2004, month: 3, day: 12)
    ) ?? Date()
    @Published var gender: Gender = .male

    // MARK: - Read-only display fields (populated from profile data)
    @Published var username: String          = "candy_boy_ss"
    @Published var profileCompletion: Double = 1.0   // 0.0 – 1.0
    @Published var level: Int                = 1

    // MARK: - Async state
    @Published var isSaving: Bool    = false
    @Published var errorMessage: String?

    // MARK: - Actions

    func saveProfile() {
        // TODO: Replace with real API call when backend is ready.
        // Example:
        //   isSaving = true
        //   defer { isSaving = false }
        //   try await network.request(ProfileEndpoints.update(
        //       firstName: firstName, lastName: lastName,
        //       dob: dateOfBirth, gender: gender.rawValue
        //   ))
        print("TODO: Save — \(firstName) \(lastName) | DOB: \(dateOfBirth) | Gender: \(gender.rawValue)")
    }

    func changeAvatar() {
        // TODO: Present PHPickerViewController for avatar photo
        print("TODO: Open avatar image picker")
    }

    func changeCoverPhoto() {
        // TODO: Present PHPickerViewController for cover photo
        print("TODO: Open cover image picker")
    }
}
