--[[ Credits to Fistofury for the general menu code formatting ]]

CreateThread(function()
	local PromptGroup = BccUtils.Prompts:SetupPromptGroup() -- Setup Prompt Group
	local firstPrompt = PromptGroup:RegisterPrompt(_U("scheduleprompt"), 0x760A9C6F, 1, 1, true, 'hold', { timedeventhash = "MEDIUM_TIMED_EVENT" }) -- Register your first prompt
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

local mainMenu, mainPage, viewPage, schedulePage, appointmentPage, checkappointmentPage

function OpenMainMenu()
	mainPage 			 = nil
	viewPage 			 = nil
	schedulePage 	     = nil
	checkappointmentPage = nil
	appointmentPage 	 = nil

	for _, business in pairs(Config.Businesses) do
		local playerPed = PlayerPedId() -- Use local variable for PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
		local dist = #(playerCoords - business.location)
		if not mainMenu then
			mainMenu = FeatherMenu:RegisterMenu('tgrp_appointment:mainMenu', {
				top = '10%',
				left = '2%',
				['720width'] = '600px',
				['1080width'] = '700px',
				['2kwidth'] = '800px',
				['4kwidth'] = '1000px',
				style = {
					--[[ ['background-size'] = 'cover',  
					['background-repeat'] = 'no-repeat',
					['background-position'] = 'center',
					['padding'] = '10px 20px',
					['margin-top'] = '5px', ]]
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
			if not mainPage then
				mainPage = mainMenu:RegisterPage('mainmenu:first:page')
				mainPage:RegisterElement("header", {
					value = business.name,
					slot = "header",
					style = {}
				})
				mainPage:RegisterElement('subheader', {
					value = _U("optiontext"),
					slot = "header",
					style = {}
				})
				mainPage:RegisterElement('line', {
					slot = "header",
					style = {}
				})
				mainPage:RegisterElement('button', {
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
					schedulePage:RouteTo()
				end)
				mainPage:RegisterElement('bottomline', {
					slot = "footer",
					style = {
					}
				})
				mainPage:RegisterElement('button', {
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
					mainMenu:Close({
						-- sound = {
						--     action = "SELECT",
						--     soundset = "RDRO_Character_Creator_Sounds"
						-- }
					})
				end)
			end
		
			if not schedulePage then
				schedulePage = mainMenu:RegisterPage('mainmenu:appointment:page')
			
				schedulePage:RegisterElement('header', {
					value = business.name,
					slot = "header",
					style = {}
				})
			
				schedulePage:RegisterElement('subheader', {
					value = _U('scheduletext'),
					slot = "header",
					style = {}
				})
				schedulePage:RegisterElement('line', {
					slot = "header",
					style = {}
				})
				local charname = ''
				schedulePage:RegisterElement('input', {
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
				schedulePage:RegisterElement('input', {
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
				schedulePage:RegisterElement('subheader', {
					value = _U('reasonlabel'),
					slot = "content",
					style = {}
				})
				local reason = ''
				schedulePage:RegisterElement('textarea', {
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
				schedulePage:RegisterElement('line', {
					slot = "footer",
					-- style = {}
				})
				schedulePage:RegisterElement('button', {
					label = _U('submitbutton'),
					slot = "footer",
					style = {},
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
						mainPage:RouteTo()
				end)
				schedulePage:RegisterElement('button', {
					label = _U("backbutton"),
					slot = "footer",
					style = {},
					sound = {
						action = "SELECT",
						soundset = "RDRO_Character_Creator_Sounds"
					},
				}, function()
					mainPage:RouteTo()
				end)
				schedulePage:RegisterElement('bottomline', {
					slot = "footer",
					-- style = {}
				})
			end
		
			if not viewPage then
				viewPage = mainMenu:RegisterPage('mainmenu:view:page')
				if LocalPlayer.state.Character.Job == business.job and dist < 1.5 then
					mainPage:RegisterElement('button', {
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
	
			if not checkappointmentPage then
				checkappointmentPage = mainMenu:RegisterPage('mainmenu:checkappoint:page')
				checkappointmentPage:RegisterElement('header', {
					value = business.name,
					slot = "header",
					style = {}
				})
				checkappointmentPage:RegisterElement('subheader', {
					value = _U('picktext'),
					slot = "header",
					style = {}
				})
				checkappointmentPage:RegisterElement('bottomline', {
					slot = "footer",
					-- style = {}
				})
				checkappointmentPage:RegisterElement('button', {
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
					mainPage:RouteTo()
				end)
			end
			mainMenu:Open({
				startupPage = mainPage,
				sound = {
					action = "SELECT",
					soundset = "RDRO_Character_Creator_Sounds"
				}
			})
		end
	end
end
	
RegisterNetEvent('tgrp_appointments:DisplayAllAppointments', function (appointments)
	checkappointmentPage = nil
	OpenMainMenu(true)
	for _, appointment in ipairs(appointments) do
		local label = appointment.charname.." | "..appointment.created_at
		checkappointmentPage:RegisterElement('button', {
			label = label,
			style = {},
			sound = {
				action = "SELECT",
				soundset = "RDRO_Character_Creator_Sounds"
			},
		}, function()
			CheckAppointment(appointment)
		end)

		checkappointmentPage:RouteTo()
	end
end)
	
	
function CheckAppointment(appointment)
	appointmentPage = mainMenu:RegisterPage('viewmenu:appointment:page')
	appointmentPage:RegisterElement('header', {
		value = appointment.charname,
		slot = "header",
		style = {}
	})
	appointmentPage:RegisterElement('subheader', {
		value = appointment.created_at,
		slot = "header",
		style = {}
	})
	appointmentPage:RegisterElement('bottomline', {
		slot = "header",
		style = {}
	})
	appointmentPage:RegisterElement('subheader', {
		value = _U('telegramtext'),
		slot = "content",
		style = {}
	})
	TextDisplay = appointmentPage:RegisterElement('textdisplay', {
		value = appointment.telegram,
		style = {}
	})
	appointmentPage:RegisterElement('subheader', {
		value = _U("reasontext"),
		slot = "content",
		style = {}
	})
	TextDisplay = appointmentPage:RegisterElement('textdisplay', {
		value = appointment.reason,
		style = {
			['padding'] = '10px 20px',
			['max-height'] = '200px',  -- Fixed maximum height
			['overflow-y'] = 'auto',   -- Allows vertical scrolling
			['overflow-x'] = 'hidden', -- Prevents horizontal scrolling
		}
	})
	appointmentPage:RegisterElement('line', {
		slot = "content",
		style = {}
	})
	appointmentPage:RegisterElement('button', {
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
		checkappointmentPage:RouteTo()
	end)
	appointmentPage:RegisterElement('button', {
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
		mainPage:RouteTo()
		-- This gets triggered whenever the button is clicked
	end)
	appointmentPage:RouteTo()
end

--[[
    --Sacred Comment
    8========D
]]