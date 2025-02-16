if imgui.BeginTabItem(fa.STAR .. u8' ������ � ������') then 
				if imgui.BeginChild('##smartuk', imgui.ImVec2(196 * settings.general.custom_dpi, 340 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.STAR .. u8' ������� ������ �������')
					imgui.Separator()
					imgui.SetCursorPosY(100 * settings.general.custom_dpi)
					imgui.SetCursorPosX(60 * settings.general.custom_dpi)
					if imgui.Button(fa.DOWNLOAD .. u8' ��������� ##smartuk') then
						if getARZServerNumber() ~= 0 then
							download_smartuk = true
							downloadFileFromUrlToPath('https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/SmartUK/' .. getARZServerNumber() .. '/SmartUK.json', path_uk)
							imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartuk')
						else
							imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##nocloudsmartuk')
						end
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##nocloudsmartuk', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
						change_dpi()
						imgui.CenterText(u8'� ���� ������ ��� ���� ������ ������� ��� ������ �������!')
						imgui.Separator()
						imgui.CenterText(u8'�� ������ ������� ��������� ��� �� ������ "���������������"')
						imgui.CenterText(u8'����� �� ������� ���������� �� �� ����� Discord � �� ����� �������� � ���� ������')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(550 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartuk', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
						if download_smartuk then
							change_dpi()
							imgui.CenterText(u8'���� �� ������ ��� ���� ������ ��� ���������� ������ ������� ��� ' .. getARZServerNumber() .. u8' �������!')
							imgui.CenterText(u8'����� ����������� �������� ��� ���� ������� � �� ������� ��������� � ����!')
							imgui.Separator()
							imgui.CenterText(u8'���� �� ������ �� ����������, ������ ��������� ������ ���������� SmartUK.json')
							imgui.CenterText(u8'�������� � ���� ������ ���� ����� ������ ��� ������ �������!')
							imgui.Separator()
							imgui.CenterText(u8'� ���� ������ �� ������ ������� ��������� ��� �� ������ "���������������"')
							imgui.CenterText(u8'����� �� ������� ���������� �� �� ����� Discord � �� ����� �������� � ���� ������')
							imgui.CenterText(u8'��� ���� ����� ������� ���� SmartUK.json , ������� ���������� �� ����:')
							imgui.CenterText(u8(path_uk))
							imgui.Separator()
						else
							imgui.CloseCurrentPopup()
						end
						if imgui.Button(fa.CIRCLE_INFO .. u8' ������', imgui.ImVec2(550 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosX(40 * settings.general.custom_dpi)
					imgui.SetCursorPosY(170 * settings.general.custom_dpi)
					if imgui.Button(fa.PEN_TO_SQUARE .. u8' ��������������� ##smartuk') then
						imgui.OpenPopup(fa.STAR .. u8' ������� ������ �������##smartuk')
					end
					imgui.SetCursorPosY(250 * settings.general.custom_dpi)
					imgui.CenterText(u8('�������������:'))
					imgui.CenterText(u8('/sum [ID ������]'))
					if imgui.BeginPopupModal(fa.STAR .. u8' ������� ������ �������##smartuk', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						change_dpi()
						imgui.BeginChild('##smartukedit', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true)
						for chapter_index, chapter in ipairs(smart_uk) do
							imgui.Columns(2)
							imgui.BulletText(u8(chapter.name))
							imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
							imgui.NextColumn()
							if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index) then
								imgui.OpenPopup(u8(chapter.name).. '##' .. chapter_index)
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index) then
								imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index)
							end
							if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index, _, imgui.WindowFlags.NoResize ) then
								change_dpi()
								imgui.CenterText(u8'�� ������������� ������ ������� �����?')
								imgui.CenterText(u8(chapter.name))
								imgui.Separator()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									table.remove(smart_uk, chapter_index)
									save_smart_uk()
									imgui.CloseCurrentPopup()
								end
								imgui.End()
							end
							imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
							imgui.Columns(1)
							if imgui.BeginPopupModal(u8(chapter.name) .. '##' .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
								change_dpi()
								if imgui.BeginChild('##smartukedititem', imgui.ImVec2(589 * settings.general.custom_dpi, 390 * settings.general.custom_dpi), true) then
									if chapter.item then
										for index, item in ipairs(chapter.item) do
											imgui.Columns(2)
											imgui.BulletText(u8(item.text))
											imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
											imgui.NextColumn()
											if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index .. '##' .. index) then
												input_smartuk_text = imgui.new.char[256](u8(item.text))
												input_smartuk_lvl = imgui.new.char[256](u8(item.lvl))
												input_smartuk_reason = imgui.new.char[256](u8(item.reason))
												imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##") .. chapter.name .. index .. chapter_index)
											end
											if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##") .. chapter.name .. index .. chapter_index, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
												change_dpi()
												if imgui.BeginChild('##smartukedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
													imgui.CenterText(u8'�������� ���������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartuk_text', input_smartuk_text, 256)
													imgui.CenterText(u8'������� ������� ��� ������ (�� 1 �� 6):')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartuk_lvl', input_smartuk_lvl, 256)
													imgui.CenterText(u8'������� ��� ������ �������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartuk_reason', input_smartuk_reason, 256)
													imgui.EndChild()
												end	
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													if u8:decode(ffi.string(input_smartuk_lvl)) ~= '' and not u8:decode(ffi.string(input_smartuk_lvl)):find('%D') and tonumber(u8:decode(ffi.string(input_smartuk_lvl))) >= 1 and tonumber(u8:decode(ffi.string(input_smartuk_lvl))) <= 6 and u8:decode(ffi.string(input_smartuk_text)) ~= '' and u8:decode(ffi.string(input_smartuk_reason)) ~= '' then
														item.text = u8:decode(ffi.string(input_smartuk_text))
														item.lvl = u8:decode(ffi.string(input_smartuk_lvl))
														item.reason = u8:decode(ffi.string(input_smartuk_reason))
														save_smart_uk()
														imgui.CloseCurrentPopup()
													else
														sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
													end
												end
												imgui.EndPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index .. '##' .. index) then
												imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index .. '##' .. index)
											end
											if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##' .. chapter_index .. '##' .. index, _, imgui.WindowFlags.NoResize ) then
												change_dpi()
												imgui.CenterText(u8'�� ������������� ������ ������� ��������?')
												imgui.CenterText(u8(item.text))
												imgui.Separator()
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													table.remove(chapter.item, index)
													save_smart_uk()
													imgui.CloseCurrentPopup()
												end
												imgui.End()
											end
											imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
											imgui.Columns(1)
											imgui.Separator()
										end
									end
									imgui.EndChild()
								end
								if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ����� ��������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									input_smartuk_text = imgui.new.char[8192](u8(''))
									input_smartuk_lvl = imgui.new.char[256](u8(''))
									input_smartuk_reason = imgui.new.char[256](u8(''))
									imgui.OpenPopup(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������'))
								end
								if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������'), _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
									change_dpi()
									if imgui.BeginChild('##smartukedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
										imgui.CenterText(u8'�������� ���������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartuk_text', input_smartuk_text, 8192)
										imgui.CenterText(u8'������� ������� ��� ������ (�� 1 �� 6):')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartuk_lvl', input_smartuk_lvl, 256)
										imgui.CenterText(u8'������� ��� ������ �������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartuk_reason', input_smartuk_reason, 256)
										imgui.EndChild()
									end	
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										local text = u8:decode(ffi.string(input_smartuk_text))
										local lvl = u8:decode(ffi.string(input_smartuk_lvl))
										local reason = u8:decode(ffi.string(input_smartuk_reason))
										if lvl ~= '' and not tostring(lvl):find('%D') and tonumber(lvl) >= 1 and tonumber(lvl) <= 6 and text ~= '' and reason ~= '' then
											local temp = { text = text, lvl = lvl, reason = reason }
											table.insert(chapter.item, temp)
											save_smart_uk()
											imgui.CloseCurrentPopup()
										else
											sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
										end
									end
									imgui.EndPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup()
							end
							imgui.Separator()
						end
						imgui.EndChild()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������� �����', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							input_smartuk_name = imgui.new.char[8192](u8(''))
							imgui.OpenPopup(fa.CIRCLE_PLUS .. u8' ���������� ������ ������')
						end
						if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8' ���������� ������ ������', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
							change_dpi()
							imgui.CenterText(u8('������� ��������/����� ������ � ������� "���������"'))
							imgui.PushItemWidth(500 * settings.general.custom_dpi)
							imgui.InputText(u8'##input_smartuk_name', input_smartuk_name, 8192)
							imgui.CenterText(u8'�������� ��������, �� �� ������� �������� ��� � ����������!')
							if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.CIRCLE_PLUS .. u8' ��������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								local temp = u8:decode(ffi.string(input_smartuk_name))
								local new_chapter = { name = temp, item = {} }
								table.insert(smart_uk, new_chapter)
								save_smart_uk()
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.EndChild()
				end
				imgui.SameLine()
				if imgui.BeginChild('##smartpdd', imgui.ImVec2(196 * settings.general.custom_dpi, 340 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.TICKET .. u8' ������� ������ ������')
					imgui.Separator()
					imgui.SetCursorPosY(105 * settings.general.custom_dpi)
					imgui.SetCursorPosX(60 * settings.general.custom_dpi)
					if imgui.Button(fa.DOWNLOAD .. u8' ��������� ##smartpdd') then
						if getARZServerNumber() ~= 0 then
							download_smartpdd = true
							downloadFileFromUrlToPath('https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/SmartPDD/' .. getARZServerNumber() .. '/SmartPDD.json', path_pdd)
							imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartpdd')
						else
							imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##nocloudsmartpdd')
						end
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##nocloudsmartpdd', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
						change_dpi()
						imgui.CenterText(u8'� ���� ������ ��� ���� ����� ������� ��� ������ �������!')
						imgui.Separator()
						imgui.CenterText(u8'�� ������ ������� ��������� ��� �� ������ "���������������"')
						imgui.CenterText(u8'����� �� ������� ���������� �� �� ����� Discord � �� ����� �������� � ���� ������')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(550 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Justice Helper - ����������##donwloadsmartpdd', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
						change_dpi()
						if download_smartpdd then
							imgui.CenterText(u8'���� �� ������ ��� ���� ������ ��� ���������� ����� ������� ��� ' .. getARZServerNumber() .. u8' �������!')
							imgui.CenterText(u8'����� ����������� �������� ��� ���� ������� � �� ������� ��������� � ����!')
							imgui.Separator()
							imgui.CenterText(u8'���� �� ������ �� ����������, ������ ��������� ������ ���������� SmartPDD.json')
							imgui.CenterText(u8'�������� � ���� ������ ���� ����� ������ ��� ������ �������!')
							imgui.Separator()
							imgui.CenterText(u8'� ���� ������ �� ������ ������� ��������� ��� �� ������ "���������������"')
							imgui.CenterText(u8'����� �� ������� ���������� �� �� ����� Discord � �� ����� �������� � ���� ������')
							imgui.CenterText(u8'��� ���� ����� ������� ���� SmartPDD.json , ������� ���������� �� ����:')
							imgui.CenterText(u8(path_pdd))
							imgui.Separator()
						else
							imgui.CloseCurrentPopup()
						end
						if imgui.Button(fa.CIRCLE_INFO .. u8' ������', imgui.ImVec2(550 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosX(40 * settings.general.custom_dpi)
					imgui.SetCursorPosY(170 * settings.general.custom_dpi)
					if imgui.Button(fa.PEN_TO_SQUARE .. u8' ��������������� ##smartpdd') then
						imgui.OpenPopup(fa.TICKET .. u8' ������� ����� �������##smartpdd')
					end
					if imgui.BeginPopupModal(fa.TICKET .. u8' ������� ����� �������##smartpdd', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						change_dpi()
						imgui.BeginChild('##smartpddedit', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true)
						for chapter_index, chapter in ipairs(smart_pdd) do
							imgui.Columns(2)
							imgui.BulletText(u8(chapter.name))
							imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
							imgui.NextColumn()
							if imgui.Button(fa.PEN_TO_SQUARE .. '##smartpdd' .. chapter_index) then
								imgui.OpenPopup(u8(chapter.name).. '##smartpdd' .. chapter_index)
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. '##smartpdd' .. chapter_index) then
								imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index)
							end
							if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index, _, imgui.WindowFlags.NoResize ) then
								change_dpi()
								imgui.CenterText(u8'�� ������������� ������ ������� �����?')
								imgui.CenterText(u8(chapter.name))
								imgui.Separator()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									table.remove(smart_pdd, chapter_index)
									save_smart_pdd()
									imgui.CloseCurrentPopup()
								end
								imgui.End()
							end
							imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
							imgui.Columns(1)
							if imgui.BeginPopupModal(u8(chapter.name).. '##smartpdd' .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
								change_dpi()
								if imgui.BeginChild('##smartpddedititem', imgui.ImVec2(589 * settings.general.custom_dpi, 390 * settings.general.custom_dpi), true) then
									if chapter.item then
										for index, item in ipairs(chapter.item) do
											imgui.Columns(2)
											imgui.BulletText(u8(item.text))
											imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
											imgui.NextColumn()
											if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index .. '##smartpdd' .. index) then
												input_smartpdd_text = imgui.new.char[8192](u8(item.text))
												input_smartpdd_amount = imgui.new.char[256](u8(item.amount))
												input_smartpdd_reason = imgui.new.char[256](u8(item.reason))
												imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##smartpdd") .. chapter.name .. index .. chapter_index)
											end
											if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8(" �������������� ���������##smartpdd") .. chapter.name .. index .. chapter_index, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
												change_dpi()
												if imgui.BeginChild('##smartpddedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
													imgui.CenterText(u8'�������� ���������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartpdd_text', input_smartpdd_text, 8192)
													imgui.CenterText(u8'����� ������ (����� ��� ����� ���� ��������):')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartpdd_amount', input_smartpdd_amount, 256)
													imgui.CenterText(u8'������� ��� ������ ������:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_smartpdd_reason', input_smartpdd_reason, 256)
													imgui.EndChild()
												end	
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													if u8:decode(ffi.string(input_smartpdd_amount)) ~= ''and u8:decode(ffi.string(input_smartpdd_text)) ~= '' and u8:decode(ffi.string(input_smartpdd_reason)) ~= '' and u8:decode(ffi.string(input_smartpdd_amount)):find('%d') and not u8:decode(ffi.string(input_smartpdd_amount)):find('%D') then
														item.text = u8:decode(ffi.string(input_smartpdd_text))
														item.amount = u8:decode(ffi.string(input_smartpdd_amount))
														item.reason = u8:decode(ffi.string(input_smartpdd_reason))
														save_smart_pdd()
														imgui.CloseCurrentPopup()
													else
														sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
													end
												end
												imgui.EndPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index .. '###smartpdd' .. index) then
												imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index .. '##' .. index)
											end
											if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Justice_Helper - �������������� ##smartpdd' .. chapter_index .. '##' .. index, _, imgui.WindowFlags.NoResize ) then
												change_dpi()
												imgui.CenterText(u8'�� ������������� ������ ������� ��������?')
												imgui.CenterText(u8(item.text))
												imgui.Separator()
												if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													table.remove(chapter.item, index)
													save_smart_pdd()
													imgui.CloseCurrentPopup()
												end
												imgui.End()
											end
											imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
											imgui.Columns(1)
											imgui.Separator()
										end
									end
									imgui.EndChild()
								end
								if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ����� ��������##smartpdd', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									input_smartpdd_text = imgui.new.char[256](u8(''))
									input_smartpdd_amount = imgui.new.char[256](u8(''))
									input_smartpdd_reason = imgui.new.char[256](u8(''))
									imgui.OpenPopup(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������##smartpdd'))
								end
								if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8(' ���������� ������ ���������##smartpdd'), _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
									change_dpi()
									if imgui.BeginChild('##smartpddedititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
										imgui.CenterText(u8'�������� ���������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartpdd_text', input_smartpdd_text, 256)
										imgui.CenterText(u8'����� ������ (����� ��� ����� ���� ��������):')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartpdd_amount', input_smartpdd_amount, 256)
										imgui.CenterText(u8'������� ��� ������ ������:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_smartpdd_reason', input_smartpdd_reason, 256)
										imgui.EndChild()
									end	
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										local text = u8:decode(ffi.string(input_smartpdd_text))
										local amount = u8:decode(ffi.string(input_smartpdd_amount))
										local reason = u8:decode(ffi.string(input_smartpdd_reason))
										if amount ~= ''and text ~= '' and reason ~= '' and tostring(amount):find('%d') and not tostring(amount):find('%D') then
											local temp = { text = text, amount = amount, reason = reason }
											table.insert(chapter.item, temp)
											save_smart_pdd()
											imgui.CloseCurrentPopup()
										else
											sampAddChatMessage('[Justice Helper] {ffffff}������ � ��������� ������, ���������!', message_color)
										end
									end
									imgui.EndPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup()
							end
							imgui.Separator()
						end
						imgui.EndChild()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������� �����', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							input_smartpdd_name = imgui.new.char[256](u8(''))
							imgui.OpenPopup(fa.CIRCLE_PLUS .. u8' ���������� ������ ������##smartpdd')
						end
						if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8' ���������� ������ ������##smartpdd', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize) then
							change_dpi()
							imgui.CenterText(u8('������� ��������/����� ������ � ������� "���������"'))
							imgui.PushItemWidth(500 * settings.general.custom_dpi)
							imgui.InputText(u8'##input_smartpdd_name', input_smartpdd_name, 256)
							imgui.CenterText(u8'�������� ��������, �� �� ������� �������� ��� � ����������!')
							if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.CIRCLE_PLUS .. u8' ��������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								local temp = u8:decode(ffi.string(input_smartpdd_name))
								local new_chapter = { name = temp, item = {} }
								table.insert(smart_pdd, new_chapter)
								save_smart_pdd()
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosY(250 * settings.general.custom_dpi)
					imgui.CenterText(u8('�������������:'))
					imgui.CenterText(u8('/tsm [ID ������]'))
					imgui.EndChild()
				end
				imgui.SameLine()
				if imgui.BeginChild('##arzveh', imgui.ImVec2(190 * settings.general.custom_dpi, 340 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.CAR .. u8' ARZ Car Models')
					imgui.Separator()
					imgui.SetCursorPosY(105 * settings.general.custom_dpi)
					imgui.SetCursorPosX(60 * settings.general.custom_dpi)
					if imgui.Button(fa.DOWNLOAD .. u8' ��������� ##arzveh') then
						download_arzvehicles = true
						downloadFileFromUrlToPath('https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/VehiclesArizona/VehiclesArizona.json', path_arzvehicles)
					end
					imgui.SetCursorPosY(170 * settings.general.custom_dpi)
					imgui.CenterText(u8('����� �������: ') .. #arzvehicles)
					imgui.SetCursorPosY(250 * settings.general.custom_dpi)
					imgui.CenterText(u8('������������� ����� ����� ���'))
					imgui.EndChild()
				end
				imgui.CenterText(u8'����������� �� ��������� �������� ������ ����������� � Discord/Telegram/BH')
			imgui.EndTabItem()
			end