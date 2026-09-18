const {
    default: makeWASocket,
    useMultiFileAuthState,
    DisconnectReason
} = require('@whiskeysockets/baileys');
const pino = require('pino');
const qrcode = require('qrcode-terminal');
const fs = require('fs');
const path = require('path');

let sock = null;
let connectionState = 'DISCONNECTED';
const authFolder = path.join(__dirname, '../../.baileys_auth');

async function connectToWhatsApp() {
    try {
        const { state, saveCreds } = await useMultiFileAuthState(authFolder);

        sock = makeWASocket({
            auth: state,
            logger: pino({ level: 'silent' }),
            browser: ['Ubuntu', 'Chrome', '22.04'],
            printQRInTerminal: false
        });

        sock.ev.on('creds.update', saveCreds);

        sock.ev.on('connection.update', (update) => {
            const { connection, lastDisconnect, qr } = update;
            connectionState = connection;

            if (qr) {
                console.log('\n📱 SCANNE CE QR CODE AVEC TON WHATSAPP :\n');
                qrcode.generate(qr, { small: true });
            }

            if (connection === 'open') {
                console.log('✅ Bot WhatsApp DƐMƐ connecté et prêt !');
            }
            else if (connection === 'close') {
                const statusCode = lastDisconnect?.error?.output?.statusCode;
                console.log(`⚠️ Déconnecté (Code: ${statusCode})`);

                const shouldReconnect = statusCode !== DisconnectReason.loggedOut;

                if (shouldReconnect) {
                    console.log('🔄 Reconnexion...');
                    connectToWhatsApp();
                } else {
                    console.log('❌ Session expirée ou déconnectée du téléphone.');
                    console.log('🧹 Suppression des fichiers de session...');
                    fs.rmSync(authFolder, { recursive: true, force: true });
                    console.log('💡 Redémarre le serveur pour obtenir un nouveau QR Code.');
                    connectionState = 'LOGGED_OUT';
                }
            }
        });

    } catch (error) {
        console.error('❌ Erreur Baileys:', error);
    }
}

connectToWhatsApp();

// ✅ EXPORTS (C'est ce qui manquait !)
module.exports = {
    getSocket: () => sock,
    getConnectionState: () => connectionState
};