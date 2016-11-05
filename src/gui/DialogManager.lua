require "src/base/Inheritance"
require "src/base/Log"

DialogManager = inheritsFrom(nil)
DialogManager.mModalDlg = nil;
DialogManager.mNeedDelay = nil;

--------------------------------------
function DialogManager:init()
	self.mNeedDelay = {};
end

--------------------------------------
function DialogManager:isModal(dlg)
	return self.mModalDlg == dlg;
end

--------------------------------------
function DialogManager:activateModal(dlg)
	info_log("DialogManager:activateModal")
	self.mModalDlg = dlg;
end

---------------------------------
function DialogManager:delayRemove(dlg)
	table.insert(self.mNeedDelay, dlg);
end

---------------------------------
function DialogManager:tick(dt)
	for i, dlg in ipairs(self.mNeedDelay) do
		dlg:destroy();
	end
	self.mNeedDelay = {};
end

--------------------------------------
function DialogManager:deactivateModal(dlg)
	info_log("DialogManager:deactivateModal");
	self.mModalDlg = nil;
end

--------------------------------------
function DialogManager:hasModalDlg()
	return self.mModalDlg ~= nil;
end