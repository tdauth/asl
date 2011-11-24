library ALibraryCoreInterfaceLeaderboard

	/**
	 * Shows or hides leaderboard \p whichLeaderboard for player \p whichPlayer.
	 */
	function ShowLeaderboardForPlayer takes player whichPlayer, leaderboard whichLeaderboard, boolean show returns nothing
		call PlayerSetLeaderboard(whichPlayer, whichLeaderboard)
		if (whichPlayer == GetLocalPlayer()) then
			call LeaderboardDisplay(whichLeaderboard, show)
		endif
	endfunction

endlibrary