Class {
	#name : #MooseModelTestResourceWithSmalltalkDependency,
	#superclass : #MooseModelTestResource,
	#category : #'Famix-PharoSmalltalk-Tests'
}

{ #category : #'as yet unclassified' }
MooseModelTestResourceWithSmalltalkDependency >> metamodelFactory [

	^ SmalltalkMetamodelFactory
]

{ #category : #setup }
MooseModelTestResourceWithSmalltalkDependency >> modelClass [
	^ FamixStModel
]

{ #category : #'as yet unclassified' }
MooseModelTestResourceWithSmalltalkDependency >> newImportClassesTask [
	
	| importer |

	importer := MooseImportClassesTask new.
	importer factory: self metamodelFactory.

	^ importer
]

{ #category : #'as yet unclassified' }
MooseModelTestResourceWithSmalltalkDependency >> newPharoImporterTask [
	
	| importer |

	importer := MoosePharoImporterTask new.
	importer factory: self metamodelFactory.

	^ importer
]