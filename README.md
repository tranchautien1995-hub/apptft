# TFT Meta 18 — V3.4 FULL CATALOG

Static snapshot, iOS 15, không server/Python.

## Sửa chính
- Mặc định Tất cả rank để thấy catalog rộng nhất.
- Thêm Low play ON/OFF giống ý tưởng `Show low play rate compositions` của tactics.tools.
- Bổ sung nhiều comp công khai bị thiếu ở V3.3, đặc biệt Platinum+ Last 2 Days, Diamond+ Patch và Master+ Last 2 Days.
- Nút Variants màu tím giữ ở màn riêng; khi Tất cả rank sẽ gom subcomp cùng family trong cùng snapshot.
- Cost tướng được chuẩn hóa theo bảng Set 18 của tactics.tools (Ezreal 4-cost, Ornn/Leona/Akali 1-cost, v.v.).
- Fiddlesticks dùng slug ảnh `da_18_fiddlesticks`.
- Filter vẫn hiện danh sách tên tướng.
- Hàng tướng trên iOS vẫn là ScrollView ngang độc lập ngoài NavigationLink.

## Build
GitHub Actions → Build TFT Meta 18 IPA → Run workflow.

- V3.4 final: thêm 3 alternate comps vào Variants cho Last 2 Days để nút tím xuất hiện rõ hơn.
