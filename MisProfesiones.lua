local idiomaActual = 1
local filas = {}

local Locales = {
    [1] = {
        titulo = "Mis Profesiones",
        confirmarTexto = "¿Estás seguro de que quieres olvidar la profesión de %s? Perderás todas las recetas aprendidas.",
        btnSi = "Sí, Olvidar",
        btnNo = "Cancelar",
        tooltipTitulo = "Mis Profesiones",
        tooltipClickIzquierdo = "Clic Izquierdo: Abrir ventana / Arrastrar libro",
    },
    [2] = {
        titulo = "My Professions",
        confirmarTexto = "Are you sure you want to unlearn %s? You will lose all your learned recipes.",
        btnSi = "Yes, Unlearn",
        btnNo = "Cancel",
        tooltipTitulo = "My Professions",
        tooltipClickIzquierdo = "Left Click: Open window / Drag book",
    }
}

local BASE_PROFESIONES = {
    ["alquimia"] = { spell = "Alquimia", icon = "Interface\\Icons\\Trade_Alchemy" },
    ["herrería"] = { spell = "Herrería", icon = "Interface\\Icons\\Trade_BlackSmithing" },
    ["encantamiento"] = { spell = "Encantamiento", icon = "Interface\\Icons\\Trade_Engraving" },
    ["ingeniería"] = { spell = "Ingeniería", icon = "Interface\\Icons\\Trade_Engineering" },
    ["inscripción"] = { spell = "Inscripción", icon = "Interface\\Icons\\INV_Scroll_08" },
    ["joyería"] = { spell = "Joyería", icon = "Interface\\Icons\\INV_Misc_Gem_01" },
    ["peletería"] = { spell = "Peletería", icon = "Interface\\Icons\\Trade_LeatherWorking" },
    ["sastrería"] = { spell = "Sastrería", icon = "Interface\\Icons\\Trade_Tailoring" },
    ["cocina"] = { spell = "Cocina", icon = "Interface\\Icons\\INV_Misc_Food_15" },
    ["primeros auxilios"] = { spell = "Primeros auxilios", icon = "Interface\\Icons\\Spell_Holy_SealOfSacrifice" },
    ["minería"] = { spell = "Fundición", icon = "Interface\\Icons\\Trade_Mining" },
    ["fundición"] = { spell = "Fundición", icon = "Interface\\Icons\\Trade_Mining" },
    ["herboristería"] = { spell = "Herboristería", icon = "Interface\\Icons\\Spell_Nature_NatureTouchToHeal" },
    ["desuello"] = { spell = "Desuello", icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01" },
    ["pesca"] = { spell = "Pesca", icon = "Interface\\Icons\\Trade_Fishing" },

    ["alchemy"] = { spell = "Alchemy", icon = "Interface\\Icons\\Trade_Alchemy" },
    ["blacksmithing"] = { spell = "Blacksmithing", icon = "Interface\\Icons\\Trade_BlackSmithing" },
    ["enchanting"] = { spell = "Enchanting", icon = "Interface\\Icons\\Trade_Engraving" },
    ["engineering"] = { spell = "Engineering", icon = "Interface\\Icons\\Trade_Engineering" },
    ["inscription"] = { spell = "Inscription", icon = "Interface\\Icons\\INV_Scroll_08" },
    ["jewelcrafting"] = { spell = "Jewelcrafting", icon = "Interface\\Icons\\INV_Misc_Gem_01" },
    ["leatherworking"] = { spell = "Leatherworking", icon = "Interface\\Icons\\Trade_LeatherWorking" },
    ["tailoring"] = { spell = "Tailoring", icon = "Interface\\Icons\\Trade_Tailoring" },
    ["cooking"] = { spell = "Cooking", icon = "Interface\\Icons\\INV_Misc_Food_15" },
    ["first aid"] = { spell = "First Aid", icon = "Interface\\Icons\\Spell_Holy_SealOfSacrifice" },
    ["mining"] = { spell = "Smelting", icon = "Interface\\Icons\\Trade_Mining" },
    ["smelting"] = { spell = "Smelting", icon = "Interface\\Icons\\Trade_Mining" },
    ["herbalism"] = { spell = "Herbalism", icon = "Interface\\Icons\\Spell_Nature_NatureTouchToHeal" },
    ["skinning"] = { spell = "Skinning", icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01" },
    ["fishing"] = { spell = "Fishing", icon = "Interface\\Icons\\Trade_Fishing" },
}

function MisProfesiones_Inicializar()
    local locale = GetLocale()
    if locale == "enUS" or locale == "enGB" then idiomaActual = 2 else idiomaActual = 1 end
    UIDropDownMenu_SetSelectedID(MisProfesionesLanguageDropDown, idiomaActual)
end

function MisProfesiones_Toggle()
    if MisProfesionesFrame:IsShown() then MisProfesionesFrame:Hide() else MisProfesionesFrame:Show() end
end

function MisProfesiones_Actualizar()
    if not MisProfesionesFrame:IsShown() then return end

    local lang = Locales[idiomaActual]
    MisProfesionesTitle:SetText(lang.titulo)

    for _, fila in ipairs(filas) do
        fila:Hide()
    end

    local filaIndex = 1
    local profesionesDetectadas = {}

    for i = 1, 500 do
        local spellName, _ = GetSpellName(i, BOOKTYPE_SPELL)
        if spellName then
            local nombreClave = string.lower(spellName)
            local profData = BASE_PROFESIONES[nombreClave]

            if profData and not profesionesDetectadas[profData.spell] then
                profesionesDetectadas[profData.spell] = true

                if not filas[filaIndex] then
                    filas[filaIndex] = CreateFrame("Frame", "MisProfesionesFila"..filaIndex, MisProfesionesScrollChild, "FrameProfresionTemplate")
                    if filaIndex == 1 then
                        filas[filaIndex]:SetPoint("TOPLEFT", MisProfesionesScrollChild, "TOPLEFT", 5, -5)
                    else
                        filas[filaIndex]:SetPoint("TOPLEFT", filas[filaIndex-1], "BOTTOMLEFT", 0, -4)
                    end
                end

                local fila = filas[filaIndex]
                fila.skillName = profData.spell

                _G[fila:GetName().."NameFrameText"]:SetText(profData.spell)
                _G[fila:GetName().."IconTexture"]:SetTexture(profData.icon)

                local iconBtn = _G[fila:GetName().."Icon"]
                iconBtn:SetAttribute("type", "spell")
                iconBtn:SetAttribute("spell", profData.spell)

                fila:Show()
                filaIndex = filaIndex + 1
            end
        end
    end
    
    local alturaTotal = (filaIndex - 1) * 44
    MisProfesionesScrollChild:SetHeight(alturaTotal > 0 and alturaTotal or 10)
end

function MisProfesiones_InterficieOlvidar(nombreProfesion)
    if not nombreProfesion then return end
    
    local skillIndexReal = nil
    local nombreBuscar = string.lower(nombreProfesion)
    
    for i = 1, GetNumSkillLines() do
        local skillName, isHeader = GetSkillLineInfo(i)
        if not isHeader and skillName and string.lower(skillName) == nombreBuscar then
            skillIndexReal = i
            break
        end
    end

    local lang = Locales[idiomaActual]
    StaticPopupDialogs["CONFIRM_UNLEARN_PROFESSION_CUSTOM"] = {
        text = string.format(lang.confirmarTexto, nombreProfesion),
        button1 = lang.btnSi,
        button2 = lang.btnNo,
        OnAccept = function() 
            if skillIndexReal then
                AbandonSkill(skillIndexReal)
            else
                UIErrorsFrame:AddMessage("El cliente de WoW bloquea el olvido automático de esta profesión. Por favor, olvídala desde tu pestaña (K).", 1.0, 0.1, 0.1, 1.0, 1)
            end
        end,
        timeout = 0, whileDead = true, hideOnEscape = true,
    }
    StaticPopup_Show("CONFIRM_UNLEARN_PROFESSION_CUSTOM")
end

function MisProfesiones_MostrarTooltip()
    local lang = Locales[idiomaActual]
    GameTooltip:SetOwner(MisProfesionesBotonLibro, "ANCHOR_LEFT")
    GameTooltip:AddLine(lang.tooltipTitulo, 1, 1, 1)
    GameTooltip:AddLine(lang.tooltipClickIzquierdo, 0.2, 1, 0.2)
    GameTooltip:Show()
end

function MisProfesiones_MenuIdioma_Initialize()
    local info = UIDropDownMenu_CreateInfo()
    info.text = "Español"   info.value = 1 info.func = MisProfesiones_CambiarIdioma info.checked = (idiomaActual == 1)
    UIDropDownMenu_AddButton(info)
    info.text = "English"   info.value = 2 info.func = MisProfesiones_CambiarIdioma info.checked = (idiomaActual == 2)
    UIDropDownMenu_AddButton(info)
end

function MisProfesiones_CambiarIdioma(self)
    idiomaActual = self.value
    UIDropDownMenu_SetSelectedID(MisProfesionesLanguageDropDown, idiomaActual)
    MisProfesiones_Actualizar()
end

SLASH_MISPROFESIONES1 = "/profesiones"
SLASH_MISPROFESIONES2 = "/profs"
SlashCmdList["MISPROFESIONES"] = function() MisProfesiones_Toggle() end