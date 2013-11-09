Blazingly fast image (de)serialization, when speed is more important then memory and disk storage.

What's in the box:

* function `UIImageRAWRepresentation` returning `NSData` representation of `UIImage`

* class method `+[UIImage az_imageWithRawData:]` used to parse data back into `UIImage`.

Basically it stores raw image data with some metadata that allows to restore the image when needed. Please refer to the following comparison table to figure out if this library is suitable for your purposes

# Encoding time [^time]

Image size | PNG | JPEG[^jpeg-quality] | RAW
 - | - | - | -
100x100 | 0.535747 | 0.275100 | 0.060641
500x432 | 14.350732 | 1.757291 | 0.643586
5120x2880 | 1661.078830 | 159.876962 | 94.347669

# Decoding time

Image size | PNG | JPEG | RAW 
 - | - | - | -
100x100 | 0.057559 | 0.091868 | 0.060641
500x432 | 0.088384 | 0.101668 | 0.004174
5120x2880 | 0.098181 | 0.162210 | 0.004557

# File size [^file-size]

Image size | PNG | JPEG | RAW
- | - | - | -
100x100 | 5419 | 2777 | 40036
500x432 | 318015 | 44583 | 684036
5120x2880 | 36366039 | 4520381 | 58982436

[^jpeg-quality]: JPEG quality was set to `0.75`.
[^time]: Encoding and decoding time is in milliseconds.
[^file-size]: Data size in bytes.
