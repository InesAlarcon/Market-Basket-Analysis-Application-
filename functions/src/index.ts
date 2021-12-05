import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
import {firebaseConfig} from "firebase-functions";
import {firestore} from "firebase-admin/lib/firestore";
import Settings = firestore.Settings;


var serviceAccount1 = require("./clientloginauth-firebase-adminsdk-hqbd2-1b443746f3.json");
var serviceAccount2 = require("./mbaaenterprise-eea0d-firebase-adminsdk-i21aq-31540cb222.json");

var _first = admin.initializeApp(
    {
        credential: admin.credential.cert(serviceAccount2),
        databaseURL: 'https://mbaaenterprise-eea0d.firebaseio.com',
    },
    'first'
)

var _second = admin.initializeApp(
    {
        credential: admin.credential.cert(serviceAccount1),
        databaseURL: 'https://clientloginauth.firebaseio.com',

    },
    'second'
)



const business = _first.firestore();
// const client = second.firestore();
//
// const _fcm = admin.messaging();
// const db = admin.firestore();


const fcmClient = _second.messaging();

//
// export const sendToTopic = functions.firestore.document('ofertas/{ofertaId}').onCreate(async snapshot => {
//     /* tslint:disable:no-unused-variable */
//     const _oferta = snapshot.data();
//
//     const payload: admin.messaging.MessagingPayload = {
//         notification: {
//             title: 'Nueva Oferta!',
//             body: _oferta.nombre,
//             clickAction: 'FLUTTER_NOTIFICATION_CLICK'
//         }
//     };
//
//     return fcmClient.sendToTopic("ofertas", payload);
// });

// export const getSub = functions.firestore.document('ofertas/')

export const sendToDevice = functions.firestore
    .document('ofertas/{bussinessId}/ofertas/{oferId}')
    .onCreate(async snapshot => {


        const order = snapshot.data();
        const docId = snapshot.id;

        let cant = ``;


        // const querySnapshot = await db
        //     .collection('ofertas')
        //     .doc(snapshot.id)
        //     .collection('ofertas')
        //     .get();
        //
        // const tokens = querySnapshot.docs.map(snap => snap.id);
        if (order.limiteUsuario<10){
            cant = `\nSolo ${order.limiteUsuario} ofertas disponibles! Aprovecha ahora.`;
        }
        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'Nueva oferta!',
                body: `Oferta ${order.nombre} a solo GTQ ${order.valor} ${cant}`,
                icon: 'your-icon-url',
                // image: order.urlImage,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }

        };

        // return fcmClient.sendToTopic(
        //   order.empresa,
        //     {
        //         data: {
        //             title: 'Nueva oferta!',
        //             body: `Oferta ${order.nombre} a solo GTQ ${order.valor}`,
        //             icon: 'your-icon-url',
        //             image: order.urlImage,
        //             click_action: 'FLUTTER_NOTIFICATION_CLICK',
        //         }
        //     }
        // );

        return fcmClient.sendToTopic(order.idEmpresa, payload);
        // return _fcm.sendToDevice(tokens, payload);
    });