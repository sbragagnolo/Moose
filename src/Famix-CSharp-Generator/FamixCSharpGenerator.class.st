Class {
	#name : #FamixCSharpGenerator,
	#superclass : #FamixFileBasedLanguageGenerator,
	#instVars : [
		'access',
		'annotationInstance',
		'annotationInstanceAttribute',
		'annotationType',
		'annotationTypeAttribute',
		'attribute',
		'caughtException',
		'class',
		'containerEntity',
		'declaredException',
		'enum',
		'enumValue',
		'exception',
		'globalVariable',
		'implicitVariable',
		'inheritance',
		'invocation',
		'localVariable',
		'method',
		'module',
		'namespace',
		'package',
		'parameter',
		'parameterType',
		'parameterizableClass',
		'primitiveType',
		'reference',
		'scopingEntity',
		'thrownException',
		'type',
		'unknownVariable',
		'parameterizedType',
		'tStructuralEntity',
		'property',
		'propertyAccessor',
		'struct',
		'delegate',
		'event'
	],
	#category : #'Famix-CSharp-Generator'
}

{ #category : #accessing }
FamixCSharpGenerator class >> packageName [

	^ #'Famix-CSharp-Entities'
]

{ #category : #accessing }
FamixCSharpGenerator class >> prefix [

	^ #'FamixCSharp'
]

{ #category : #accessing }
FamixCSharpGenerator class >> wantsAllEntitiesNavigation [

	^ false
]

{ #category : #definition }
FamixCSharpGenerator >> defineClasses [

	super defineClasses.

	access := builder newClassNamed: #Access.
	annotationInstance := builder newClassNamed: #AnnotationInstance.
	annotationInstanceAttribute := builder newClassNamed: #AnnotationInstanceAttribute.
	annotationType := builder newClassNamed: #AnnotationType.
	annotationTypeAttribute := builder newClassNamed: #AnnotationTypeAttribute.
	attribute := builder newClassNamed: #Attribute.
	
	property := builder newClassNamed:#Property.
	propertyAccessor := builder newClassNamed:#PropertyAccessor.
	struct := builder newClassNamed:#Struct.
	delegate := builder newClassNamed:#Delegate.
	event := builder newClassNamed: #Event.


	caughtException := builder newClassNamed: #CaughtException.
	class := builder newClassNamed: #Class.
	containerEntity := builder newClassNamed: #ContainerEntity.
	declaredException := builder newClassNamed: #DeclaredException.
	enum := builder newClassNamed: #Enum.
	enumValue := builder newClassNamed: #EnumValue.
	exception := builder newClassNamed: #Exception.
	globalVariable := builder newClassNamed: #GlobalVariable.
	implicitVariable := builder newClassNamed: #ImplicitVariable.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	localVariable := builder newClassNamed: #LocalVariable.
	method := builder newClassNamed: #Method.
	namespace := builder newClassNamed: #Namespace.
	package := builder newClassNamed: #Package.
	parameter := builder newClassNamed: #Parameter.
	parameterType := builder newClassNamed: #ParameterType.
	parameterizableClass := builder newClassNamed: #ParameterizableClass.
	parameterizedType := builder newClassNamed: #ParameterizedType.
	primitiveType := builder newClassNamed: #PrimitiveType.
	reference := builder newClassNamed: #Reference.
	scopingEntity := builder newClassNamed: #ScopingEntity.
	thrownException := builder newClassNamed: #ThrownException.
	type := builder newClassNamed: #Type.
	unknownVariable := builder newClassNamed: #UnknownVariable.
	
	primitiveType withTesting.

	self defineComments
]

{ #category : #definition }
FamixCSharpGenerator >> defineComments [
	entity comment: 'file :=  ''ArgoUML-0.34.mse'' asFileReference readStream.

dictionary := Dictionary newFrom: (
	FamixJavaEntity withAllSubclasses collect: [ :c | 
		cn := c name withoutPrefix: #FamixJava.
		(''FAMIX.'', cn) -> (''FamixJava-Entities.'', cn) ]).

dictionary at: ''FAMIX.JavaSourceLanguage'' put: ''FamixJava-Entities.SourceLanguage''.

repo := MooseModel importFrom: file withMetamodel: FamixJavaGenerator metamodel translationDictionary: dictionary.

model := MooseModel new.
	model silentlyAddAll: repo elements.
	model entityStorage forRuntime.
model.'
]

{ #category : #definition }
FamixCSharpGenerator >> defineHierarchy [

	super defineHierarchy.

	entity <|-- exception.
	
	access --|> association.
	access --|> #TAccess.

	annotationInstance --|> sourcedEntity.
	annotationInstance --|> #TAnnotationInstance.
	annotationInstance --|> #TWithAnnotationInstanceAttributes.
	annotationInstance --|> #TTypedAnnotationInstance.

	annotationInstanceAttribute --|> sourcedEntity.
	annotationInstanceAttribute --|> #TAnnotationInstanceAttribute.
	annotationInstanceAttribute --|> #TTypedAnnotationInstanceAttribute.

	annotationType --|> type.
	annotationType --|> #TAnnotationType.

	annotationTypeAttribute --|> attribute.
	annotationTypeAttribute --|> #TWithAttributes.
	annotationTypeAttribute --|> #TAnnotationTypeAttribute.
	annotationTypeAttribute --|> #TTypedAnnotationInstanceAttribute.

	attribute --|> namedEntity.
	attribute --|> tStructuralEntity.
	attribute --|> #TAttribute.
	attribute --|> #TWithClassScope.
	
	method --|> containerEntity.
	method --|> #TMethod.
	method --|> #TWithThrownExceptions.
	method --|> #TWithDeclaredExceptions.
	method --|> #TWithCaughtExceptions.
	method --|> #TWithStatements.


" ICIIIIIIIIIIIII "
	property --|> localVariable.
	property --|> #TAttribute.
	propertyAccessor --|> method.
	struct  --|> type. 
	delegate --|> type. 
	event --|> method. 
	event --|> #TWithMethods.



	caughtException --|> exception.
	caughtException --|> #TCaughtException.

	class --|> type.
	class --|> #TWithExceptions.
	class --|> #TClass.
	class --|> #TLCOMMetrics.
	class --|> #TWithAttributes.
	class --|> #TWithProperties.
	
	
	

	containerEntity --|> namedEntity.
	containerEntity --|> #TWithTypes.
	containerEntity --|> #TWithClasses.
	containerEntity --|> #TWithAnnotationTypes.
	containerEntity --|> #TOODependencyQueries.

	declaredException --|> exception.
	declaredException --|> #TDeclaredException.

	enum --|> type.
	enum --|> #TWithEnumValues.

	enumValue --|> namedEntity.
	enumValue inheritsFromTrait: tStructuralEntity without: #(#mooseNameOn:).
	enumValue --|> #TEnumValue.

	exception --|> #TException.

	globalVariable --|> namedEntity.
	globalVariable --|> tStructuralEntity.
	globalVariable --|> #TGlobalVariable.

	implicitVariable --|> namedEntity.
	implicitVariable --|> tStructuralEntity.
	implicitVariable --|> #TImplicitVariable.

	inheritance --|> association.
	inheritance --|> #TSubInheritance.
	inheritance --|> #TSuperInheritance.

	invocation --|> association.
	invocation --|> #TInvocation.
	invocation --|> #TWithSignature.

	localVariable --|> namedEntity.
	localVariable --|> tStructuralEntity.
	localVariable --|> #TLocalVariable.

	namedEntity --|> #TPackageable.
	namedEntity --|> #TInvocationsReceiver.
	namedEntity --|> #TWithAnnotationInstances.
	namedEntity --|> #TWithModifiers.
	namedEntity --|> #TPossibleStub.

	namespace --|> scopingEntity.
	namespace --|> #TNamespace.

	package --|> scopingEntity.
	package --|> #TPackage.

	parameter --|> namedEntity.
	parameter --|> tStructuralEntity.
	parameter --|> #TParameter.

	parameterType --|> type.

	parameterizableClass --|> class.
	parameterizableClass --|> #TWithParameterizedTypes.

	parameterizedType --|> type.
	parameterizedType --|> #TParameterizedType.
	parameterizedType --|> #TWithParameterizedTypeUsers.

	primitiveType --|> type.

	reference --|> association.
	reference --|> #TReference.

	scopingEntity --|> containerEntity.
	scopingEntity --|> #TGlobalVariableScope.
	scopingEntity --|> #TScopingEntity.

	thrownException --|> exception.
	thrownException --|> #TThrownException.

	type --|> containerEntity.
	type --|> #TType.
	type --|> #TWithMethods.
	type --|> #TWithTypeAliases.
	type --|> #TParameterizedTypeUser.
	type --|> #TClassHierarchyNavigation. 
	type --|> #TWithAttributes.
	type --|> #TWithProperties.
	type --|> #TWithSubInheritances.
	type --|> #TWithSuperInheritances.


	tStructuralEntity --|> #TStructuralEntity.
	tStructuralEntity --|> #TWithDereferencedInvocations.

	unknownVariable --|> namedEntity.
	unknownVariable --|> tStructuralEntity.
	


]

{ #category : #definition }
FamixCSharpGenerator >> defineProperties [
	super defineProperties.
	(property property: #setter type: #FamixCSharpPropertyAccessor)
		comment: 'Setter of a property'.
	(property property: #getter type:  #FamixCSharpPropertyAccessor)
		comment: 'Getter of a property'
]

{ #category : #definition }
FamixCSharpGenerator >> defineTraits [
	super defineTraits.
	tStructuralEntity := builder newTraitNamed: #TStructuralEntity
]

{ #category : #definition }
FamixCSharpGenerator >> newBuilder [
	^ super newBuilder
		withImportingContext;
		yourself
]
