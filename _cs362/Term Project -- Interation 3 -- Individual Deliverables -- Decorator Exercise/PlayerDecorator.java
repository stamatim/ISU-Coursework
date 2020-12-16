/**
 * Iteration 3 - Player Decorator
 * @author Stamati Morellas
 *
 */
package coms362.cards.fiftytwo;

import coms362.cards.abstractcomp.Player;

public class PlayerDecorator implements Player {

    protected Player player;

    public PlayerDecorator(Player p) {
        this.player = p;
    }

    @Override
    public int addToScore(int amount) {
        return this.player.addToScore(amount);
    }

    @Override
    public int getPlayerNum() {
        return this.player.getPlayerNum();
    }

    @Override
    public String getSocketId() {
        return this.player.getSocketId();
    }

    @Override
    public int getScore() {
        return this.player.getScore();
    }
}
