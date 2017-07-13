<html>
<?php
  /*! \file temperature.php
   * \brief The website with the core temperature display.
   *
   * This is the website of Fast and Curious which shows the core temperature trend of the processor. It needs the file generated from the script temperature.sh and shows a graph since the NanoPi is running with the temperature every 60 seconds.
   */
  ?>
<head>
<script type="text/javascript"
  src="dygraph.js"></script>
<link rel="stylesheet" src="dygraph.css" />
</head>
<body>
<div id="graphdiv3"
  style="width:800px; height:300px;"></div>
<script type="text/javascript">
  g3 = new Dygraph(
    document.getElementById("graphdiv3"),
    "temperatures.csv",
    {
      rollPeriod: 7,
      showRoller: true
    }
  );
</script>
</body>
</html>
