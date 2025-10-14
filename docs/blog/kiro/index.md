# Experimenting with Kiro

Recently we've all been hearing about vibe coding[^1]. Some people are ecstatic about it, while others are very negative.
I've been using CoPilot for a few years now, and I definitely think it's a big help. Whether it's writing function
documentation or converting a normal loop to using a thread pool executor, it comes in handy. But every time I ask it to
do something that I don't already know how to do, it lets me down with nonsense code. Itt's gotten a lot better since I
started, but it's still dumber than a bag of hammers.

Then I saw an advert for [Kiro] and thought it sounded interesting. Simply put, Kiro is VSCode with a
builtin AI agent that helps you through the flow of designing and implementing an application. Below the hood, it uses
Claude, but it's very well integrated and feels more finished than CoPilot. I signed up for their waiting list and
forgot about, until a few weeks ago, when I got my key. Then In was busy for a while until there was only a week left of
the trial. This coincided with a weekend without chores, so I started playing around with it. This is the second attempt
at a web app from scratch, but the end result of the first attempt was much the same.

I'm a _serviceable_ we developer, but it's not what I do for a living. While I've been making _serviceable_ web apps for
25 years, I return infrequently enough that every time it's like I've traveled a 100 years in time, and none of the
frameworks or languages are the same. Even HTML keeps changing. I wanted the project to be a web app, because it's
something I'm not intimately familiar with, and I wanted to see how helpful the AI actually is. Since I use TypeScript
in my day job, and I've used React in other projects, those are the technologies I settled on here. The rest was picked
by the AI.

[^1]: If you are a late arrival to this page, it was something people thought was cool in 2025.

## The idea

The idea for the app we will make comes from the Copenhagen graffiti artist Spyo. Think of him like Temu Banksy if you
are not familiar. When walking in Copenhagen you constantly come across his work in the form of little birds and
political slogans in bold capital letters. A while ago, my kids and I started photographing them, and it became a bit of
an obsession to find new ones. So I thought it would be cool to map the ones we have on a map, so we can avoid
duplicates and better plan trips to find new ones. Spyo has been doing public defacement for 20+ years and he really
hates capitalists, so there's a lot of art. At the same time, the city and home owners are vicious art critics, so often
some of the art will disappear.

This is the result of using Kiro to make that map site.

## Development

The end goal is a browser-based web application that displays geo-tagged images on an interactive map. Users can browse
images by location, view them in a modal lightbox, navigate between nearby images, and share them on social media. The
application is built as a stateless React/TypeScript web app that can be hosted on any static web server.

As stated, it is not my first attempt at creating a full app with Kiro, but it was the first _partially_ successful.

## Initial prompt

```plaintext
I want to create a browser web-app that displays images on a map. The images are stored in a local folder and contain
geo location metadata.

Using the metadata, I want to display a map using Google Maps where the images are shown on the map in the location
contained in their metadata as a small thumbnail.

Clicking the thumbnail should display the full image in a modal light box. When viewing an image, if there are any other
images on the map within 1 km of the current image, there should be arrow buttons that allow the user to browse those
images as a carousel.

The application should use routing to give each image a unique URL, and there should be social media buttons on the full
image display to allow users to share the image on Twitter/X, Facebook, and Instagram.

* The UI source code should be in Typescript using React
* The app should be runnable from a plain web host, and the app should be stateless apart from data stored in users'
  browsers (cookies, localstorage, etc.)
* The website should be reactive and work both on desktop and mobile devices
* The code should be compressed for distribution to improve performance on slow devices
```

I forget some important stuff, but I get back to it later.

## Pre-development

From the initial prompt, Kiro generated a [requirements document].

Since I forgot about the overhead of scanning 1000's of images for EXIF data, I later had to add a manual
**[Requirement 0]** for a tool to generate an SQLite database from a folder with the data in it.

From the requirements, Kiro then generated a [design document]. After reading it I was mostly happy, but since I don't
care about focal length and camera types, and I do care about any optional additional GPS data, I [updated the design]
to not store that information.

Whenever I edited Kiro's initial drafts of a file, I told Kiro about it in the interactive chat. Not certain that is
important, but in earlier work, Kiro seemed to get confused if I edited fields without saying so. It's possible this is
what the "Refine" and "Update tasks" buttons do.

From the modified design, Kiro generated a [task list]. I skimmed it with less enthusiasm than the previous two, because
at this point I had spent about an hour doing my least favorite thing, _documentation_, and I was keen to get to the
coding. At a glance, the tasks looked fine, although less granular than I expected. I proceeded running the tasks.

## Code generation

During this step, I began running the code generation steps.

### Create Python EXIF extraction script

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/81240ebb05b86f675982689b6bf873a9eb18ded9)

During the running, Kiro asks for permission to run a few commands. While you can grant general trust, I chose to OK
each individual command to forestall a `sudo rm -rf /` scenario. The result was a single Python script,
[`extract_exif.py`] that looked reasonably clear at a glance. Additionally, it created a Python requirements file and
some documentation. The latter I moved into this README file.

The first step was to run the script on a folder, and it looked like it worked, despite some issues. Mainly that it stored
everything inside the scanned folder. As a nice surprise, it pre-generated thumbnails, which is another thing I should
have thought of in the requirements.

I told Kiro to update the requirements for the "extract_exif.py" tool:

- When the script scans a folder it should first create a new folder (if it doesn't exist) in the web application root
  folder called "images", and a sub-folder in images called "thumbnails"
- When the script runs, it should create the SQLite data base in the web application root folder.
- Any file that contains GPS information should be scaled so it isn't larger than 2048 by 2048 pixels while preserving
  aspect ratio, and the new file should be saved in the "images" folder with the same name as its id in the sqlite
  database.
- For any file with GPS data that is processed, its thumbnail should be saved in "images/thumbnails" with the same name
  as its id in the sqlite database.

Another generation step, and the updates were implemented. Next I noticed that there was no reason to store image paths
in the SQLite database since we rename the scaled images to a hash of the original[^2].

[^2]: This is a cool detail, because it allows us to skip regeneration if we add more images to a folder and re-scan it. It also eliminates duplicate images.

### Set up React TypeScript project structure

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/a97656be88332d2e013c248b93d1ec71f05d3e92)

This task was rough. Kiro ran a Vite project bootstrap command which nuked my `README` and `.gitignore` files[^3]. It
also asked questions about technology choices I wasn't super qualified to answer. After a little Googling, I could see
that it was something about the distribution bundling of the TypeScript code so I chose Typescript + SWC. That might
come back to haunt me later. Finally, it started a server, and I had to stop it manually to proceed with Kiro's
generation.

The generation was also rough, with Kiro generating invalid code, but then noticing it, and fixing the issues. It took a
couple of attempts before it was able to run `npm run dev`. The generator also dumps everything in the root folder
making a huge mess, but it seems to work.

[^3]: ... easily restored from Git.

### Implement database service layer

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/c4f14c8)

This created some utilities for reading from SQLite, but it's hard to tell if they will work at a glance, so I leave it
as-is for now, and proceed to the next tasks[^4].

[^4]: In retrospect, I should have noticed that the model had references to "paths". That's going to hurt me in the next step.

### Create Google Maps integration

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/9c0be58)

I was excited to see how this one panned out. Kiro struggled for a long time with it, and in the end generated some code
along with some documentation in a file called `google-maps-setup.md` that I merged into this README.

The instructions for generating an API key are wrong, but I was able to generate one anyway and put it in new `.env`
file. However when starting the DEV server, the app seems to be having trouble reading the database, apparently because
it still assumes the database to have a path column for the files. I will need to fix that.

While explaining the issue to Kiro, I realize that files might potentially have differing file endings, but I notice
that all files are converted to JPEG with the ".jpg" ending during scaling, so that's good.

During the process, Kiro decided to move the image folder and the database into a sub-folder called "public" which I
went along with.

To my immense surprise, the app now starts and shows a map with image locations, even grouping images that were taken
close to each other. The only downside seems to be that the thumbnails are displayed as blank circles for now, instead of
using the thumbnail image.

There is however, an ominous warning in the console, indicating that the code is not up to spec with the latest API.

> As of February 21st, 2024, google.maps.Marker is deprecated. Please use google.maps.marker.AdvancedMarkerElement
> instead. At this time, google.maps.Marker is not scheduled to be discontinued, but
> google.maps.marker.AdvancedMarkerElement is recommended over google.maps.Marker.

This, and a subsequent warning was easily fixed by asking Kiro to update the code appropriately.

### Build image modal and lightbox functionality

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/3c8af3b)

The generation step looked smoother this time, and the app can run without errors. Clicking a map thumbnail correctly
displays the larger image, but the metadata on the image looks broken.

> **Photo taken on Invalid Date**<br/>
> Invalid Date<br/>
> Altitude: 45m<br/>
> 55.646103, 12.614439

Still, very close to the goal. I'm going to leave it for now and move on to the next task.

### Implement nearby image navigation

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/40879a5)

This task ran without a hitch, but only partially implemented the feature. The 1k nearby logic was already in place, and
it is now possible to navigate between images in a group with the arrow keys and swiping on mobile devices. However,
there seems to be some graphics missing for showing an icon to close the lightbox and and for left- and right-arrows. On
closer inspection, it's because the images are stored as inline SVG in the `src\components\ImageModal.tsx` file, which
the browser doesn't support. I tell Kiro to replace them with generic icons from the Font Awesome package, and now it
looks right, at the expense of another 300k of fonts and code.

I noticed later that the actual navigation was bonkers since the group of images would change order every time you moved
right or left, but It's fine for now.

### Add URL routing for image sharing

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/ac220bd)

This step took a long time and when it was complete, it had introduced a bug where the images in the lightbox now used
an invalid URL. Once it was explained to Kiro (twice) it fixed the issue partially. However, the feature doesn't work.
The URL displayed in the browser doesn't work if used directly, so there is an issue with the routing. After some
Googling, the solution was to use a react HashRouter which Kiro could implement. The application now uses HashRouter
instead of BrowserRouter, which means URLs look like `http://hostname/#/image/id` instead of `http://hostname/image/id`.
This works with any static web server without requiring server-side configuration for SPA routing.

### Create social media sharing functionality

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/742de20)

Kiro almost managed this one in the first attempt, but the URLs used in shared links used the old host routing scheme.
It was a very quick fix however, to add `/#` in front of the URL to fix that. Didn't require Kiro's help.

### Skipped tasks

After running "Implement responsive design and mobile optimization" there were no noticeable improvements in the UI, and
an annoying bug had been introduced in the desktop UI that made the layout bounce when using the navigation buttons.

After running "Add performance optimizations", the amount of code almost doubled with no noticeable effect on the load
times. The image lazy loading had no visible effect even when simulating 4G speeds.

In both cases, I reverted the changes and marked the tasks as optional.

### Configure build and deployment setup

[🔗GitHub](https://github.com/mhvelplund/spyo-map/tree/dd35c97)

This was the final step I ran. It added a deployment document with instructions, a lot of metadata headers to the HTML
that I'm not familiar with, and config files for deployment technologies with GitHub Actions, Netlify and Vercel.

I removed Vercel and Netlify stuff, but the plan was always to run the site as a GH page, so I only slightly modify the
GitHub workflow. Among other things, it used ancient versions of Node.js and Python, so I update that. It also assumes
that the images to display are located in Git. For now the action will just have to fail.

I notice that some of the code seems to contain windows path specific code which will probably cause problems for the GH
workflow, but at this point I've spent 7 hours getting this far, and I don't care any more.

## Conclusion

After 8 hours of work, I have a _serviceable_ web app that will show my images on a map. The image navigation is crazy,
but technically that's because I wasn't specific enough when I asked Kiro to make it. The descriptions for the full size
images are obviously broken, but I suspect it's simple to fix. It seems related to the way timestamps are stored as text
in the SQLite database but expected to be timestamps in UI. Again something I could probably have fixed by adding it to
the design- or requirements documents. In general, a lot of the early errors were due to me forgetting things or not
being specific enough.

As development progressed however, I started seeing more errors that were due to Kiro/Claude hallucinating some code or
getting the import order wrong for modules. I also saw examples of one step breaking the work of the previous step, and
then when called out, claiming to understand and fix the problem, only to not do it. That experience was _very much_
like working with an eager younger colleague 😂.

My general feeling was that Kiro was providing diminishing returns as the code got more complex. Some of the changes I
reverted seemed to add huge chunks of unnecessary code, or breaking layout changes. It is as if Kiro, as it had to work
with more of it's own generated code, started to get confused. I've heard this also happens when you try to train models
on generated text, so it makes sense that it would happen here too.

Where Kiro was a huge help was in the beginning. Formalizing requirements and getting a boiler plate app up and running.
After the first two hours, I think I could have done the remaining tasks faster and better myself with Google,
StackOverflow, and CoPilot. "Doing it myself" also makes the app easier to maintain because it's not just a bag of other
people's code, where I have to guess at the decisions. This is especially important since Kiro's usefulness drops off as
it tries to update and maintain its own code.

All in all, I don't think I'm going to shell out for Kiro before we get a bit further towards the singularity ...

## Nice to haves

While working on the app, I noticed that most of the images had a built-in direction vector. I think it would be cool to
have that visualized on the overview map.

I also got a request from my daughter to add automatic blurring of people in the images to the import script. She's from
a generation that is more aware of the effect of becoming internet famous because you look lame in someone else's
picture ☺️

<!-- Links -->

[`extract_exif.py`]: https://github.com/mhvelplund/spyo-map/blob/main/extract_exif.py
[design document]: https://github.com/mhvelplund/spyo-map/blob/73d1e03bdc4a96edcd929cfa6ac24180fd51ed52/.kiro/specs/geo-image-map-browser/design.md
[Kiro]: https://kiro.dev
[Requirement 0]: https://github.com/mhvelplund/spyo-map/blob/main/.kiro/specs/geo-image-map-browser/requirements.md#requirement-0
[requirements document]: https://github.com/mhvelplund/spyo-map/blob/d414542419026f3cdc43e075e999a4beb97f2c40/.kiro/specs/geo-image-map-browser/requirements.md
[task list]: https://github.com/mhvelplund/spyo-map/blob/4067f43b8f312d6fdb1b8ebdb8912c2c4d9b9d0a/.kiro/specs/geo-image-map-browser/tasks.md
[updated the design]: https://github.com/mhvelplund/spyo-map/blob/main/.kiro/specs/geo-image-map-browser/design.md#2-database-service-srcservicesdatabaseservicets
