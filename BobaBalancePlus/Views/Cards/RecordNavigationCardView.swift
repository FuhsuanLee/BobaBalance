//
//  RecordNavigationCardView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct RecordNavigationCardView: View {
    @Binding var records: [DrinkRecord]
    let onRecordsChanged: () -> Void

    var body: some View {
        NavigationLink {
            RecordListView(
                records: $records,
                onRecordsChanged: onRecordsChanged
            )
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("飲料紀錄")
                        .bobaSectionTitleStyle()

                    Text("目前共有 \(records.count) 筆紀錄")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(Color.bobaBrown)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .bobaCardStyle()
    }
}
