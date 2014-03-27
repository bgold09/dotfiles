import sys
import os
import atexit
import readline, rlcompleter
from tempfile import mkstemp
from code import InteractiveConsole

### enable history ###
HISTFILE = "%s/.pyhistory" % os.environ["HOME"]
if os.path.exists(HISTFILE):
	readline.read_history_file(HISTFILE)

readline.set_history_length(300)

def savehist():
	readline.write_history_file(HISTFILE)

atexit.register(savehist)


### tab completion ###
class irlcompleter(rlcompleter.Completer):
	def complete(self, text, state):
		if text == "":
			return ['\t', None][state]
		else:
			return rlcompleter.Completer.complete(self, text, state)

readline.parse_and_bind("tab: complete")
readline.set_completer(irlcompleter().complete)


### start an external editor with \e ###
# http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/438813/

EDITOR = os.environ.get('EDITOR', 'vi')
EDIT_CMD = '\e'

class EditableBufferInteractiveConsole(InteractiveConsole):
	def __init__(self, *args, **kwargs):
		self.last_buffer = [] # This holds the last executed statement
		InteractiveConsole.__init__(self, *args, **kwargs)

	def runsource(self, source, *args):
		self.last_buffer = [ source.encode('utf-8') ]
		return InteractiveConsole.runsource(self, source, *args)

	def raw_input(self, *args):
		line = InteractiveConsole.raw_input(self, *args)
		if line == EDIT_CMD:
			fd, tmpfl = mkstemp('.py')
			os.write(fd, b'\n'.join(self.last_buffer))
			os.close(fd)
			os.system('%s %s' % (EDITOR, tmpfl))
			line = open(tmpfl).read()
			os.unlink(tmpfl)
			tmpfl = ''
			lines = line.split( '\n' )
			for i in range(len(lines) - 1): 
				self.push( lines[i] )
			line = lines[-1]
		return line

c = EditableBufferInteractiveConsole(locals=locals())
c.interact("")

# Exit the Python shell on exiting the InteractiveConsole
sys.exit()
