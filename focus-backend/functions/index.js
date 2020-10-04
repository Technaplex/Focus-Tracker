const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

function getOverlap(t1, t2, tr1, tr2){
	if (t1 >= tr2 || t2 <= tr1) {
		return 0;
	}
	else {
		omin = Math.max(t1, tr1)
		omax = Math.min(t2, tr2)
	}
	return omax - omin
}

function getTimeInt(lst){
	return lst[0] * 3600000 + lst[1] * 60000 + lst[2] * 1000
}

exports.calculateStudyDay = functions.firestore.document('/users/{userId}/sessions/{sessionId}')
	.onCreate((sess, context) => {
		const sessData = sess.data();
		const sessStart = sessData.start.toMillis();
		const sessEnd = sessData.end.toMillis();
		const dur = sessEnd - sessStart;
		const userRef = db.collection("users").doc(context.params.userId);
		console.log('Getting data from', context.params.userId);
		userData = null
		return userRef.get().then(doc => {
			userData = doc.data()
			if ('hist' in userData){
				histToDate = userData['hist'];
			} else {
				histToDate = {};
			}
			tmpDate = sessData.date.toDate();
			tmpDate.setHours(0,0,0,0);
			const date = tmpDate.getTime() + 86400000;
			const dayStart = date + getTimeInt(userData['dayHours'].slice(1, 4));
			const dayEnd = date + getTimeInt(userData['dayHours'].slice(4, 7));
			const workStart = date + getTimeInt(userData['workHours'].slice(1, 4));
			const workEnd = date + getTimeInt(userData['workHours'].slice(4, 7));
			if (date in histToDate) {
				dataToday = histToDate[date];
				studyDay = {
			
					0: dataToday[0],
					1: dataToday[1],
					2: dataToday[2],
					3: dataToday[3],
					interrupts: dataToday["interrupts"],
					dstart: dataToday["dstart"],
					dend: dataToday["dend"],
					wstart: dataToday["wstart"],
					wend: dataToday["wend"]
				};
			} else {
				initDayHours = dayEnd - dayStart;
				initWorkHours = workEnd - workStart;
				studyDay = {
					0: 0,
					1: 0,
					2: initWorkHours,
					3: initDayHours - initWorkHours,
					interrupts: 0,
					dstart: dayStart - date,
					dend: dayEnd - date,
					wstart: workStart - date,
					wend: workEnd - date
				}
			}
			if (sessData.category == 0) {
				studyDay[0] += dur;
			} else {
				studyDay[1] += dur;
			}
			studyDay[2] -= getOverlap(sessStart, sessEnd, workStart, workEnd);
			studyDay[3] = studyDay[3] - getOverlap(sessStart, sessEnd, dayStart, workStart) - getOverlap(sessStart, sessEnd, workEnd, dayStart);
			studyDay["interrupts"] += sessData.interrupts
			histToDate[date] = studyDay;
			return db.collection("users").doc(context.params.userId).set({"hist": histToDate}, {merge: true})
		})
	});
