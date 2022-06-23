package env;

public class Resource extends PlanetCell {

  private int amount;

  public Resource(int amount1) {
    amount = amount1;
  }

  public int getAmount() {
    return amount;
  }

  public void mine() {
    amount--;
  }

  public boolean depleted() {
    return amount < 1;
  }

}
