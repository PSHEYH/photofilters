import 'dart:typed_data';

import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/models.dart';

///The [ColorSubFilter] class is the abstract class to define any ColorSubFilter.
abstract class ColorSubFilter extends SubFilter {
  ///Apply the [SubFilter] to an Image.
  RGBA applyFilter(RGBA color);
}

///The [ColorFilter] class to define a Filter which will applied to each color, consists of multiple [SubFilter]s
class ColorFilter extends Filter {
  List<ColorSubFilter> subFilters;
  ColorFilter({required String name})
      : subFilters = [],
        super(name: name);

  @override
  void apply(Uint8List pixels, int width, int height) {
    for (int i = 0; i < pixels.length; i += 4) {
      RGBA color = RGBA(
          red: pixels[i],
          green: i + 1 != pixels.length ? pixels[i + 1] : 0,
          blue: i + 2 != pixels.length ? pixels[i + 2] : 0,
          alpha: i + 3 != pixels.length ? pixels[i + 3] : 0);
      for (ColorSubFilter subFilter in subFilters) {
        color = subFilter.applyFilter(color);
      }
      pixels[i] = color.red;
      if (i + 1 != pixels.length) {
        pixels[i + 1] = color.green;
      }
      if (i + 2 != pixels.length) {
        pixels[i + 2] = color.blue;
      }
      if (i + 3 != pixels.length) {
        pixels[i + 3] = color.alpha;
      }
    }
  }

  void addSubFilter(ColorSubFilter subFilter) {
    subFilters.add(subFilter);
  }

  void addSubFilters(List<ColorSubFilter> subFilters) {
    this.subFilters.addAll(subFilters);
  }
}
