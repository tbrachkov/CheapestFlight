# CheapestFlight

This is a sample project to demostrate how to find the cheapest path from two location. 
To calculate that I use `GameplayKit` from Apple standard iOS SDK.
The object it provides is `GKGraph` and `GKGraphNode`. Building my graph structure by parsing the JSON file returned from the backend and then calling `func findPath(from startNode: GKGraphNode, to endNode: GKGraphNode) -> [GKGraphNode]` is the key solution to this problem. I do find this solution straight forward and hope you like it. If you don't like this solution implementation of a Graph structure and Dijkstra's algorithm would give the same results, however `GameplayKit` seems to be delivering great simplicity and performace at the same time.

The app has been tested using UnitTests and UITests. Line code coverage is 93.4%. Please see the image in the folder.

![Test result](https://i.ibb.co/X5xpn1L/Screenshot-2019-01-18-at-10-46-14.png)

Both bonus tasks have been implemented.
Please feel free to browse the code and the tests, and ask any further questions.
