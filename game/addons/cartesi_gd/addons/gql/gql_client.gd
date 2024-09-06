extends Node

class_name GQLClient

var endpoint: String
var use_ssl: bool


class AbstractQuery:
	extends GQLQuery


	func _init(name:String):
		super(name);


	func _serialize_args()->String:
		var query = " ("
		var sep = "$"
		for variable in args_list.keys():
			query +=sep+variable+": "+args_list[variable]
			sep = ", $"
		return query + ")"


class Query:
	extends AbstractQuery

	func _init(name=null):
		super("query "+name)


class Mutation:
	extends AbstractQuery

	func _init(name:String):
		super("mutation "+name)


func set_endpoint(url:String):
	use_ssl = url.begins_with("https")
	endpoint = url


func query(name:String, args: Dictionary, query: GQLQuery) -> GQLQueryExecuter:
	var _query = Query.new(name).set_args(args).add_prop(query)
	return GQLQueryExecuter.new(endpoint, use_ssl, "_query")


func mutation(name:String, args: Dictionary, query: GQLQuery) -> GQLQueryExecuter:
	var _query = Mutation.new(name).set_args(args).add_prop(query)
	return GQLQueryExecuter.new(endpoint, use_ssl, "_query")


func raw(query:String) -> GQLQueryExecuter:
	return GQLQueryExecuter.new(endpoint, use_ssl, query)


func raw_query(query: GQLQuery) -> GQLQueryExecuter:
	return GQLQueryExecuter.new(endpoint, use_ssl, "query")
