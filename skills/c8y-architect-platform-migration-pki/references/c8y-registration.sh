# This needs to be your "external id". Use the same value here as your
# device is using as client-id
DEVICE_ID="sn-123456"
DEVICE_ONE_TIME_PASSWORD="your-secret-otp"
C8Y_DOMAIN="example-tenant.cumulocity.com"

# Create private key
openssl ecparam -genkey -name prime256v1 -out device-private-key.pem

# Create CSR
openssl req \
    -new \
    -key device-private-key.pem \
    -noenc \
    -subj "/C=DE/O=My Company/OU=TestDevice/CN=${DEVICE_ID}" \
    -out device.csr

# Enroll Device
curl https://${C8Y_DOMAIN}/.well-known/est/simpleenroll \
    -sfv \
    -u "${DEVICE_ID}:${DEVICE_ONE_TIME_PASSWORD}" \
    --data-binary @device.csr \
    -H "Content-Type: application/pkcs10" \
    -H "Accept: application/pkcs10" \
    -o device-certificate.pem

# When you have a device registration request in the target tenant with matching Device-ID and OTP, you will find the certificate + private-key in your working directory.
# These can be used to connect to Cumulocity on 8883 and 9883. For connecting with certificates, make sure the MQTT Client ID matches with your Device-ID!