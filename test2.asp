<!DOCTYPE html>
<html>

<head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>Page Title</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <!-- <link rel='stylesheet' type='text/css' media='screen' href='main.css'>
    <script src='main.js'></script> -->
</head>

<body>
    <script type="module" src="three.min.js"></script>
    <script type="module" src="https://unpkg.com/three/examples/jsm/loaders/GLTFLoader.js"></script>
    <script type="module" src="https://unpkg.com/three/examples/jsm/controls/OrbitControls.js"></script>
    <script src="//cdn.rawgit.com/mrdoob/three.js/master/build/three.min.js"></script>

    <!-- <script src="https://unpkg.com/three/build/three.module.js"></script> -->
    <script type="module">
        let scene, camera, renderer;
        const mouse = new THREE.Vector2();
        const target = new THREE.Vector2();
        const windowHalf = new THREE.Vector2(window.innerWidth / 2, window.innerHeight / 2);


        import * as THREE from 'https://unpkg.com/three/build/three.module.js';
        import { OrbitControls } from "./three.js-master/examples/jsm/controls/OrbitControls.js";
        import { GLTFLoader } from "./three.js-master/examples/jsm/loaders/GLTFLoader.js";
        // import {OrbitControls} from 'https://unpkg.com/three/examples/jsm/controls/OrbitControls.js';
        // import { GLTFLoader } from 'https://unpkg.com/three/examples/jsm/loaders/GLTFLoader.js';
        function init() {

            console.log("hi")
            // import * as THREE from 'https://unpkg.com/three/build/three.module.js';
            scene = new THREE.Scene(); //allow you to set up what and where is to be rendered by three.js. This is where you place objects, lights and cameras.
            scene.background = new THREE.Color(0x0f0f0f);

            camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 5000);// projection mode that mimics human eye.Camera frustum: fov- vertical field of view. aspect-aspect ratio. near-near plane. far-far plane. view frustum is the region of space in the modeled world that may appear on the screen; it is the field of view of a perspective virtual camera system.
            camera.rotation.y = 45 / 180 * Math.PI; //sets rotation on y axis
            camera.position.x = 800;
            camera.position.y = 100;
            camera.position.z = 1000;

            const geometry = new THREE.BoxBufferGeometry();
            const material = new THREE.MeshNormalMaterial();

            for (let i = 0; i < 1000; i++) {

                const object = new THREE.Mesh(geometry, material);
                object.position.x = Math.random() * 80 - 40;
                object.position.y = Math.random() * 80 - 40;
                object.position.z = Math.random() * 80 - 40;
                object.rotation.x = Math.random() * 2 * Math.PI;
                object.rotation.y = Math.random() * 2 * Math.PI;
                object.rotation.z = Math.random() * 2 * Math.PI;
                scene.add(object);

            }


            renderer = new THREE.WebGLRenderer({ antialias: true }); //sets antialias to true - removes aliasing = removes jagged squares creating "staircase effect" (fake resolution - to look smoother and higher resolution without updating the display resolution)
            renderer.setSize(window.innerWidth, window.innerHeight); //sets the size of the window - renders anything within the window
            document.body.appendChild(renderer.domElement); // creates domElement ("blank canvas")


            document.addEventListener('mousemove', onMouseMove, false);
            document.addEventListener('wheel', onMouseWheel, false);
            window.addEventListener('resize', onResize, false);

            let controls = new OrbitControls(camera, renderer.domElement); //takes object and domElemnent and allows the camera to orbit around target
            // controls.addEventListener('change', renderer);

            let hlight = new THREE.AmbientLight(0x404040, .1); //This light globally illuminates all objects in the scene equally.This light cannot be used to cast shadows as it does not have a direction.
            scene.add(hlight);

            let directionalLight = new THREE.DirectionalLight(0xffffff, 1); //A light that gets emitted in a specific direction and can cast shadows. This light will behave as though it is infinitely far away and the rays produced from it are all parallel. The common use case for this is to simulate daylight; the sun is far enough away that its position can be considered to be infinite, and all light rays coming from it are parallel.
            directionalLight.position.set(0, 1, 0);
            directionalLight.castShadow = true;
            scene.add(directionalLight);
            let light = new THREE.PointLight(0xc4c4c4, .25); //A light that gets emitted from a single point in all directions and can cast shadows. A common use case for this is to replicate the light emitted from a bare lightbulb.
            light.position.set(0, 300, 500);
            scene.add(light);
            let light2 = new THREE.PointLight(0xc4c4c4, .05);
            light2.position.set(500, 100, 0);
            scene.add(light2);
            let light3 = new THREE.PointLight(0xc4c4c4, .25);
            light3.position.set(0, 100, -500);
            scene.add(light3);
            let light4 = new THREE.PointLight(0xc4c4c4, .25);
            light4.position.set(-500, 300, 500);
            scene.add(light4);

            // renderer = new THREE.WebGLRenderer({antialias:true});
            // renderer.setSize(window.innerWidth,window.innerHeight);
            // document.body.appendChild(renderer.domElement);

            let loader = new GLTFLoader();// create loader used to load 3d object
            loader.load('scene.gltf', function (gltf) { //load gltf resource (resource, function run once resource is loaded)
                let car = gltf.scene.children[0];
                car.scale.set(50, 50, 50);
                scene.add(gltf.scene);
                animate();
            });
        }
        function animate() {

            target.x = (1 - mouse.x) * 0.002;
            target.y = (1 - mouse.y) * 0.002;

            camera.rotation.x += 0.05 * (target.y - camera.rotation.x);
            camera.rotation.y += 0.05 * (target.x - camera.rotation.y);
            renderer.render(scene, camera); //displays scenes - 3d object
            requestAnimationFrame(animate);//used in webxr projects instead of set animation loop. Calls a function at every available frame
        }

        function onMouseMove(event) {

            mouse.x = (event.clientX - windowHalf.x);
            mouse.y = (event.clientY - windowHalf.x);

        }

        function onMouseWheel(event) {

            camera.position.z += event.deltaY * 0.1; // move camera along z-axis

        }
        function onResize(event) {

            const width = window.innerWidth;
            const height = window.innerHeight;

            windowHalf.set(width / 2, height / 2);

            camera.aspect = width / height;
            camera.updateProjectionMatrix();
            renderer.setSize(width, height);

        }
        init();
    </script>

</body>

</html>