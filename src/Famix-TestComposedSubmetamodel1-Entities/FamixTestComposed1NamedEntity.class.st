Class {
	#name : #FamixTestComposed1NamedEntity,
	#superclass : #FamixTestComposed1SourcedEntity,
	#traits : 'FamixTNamedEntity + TDependencyQueries + TEntityMetaLevelDependency',
	#classTraits : 'FamixTNamedEntity classTrait + TDependencyQueries classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'Famix-TestComposedSubmetamodel1-Entities-Entities'
}

{ #category : #meta }
FamixTestComposed1NamedEntity class >> annotation [

	<FMClass: #NamedEntity super: #FamixTestComposed1SourcedEntity>
	<package: #'Famix-TestComposedSubmetamodel1-Entities'>
	<generated>
	^self
]
