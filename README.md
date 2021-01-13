# flutter_bouncy

![Logo](https://github.com/pstromberg98/flutter_bouncy/blob/master/media/logo.png)

Slivers and list widgets that add a natural springy effect to their items when scrolling

## Quick Features

↕️ &nbsp;Horizontal and vertical scroll direction support

🧠 &nbsp;Sliver implementations for use in existing CustomScrollView's

⛓ &nbsp;Customizable spring/bounce settings with Flutter's `SpringDescription`

👻 &nbsp;Includes an animated bouncy list that works exactly the same as `AnimatedList`

## Examples

<img src="https://github.com/pstromberg98/flutter_bouncy/blob/master/media/example1.gif" width="150" /><img src="https://github.com/pstromberg98/flutter_bouncy/blob/master/media/example2.gif" width="150" />

## How to use

For use in a `CustomScrollView` use `SliverBouncyList`/`SliverAnimatedBouncyList`. The api is orthogonal to the `SliverList`/`SliverAnimatedList`

```
@override
Widget build(BuildContext context) {
  return CustomScrollView(
    slivers: [
       SliverBouncyList(
        delegate: SliverChildListDelegate(
          [
            // Children here
          ],
        ),
      );
    ],
  );
}

```

If you don't need the Sliver versions then you can just use `BouncyList`/`AnimatedBouncyList`. The api is orthogonal to `ListView`/`AnimatedListView`

```
@override
Widget build(BuildContext context) {
  return BouncyList(
    children: [
      // Children here
    ]
  );
}

```
