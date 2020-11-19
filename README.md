<!DOCTYPE html>
<html>
<body>
<h1>CloudCover</h1>

<p>A repository for the R functions used to create the simplified word clouds described in Maurits et al 2021</p>

<h2>Setup</h2>

<ol>
	<li>Download the Function.r file in /R and place in your working directory</li>
	<li>Read the functions into your R session using <code>source("/Functions.r")</code></li>
	<li>Make sure you have installed and loaded the required dependencies
	<ul>
		<li><a href="https://cran.r-project.org/web/packages/magick/index.html">magick</a></li>
		<li><a href="https://cran.r-project.org/web/packages/ggplot2/index.html">ggplot2</a></li>
		<li><a href="https://cran.r-project.org/web/packages/gridExtra/index.html">gridExtra</a></li>
		<li><a href="https://cran.r-project.org/web/packages/colorRamps/index.html">colorRamps</a></li>
		</ul>
	</li>
</ol>

<h2>Usage</h2>
<p>The functions <code>plotCloudSA()</code> and <code>plotCloudST()</code> respectively scale words by their surface area and their font size, using the same optional parameters.</p>

<ul>
	<li><code>max_words</code> determines the maximum number of words to include in the plot (integer)</li>
	<li><code>order</code> makes it so the most frequent word is on the bottom and the least frequent on the top (logical)</li>
	<li><code>font</code> determines extra font attributes, 1 = normal, 2 = bold, 3 = italic and 4 = both bold & italic</li>
	<li><code>party</code> assigns random colours to words (logical)</li>
	<li><code>cap</code> determines whether words are in all-caps ("all"), no-caps ("none"), or as provided ("as.is")</li>
</ul>

<p>Input data should be of the format:</p>
<table>
	<tr>
		<th>word</th>
		<th>freq</th>
	</tr>
	<tr>
		<td>Pizza</td>
		<td>15</td>
	</tr>
	<tr>
		<td>Spons</td>
		<td>30</td>
	</tr>
	<tr>
		<td>Gozer</td>
		<td>60</td>
	</tr>
	<tr>
		<td>Krimp</td>
		<td>120</td>
	</tr>
	<tr>
		<td>Joker</td>
		<td>240</td>
	</tr>
</table>

<h2>Examples</h2>
<p>The below images were created using the Script.r file in /R on the identical included example data</p>
<p>Font size scaling method</p>
<img src="/images/ex_font_size.png">
<p>Surface area scaling method</p>
<img src="/images/ex_surface_area.png">

</body>
</html>
