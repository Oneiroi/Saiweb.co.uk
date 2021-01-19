---
date: "2008-06-02T14:02:06Z"
tags:
- linux
- green_giant
title: Green Giant - Hardware Estimates
wordpress_id: 62
wordpress_url: https://blog.oneiroi.co.uk/linux/green-giant-hardware-estimates
---
<div style=''>Ok so I have begun to work out the cost implications of doing this ...</p>
<p>On the upshot the concept I have in mind will allow for nodes to be added dynamically.</p>
<p>Anyway onto the "beancounting"</p>
<p>GA-G33M-DSR2 £65.56 (ebuyer)<br />
Corsair 4GB DDR2(800mhz) £65.35 x 2 (£130.7)<br />
Intel core 2 quad Q6600 Energy Efficent 95w 2.4GZ 8mb L2 (4mb per core pair) £126.99</p>
<p>Total: <b><u>£323.25</u></b></p>
<p>----</p>
<p>Example config:</p>
<p>5 Nodes<br />
20 Cpu cores<br />
48 GHZ<br />
40GB Ram<br />
150 Gflops (estimated)</p>
<p>£1616.25 Total<br />
£33.67 / Ghz<br />
£10.78/Gflop/s</p>
<p>-----</p>
<p>Quite a considerable "chunk" of change, anyone any ideas as to cheaper suppliers? my Prices are based on the ebuyer.co.uk costs at the time of writing.</p>
</div>
<p>For US readers £1616.25 @ £1:$1.9432 = $3140.697 total = $628.14 / node</p>

Update based on my previous spec <a href="https://blog.oneiroi.co.uk/linux/green-giant-cluster-project">here</a> 

"<em>Not draw more than a total 30w / GHZ under load (Bringing the 4 node total to just 120w)</em>"

Based on the current _estimated_ 400w @ 48GHZ = 8.33w / GHZ (Well under target) ...

We shall see what the actuall power consumption is once I find an alternate supplier.
