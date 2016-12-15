An application showing a view containing a list of items representing images.
The data for the content are obtained by calling the Getty Images API.
With infinite scrolling pagination.

Getty Images API
Details about the API itself can be found here: http://developers.gettyimages.com/api/docs/ but the basics are as follows:
API endpoint: https://api.gettyimages.com:443/v3/search/images
Parameters used in this example:
page: Request results starting at a page number
page_size: Request number of images to return in each page.
phrase: Search images using a search phrase.
API Key: 4x3mqfykgft2uj2zynnw4b9w
The API key is provided using the http header "Api-Key"
Sample URL: https://api.gettyimages.com:443/v3/search/images?page=1&page_size=10&phrase=mobile
In this example we display following elements for each image:
Id 
Title
Caption (This is shown as a popup when the user taps the image)
