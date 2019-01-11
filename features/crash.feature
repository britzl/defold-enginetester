Feature: Crash test

	@crash
	Scenario: Crash and load dump
		Given I have set crash user field 0 to foobar
		When the app crashes
		Then I should be able to load a crash dump
		And crash signum should exist
		And crash extra data should contain Crash_WriteDump
		And crash backtrace should contain at least 3 entries
		And crash modules should contain DefoldEngineTester
		And crash sys fields should be set
		And crash user field 0 should be foobar