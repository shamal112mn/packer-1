function searchFunction() {
    var input, filter, allUlItems, allLiItems, i;
    input = document.getElementById("searchInputServers");
    filter = input.value.toUpperCase();
    allUlItems = document.getElementById("serviceMenu");
    allLiItems = allUlItems.getElementsByTagName("li");
    for (i = 0; i < allLiItems.length; i++) {
        foundItem = allLiItems[i].getElementsByTagName("h4")[0];
        if (foundItem.innerHTML.toUpperCase().indexOf(filter) > -1) {
            allLiItems[i].style.display = "";
        } else {
            allLiItems[i].style.display = "none";
        }
    }
}