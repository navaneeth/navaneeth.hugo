+++
date = "2014-09-28 11:29:28 +0530"
title = "Hiding menu when clicking outside - AngularJS"
categories = ["programming", "angularjs", "web"]
+++

Assume you have a menu which looks like the following:

{{< highlight html >}}
<div class="right-menu" ng-click="toggleMenu($event);">
  <img src="img/RightMenuIcon.png" alt="" />
</div>

<div ng-show="menuOpened" class="menu-dropdown-right">
  <ul>
    <li ng-hide="loggedIn" class="class"><a href="#/authenticate">Login</a>
    </li>
    <li ng-show="loggedIn"  ng-click="logOut()"><a href="#">Logout</a>
    </li>
  </ul>
</div>
{{< /highlight >}}

When the div gets a click event, angular calls `toggleMenu` which toggles the `menuOpened` variable. Changing the value of this variable in turn makes the div show/hide.

To hide the menu when clicking outside of the div, we add a `onclick` handler to `window` object which checks the `menuOpened` variable and updates it if the menu is visible.

Here is the code for `MenuCtrl` and the `onclick` handler:

```js
angularApp.controller('MenuCtrl', ['$scope', '$location', '$rootScope',

  function($scope, $location, $rootScope) {

		$scope.menuOpened = false;

		$scope.toggleMenu = function(event) {
			$scope.menuOpened = !($scope.menuOpened);

      // Important part in the implementation
      // Stopping event propagation means window.onclick won't get called when someone clicks
      // on the menu div. Without this, menu will be hidden immediately
			event.stopPropagation();
		};

		window.onclick = function() {
			if ($scope.menuOpened) {
				$scope.menuOpened = false;

        // You should let angular know about the update that you have made, so that it can refresh the UI
				$scope.$apply();
			}
		};
	}
]);
```
