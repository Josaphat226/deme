const { proto } = require('@whiskeysockets/baileys');

/**
 * Sérialisation profonde pour gérer les buffers et objets protobuf de Baileys
 */
function serializeValue(value) {
    if (value === null || value === undefined) return value;
    if (Buffer.isBuffer(value)) return { __type: 'Buffer', data: value.toString('base64') };
    if (value instanceof Uint8Array) return { __type: 'Uint8Array', data: Buffer.from(value).toString('base64') };
    if (typeof value === 'object') {
        if (value.toBase64) return { __type: 'Buffer', data: value.toBase64() };
        const result = {};
        for (const key in value) {
            if (Object.prototype.hasOwnProperty.call(value, key)) {
                result[key] = serializeValue(value[key]);
            }
        }
        return result;
    }
    return value;
}

function deserializeValue(value) {
    if (value === null || value === undefined) return value;
    if (typeof value === 'object' && value.__type === 'Buffer') return Buffer.from(value.data, 'base64');
    if (typeof value === 'object' && value.__type === 'Uint8Array') return new Uint8Array(Buffer.from(value.data, 'base64'));
    if (typeof value === 'object') {
        const result = {};
        for (const key in value) {
            if (Object.prototype.hasOwnProperty.call(value, key)) {
                result[key] = deserializeValue(value[key]);
            }
        }
        return result;
    }
    return value;
}

/**
 * Adaptateur Supabase pour Baileys - Version finale et robuste
 */
async function useSupabaseAuthState(supabase) {
    // 1. Récupérer l'état depuis Supabase
    const { data, error } = await supabase
        .from('baileys_auth')
        .select('auth_key, auth_value')
        .in('auth_key', ['creds', 'keys']);

    if (error && error.code !== 'PGRST116') {
        console.error('Erreur lecture Supabase Auth:', error);
    }

    // 2. Parser les données
    let creds = {};
    let keys = {};

    if (data && data.length > 0) {
        const credsRow = data.find(row => row.auth_key === 'creds');
        const keysRow = data.find(row => row.auth_key === 'keys');

        if (credsRow) creds = deserializeValue(credsRow.auth_value);
        if (keysRow) keys = deserializeValue(keysRow.auth_value);
    }

    // 3. Fonction de sauvegarde des credentials
    async function saveCreds() {
        await supabase
            .from('baileys_auth')
            .upsert({
                auth_key: 'creds',
                auth_value: serializeValue(creds),
                updated_at: new Date().toISOString()
            });
    }

    // 4. Retourner l'état formaté pour Baileys
    return {
        state: {
            creds,
            keys: {
                get: (type, ids) => {
                    if (!keys[type]) return {};
                    return ids.reduce((dict, id) => {
                        if (keys[type][id]) {
                            dict[id] = deserializeValue(keys[type][id]);
                        }
                        return dict;
                    }, {});
                },
                set: (data) => {
                    for (const category in data) {
                        if (!keys[category]) keys[category] = {};
                        for (const id in data[category]) {
                            const value = data[category][id];
                            if (value) {
                                keys[category][id] = serializeValue(value);
                            }
                        }
                    }
                    // Sauvegarde immédiate des clés
                    supabase
                        .from('baileys_auth')
                        .upsert({
                            auth_key: 'keys',
                            auth_value: serializeValue(keys),
                            updated_at: new Date().toISOString()
                        })
                        .then(({ error }) => { if (error) console.error('Erreur save keys:', error); });
                }
            }
        },
        saveCreds
    };
}

module.exports = { useSupabaseAuthState };