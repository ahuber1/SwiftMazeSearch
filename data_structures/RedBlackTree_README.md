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
3. All leaves (`NIL`) are black.
4. If a node is red, then both of its children are black.
5. Every path from a given node to any of its descendant `NIL` nodes contains the same number of black
   nodes. With this said, there are a few useful definitions:
  * **Black depth** is the number of black nodes from the root to a node
  * **Black height** is the uniform number of black nodes in all paths from the root to the leaves.

![The image of a Red Black Tree no longer exists on Wikipedia][img:rbt]

## Insert Cases

For all of the cases below, we explain the case, and give an explanation as to which properties of a Red Black Tree still hold even after we made changes to the tree during that insertion case. However, we omit two properties in each explanation because they are unnecessary.

| Property Number | Why this property does not need to be explained in each insertion case                                   |
| --------------: | :------------------------------------------------------------------------------------------------------- |
| 1               | In every insertion case, the node will either be black or red, and each node may be recolored, but we will recolor them as red if they were black, or black if they were red; this property will _always_ hold.                         |
| 3               | Our code will consider all leaves as black, _always_.                                                    |

It is also important to remember that, in a Red Black Tree, _all_ newly inserted nodes are red at first.

### Case 1
In this case, the current node `N` is the root of the tree. In this case, it is repainted black.

| Property Number | Why this property still holds                                                                            |
| --------------: | :------------------------------------------------------------------------------------------------------- |
| 2               | Because the current node is `N` and it was repainted black, this property still holds.                   |
| 4               | The other cases ensure that this property still holds for insertions where the number of nodes in the tree is greater than one. If `N` is the only node in the tree, then this property still holds because of Property 3 (all leaves are black)                                                                                                                       |
| 5               | Even if the root _was_ red and is _now_ black, the number of nodes from any given node (in this instance, the root, to all leaf nodes is _still_ the same; we just increased that number by one. Therefore, this property still holds. |

```C
void insert_case1(struct node *n)
{
 if (n->parent == NULL)
  n->color = BLACK;
 else
  insert_case2(n);
}
```
### Case 2
**Precondition(s): `N` is red, `N` has a parent.**

In this case, the current node's parent `P` is black.

| Property Number | Why this property still holds                                                                            |
| --------------: | :------------------------------------------------------------------------------------------------------- |
| 2               | It is possible that `P` is the root of the tree, but because this insertion case immediately returns if `P` is black, this property still holds. If `P` is _not_ the root of the tree, then this property is not threatened.         |
| 4               | Regardless of the color of `P`, `N` is still red because it is either a newly-inserted node, which is always red, or a red node passed in by another insertion case. Therefore, if `P` is black, then we do not care about the color of `N`, which is why the code immediately returns in that case. However, if `P` is red, then we need to move onto the third insertion case to see if this property still holds.                                                                          |
| 5               | If `P` is black, then the number of nodes from `P` to any of its descendant nodes has not changed because `N` is red. However, if `P` is red, then we need to see if this property still holds, and move onto the third insertion case.|

```C
void insert_case2(struct node *n)
{
 if (n->parent->color == BLACK)
  return; /* Tree is still valid */
 else
  insert_case3(n);
}
```

### Case 3
**Precondition(s): `N` is red, `P` is red.**

Because of **Case 1**, we have determined that `N` is _not_ the root of the tree, and because of **Case 2**, we have determined that `P` is red. In this case, we have to see if there is an uncle of `N`; this uncle is called `U`.


| Property Number | Why this property still holds                                                                            |
| --------------: | :------------------------------------------------------------------------------------------------------- |
| 2               | Because this insertion case does not change the color of `P` and `N` is not the root, this condition still holds.                                                                                                                       |
| 4               | If `P` and `U` are red, then `P` and `U` are repainted black, and the grandparent `G` becomes red. Because of this, the children of `G` (`P` and `U`) are both black. Although `N` is red, it is either a newly added node with no children, thereby making this property hold, or its children are black because the other insertion cases already corrected the tree, making this condition hold in that scenario as well.                                                                  |
| 5               | In order to maintain this property, `P` and `U` are repainted black, and the grandparent `G` becomes red if `P` and `U` are red. We know that `P` is red because it is a precondition, and `U` is red because this code tests for it. Repainting `G` red also ensures that the black height does not change, but in order to ensure that another property is not violated, we recursively call `insert_case1` on `G`. If `U` does not exist _or_ it is black, we go to the fourth case to ensure this property holds. |

```C
void insert_case3(struct node *n)
{
  struct node *u = uncle(n),
  struct node *g = n->parent->parent;

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

### Case 4
**Precondition(s): `N` is red, `P` is red, `U` either does not exist or is black.**

During the following scenario, we perform a left rotation on the current node's parent `P` that switches the role of the current node `N` and its parent `P` _so long as `P` is the left child of its parent `G`_. If `P` is the _right_ child of `G`, then a _right_ rotation is performed.

| Property Number | Why this property still holds                                                                            |
| --------------: | :------------------------------------------------------------------------------------------------------- |
| 2               | If `G` is the root of the tree, then its color does not change as a result of the tree rotation. If `G` is not the root of the tree, then this property is not violated.                                                                |
| 4               | `P` is red and its child `N` is red, making this a violation of this property. This violation is dealt with by calling the `insert_case5`.                                                                                          |
| 5               | The rotation causes some paths labeled in subtree "3" to not pass through the node `P` where they did before. However, both `N` and `P` are red, so this property is not violated by the rotation.                                 |

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

  n = n->left; // this makes us pass in the previous parent (P) to insert_case5

 } else {
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

  n = n->right; // this makes us pass in the previous parent (P) to insert_case5
 }
 insert_case5(n);
}
```

![The image of Insertion Case 4 no longer exists on Wikipedia][img:insert4]

### Case 5
**Precondition(s): `N` is red, `P` is red, `U` either does not exist or is black, `G` is black since its former child `P` could not have been red otherwise without violating Property 4.**

During the following scenario, the colors of the current node's parent and grandparent, `P` and `G`, are switched (i.e., repainted black and red, respectively) so that Property 4 is satisfied. Then, a right rotation on `G` is performed, resulting in a tree where the former parent `P` is now the parent of both the current node `N` and the former grandparent `G` so long as `N` is the left child of `P`. If `N` is the right child of `P`, a _left_ rotation is performed instead.

| Property Number | Why this property still holds                                                                            |
| --------------: | :------------------------------------------------------------------------------------------------------- |
| 2               | If `G` is the root, then it it is swapped with `P`, which is black. If `G` is not the root, then this property is not violated.                                                                                                    |
| 4               | Because `P` becomes black, the correction that was needed to make this property hold was performed.      |
| 5               | This property remains satisfied because all paths that went through `N`, `P`, and `U` went through `G` and now they go through `P`.                                                                                                   　|

```C
void insert_case5(struct node *n)
{
  struct node *g = n->parent->parent

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
