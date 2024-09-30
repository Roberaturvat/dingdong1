-- Settings
local SNAKE_LENGTH = 10
local SNAKE_SIZE = 1
local SNAKE_WOBBLINESS = 50

-- Script
local Character = game:GetService("Players").LocalPlayer.Character
local Root = Character:WaitForChild("HumanoidRootPart")

local TailAttachment = Instance.new("Attachment")
TailAttachment.Name = "TailAttachment"
TailAttachment.Position = Vector3.new(0, -1, -0.5)
TailAttachment.Orientation = Vector3.new(0, 90, 0)
TailAttachment.Parent = Root

local TailHolder = Instance.new("Folder")
TailHolder.Name = "TailHolder"
TailHolder.Parent = workspace

local function MakeSnake(Length, Size, Wobbliness)
    TailHolder:ClearAllChildren()

    local LastSection
    local Sections = {}

    local TailRoot = Instance.new("Part")
    TailRoot.Transparency = 1
    TailRoot.CanCollide = false
    TailRoot.CanQuery = false
    TailRoot.CanTouch = false
    TailRoot.Massless = true
    TailRoot.Name = "TailRoot"
    TailRoot.Parent = TailHolder

    local NewTailAttachment = Instance.new("Attachment")
    NewTailAttachment.Parent = TailRoot

    local AlignTail = Instance.new("AlignPosition")
    AlignTail.RigidityEnabled = true
    AlignTail.Attachment0 = NewTailAttachment
    AlignTail.Attachment1 = TailAttachment
    AlignTail.Parent = TailRoot

    local AlignTailRotation = Instance.new("AlignOrientation")
    AlignTailRotation.RigidityEnabled = true
    AlignTailRotation.Attachment0 = NewTailAttachment
    AlignTailRotation.Attachment1 = TailAttachment
    AlignTailRotation.Parent = TailRoot

    for i = 1, Length do
        local TailSection = Instance.new("Part")
        TailSection.Shape = Enum.PartType.Cylinder
        TailSection.CanCollide = false
        TailSection.Massless = true
        TailSection.Material = Enum.Material.SmoothPlastic
        TailSection.Position = Root.Position
        TailSection.Size = Vector3.new(Size, Size * 2, Size)
        
        local BackAttachment = Instance.new("Attachment")
        BackAttachment.Position = Vector3.new(-Size / 2, 0, 0)
        BackAttachment.Parent = TailSection

        local FrontAttachment = Instance.new("Attachment")
        FrontAttachment.Position = Vector3.new(Size / 2, 0, 0)
        FrontAttachment.Name = "FrontAttachment"
        FrontAttachment.Parent = TailSection

        local BallConstraint = Instance.new("BallSocketConstraint")
        BallConstraint.Attachment0 = LastSection and LastSection:FindFirstChild("FrontAttachment") or NewTailAttachment
        BallConstraint.Attachment1 = BackAttachment
        BallConstraint.Parent = TailSection

        local AlignOrientation = Instance.new("AlignOrientation")
        AlignOrientation.Responsiveness = Wobbliness or 10
        AlignOrientation.Attachment0 = BackAttachment
        AlignOrientation.Attachment1 = LastSection and LastSection:FindFirstChild("FrontAttachment") or NewTailAttachment
        AlignOrientation.Parent = TailSection

        local AlignPosition = Instance.new("AlignPosition")
        AlignPosition.Responsiveness = 10
        AlignPosition.Attachment0 = BackAttachment
        AlignPosition.Attachment1 = LastSection and LastSection:FindFirstChild("FrontAttachment") or TailAttachment
        AlignPosition.Parent = TailSection

        TailSection.Parent = TailHolder
        LastSection = TailSection

        table.insert(Sections, TailSection)
    end

    -- Prevent sections from colliding with each other
    for _, Section in pairs(Sections) do
        for _, OtherSection in pairs(Sections) do
            if Section == OtherSection then continue end

            local NoCollision = Instance.new("NoCollisionConstraint")
            NoCollision.Part0 = Section
            NoCollision.Part1 = OtherSection
            NoCollision.Parent = Section
        end
    end
end

MakeSnake(SNAKE_LENGTH, SNAKE_SIZE, SNAKE_WOBBLINESS)
