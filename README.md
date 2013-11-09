# About

Blazingly fast image (de)serialization, when speed is more important then memory and disk storage.

What's in the box:

* function `UIImageRAWRepresentation` returning `NSData` representation of `UIImage`

* class method `+[UIImage az_imageWithRawData:]` used to parse data back into `UIImage`.

Basically it stores raw image data with some metadata that allows to restore the image when needed. Please refer to the following comparison table to figure out if this library is suitable for your purposes

## Encoding time

<table>
<thead>
<tr>
<th>Image size </th>
<th>PNG</th><th>JPEG</th><th>RAW</th>
</tr>
</thead>
<tbody>
<tr>
<td>100x100 </td>
<td>0.535747</td><td>0.275100</td><td>0.060641</td>
</tr>
<tr>
<td>500x432 </td>
<td> 14.350732 </td><td> 1.757291 </td><td> 0.643586</td>
</tr>
<tr>
<td>5120x2880 </td>
<td> 1661.078830 </td><td> 159.876962 </td><td> 94.347669</td>
</tr>
</tbody>
</table>

## Decoding time

<table>
<thead>
<tr>
<th>Image size </th>
<th> PNG </th>
<th> JPEG </th>
<th> RAW</th>
</tr>
</thead>
<tbody>
<tr>
<td>100x100 </td>
<td> 0.057559 </td>
<td> 0.091868 </td>
<td> 0.060641</td>
</tr>
<tr>
<td>500x432 </td>
<td> 0.088384 </td>
<td> 0.101668 </td>
<td> 0.004174</td>
</tr>
<tr>
<td>5120x2880 </td>
<td> 0.098181 </td>
<td> 0.162210 </td>
<td> 0.004557</td>
</tr>
</tbody>
</table>

## File size

<table>
<thead>
<tr>
<th>Image size </th>
<th>PNG</th><th>JPEG</th><th>RAW</th>
</tr>
</thead>
<tbody>
<tr>
<td>100x100</td>
<td>5419</td><td>2777</td><td>40036</td>
</tr>
<tr>
<td>500x432</td>
<td>318015</td><td>44583</td><td>684036</td>
</tr>
<tr>
<td>5120x2880 </td>
<td>36366039</td><td>4520381</td><td>58982436</td>
</tr>
</tbody>
</table>

# Notes

* JPEG quality was set to `0.75`.
* Encoding and decoding time is in milliseconds.
* Data size in bytes.