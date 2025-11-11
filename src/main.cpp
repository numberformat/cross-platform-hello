#include <wx/wx.h>

class HelloFrame : public wxFrame {
public:
    HelloFrame()
        : wxFrame(nullptr, wxID_ANY, "Cross-Platform Hello", wxDefaultPosition, wxSize(480, 240)) {
        auto* panel = new wxPanel(this);
        auto* sizer = new wxBoxSizer(wxVERTICAL);
        auto* text = new wxStaticText(panel, wxID_ANY, "Hello from wxWidgets!", wxDefaultPosition, wxDefaultSize, wxALIGN_CENTER);
        text->SetFont(wxFontInfo(18).Bold());
        sizer->AddStretchSpacer();
        sizer->Add(text, 0, wxALIGN_CENTER | wxALL, 10);
        sizer->AddStretchSpacer();
        panel->SetSizer(sizer);
    }
};

class HelloApp : public wxApp {
public:
    bool OnInit() override {
        auto* frame = new HelloFrame();
        frame->Show(true);
        return true;
    }
};

wxIMPLEMENT_APP(HelloApp);
