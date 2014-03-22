import readline, rlcompleter

class irlcompleter(rlcompleter.Completer):
	def complete(self, text, state):
		if text == "":
			return ['\t', None][state]
		else:
			return rlcompleter.Completer.complete(self, text, state)

readline.parse_and_bind("tab: complete")
readline.set_completer(irlcompleter().complete)
