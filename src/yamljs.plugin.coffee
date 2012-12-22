# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class YamljsPlugin extends BasePlugin
		# Plugin Name
		name: 'yamljs'

		# Plugin Configuration
		config:
			indent: false

		# =============================
		# Events

		# Render
		# Called per document, for each extension conversion. Used to render one extension to another.
		render: (opts,next) ->
			# Prepare
			config = @config
			{inExtension,outExtension} = opts

			# YAML to JSON
			if inExtension in ['yml', 'yaml'] and outExtension in ['json', null]
				# Render and complete
				YAML = require('yamljs')
				obj = null
				try
					obj = YAML.parse opts.content
				catch err
					return next(err)

				if config.indent is false
					opts.content = JSON.stringify(obj)
				else if config.indent is true
					opts.content = JSON.stringify(obj,null,4)
				else
					opts.content = JSON.stringify(obj,null,config.indent)
				return next()

			# JSON to YAML
			else if inExtension is 'json' and outExtension in ['yml', 'yaml']
				# Render and complete
				YAML = require('yamljs')
				obj = null
				try
					obj = JSON.parse opts.content
				catch err
					return next(err)

				opts.content = YAML.stringify(obj, 8)
				return next()

			# Something else
			else
				# Nothing to do, return back to DocPad
				return next()
