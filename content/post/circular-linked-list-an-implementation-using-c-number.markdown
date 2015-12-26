+++
categories = ["programming", "datastructures", "c#"]
date = "2009-08-18T12:59:50+05:30"
description = ""
keywords = []
title = "Circular linked list – An implementation using C#"
+++

In this post, I will explain about creating a circular doubly linked list using C#. .NET framework provides a doubly linked list implementation in System.Collections.Generic.LinkedList<T> class . But this class is not providing the behavior of a circular linked list and it is very tough to extend for supporting circular linked list requirements.

In a normal doubly linked list, each node will have a link to its previous and next nodes. In a circular doubly linked list, tail node’s next node will be head and head node’s previous node will be tail. Here is an image taken from wikipedia which visualizes circular linked list.

![Alt text](images/posts/circular_linked_list.png "Circular linked list")

 Here is our requirements for the circular linked list

* Adding items to the list should be O(1).
* Provide similar interface like the standard LinkedList<T> class.
* Keep items in a type-safe way.
* Avoid using collections like List or array internally for keeping items.
* Should provide access to Head and Tail
* Option to enumerate all items
* Reverse enumeration
* Access items with an index.
* Maintain collection semantics.

Here is the class diagram.

![Alt text](images/posts/classdiagram1.png "Class diagram")

Node&lt;T&gt; class
--------------

> Every problem can be solved by adding another layer of indirection.

Node class is a layer of indirection added to hold the linked list value. It manages the next and previous items and provides an option to get the current value. This class is immutable. Here is Node class looks like,

```csharp
/// <summary>
/// Represents a node
/// </summary>
/// <typeparam name="T"></typeparam>
[DebuggerDisplay("Value = {Value}")]
public sealed class Node<T>
{
    /// <summary>
    /// Gets the Value
    /// </summary>
    public T Value { get; private set; }

    /// <summary>
    /// Gets next node
    /// </summary>
    public Node<T> Next { get; internal set; }

    /// <summary>
    /// Gets previous node
    /// </summary>
    public Node<T> Previous { get; internal set; }

    /// <summary>
    /// Initializes a new <see cref="Node"/> instance
    /// </summary>
    /// <param name="item">Value to be assigned</param>
    internal Node(T item)
    {
        this.Value = item;
    }
}
```

CircularLinkedList&lt;T&gt; class
-------------------
Keeping the requirements in mind, let us start writing the generic CircularLinkedList<T>. Some linked list implementations maintains only a link to the head node and when adding a new item to the list, each node in the list has to be traveled till tail node is found and this gives O(n) complexity for the algorithm.

Maintaining link to head and tail helps us to do insertions with a O(1) complexity. In such cases, list traversal is not required. All we need is to change the pointer in the tail node. Head and tail node are member variables of CircularLinkedList class.

```csharp
public sealed class CircularLinkedList<T>
{
    [DebuggerBrowsable(DebuggerBrowsableState.Never)]
    Node head = null;

    [DebuggerBrowsable(DebuggerBrowsableState.Never)]
    Node tail = null;
}
```

To add an item to the last, we need to create a new node from the supplied item. Set the new node’s next pointer pointing to the list’s head and previous pointing to the tail. Finally, tail will be replaced with the new node. Here is the `AddLast()` method implementation.

```csharp
public void AddLast(T item)
{
    // if head is null, then this will be the first item
    if (head == null)
        this.AddFirstItem(item);
    else
    {
        Node<T> newNode = new Node<T>(item);
        tail.Next = newNode;
        newNode.Next = head;
        newNode.Previous = tail;
        tail = newNode;
        head.Previous = tail;
    }
    ++count;
}

void AddFirstItem(T item)
{
    head = new Node<T>(item);
    tail = head;
    head.Next = tail;
    head.Previous = tail;
}
```

We can easily add another method that will add item to the first position in the list. Implementation looks similar like `AddLast()`. Unlike `AddLast()`, head node’s previous pointer will be re-pointed to the new node. The new node’s previous and next pointer will be pointed to tail and head respectively. Finally head will be replaced with the new node.

```csharp
public void AddFirst(T item)
{
    if (head == null)
        this.AddFirstItem(item);
    else
    {
        Node<T> newNode = new Node<T>(item);
        head.Previous = newNode;
        newNode.Previous = tail;
        newNode.Next = head;
        tail.Next = newNode;
        head = newNode;
    }
    ++count;
}
```

Finding an item from the list will have a `O(n)` complexity as it needs to traverse through all items in the list until we get a matching item. Here is a recursive implementation.

```csharp
public Node<T> Find(T item)
{
    Node<T> node = FindNode(head, item);
    return node;
}

Node<T> FindNode(Node<T> node, T valueToCompare)
{
    Node<T> result = null;
    if (comparer.Equals(node.Value, valueToCompare))
        result = node;
    else if (result == null && node.Next != head)
        result = FindNode(node.Next, valueToCompare);
    return result;
}
```

Providing an iterator to iterate the items in the list will be useful. Since this is a circular linked list, a reverse iterator also makes sense. `yield` keyword makes iterator implementations almost trivial.

```csharp
public IEnumerator<T> GetEnumerator()
{
    Node<T> current = head;
    if (current != null)
    {
        do
        {
            yield return current.Value;
            current = current.Next;
        } while (current != head);
    }
}

public IEnumerator<T> GetReverseEnumerator()
{
    Node<T> current = tail;
    if (current != null)
    {
        do
        {
            yield return current.Value;
            current = current.Previous;
        } while (current != tail);
    }
}
```

Removing items from list is also just re-pointing the previous and next pointers of the node’s previous.

```csharp
public bool Remove(T item)
{
    // finding the first occurance of this item
    Node<T> nodeToRemove = this.Find(item);
    if (nodeToRemove != null)
        return this.RemoveNode(nodeToRemove);
    return false;
}

bool RemoveNode(Node<T> nodeToRemove)
{
    Node<T> previous = nodeToRemove.Previous;
    previous.Next = nodeToRemove.Next;
    nodeToRemove.Next.Previous = nodeToRemove.Previous;

    // if this is head, we need to update the head reference
    if (head == nodeToRemove)
        head = nodeToRemove.Next;
    else if (tail == nodeToRemove)
        tail = tail.Previous;

    --count;
    return true;
}
```

Finally, an indexer is provided so that list items can be accessed using an index. Like `Find()` method, this also has a `O(n)` complexity.

```csharp
public Node<T> this[int index]
{
    get
    {
        if (index >= count || index < 0)
            throw new ArgumentOutOfRangeException("index");
        else
        {
            Node<T> node = this.head;
            for (int i = 0; i < index; i++)
                node = node.Next;
            return node;
        }
    }
}
```

To get a collection semantics and maintain similar interface like the standard LinkedList, we implement `ICollection<T>` and `IEnumerable<T>` interfaces.

```csharp
public sealed class CircularLinkedList<T> : ICollection<T>, IEnumerable<T>
{
    // code
}
```

Test harness
-----------
Following code shows how this class can be used,

```csharp
static void Main(string[] args)
{
    CircularLinkedList<int> list = new CircularLinkedList<int>();
    list.AddLast(1);
    list.AddLast(2);
    list.AddLast(3);
    Console.WriteLine("List count = {0}", list.Count);
    Console.WriteLine("Head  = {0}", list.Head.Value);
    Console.WriteLine("Tail  = {0}", list.Tail.Value);
    Console.WriteLine("Head's Previous  = {0}", list.Head.Previous.Value);
    Console.WriteLine("Tail's Next  = {0}", list.Tail.Next.Value);
    Console.WriteLine("************List Items***********");
    foreach (int i in list)
        Console.WriteLine(i);

    Console.WriteLine("************List Items in reverse***********");
    for (IEnumerator<int> r = list.GetReverseEnumerator(); r.MoveNext(); )
        Console.WriteLine(r.Current);

    Console.WriteLine("************Adding a new item at first***********");
    list.AddFirst(0);
    foreach (int i in list)
        Console.WriteLine(i);

    Console.WriteLine("************Adding item before***********");
    list.AddBefore(2,11);
    foreach (int i in list)
        Console.WriteLine(i);

    Console.WriteLine("************Adding item after***********");
    list.AddAfter(3, 4);
    foreach (int i in list)
        Console.WriteLine(i);

    Console.ReadKey();
}
```

Possible expansions
----------------
There are good and complex features that can be added to this list. Here are few that will be useful,

* Remove duplicate nodes.
* Move nodes around.
* Sorting.

Probably we will see these features in another post.
