import anime from 'animejs'
//import { initialize } from 'esbuild';
//import { add } from 'points'
//import { toPath } from 'svg-points'
import { parsePath } from 'path-data-parser' // , absolutize, normalize, serialize 


//	  Legend
/* ============ *
 * kf = Key Frame
 * ============ */



const updateDelay = 1000;

function makeMod(segKey, segData) {
	// basic promise to allow handelling
	return {
		request: new Promise(function(request, rejected) {
			try {
				request(segData);
			} catch (error) {
				console.log(error);
				rejected(segData);
			}
		}),
		key: segKey,
	};
}

function addPath(kfArr, path) {
	const parsedPath = parsePath(path);
	const modifiedPath = parsedPath.reduce((acc, element, index) => {

		let mod = makeMod(element.key + "-" + index.toString(), element.data);
		acc.set(mod.key, mod.request);
		return acc;
	}, new Map()); // returns the path as an array of objects

	kfArr.push(modifiedPath);
}

async function flattenPathMap(pathMap) {
	// all I need to do is make a promise that uses the scope of this func
	// to send back the cached map
	// I'll do this later!
	let flatPath = "";
	for (let [key, request] of pathMap) {
		let retrievedData = await retrieve(request);
		let keyUnindexed = key.replace(/-.*/, "");
		let parsedData = retrievedData
			.reduce((acc, element) => {
				acc = acc.concat(" ", element);
				return acc;
			}, "");
		flatPath = flatPath.concat(keyUnindexed, parsedData, " ");
	}
	return flatPath;
}


async function retrieve(request) {
	return request
		.then((data) => {
			return data;
		})
		.catch(function(error) {
			console.log(error);
		});
}

async function update(segRequest, updateFunc) {
	// switched time out placement might cause bugs bcz untested
	return segRequest
		.then(setTimeout(() => "", 1000))
		.then(updateFunc(),
			function(data) {
				return data;
			})
		.catch(function(error) {
			console.log(error);
		});
}



async function init() {

	const waveKF = [];

	let waveP1 = "M0 5 Q 45 -5, 70 5 T 120 5 V15 H0 Z";
	let waveP2 = "M0 5 Q 25 -5, 50 5 T 100 5 V15 H0 Z";

	addPath(waveKF, waveP1)
	addPath(waveKF, waveP2);

	const flatPath = await flattenPathMap(waveKF[0]);
	console.log(flatPath);



	// last step is to grab a cached update
	//update(waveKF[0].get("Q-1"),
	//	(data) => {
	//		data.forEach(element => Math.sin(element));
	//	}
	//);


	anime({
		targets: ".wave",
		d: [
			{ value: await flattenPathMap(waveKF[0]) },
			{ value: await flattenPathMap(waveKF[1]) },
		],
		easing: "linear",
		duration: 1000,
		loop: true,
	});
}

init();
