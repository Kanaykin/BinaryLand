require "src/base/Inheritance"
require "src/base/Log"

DialogManager = inheritsFrom(nil)
DialogManager.mModalDlg = nil;

--------------------------------------
function DialogManager:isModal(dlg)
	return self.mModalDlg == dlg;
end

--------------------------------------
function DialogManager:activateModal(dlg)
	info_log("DialogManager:activateModal")
	self.mModalDlg = dlg;
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