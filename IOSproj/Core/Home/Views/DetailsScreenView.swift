import SwiftUI

struct DetailsScreenView: View {
    @EnvironmentObject var user: AuthViewModel

    var body: some View {
        let name = user.currentUser?.fullName ?? ""
        let badges = [
            ("First Hike", "star.fill"),
            ("Second Hike", "leaf.fill"),
            ("Third Hike", "person.2.fill")
        ]
    Spacer()
        VStack(alignment: .leading, spacing: 20) {
            

            VStack(alignment: .leading, spacing: 14) {
                Text(name).bold()
                    .font(.title)
                Text("Seasonal Photos: ⛄️")
                Text("Notifications: On")
                Text("Goal Date: October 18, 2023")
            }
            .padding(.leading)

            Divider()

            Section(header: Text("Completed Badges")
                .bold()
                .font(.subheadline)) {
                HStack {
                    ForEach(badges, id: \.0) { (badgeName) in
                        VStack(alignment: .center) {
                            Badge()
                                .frame(width: 120, height: 120) 
                            Text(badgeName.0)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                   
                .padding(.vertical, 10)
            }

            Divider()


            Section(header: Text("Recent Hikes")
                .bold()
                .font(.subheadline)) {
                HikeView(hike: ModelData().hikes[0])
                   
            }

            Spacer()         }
        .padding()
    }
}

