_run = ( ->
  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera( 75, (window.innerWidth/window.innerHeight), 0.1, 1000 )
  renderer = new THREE.WebGLRenderer()

  renderer.setSize( window.innerWidth, window.innerHeight )
  document.body.appendChild( renderer.domElement )

  coords_for_arc_angle = (radians,arc_length) ->
    coords = {}
    coords.x = Math.cos(radians) * arc_length
    coords.y = Math.sin(radians) * arc_length
    coords

  coords_for_rotation_phase = (x,y,arc_length,particle_total,particle_index,rotation_period,frame_count) ->
    index_fraction = particle_index / particle_total
    rotation_fraction = (frame_count % rotation_period) / parseFloat(rotation_period)
    fraction = index_fraction + rotation_fraction

    radians = (fraction * 360.0) * (Math.PI / 180)
    coords_for_arc_angle(radians,3.0)

  make_cube = (x,y,z,options) ->
    xd = yd = zd = options.divisions || 1
    geometry = new THREE.CubeGeometry(x,y,z,xd,yd,zd)
    material = new THREE.MeshBasicMaterial(options)
    new THREE.Mesh( geometry, material )

  scene_cube = make_cube(10,10,10,{ color: 0xffff00, wireframe: true, divisions: 3 })
  scene_cube.x = -5.0
  scene_cube.y = -5.0
  scene_cube.z = -5.0
  scene.add( scene_cube )

  CUBES_COUNT = 10
  cubes = []

  for i in [0..CUBES_COUNT]
    cube = make_cube(1,1,1,{ color: 0x00ff00, wireframe: true })
    scene.add( cube )
    cubes.push( cube )
    coords = coords_for_rotation_phase(0,0,3.0,CUBES_COUNT,i,2,1)
    cube.position.x = coords.x
    cube.position.z = coords.y
    cube.position.y = (i * 0.5) - 3.0

  # camera.position.z = 7.0;
  # camera.position.y = 4.0;

  origin = new THREE.Vector3(0.0,0.0,0.0)
  frame_count = 0

  do_think = ->
    for cube, idx in cubes
      cube.rotation.y += 0.1
      cube.rotation.x += 0.1
      coords = coords_for_rotation_phase(0,0,3.0,CUBES_COUNT,idx,120,frame_count)
      cube.position.x = coords.x
      cube.position.z = coords.y

    cam_coords = coords_for_rotation_phase(0,0,3.0,1,1,100,frame_count)
    camera.position.z = coords.x * 7.0
    camera.position.x = coords.y * 7.0
    camera.position.y = coords.x * 7.0
    camera.lookAt(origin)
  setInterval(do_think,1000.0 / 60)

  do_render = ->
    requestAnimationFrame(do_render)
    renderer.render(scene,camera)
    frame_count += 1

  do_render()
)

window.addEventListener("load",_run)
