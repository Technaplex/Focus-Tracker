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

exports.calculateStudyDay = functions.firestore.document('/users/{userId}/sessions/{sessionId}')
	.onCreate((sess, context) => {
		const sessData = sess.data();
		const sessStart = sessData.start.toMillis()
		const sessEnd = sessData.end.toMillis()
		const dur = sessStart - sessEnd
		userData = db.doc('/users/' + context.params.userId).data()
		histToDate = userData.hist
		const date = data.date.toMillis()
		const dayStart = userData.dayHours[0].toMillis()
		const dayEnd = userData.dayHours[1].toMillis()
		const workStart = userData.workHours[0].toMillis()
		const workEnd = userData.workHours[1].toMillis()
		if (date in userData.hist) {
			dataToday = histToDate[date];
			studyDay = {
				0: dataToday[0],
				1: dataToday[1],
				2: dataToday[2],
				3: dataToday[3]
			};
		} else {
			initDayHours = dayEnd - dayStart
			initWorkHours = workEnd - workStart
			studyDay = {
				0: 0,
				1: 0,
				2: initWorkHours,
				3: initDayHours - initWorkHours
			}
		}
		if (sessData.category == 0) {
			studyDay[0] += dur
		} else {
			studyDay[1] += dur
		}
		studyDay[2] -= getOverlap(sessStart, sessEnd, workStart, workEnd)
		studyDay[3] = studyDay[3] - getOverlap(sessStart, sessEnd, dayStart, workStart) - getOverlap(sessStart, sessEnd, workEnd, dayStart)
		histToDate[date] = studyDay
		db.doc('/users/' + context.params.userId).set({"hist": histToDate}, {merge: true})
	});