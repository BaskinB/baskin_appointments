--[[ Credits to Fistofury for the general menu code formatting ]]

CreateThread(function()
	local PromptGroup = BccUtils.Prompts:SetupPromptGroup() -- Setup Prompt Group
	local firstPrompt = PromptGroup:RegisterPrompt("Schedule Appointment", 0x760A9C6F, 1, 1, true, 'hold', { timedeventhash = "MEDIUM_TIMED_EVENT" }) -- Register your first prompt
    while true do
        Wait(1)
        local inMenu = false -- Define and initialize inMenu here
        local playerPed = PlayerPedId() -- Use local variable for PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = true
        for _, business in pairs(Config.Businesses) do
            local dist = #(playerCoords - business.location)
            if dist < 1.5 then
                sleep = false
                PromptGroup:ShowGroup(business.name)
                if firstPrompt:HasCompleted() then
                    inMenu = true
                    --TaskStandStill(playerPed, -1) -- Assuming OpenMenu() requires the key as an argument
                end
            end
        end

        if inMenu then
			OpenMainMenu()
			if sleep then
                Wait(500)
            end
        end
    end
end)

local MainMenu, MainPage, ViewPage, SchedulePage, AppointmentPage, CheckAppointmentPage

function OpenMainMenu()
	MainPage 			 = nil
	ViewPage 			 = nil
	SchedulePagePage 	 = nil
	CheckAppointmentPage = nil
	AppointmentPage 	 = nil

	for _, business in pairs(Config.Businesses) do
		local playerPed = PlayerPedId() -- Use local variable for PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
		local dist = #(playerCoords - business.location)
		if not MainMenu then
			MainMenu = FeatherMenu:RegisterMenu('tgrp_appointment:MainMenu', {
				top = '10%',
				left = '2%',
				['720width'] = '600px',
				['1080width'] = '700px',
				['2kwidth'] = '800px',
				['4kwidth'] = '1000px',
				style = {
					['background-size'] = 'cover',  
					['background-repeat'] = 'no-repeat',
					['background-position'] = 'center',
					['padding'] = '10px 20px',
					['margin-top'] = '5px',
				},
				contentslot = {
					style = {
						['max-height'] = '550px',  -- Fixed maximum height
					} -- Fixed maximum height
				},
				draggable = false,
				canclose = true
			})
		end
		
		if dist < 1.5 then
			if not MainPage then
				MainPage = MainMenu:RegisterPage('mainmenu:first:page')
				MainPage:RegisterElement("header", {
					value = business.name,
					slot = "header",
					style = {}
				})
				MainPage:RegisterElement('subheader', {
					value = _U("optiontext"),
					slot = "header",
					style = {}
				})
				MainPage:RegisterElement('line', {
					slot = "header",
					style = {}
				})
				MainPage:RegisterElement('button', {
					label = _U("schedulebutton"),
					style = {
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					},
					sound = {
						action = "SELECT",
						soundset = "RDRO_Character_Creator_Sounds"
					},
				}, function()
					SchedulePage:RouteTo()
				end)
				MainPage:RegisterElement('bottomline', {
					slot = "footer",
					style = {
					}
				})
				MainPage:RegisterElement('button', {
					label = _U("closebutton"),
					slot = "footer",
					style = {
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					},
					sound = {
						action = "SELECT",
						soundset = "RDRO_Character_Creator_Sounds"
					},
				}, function()
					MainMenu:Close({
						-- sound = {
						--     action = "SELECT",
						--     soundset = "RDRO_Character_Creator_Sounds"
						-- }
					})
				end)
			end
		
			if not SchedulePage then
				SchedulePage = MainMenu:RegisterPage('mainmenu:appointment:page')
			
				SchedulePage:RegisterElement('header', {
					value = business.name,
					slot = "header",
					style = {}
				})
			
				SchedulePage:RegisterElement('subheader', {
					value = _U('scheduletext'),
					slot = "header",
					style = {}
				})
				SchedulePage:RegisterElement('line', {
					slot = "header",
					style = {}
				})
				local charname = ''
				SchedulePage:RegisterElement('input', {
					label = _U('namelabel'),
					placeholder = _U('nameplace'),
					persist = false,
					style = {
						['border-color'] = "#513e23"
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					}
				}, function(data)
					-- This gets triggered whenever the input value change
					charname = data.value
				end)
				local telegram = ''
				SchedulePage:RegisterElement('input', {
					label = _U('telelabel'),
					placeholder = _U('teleplace'),
					persist = false,
					style = {
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					}
				}, function(data)
					-- This gets triggered whenever the input value changes
					telegram = data.value
				end)
				SchedulePage:RegisterElement('subheader', {
					value = _U('reasonlabel'),
					slot = "content",
					style = {}
				})
				local reason = ''
				SchedulePage:RegisterElement('textarea', {
					--label = _U('reasonlabel'),
					placeholder = _U('reasonplace'),
					rows = "4",
					--cols = "33",
					resize = false,
					persist = false,
					style = {
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					}
				}, function(data)
					-- This gets triggered whenever the input value changes
					reason = data.value
				end)
				SchedulePage:RegisterElement('line', {
					slot = "footer",
					-- style = {}
				})
				SchedulePage:RegisterElement('button', {
					label = _U('submitbutton'),
					slot = "footer",
					style = {
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					},
					sound = {
						 action = "SELECT",
						 soundset = "RDRO_Character_Creator_Sounds"
					},
				}, function()
						--local desc = "**Business Name:** \n "..name.."\n\n **Name:** \n"..charname.."\n\n **Telegram Number:** \n"..telegram.."\n\n **Reason:** \n"..reason
						--VORPcore.AddWebhook("Business Appointment",webhook,desc)
						local appointmentData = { job = business.job, charname = charname, reason = reason, telegram = telegram, created_at = timestamp}
						TriggerServerEvent("tgrp_appointments:InsertCreatedAppointmentIntoDB", appointmentData)
						VORPcore.NotifyObjective(_U("schedulenotify")..business.name,5000)
						MainPage:RouteTo()

						--MainPage:RouteTo()
				end)
				SchedulePage:RegisterElement('button', {
					label = _U("backbutton"),
					slot = "footer",
					style = {
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					},
					sound = {
						action = "SELECT",
						soundset = "RDRO_Character_Creator_Sounds"
					},
				}, function()
					MainPage:RouteTo()
				end)
				SchedulePage:RegisterElement('bottomline', {
					slot = "footer",
					-- style = {}
				})
			end
		
			if not ViewPage then
				ViewPage = MainMenu:RegisterPage('mainmenu:view:page')
				if LocalPlayer.state.Character.Job == business.job and dist < 1.5 then
					MainPage:RegisterElement('button', {
						label = "View Appointments",
						style = {
						},
						sound = {
							action = "SELECT",
							soundset = "RDRO_Character_Creator_Sounds"
						},
					}, function()
						TriggerServerEvent('tgrp_appointments:GetAllAppointments', job)
					end)
				end
			end
	
			if not CheckAppointmentPage then
				CheckAppointmentPage = MainMenu:RegisterPage('mainmenu:checkappoint:page')
				CheckAppointmentPage:RegisterElement('header', {
					value = business.name,
					slot = "header",
					style = {}
				})
				CheckAppointmentPage:RegisterElement('subheader', {
					value = _U('picktext'),
					slot = "header",
					style = {}
				})
				CheckAppointmentPage:RegisterElement('bottomline', {
					slot = "footer",
					-- style = {}
				})
				CheckAppointmentPage:RegisterElement('button', {
					label = _U('backbutton'),
					slot = "footer",
					style = {
						-- ['background-image'] = 'none',
						-- ['background-color'] = '#E8E8E8',
						-- ['color'] = 'black',
						-- ['border-radius'] = '6px'
					},
					sound = {
						action = "SELECT",
						soundset = "RDRO_Character_Creator_Sounds"
					},
				}, function()
					MainPage:RouteTo()
				end)
			end
			MainMenu:Open({
				startupPage = MainPage,
				sound = {
					action = "SELECT",
					soundset = "RDRO_Character_Creator_Sounds"
				}
			})
		end
	end
end
	
RegisterNetEvent('tgrp_appointments:DisplayAllAppointments', function (appointments)
	CheckAppointmentPage = nil
	OpenMainMenu(true)
	for _, appointment in ipairs(appointments) do
		local label = appointment.charname.." | "..appointment.created_at
		CheckAppointmentPage:RegisterElement('button', {
			label = label,
			style = {},
			sound = {
				action = "SELECT",
				soundset = "RDRO_Character_Creator_Sounds"
			},
		}, function()
			CheckAppointment(appointment)
		end)

		CheckAppointmentPage:RouteTo()
	end
end)
	
	
function CheckAppointment(appointment)
	AppointmentPage = MainMenu:RegisterPage('viewmenu:appointment:page')
	AppointmentPage:RegisterElement('header', {
		value = appointment.charname,
		slot = "header",
		style = {}
	})
	AppointmentPage:RegisterElement('subheader', {
		value = appointment.created_at,
		slot = "header",
		style = {}
	})
	AppointmentPage:RegisterElement('bottomline', {
		slot = "header",
		style = {}
	})
	AppointmentPage:RegisterElement('subheader', {
		value = _U('telegramtext'),
		slot = "content",
		style = {}
	})
	TextDisplay = AppointmentPage:RegisterElement('textdisplay', {
		value = appointment.telegram,
		style = {}
	})
	AppointmentPage:RegisterElement('subheader', {
		value = _U("reasontext"),
		slot = "content",
		style = {}
	})
	TextDisplay = AppointmentPage:RegisterElement('textdisplay', {
		value = appointment.reason,
		style = {
			['padding'] = '10px 20px',
			['max-height'] = '200px',  -- Fixed maximum height
			['overflow-y'] = 'auto',   -- Allows vertical scrolling
			['overflow-x'] = 'hidden', -- Prevents horizontal scrolling
		}
	})
	AppointmentPage:RegisterElement('line', {
		slot = "content",
		style = {}
	})
	AppointmentPage:RegisterElement('button', {
		label = _U('backbutton'),
		slot = "footer",
		style = {
			-- ['background-image'] = 'none',
			-- ['background-color'] = '#E8E8E8',
			-- ['color'] = 'black',
			-- ['border-radius'] = '6px'
		},
		sound = {
			action = "SELECT",
			soundset = "RDRO_Character_Creator_Sounds"
		},
	}, function()
		CheckAppointmentPage:RouteTo()
	end)
	AppointmentPage:RegisterElement('button', {
		label = _U('deletebutton'),
		slot = "footer",
		style = {
			['color'] = '#ff454b',
		},
		-- sound = {
		--     action = "SELECT",
		--     soundset = "RDRO_Character_Creator_Sounds"
		-- },
	}, function()
		TriggerServerEvent('baskin_appointments:DeleteAppointment', appointment.id)
		VORPcore.NotifyObjective(_U('deletenotify'),5000)
		MainPage:RouteTo()
		-- This gets triggered whenever the button is clicked
	end)
	AppointmentPage:RouteTo()
end

--[[
    --Sacred Comment
    8========D
]]