<%@ page pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="theme-color" content="#0284c7">
<c:set var="bodyStyle" value="margin:0;height:100dvh;min-height:0;overflow:hidden;display:flex;flex-direction:column;background:#f8fafc;color:#0f172a;font-family:Segoe UI,Arial,sans-serif;font-size:14px;line-height:1.4;"/>
<c:set var="panelStyle" value="background:#fff;border:1px solid #e2e8f0;border-radius:14px;padding:16px;box-shadow:0 3px 12px #0f172a05;box-sizing:border-box;max-height:100%;min-height:0;"/>
<c:set var="buttonStyle" value="display:inline-flex;align-items:center;justify-content:center;gap:6px;border:1px solid transparent;border-radius:9px;background:#0284c7;color:#fff;padding:8px 14px;font:600 14px Segoe UI,Arial,sans-serif;text-decoration:none;cursor:pointer;box-sizing:border-box;flex-shrink:0;"/>
<c:set var="secondaryStyle" value="display:inline-flex;align-items:center;justify-content:center;border:1px solid #e2e8f0;border-radius:9px;background:#fff;color:#475569;padding:8px 14px;font:600 14px Segoe UI,Arial,sans-serif;text-decoration:none;cursor:pointer;box-sizing:border-box;flex-shrink:0;align-self:flex-start;"/>
<c:set var="inputStyle" value="width:100%;box-sizing:border-box;border:1px solid #cbd5e1;border-radius:9px;background:#f8fafc;color:#0f172a;padding:8px 10px;font:400 14px Segoe UI,Arial,sans-serif;accent-color:#0284c7;"/>
<c:set var="labelStyle" value="display:block;font-size:12px;font-weight:600;color:#475569;margin-bottom:4px;"/>
<c:set var="mutedStyle" value="color:#64748b;font-size:14px;"/>
<c:set var="titleStyle" value="margin:0 0 8px;font-size:23px;line-height:1.25;"/>
<c:set var="tagStyle" value="display:inline-block;padding:4px 10px;border-radius:8px;background:#e0f2fe;color:#0369a1;font-size:12px;font-weight:600;"/>
<c:set var="alertStyle" value="padding:8px 12px;border:1px solid #fed7aa;border-radius:9px;background:#fff7ed;color:#9a3412;margin:10px 0;flex-shrink:0;"/>
<c:set var="tableStyle" value="width:100%;border-collapse:collapse;text-align:left;font-size:14px;"/>
<c:set var="thStyle" value="padding:10px 12px;background:#f1f5f9;color:#475569;border-bottom:1px solid #e2e8f0;white-space:nowrap;font-size:12px;position:sticky;top:0;z-index:1;"/>
<c:set var="tdStyle" value="padding:10px 12px;border-bottom:1px solid #edf2f7;vertical-align:middle;"/>
<c:set var="mainStyle" value="width:min(1140px,calc(100% - 24px));margin:12px auto;flex:1;min-height:0;display:flex;flex-direction:column;"/>
<c:set var="businessPanelStyle" value="${panelStyle}display:flex;flex-direction:column;flex:1;"/>
<c:set var="tableScrollStyle" value="overflow:auto;min-height:0;flex:1;border:1px solid #e2e8f0;border-radius:10px;margin:12px 0;"/>
<c:set var="linkStyle" value="color:#0369a1;text-decoration:none;font-weight:600;"/>
<fmt:setLocale value="vi_VN"/>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>
