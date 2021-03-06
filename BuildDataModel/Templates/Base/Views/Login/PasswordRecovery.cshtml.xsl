﻿<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output omit-xml-declaration="yes" indent="no" encoding="UTF-8" method="xml"/>
<xsl:template match="ParentData"><xsl:text disable-output-escaping="yes"><![CDATA[@model ]]></xsl:text><xsl:value-of select="AppName"/><xsl:text disable-output-escaping="yes"><![CDATA[.Code.PasswordResetData

<div class="col-md-6 offset-md-3">
    <span class="anchor" id="formResetPassword"></span>
    <hr class="mb-5">

    <!-- form card reset password -->
    <div class="card card-outline-secondary">
        <div class="card-header">
            <h3 class="mb-0">Password Reset</h3>
        </div>
        <div class="card-body">
            <form class="form" role="form" autocomplete="off" asp-action="PasswordRecovery" asp-controller="Login" method="post">
                <div class="form-group">
                    <label for="resetEmail">Email</label>
                    <input type="email" class="form-control" name="resetEmail" id="resetEmail" required="" value="@Model.ResetEmail">
                    <label for="resetKey">Reset key code</label>
                    <input class="form-control" name="resetKey" id="resetKey" required="" value="@Model.ResetKey">
                    <label for="resetPassword">Password</label>
                    <input name="resetPassword" class="form-control" required="required" type="password" id="resetPassword" />
                    <label for="confirmPassword">Confirm Password</label>
                    <input name="confirmPassword" class="form-control" required="required" type="password" id="confirmPassword" oninput="check(this)" />
                    <span id="helpResetPasswordEmail" class="form-text small text-muted">
                        Password reset instructions will be sent to this email address.
                    </span>
                    <script language='javascript' type='text/javascript'>
                        function check(input) {
                            if (input.value != document.getElementById('resetPassword').value) {
                                input.setCustomValidity('Passwords Must be Matching.');
                            } else {
                                // input is valid -- reset the error message
                                input.setCustomValidity('');
                            }
                        }
                    </script>
                </div>
                <div class="form-group">
                    <input type="submit" class="btn btn-success btn-lg float-right" value="Reset" />
                </div>
            </form>
        </div>
    </div>
</div>]]></xsl:text>
</xsl:template>
</xsl:stylesheet>
