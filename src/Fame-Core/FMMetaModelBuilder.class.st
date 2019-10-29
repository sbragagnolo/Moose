"
I generate the FAME model from the annotations that are described in the Moose Model smalltalk classes.

I do the parsing of the pragmas of the methods defined in the classes and a create the instance of the entities of the meta meta model.

I collaborate with the MooseModel resetMeta.

Public API and Key Messages

- run (no setters I worked on the whole image (it seems to))

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	classDict:		<Object>
	elements:		<Object>
	metaDict:		<Object>
	mmClassDict:		<Object>
	oppositeDict:		<Object>
	packMetaDict:		<Object>
	packPropDict:		<Object>
	packageDict:		<Object>
	queue:		<Object>
	superclassDict:		<Object>
	typeDict:		<Object>


    Implementation Points
"
Class {
	#name : #FMMetaModelBuilder,
	#superclass : #Object,
	#instVars : [
		'elements',
		'packageDict',
		'classDict',
		'metaDict',
		'superclassDict',
		'typeDict',
		'oppositeDict',
		'mmClassDict',
		'queue',
		'implementingPackages',
		'packDict',
		'traitsDict'
	],
	#classVars : [
		'ShouldValidateMetaModel'
	],
	#category : #'Fame-Core-Utilities'
}

{ #category : #'class initialization' }
FMMetaModelBuilder class >> initialize [
	self shouldValidateMetaModel: true
]

{ #category : #processing }
FMMetaModelBuilder class >> metamodelFrom: aCollectionOfClasses [
	^ self new
		queue: aCollectionOfClasses;
		run;
		asMetamodel
]

{ #category : #processing }
FMMetaModelBuilder class >> metamodelFromPackages: aCollectionOfPackages [
	^ self new
		queue: (aCollectionOfPackages flatCollectAsSet: [ :p | p definedClasses asSet select: #isMetamodelEntity ]);
		implementingPackages: aCollectionOfPackages;
		run;
		asMetamodel
]

{ #category : #accessing }
FMMetaModelBuilder class >> shouldValidateMetaModel [
	^ ShouldValidateMetaModel
]

{ #category : #accessing }
FMMetaModelBuilder class >> shouldValidateMetaModel: anObject [
	ShouldValidateMetaModel := anObject
]

{ #category : #converting }
FMMetaModelBuilder >> asMetamodel [
	^ FMMetaModel new
		addAll: elements;
		yourself
]

{ #category : #running }
FMMetaModelBuilder >> buildFM3 [
	self
		queue: (self class package definedClasses asSet select: #isMetamodelEntity);
		run
]

{ #category : #accessing }
FMMetaModelBuilder >> classes [
	^ elements select: #isFM3Class
]

{ #category : #accessing }
FMMetaModelBuilder >> elements [
	^ elements
]

{ #category : #private }
FMMetaModelBuilder >> ensureClass: var [
	var isBehavior ifTrue: [ ^ classDict at: var ].
	var isSymbol ifTrue: [ ^ classDict at: (self class environment at: var) ifAbsent: [ metaDict at: var asString ] ].
	var isString ifTrue: [ ^ metaDict at: var ].
	self assert: false
]

{ #category : #private }
FMMetaModelBuilder >> ensurePackage: name [
	| symbol |
	self assert: (name isSymbol or: [ name isString ]).
	symbol := name asString.
	^ packageDict
		at: symbol
		ifAbsentPut: [ | pack |
			pack := FM3Package named: symbol.
			elements add: pack.
			pack ]
]

{ #category : #private }
FMMetaModelBuilder >> extractPackageFrom: method for: aFM3Element [
	^ (method pragmaAt: #package:) ifNotNil: [ :p | packDict at: aFM3Element put: (p argumentAt: 1) ]
]

{ #category : #running }
FMMetaModelBuilder >> implementingPackages [
	^ implementingPackages ifNil: [ implementingPackages := queue collectAsSet: #package ]
]

{ #category : #running }
FMMetaModelBuilder >> implementingPackages: aColl [
	implementingPackages := aColl
]

{ #category : #initialization }
FMMetaModelBuilder >> initialize [
	"Used for queuing classes before running."

	queue := OrderedCollection new.
	"Used to store resulting FM3 elements."
	elements := OrderedCollection new.
	"Several dictionaries ... see #resolveObjectReference"
	packageDict := Dictionary new.
	classDict := Dictionary new.
	superclassDict := IdentityDictionary new.
	packDict := IdentityDictionary new.
	typeDict := IdentityDictionary new.
	oppositeDict := IdentityDictionary new.
	mmClassDict := IdentityDictionary new.
	traitsDict := IdentityDictionary new.

	"Must use the cannonical primitives here!"
	"Please do not add these primitives to elements!"
	metaDict := (FM3Constant constants collect: [ :const | const name asString -> const ]) asDictionary
]

{ #category : #private }
FMMetaModelBuilder >> methodsToProcessFrom: aClass [
	"We need to process the methods from the class and the extensions methods comming from the packages containing the entites. We should reject extension methods comming from other packages."

	^ aClass localMethods select: [ :method | method isExtension not or: [ self implementingPackages includes: method package ] ]
]

{ #category : #accessing }
FMMetaModelBuilder >> packages [
	^ elements select: #isFM3Package
]

{ #category : #private }
FMMetaModelBuilder >> processClass: aClass [
	^ self processClass: aClass ifPragmaAbsent: [ self error: 'Fame Undeclared class ' , aClass name ]
]

{ #category : #private }
FMMetaModelBuilder >> processClass: aClass ifPragmaAbsent: anErrorBlock [
	aClass metamodelDefinitionPragma
		ifNil: anErrorBlock
		ifNotNil: [ :pragma | 
			| fm3Class |
			fm3Class := FM3Class named: (pragma argumentAt: 1).
			superclassDict at: fm3Class put: (pragma argumentAt: 2).
			fm3Class implementingClass: aClass.

			(pragma method pragmaAt: #abstract) ifNotNil: [ fm3Class isAbstract: true ].
			self extractPackageFrom: pragma method for: fm3Class.
			classDict at: aClass put: fm3Class.
			(self methodsToProcessFrom: aClass) do: [ :each | self processCompiledMethod: each ].
			aClass localSlots select: #isFMRelationSlot thenDo: [ :each | self processSlot: each in: aClass ].

			traitsDict at: fm3Class put: aClass allGeneratedTraits.

			elements add: fm3Class ]
]

{ #category : #private }
FMMetaModelBuilder >> processCompiledMethod: aMethod [
	| method |
	method := aMethod.

	"If the method is a reflective method we need to ensure it is compiled and use its compiled method.
	A refelctive method is for exemple a method created via a metalink and that was never executed."
	(aMethod isKindOf: ReflectiveMethod)
		ifTrue: [ method := aMethod
				compileAndInstallCompiledMethod;
				compiledMethod ].
	self assert: method isCompiledMethod.

	method pragmas
		detect: [ :each | #(#MSEProperty:type:opposite: #MSEProperty:type:) includes: each selector ]
		ifFound: [ :pragma | 
			| prop |
			prop := FM3Property named: (pragma argumentAt: 1) asString.
			typeDict at: prop put: (pragma argumentAt: 2).
			mmClassDict at: prop put: method methodClass.
			pragma selector = #MSEProperty:type:opposite: ifTrue: [ oppositeDict at: prop put: (pragma argumentAt: 3) ].
			self processInfosFrom: method for: prop.

			elements add: prop ]
]

{ #category : #private }
FMMetaModelBuilder >> processInfosFrom: aMethod for: prop [
	prop implementingSelector: aMethod selector.
	self extractPackageFrom: aMethod for: prop.
	(aMethod pragmaAt: #container) ifNotNil: [ prop isContainer: true ].
	(aMethod pragmaAt: #derived) ifNotNil: [ prop isDerived: true ].
	(aMethod pragmaAt: #source) ifNotNil: [ prop isSource: true ].
	(aMethod pragmaAt: #target) ifNotNil: [ prop isTarget: true ].
	(aMethod pragmaAt: #multivalued) ifNotNil: [ prop isMultivalued: true ]
]

{ #category : #private }
FMMetaModelBuilder >> processSlot: aSlot in: aClass [
	| prop |
	prop := FM3Property named: aSlot name.
	prop implementingSelector: aSlot name.
	prop isMultivalued: aSlot isToMany.

	typeDict at: prop put: aSlot targetClass.
	mmClassDict at: prop put: aClass.
	oppositeDict at: prop put: aSlot inverseName.

	aClass compiledMethodAt: aSlot name asSymbol ifPresent: [ :aMethod | self processInfosFrom: aMethod for: prop ].

	elements add: prop
]

{ #category : #accessing }
FMMetaModelBuilder >> properties [
	^ elements select: #isFM3Property
]

{ #category : #running }
FMMetaModelBuilder >> queue: var [
	"Add one or many classes to be processed. Nothing is done before the run method is called"

	var isBehavior  
		ifTrue: [
			queue add: var.
			^self ].
	var isCollection
		ifTrue: [
			var do: [ :each | self queue: each ].
			^self ].
	
	[ false ] assert.
]

{ #category : #private }
FMMetaModelBuilder >> resolveObjectReferences [

	"establish class-package and property-package links"
	packDict keysAndValuesDo: [ :fm3Element :value | fm3Element package: (self ensurePackage: value) ].

	"establish property-class associations"
	mmClassDict keysAndValuesDo: [ :prop :value | prop mmClass: (self ensureClass: value) ].

	"map classes by full name"
	self classes do: [ :meta | metaDict at: meta fullName asString put: meta ].

	"establish class-superclass associations"
	superclassDict keysAndValuesDo: [ :meta :value | meta superclass: (self ensureClass: value) ].

	"establish property-type-opposite relations"
	typeDict keysAndValuesDo: [ :prop :value | prop type: (self ensureClass: value) ].

	"establish class-traits relations"
	traitsDict keysAndValuesDo: [ :class :traits | class addTraits: (traits collect: [ :t | classDict at: t ]) ].

	" Fill in oppositelinks"
	oppositeDict keysAndValuesDo: [ :prop :oppName | prop opposite: (prop type propertyNamed: oppName) ]
]

{ #category : #running }
FMMetaModelBuilder >> run [
	queue do: [ :cls | self processClass: cls ].
	self resolveObjectReferences.
	self class shouldValidateMetaModel ifTrue: [ FMMetamodelValidator for: self ]
]