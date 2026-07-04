<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Email Verification</title>
</head>

<body style="margin:0;padding:0;background:#f4f7fb;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f7fb;padding:40px 0;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
       style="background:#ffffff;border-radius:14px;overflow:hidden;box-shadow:0 8px 25px rgba(0,0,0,.08);">

    <!-- Header -->
    <tr>
        <td align="center"
            style="background:linear-gradient(135deg,#2563EB,#1D4ED8);padding:35px;">

            <h1 style="margin:0;color:#ffffff;font-size:28px;">
                Human Resource Management System
            </h1>

            <p style="margin-top:10px;color:#DCE8FF;font-size:15px;">
                Email Verification
            </p>

        </td>
    </tr>

    <!-- Body -->
    <tr>
        <td style="padding:40px;">

            <h2 style="margin-top:0;color:#1F2937;">
                Hello {{ $user->name }},
            </h2>

            <p style="font-size:16px;color:#4B5563;line-height:28px;">
                Thank you for registering with our
                <strong>Human Resource Management System (HRMS)</strong>.
            </p>

            <p style="font-size:16px;color:#4B5563;line-height:28px;">
                Please use the verification code below to verify your email address.
            </p>

            <!-- OTP -->
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="center">

                        <div style="
                            margin:35px 0;
                            display:inline-block;
                            padding:18px 40px;
                            background:#EEF4FF;
                            border:2px dashed #2563EB;
                            border-radius:12px;
                            font-size:38px;
                            font-weight:bold;
                            letter-spacing:10px;
                            color:#2563EB;
                        ">
                            {{ $otp }}
                        </div>

                    </td>
                </tr>
            </table>

            <p style="font-size:15px;color:#6B7280;line-height:26px;">
                ⏰ This OTP is valid for
                <strong>10 minutes</strong>.
            </p>

            <p style="font-size:15px;color:#6B7280;line-height:26px;">
                If you did not create an account, please ignore this email.
            </p>

        </td>
    </tr>

    <!-- Divider -->
    <tr>
        <td>
            <hr style="border:none;border-top:1px solid #ECECEC;">
        </td>
    </tr>

    <!-- Footer -->
    <tr>
        <td align="center" style="padding:30px;">

            <p style="margin:0;font-size:14px;color:#9CA3AF;">
                © {{ date('Y') }} Human Resource Management System
            </p>

            <p style="margin-top:8px;font-size:13px;color:#9CA3AF;">
                Secure • Fast • Reliable
            </p>

        </td>
    </tr>

</table>

</td>
</tr>
</table>

</body>

</html>