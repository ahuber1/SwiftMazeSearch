# Explanation of the Red Black Tree

In the Red Black Tree, there are five insert cases and six remove cases. Rather than explaining 
them in the comments of the code, I thought it would be best to explain how these cases work and the
logic behind them in this README. My code for the five insert cases and six remove cases was 
translated from the C-style psuedocode on 
[Wikipedia's page on Red Black Trees](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree). The 
explanations of each of the cases have been rephrases from their originals on the Wikipedia page.

## Properties of a Red Black Tree

Before I proceed to the explanations of the insert and delete cases, I think it is important to recap
the properties of a Red Black Tree, and to list them here because we will be mentioning them a lot.

1. Each node is either red or black.
2. The root is black. This rule is sometimes omitted. Since the root can always be changed from red to
   black, but not necessarily vice versa, this rule has little effect on analysis.
3. Allleaves (`NIL`) are black.
4. If a node is red, then both of its children are black.
5. Every path from a gicen node to any of its descendant NIL nodes contains the same number of black
   nodes. With this said, there are a few useful definitions:
  * **Black depth** is the number of black nodes from the root to a node
  * **Black height** is the uniform number of black nodes in all paths from the root to the leaves.
  
![The image of a Red Black Tree no longer exists on Wikipedia][img:rbt]

## Insert Cases

**Case 1.** The current node `N` is at the root of the tree. In this case, it is repainted black
to satisfy Property 2 (the root is black). Property 5 (all paths from any given node to its leaf nodes
contain the same number of black nodes) is not violated since this adds one black node to every path
at once.

```C
void insert_case1(struct node *n)
{
 if (n->parent == NULL)
  n->color = BLACK;
 else
  insert_case2(n);
}
```

**Case 2.** The current node's parent `P` is black, so the fourth property (both children of every
red node are black) still holds. Property 5 (all paths from any given node to its leaf nodes contain the
same number of black nodes) is not threatened because the current node `N` has two black leaf children,
but because `N` is red, the paths through each of its children have the same number of black nodes as the
path through the leaf it replaced, which was black, and so this property still holds.

```C
void insert_case2(struct node *n)
{
 if (n->parent->color == BLACK)
  return; /* Tree is still valid */
 else
  insert_case3(n);
}
```

**Case 3.** In order to maintain Property 5 (all paths from any given node to its leaf nodes contan the
same number of black nodes), the parent `P` and the uncle `U` are repainted black and the grandparent `G`
becomes red if `P` and `U` are red.

```C
void insert_case3(struct node *n)
{
  struct node *u = uncle(n), *g;

  if ((u != NULL) && (u->color == RED)) {
    n->parent->color = BLACK;
    u->color = BLACK;
    g = grandparent(n);
    g->color = RED;
    insert_case1(g);
   } 
   else {
    insert_case4(n);
   }
}
```

![The image of Insertion Case 3 no longer exists on Wikipedia][img:insert3]

**Case 4.** During the following scenario, we perform a left rotation on the current node's parent `P`
that switches the role of the current node `N` and its parent `P`.

1. The parent `P` is red
2. The uncle `U` is black
3. The current node `N` is the right child of `P`
4. `P` is the left child of its parent `G`

The former parent node `P` is dealt with using Case 5 (relabeling `N` and `P`) because Property 3
(both children of every red node are black) is still violated. The rotation causes some paths (those
in a subtree labeled "1") to pass through the node `N` where they did not before.

It also causes some paths (those in sub-tree labeled "3") not to pass through the node `P` where they
did before. However, both of these nodes are red, so Property 5 (all paths from any given node to its 
leaf nodes contain the same number of black nodes) is not violated by the rotation.

After this case has been competed, Property 4 (both children of every red node are black) is still
violated, but now we can resolve this by continuing to Case 5.

```C
void insert_case4(struct node *n)
{
  struct node *g = grandparent(n);

  if ((n == n->parent->right) && (n->parent == g->left)) {
    rotate_left(n->parent);

   /*
    * rotate_left can be the below because of already having *g =  grandparent(n) 
    *
    * struct node *saved_p=g->left, *saved_left_n=n->left;
    * g->left=n; 
    * n->left=saved_p;
    * saved_p->right=saved_left_n;
    * 
    * and modify the parent's nodes properly
    */

    n = n->left;

   } 
    else if ((n == n->parent->left) && (n->parent == g->right)) {
      rotate_right(n->parent);

     /*
      * rotate_right can be the below to take advantage of already having *g =  grandparent(n) 
      *
      * struct node *saved_p=g->right, *saved_right_n=n->right;
      * g->right=n; 
      * n->right=saved_p;
      * saved_p->left=saved_right_n;
      * 
      */

      n = n->right; 
  }
  
  insert_case5(n);
}
```

![The image of Insertion Case 4 no longer exists on Wikipedia][img:insert4]

**Case 5.** During the following scenario, a right rotation on the node's grandparent `G` is performed,
resulting in a tree where the former parent `P` is now the parent of both the current node `N` and the
former grandparent `G`.

1. The parent `P` is red
2. The uncle `U` is black
3. The current `N` is the left child of `P`
4. `P` is the left child of its parent `G`

`G` is known to be black, since its former child `P` could not have been red otherwise without violating
Property 4. Then, the colors of `P` and `G` are switchd, and the resulting tree satisfies Property 4
(both children of every node are black). Property 5 (all paths from any given node to its leaf nodes
contain the same number of black nodes) also remains satisfied, since all paths that went through any of
these three nodes went through `G` before, and now they all go through `P`. In each case, this is the only 
black node of the three.

```C
void insert_case5(struct node *n)
{
  struct node *g = grandparent(n);

  n->parent->color = BLACK;
  g->color = RED;
  if (n == n->parent->left)
    rotate_right(g);
  else
    rotate_left(g);
}
```

![The image of Insertion Case 5 no longer exists on Wikipedia][img:insert5]

[img:rbt]: https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Red-black_tree_example.svg/1350px-Red-black_tree_example.svg.png
[img:insert3]: https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Red-black_tree_insert_case_3.svg/2000px-Red-black_tree_insert_case_3.svg.png
[img:insert4]: https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Red-black_tree_insert_case_4.svg/2000px-Red-black_tree_insert_case_4.svg.png
[img:insert5]: https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Red-black_tree_insert_case_5.svg/2000px-Red-black_tree_insert_case_5.svg.png
