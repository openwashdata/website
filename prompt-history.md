# Prompt History

## 2026-08-17

- 14:45 - The review for pages/blog/posts/2026-06-22-collaboration/index.qmd came back. Please add citation for ERIC dataset (find bibtex entry in page: https://opendata.eawag.ch/dataset/improving-methane-emission-estimates-from-nss-containments) and also explicitly mention the collaboration with Eawag and Makerere University (e.g., "This work was carried out in collaboration the Swiss Federal Institute of Aquatic Science and Technology (Eawag), and Makerere University."). For Makerere add Department of Civil and Environmental Engineering.
- 14:48 - Also update the data package citation: https://openwashdata.github.io/fecalcanuga/
- 14:55 - Commit and push the updates.
- 14:58 - I added this sentence: "The R data package is curated as a website that helps exploring the data: https://openwashdata.github.io/fecalcanuga/". Review and see if this flows well.
- 15:00 - Yes (apply the suggested revision and merge it into the previous paragraph).
- 15:01 - No prompt archive for the commit.

## 2026-08-20

- 16:43 - I have added a PDF with feedback on collaboration blog. Extract all comments and proposed changes, then make a plan for updating the .qmd draft.
- 16:51 - yes, go ahead (apply the planned updates from the PDF feedback).

## 2026-08-24

- 13:42 - the netlify build on github fails: (pasted Netlify build log showing "Unable to locate an installed version of R" while rendering pages/gallery/reports/openwashdata-02/index.qmd).

## 2026-09-07

- 15:35 - i have worked on two blog posts, i want to finalize them now. I want to add the original LinkedIn post where these blogs were shared and claim them as repost from there and Emmanuel as author.
- 15:39 - one link: https://www.linkedin.com/pulse/beyond-publishing-data-what-we-learned-building-open-science-mhango-w1h8f/ the other: https://www.linkedin.com/pulse/i-thought-my-job-data-turned-out-people-emmanuel-mhango-rszvf/
- 15:52 - yes, rename so folders and order match the original (LinkedIn publication dates).
- 15:58 - it should not be on landing mockup branch. use a branch off dev. how about blog?
- 16:04 - I don't like the titles to be capitalizes, use the convention of the other blog posts.
- 16:07 - what's the issue with divergence on main?
- 16:10 - git branch -f main origin/main
- 16:48 - Commit the blog posts
- 16:48 - 1 to 6 (prompts to archive)
- 18:13 - git push -u origin blog-reposts

## 2026-09-08

- 06:23 - Yes pr to dev
- 06:26 - Commit
- 09:45 - git push
- 09:50 - Add these two blog posts as entries to the next openwashdata newsletter, also add news about the brand development announcing a reworked landing page
- 10:15 - voice inbox has a voice note with a conversation about the website mockups, transcribe and identify the suggested changes. Note down any issues that might opening beyond the conversation about the mockup
- 10:28 - it's there now recording 52
- 14:52 - yes, post decision and change list, open issue, then work through change list and create a PR to dev.
- 15:09 - keep some form of FAIR principles in there openwashdata is an active global community that applies FAIR principles to data generated in the greater water, sanitation, and hygiene (WASH) sector
- 15:13 - swap the dataset of the month, we will use https://openwashdata.github.io/solidwastekampala/, the learn part can stay with a note that we are currently preparing the sign-up forms for the 3rd iteration starting around September 2027, but people can browse the course website of the 2025 2nd cohort
- 15:16 - the image of the dataset of the month must be a plot where I see the R code (at least for the plot) inside the code-chunk before, not a png. That is a general rule for all my work with Quarto. It belongs either into memory or a CLAUDE.md at root for all projects.
- 15:17 - on openwashdata/newsletter use the gh issue to document Charles as contributor of the month for sharing his data solidwastekamapala, also add if not there yet that I will prepare a blog about the story of how that data package was created.
- 15:22 - yes, swithc it (newsletter issue 23 draft to solidwastekampala as dataset of the month)
- 15:25 - I don't want the code-fold option. I only want to see the code in the .qmd, hide from output
- 15:29 - can the plot be done with D3 in an OJS cell, so that the columns are hoverable
- 15:34 - go for recommendation (Observable Plot in an OJS cell with hover tooltip)
- 15:35 - [image] the listing doesn't look good now. The font size is not the same as the page text
- 15:35 - [image] each section has too much space above the heading
- 15:42 - [image] this plot isn't readable, make a suggestion for adapting to a different plot type. what about waffle?
- 15:42 - [image] learn and join sections still have too much space
- 15:53 - [image] it's a question for my brand choices, but these contrasts seem poor for the chosen colors. Rework the waffle plot again. I don't like it. It doesn't improve the display. What other options could you propose?
- 15:55 - the current landing page should not show "join the course" because we do not yet have a sign up. Read out stories and then to the blog is the best other alternative
- 15:57 - go for options 1, then open an issue for brand, i will need 6+ colours regularly.
- 16:32 - that plot is lovely!
- 16:34 - commit all work and merge into dev, also check the other branches and and open work from the two newly added blog posts. I want it all as a complete solved branch on dev before I open a PR to main. You can open PRs to dev, review them, close them. You have permission to commit and push. the newsletter issue draft doesn't belong here. it belongs into openwashdata/newsletter. move it.
- 21:01 - Get Started can be removed from the list of items in the top
- 21:02 - The footer can say: Supported by the Open Research ... and Global Health Engineering ETH Zurich with a hyperlink to ghe.ethz.ch
- 21:18 - Under the read entries, can it show the date, title and author?
- 21:19 - the code of conduct page can sit in the bottom of the page. It doesnt fit well at the top
- 21:24 - /ultrareview on dev; findings: Learn typos and stale freeze (already fixed), dead .owd-dotm img CSS, stale theme-dark.scss, prompts/ vs prompt-history.md undocumented
- 21:43 - commit
- 21:53 - open PR for website
- 21:54 - continue your work on brand.
- 22:06 - run the tests on PR and merge when complete
- 22:30 - on the dot plot on index, add some type of tipp to hover over the dots to see each data pont
- 22:33 - Learn on index also needs the graduates 2026 paze link so people can look at the projects. The academy page needs both gradudate pages as entries for people to navigate to when they read that page.
- 22:38 - the tooltip worked fine. I wanted a note for the reader in the title or subtitle to tell them to hover. people don't know that.
- 22:44 - are those changes on dev? if so, commit, push, pr, merge.

## 2026-09-09

- 05:40 - The grey is not legible. In Emmanuel's blogs, check for consistency of naming with website. It says openWASH programme. It's openwashdata and it's a community.
- 05:51 - Move tag
- 06:05 - The note about the LinkedIn post should sit at the top. ETH Zurich needs also Global Health Engineering, ETH Zurich (without umlaut)
- 06:35 - There is still too much space at the top of landing page
- 06:36 - Open an issue on website repo to write blog post about national ord prize. We never properly announced it.
