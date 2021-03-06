"
rce: 22987863
"
Class {
	#name : #BaselineOfMoose,
	#superclass : #BaselineOf,
	#instVars : [
		'repository'
	],
	#category : #BaselineOfMoose
}

{ #category : #baseline }
BaselineOfMoose >> baseline: spec [
	<baseline>
	repository := self packageRepositoryURL.
	spec for: #common do: [ 
		self
			famix: spec;
			mooseAlgos: spec;
			mooseEasy: spec;
			roassal2: spec.
		spec
			package: 'Moose-Finder'
			with: [ 
				spec requires: #( 'Famix' 'MooseAlgos' 'Moose-RoassalPaintings' ) ];
			package: 'Moose-MenuBar'
			with: [ spec requires: #( 'Moose-Finder' ) ];
			package: 'Moose-Configuration';
			package: 'Glamour-Tools';
			package: 'Glamour-Magritte-Presentations';
			package: 'Moose-Help';
			package: 'Moose-RoassalPaintings'
			with: [ spec requires: #( 'Roassal2' ) ];
			package: 'Moose-Tests-Finder';
			package: 'Moose-Tests-RoassalPaintings';
			package: 'Merlin';
			package: 'Moose-Wizard';
			package: 'Merlin';
			package: 'Moose-DistributionMap';
			package: 'Moose-Tests-DistributionMap' ].
	spec for: #'pharo8.x' do: [ 
		spec
			package: 'Moose-Finder-Pharo8';
			package: 'Moose-Finder'
			with: [ spec includes: #( 'Moose-Finder-Pharo8' ) ].
		spec for: #( #NewTools ) do: [ 
			spec
				package: 'Moose-Finder-Pharo8';
				package: 'Moose-Finder2';
				package: 'Moose-Finder'
				with: [ spec includes: #( 'Moose-Finder-Pharo8'
						   'Moose-Finder2' ) ] ] ]
]

{ #category : #baseline }
BaselineOfMoose >> customProjectAttributes [
	^ (Smalltalk classNamed: 'StInspector')
		  ifNotNil: [ #( #NewTools ) ]
		  ifNil: [ #(  ) ]
]

{ #category : #dependencies }
BaselineOfMoose >> famix: spec [
	spec baseline: 'Famix' with: [ spec repository: repository ]
]

{ #category : #dependencies }
BaselineOfMoose >> mooseAlgos: spec [
	spec
		baseline: 'MooseAlgos'
		with: [ spec
				loads: 'Core';
				repository: 'github://moosetechnology/MooseAlgos:v1.x.x/src' ]
]

{ #category : #baselines }
BaselineOfMoose >> mooseEasy: spec [
	spec baseline: 'MooseEasy' with: [ spec repository: 'github://moosetechnology/Moose-Easy:v1.x.x/src' ]
]

{ #category : #accessing }
BaselineOfMoose >> packageRepositoryURL [
	^ super packageRepositoryURL
		ifEmpty: [ | packageName |
			packageName := self class package name.
			'tonel://' , (IceRepository registry detect: [ :repo | repo workingCopy packageNames includes: packageName ] ifFound: [ :repo | repo location pathString , '/' , repo subdirectory ] ifNone: [ '' ]) ]
]

{ #category : #accessing }
BaselineOfMoose >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #dependencies }
BaselineOfMoose >> roassal2: spec [
	spec
		baseline: 'Roassal2'
		with: [ spec
				loads: 'Minimal';
				repository: 'github://ObjectProfile/Roassal2:004ab6f3dfd41cf06526c57115ee42cc921e7668/src' ]
]
