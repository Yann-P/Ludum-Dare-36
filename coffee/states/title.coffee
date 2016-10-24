class gm.Title extends Phaser.State

	create: ->


		this.backgroud = this.game.add.image(0, 0, 'title')

		this.title = this.game.add.text(450, 50, 'Fix It', { fill: 'white', font: 'MedievalSharp', fontSize: 120, fontWeight:"bold" });
		this.text = this.game.add.text(380, 300, 'Play or Resume', { fill: 'white', font: 'MedievalSharp', fontSize: 60, fontWeight:"bold" });
		this.text2 = this.game.add.text(380, 360, 'Erase save', { fill: 'white', font: 'MedievalSharp', fontSize: 60 })
		this.credits = this.game.add.text(10, 580, 'Pierre Gabon, Yann Pellegrini - 2016', { fill: 'white', font: 'MedievalSharp', fontSize: 18 });

		this.text.inputEnabled = true

		@text.events.onInputDown.add =>
			@startFromSave()
		, @

		this.text2.inputEnabled = true

		this.text2.events.onInputDown.add =>
			localStorage.setItem('level', null)
			window.location.reload()

	startFromSave: ->
		try
			lvl = localStorage.getItem('level')
			if not (lvl > 0)
				lvl = 1
			console.log lvl
			@game.state.start('level', true, false, +lvl)
		catch e
			console.warn('cant use localstorage')
			@game.state.start('level', true, false, 1)

	