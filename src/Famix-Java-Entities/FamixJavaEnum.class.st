Class {
	#name : #FamixJavaEnum,
	#superclass : #FamixJavaType,
	#traits : 'FamixTWithEnumValues',
	#classTraits : 'FamixTWithEnumValues classTrait',
	#category : #'Famix-Java-Entities-Entities'
}

{ #category : #meta }
FamixJavaEnum class >> annotation [

	<FMClass: #Enum super: #FamixJavaType>
	<package: #'Famix-Java-Entities'>
	<generated>
	^self
]

{ #category : #'as yet unclassified' }
FamixJavaEnum >> values [
	^ self enumValues
]

{ #category : #'as yet unclassified' }
FamixJavaEnum >> values: anObject [
	self enumValues: anObject
]
