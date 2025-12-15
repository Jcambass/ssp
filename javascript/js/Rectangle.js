function Rectangle(x, y, width, height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;

    this.Intersects = function (rect) {
        return !(((rect.y + rect.height) < (this.y)) ||
        (rect.y > (this.y + this.height)) ||
        ((rect.x + rect.width) < this.x) ||
        (rect.x > (this.x + this.width)));
    }
}