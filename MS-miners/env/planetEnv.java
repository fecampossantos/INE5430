package env;

import jason.asSyntax.Literal;
import jason.asSyntax.Structure;
import jason.asSyntax.Term;
import jason.environment.Environment;

import java.util.LinkedList;
import java.util.List;
import java.util.Random;

public class planetEnv extends Environment {

  public final int gridSize;
  public final int middle;
  public final int amount_gold_cells;

  public final PlanetCell[][] planet;
  public final boolean[][] resourcemap;

  public final int X = 0;
  public final int Y = 1;

  public int miner1[];
  public int miner2[];
  public int miner3[];

  public int builder[];

  public Random random = new Random(System.currentTimeMillis());

  public Literal miner1_position;
  public Literal miner2_position;
  public Literal miner3_position;
  public Literal resC1;
  public Literal resC2;
  public Literal resC3;

  public int rid;
  public List rstore = new LinkedList();

  public Literal r1fin = Literal.parseLiteral("enough(1)");
  // public Literal r2fin = Literal.parseLiteral("enough(2)");
  public Literal finished = Literal.parseLiteral("finished_collecting");

  public final String build_using = new String("build_using");
  public final String mine_gold = new String("mine");
  public final String drop_gold = new String("drop");
  public final Term move_to_next_cell = Literal.parseLiteral("move_to(next_cell)");

  public int b1res;
  public int c1res;
  public int c2res;
  public int c3res;

  public GUI gui;

  public planetEnv() {

    gridSize = 20;
    amount_gold_cells = 60;
    middle = gridSize / 2;

    planet = new PlanetCell[gridSize][gridSize];
    resourcemap = new boolean[gridSize][gridSize];

    builder = new int[2];
    builder[X] = middle;
    builder[Y] = middle;

    miner1 = new int[2];
    miner1[X] = middle;
    miner1[Y] = middle;
    miner2 = new int[2];
    miner2[X] = middle;
    miner2[Y] = middle;
    miner3 = new int[2];
    miner3[X] = middle;
    miner3[Y] = middle;

    rid = 0;

    int x;
    int y;

    for (int i = 0; i < amount_gold_cells; i++) {

      x = random.nextInt(gridSize);
      y = random.nextInt(gridSize);

      while (planet[x][y] != null || x == middle && y == middle) {

        x = random.nextInt(gridSize);
        y = random.nextInt(gridSize);
      }

      int amount = random.nextInt(4);

      while(amount == 0){
        amount = random.nextInt(4);
      }

      planet[x][y] = new Resource(amount); // adds up to 4 pieces of gold
      resourcemap[x][y] = true;
    }

    planet[middle][middle] = new Site();

    c1res = 1;
    c2res = 1;
    c3res = 1;

    updatePercepts("miner1");
    updatePercepts("miner2");
    updatePercepts("miner3");

    gui = new GUI(this);

  }

  public boolean executeAction(String agent, Structure action) {
    if (action.equals(move_to_next_cell)) {
      if (agent.equals("miner1")) {

        miner1[X]++;

        if (miner1[X] == gridSize) {
          miner1[X] = 0;
          miner1[Y]++;
        }
        if (miner1[Y] == gridSize) {
          miner1[Y] = 0;
        }

      } else if (agent.equals("miner2")) {

        miner2[X]--;

        if (miner2[X] == -1) {
          miner2[X] = gridSize - 1;
          miner2[Y]--;
        }
        if (miner2[Y] == -1) {
          miner2[Y] = gridSize - 1;
        }

      } else if (agent.equals("miner3")) {

        miner3[Y]++;

        if (miner3[Y] == gridSize) {
          miner3[Y] = 0;
          miner3[X]++;
        }
        if (miner3[X] == gridSize) {
          miner3[X] = 0;
        }

      }

    } else if (action.getFunctor().equals(build_using)) {

      Site s = (Site) planet[middle][middle];
      int resourceBuilt = s.build();

      Literal nr = Literal.parseLiteral("new_resource(" + action.getTerm(0) + "," + action.getTerm(1) + ")");
      removePercept("builder", nr);

      if (resourceBuilt == 1) {
        if (s.getr1() == 0) {
          addPercept("builder", r1fin);
          gui.out("Resource 1 no longer needed: Requesting Resource 2.");
        }
      }
      // if (resourceBuilt == 2) {
      // if (s.getr2() == 0) {
      // addPercept("builder", r2fin);
      // gui.out("Resource 2 no longer needed: Requesting Resource 3.");
      // }
      // }
      // if (resourceBuilt == 3) {
      // if (s.complete()) {
      // addPercept("builder", finished);
      // gui.out("Building complete: requesting agents to return home.");
      // }
      // }

      // gui.out("Resource " + resourceBuilt + " used, current values needed: r1 = " +
      // s.getr1() + ",r2 = " + s.getr2()
      // + ", r3 = " + s.getr3());
    } else if (action.getFunctor().equals(mine_gold)) {

      if (agent.equals("miner1")) {

        if (resourcemap[miner1[X]][miner1[Y]]) {
          Resource r = (Resource) planet[miner1[X]][miner1[Y]];
          r.mine();
          // c1res = r.getType();
          gui.out("Agent A mining gold");
          if (r.depleted()) {
            planet[miner1[X]][miner1[Y]] = null;
            resourcemap[miner1[X]][miner1[Y]] = false;
          }
        }

      } else if (agent.equals("miner2")) {

        if (resourcemap[miner2[X]][miner2[Y]]) {
          Resource r = (Resource) planet[miner2[X]][miner2[Y]];
          r.mine();
          // c2res = r.getType();
          gui.out("Agent B mining gold");
          if (r.depleted()) {
            planet[miner2[X]][miner2[Y]] = null;
            resourcemap[miner2[X]][miner2[Y]] = false;
          }
        }

      } else if (agent.equals("miner3")) {

        if (resourcemap[miner3[X]][miner3[Y]]) {
          Resource r = (Resource) planet[miner3[X]][miner3[Y]];
          r.mine();
          // c3res = r.getType();
          gui.out("Agent C mining gold");
          if (r.depleted()) {
            planet[miner3[X]][miner3[Y]] = null;
            resourcemap[miner3[X]][miner3[Y]] = false;
          }
        }
      }

    } else if (action.getFunctor().equals(drop_gold)) {

      rid++;
      Literal r1store = Literal.parseLiteral("new_resource(1," + rid + ")");
      // Literal r2store = Literal.parseLiteral("new_resource(2," + rid + ")");
      // Literal r3store = Literal.parseLiteral("new_resource(3," + rid + ")");

      if (agent.equals("miner1")) {
        Site s = (Site) planet[middle][middle];
        s.addstore(c1res);
        gui.out("Agent A dropped gold at home base");
        // switch (c1res) {
        // case 1:
        addPercept("builder", r1store);
        // break;
        // case 2:
        // addPercept("builder", r2store);
        // break;
        // case 3:
        // addPercept("builder", r3store);
        // break;
        // }
      } else if (agent.equals("miner2")) {
        Site s = (Site) planet[middle][middle];
        s.addstore(c2res);
        gui.out("Agent B dropped gold at home base");
        // switch (c2res) {
        // case 1:
        addPercept("builder", r1store);
        // break;
        // case 2:
        // addPercept("builder", r2store);
        // break;
        // case 3:
        // addPercept("builder", r3store);
        // break;
        // }
      } else if (agent.equals("miner3")) {
        Site s = (Site) planet[middle][middle];
        s.addstore(c3res);
        gui.out("Agent C dropped gold at home base");
        // switch (c3res) {
        // case 1:
        addPercept("builder", r1store);
        // break;
        // case 2:
        // addPercept("builder", r2store);
        // break;
        // case 3:
        // addPercept("builder", r3store);
        // break;
        // }

      }

    } else if (action.getFunctor().equals("move_towards")) {

      int x = (new Integer(action.getTerm(0).toString())).intValue();
      int y = (new Integer(action.getTerm(1).toString())).intValue();

      if (agent.equals("miner1")) {

        if (miner1[X] < x)
          miner1[X]++;
        else if (miner1[X] > x)
          miner1[X]--;
        if (miner1[Y] < y)
          miner1[Y]++;
        else if (miner1[Y] > y)
          miner1[Y]--;

      } else if (agent.equals("miner2")) {

        if (miner2[X] < x)
          miner2[X]++;
        else if (miner2[X] > x)
          miner2[X]--;
        if (miner2[Y] < y)
          miner2[Y]++;
        else if (miner2[Y] > y)
          miner2[Y]--;

      } else if (agent.equals("miner3")) {

        if (miner3[X] < x)
          miner3[X]++;
        else if (miner3[X] > x)
          miner3[X]--;
        if (miner3[Y] < y)
          miner3[Y]++;
        else if (miner3[Y] > y)
          miner3[Y]--;

      }

    }

    updatePercepts(agent);
    informAgsEnvironmentChanged();

    try {
      Thread.sleep(200);
    } catch (Exception e) {}


    // gui.out(getPercepts("miner1").toString()+getPercepts("miner2").toString()+getPercepts("miner3").toString()+getPercepts("builder").toString());
    gui.update();

    return true;

  }

  void updatePercepts(String agent) {
    if (agent.equals("miner1")) {
      clearPercepts("miner1");
      miner1_position = Literal.parseLiteral("current_miner_position(" + miner1[X] + "," + miner1[Y] + ")");
      addPercept("miner1", miner1_position);

      if (resourcemap[miner1[X]][miner1[Y]]) {
        Resource r = (Resource) planet[miner1[X]][miner1[Y]];
        // int resource = r.getType();
        resC1 = Literal.parseLiteral("found");
        addPercept("miner1", resC1);
      }
    } else if (agent.equals("miner2")) {
      clearPercepts("miner2");
      miner2_position = Literal.parseLiteral("current_miner_position(" + miner2[X] + "," + miner2[Y] + ")");
      addPercept("miner2", miner2_position);

      if (resourcemap[miner2[X]][miner2[Y]]) {
        Resource r = (Resource) planet[miner2[X]][miner2[Y]];
        // int resource = r.getType();
        resC2 = Literal.parseLiteral("found");
        addPercept("miner2", resC2);
      }
    } else if (agent.equals("miner3")) {
      clearPercepts("miner3");
      miner3_position = Literal.parseLiteral("current_miner_position(" + miner3[X] + "," + miner3[Y] + ")");
      addPercept("miner3", miner3_position);

      if (resourcemap[miner3[X]][miner3[Y]]) {
        Resource r = (Resource) planet[miner3[X]][miner3[Y]];
        // int resource = r.getType();
        resC3 = Literal.parseLiteral("found");
        addPercept("miner3", resC3);
      }
    }
  }

  public PlanetCell[][] getPlanet() {
    return planet;
  }

  public int[] geta1() {
    return miner1;
  }

  public int[] geta2() {
    return miner2;
  }

  public int[] geta3() {
    return miner3;
  }

  public void stop() {
    super.stop();
    gui.dispose();
  }
}
