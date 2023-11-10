<!DOCTYPE html>
<html>
<head>
    <h1>Ping Sweep script in Bash</h1>
</head>
<body>
    <p>A ping sweep or ICMP sweep is a basic network scanning technique, used to map a network’s IP addresses to live hosts (To discover available computers). This is useful in cybersecurity for many reasons, as I will mention.</h2>
  <h5>Offensive Perspective - Pentesting/ReadTeam</h5>
    <p>You can use an ICMP sweep, along with other techniques such as ARP scanning, to discover the hosts of a network you are auditing. These are going to be the future targets you might want to attack as a pentester, expanding the attack surface for possible vulnerabilities.</p>
  <h5>Defensive Perspective - SOC/NOC</h5>
    <p>As a network administrator you can block ICMP echo requests from outside sources, this gives you the possibility to detect an unrecognized device in the network that can be malicious, and ensure the devices are working correctly.</p>
  <h2>How it works</h2>
  <p>A ping sweeper is actually not a complex tool, is based on the ICMP echo request which we can do with the bash command</p><p><code>ping [ip_address]</code>, if the target IP address allows ping requests it will respond with a message similar to the image below:</p><p><code>64 bytes from [ip_address] [flags]</code></p>
    <img src="images/6.png" alt="ping">
  <p>If the network is a /24 network, this means we have 256 possible possible IP addresses, ranging from xxx.xxx.xxx.0 to xxx.xxx.xxx.255, but not all these are actually useful addresses, we have to consider that the .0 is used for the network address, and the .255 is used for broadcasting, these are not usually valid targets, so we are left with 254 addresses to ping. So all we have to do is iterate through the range xxx.xxx.xxx.1 to xxx.xxx.xxx.254 and send a ICMP echo request to each of them, luckily for us this is an easy task for a computer since each ping request usually takes the order of milliseconds.</p>
    <h2>Read the file contents</h2>
    <p>In the image, above, you can see that after the files are opened they are read through the method <code>.read()</code>, this is because to be able to work with the data inside the file it has to be a python data type, in this case it is converted to a string and stored inside the variable <code>ip_addresses</code>, this variable, unlike the variable file, is going to be useful to work with the data outside the <code>with</code> statement. It is essential that the lines of code that are meant to be inside the <code>with</code> statement are properly indented, this way we prevent errors.</p>
    <h2>Convert the strings into lists</h2>
    <p>It is convenient to convert the string into a list, this way it’s easier to iterate through each element of the list to compare them. This is done using the <code>.split()</code> method, the method separates the strings based on a specified character passed into <code>.split()</code> as an argument, if you do not pass any arguments then it separates the string based on the blank spaces, such as a space or a new line (<code>\n</code>). After that the list is reassigned to the same variable, <code>ip_addresses</code> or <code>remove_ip</code>, as you can see in the image below, the data is being separated by blank spaces.</p>
    <img src="images/2.png" alt="read file">
    <h2>Iterate through the allow list</h2>
    <p>The next step is to search through the allow list for any IP address that has to be removed due to employees changing to tasks that do not need access to that information. I did this with a <code>for</code> loop, a loop that iterates over a sequence, using the <code>ip_addresses</code> list as the guide sequence. It is also worth noting the temporal variable <code>ip</code>, this variable is temporarily created to be used inside the <code>for</code> loop, and it will take the values of each element of the list.</p>
    <img src="images/3.png" alt="Iterate">
    <h2>Remove the IP addresses in the remove list</h2>
    <p>To be able to identify if there are IP addresses in the allow list that should not be there a conditional, <code>if</code> statement, is used inside the <code>for</code> loop, this way the condition is tested on every element of the <code>ip_addresses</code> list, in this case the condition is that the element has to be inside the remove list, as it’s shown on the image above <code>ip in remove_ip:</code>. If the condition is met then the next line of code is executed <code>ip_addresses.remove(ip)</code>, <code>.remove()</code> is a method that removes the first match of its argument on a given list.</p>
    <h2>Update the file</h2>
    <p>Now that the <code>ip_addresses</code> variable only has the correct IP addresses it’s time to write the data into a new updated file, or simply update the old one. To facilitate this, I change data types from list to string, using the method <code>.join()</code>, this method is a bit different that the others, since the list you want to convert to a string (<code>ip_addresses</code>) goes inside the argument of the method, and the string that is going to be used to separate each element of the list (<code>“\n”</code>) comes before the point. Then I used the <code>with open()</code> statement, in <code>“w”</code> mode to write into a new file called <code>“updated_allow_list.txt”</code>, if this file does not exist then the function creates it. Finally the data stored on <code>ip_addresses</code> is written into the file variable through the <code>.write()</code> method.</p>
    <img src="images/4.png" alt="Update">
    <h2>Summary</h2>
    <p>With this project I can showcase my understanding of python scripting for automation of repetitive tasks, this greatly helps saving time and reducing human error.That being said, the final script has room for improvements, for example, one serious vulnerability that I can see is the fact that if an IP address is repeated inside the allow list, then this code is not going to remove it, this way an attacker just have to insert its IP address twice in the allow list and would be safe from being removed. As you can see here:</p>
    <table>
      <tr>
        <td><img src="images/5.png" alt="Example 1"></td>
        <td><img src="images/6.png" alt="Example 2"></td>
      </tr>
      <tr>
        <td>Before the script ran</td>
        <td>After the script ran</td>
      </tr>
    </table>
    <p>All IP addresses were removed successfully except the highlighted ones, this is because the .remove() method just removes the first matching element of the list but the highlighted were repeated. For this reason I kept the PEP 8 style guidelines in mind, as a result the code is more readable and has comments that might help others, or myself, update and patch the code if needed.</p>
</body>
</html>
