---
layout: post
title: Can we stop trying to measure AI by water consumption?
author: Stuart Frost
comments: true
date: 2026-05-29
background: /assets/cloud.webp
image_attribution: Photo by <a href="https://unsplash.com/@growtika?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Growtika</a> on <a href="https://unsplash.com/photos/a-close-up-of-a-device-KPZNNKQbTMw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
tags:
  - ai
  - technology
---

I recently launched an online book discovery tool called [BookDeck](https://bookdeck.uk/) which means I have mixed with a new (to me) online community of creatives and book lovers. You don't have to look too far in a community like this to find strong anti-AI sentiment. There's lots of valid reasons to dislike AI and the potential disruption it could cause, but one which caught my attention was the claim that using AI specifically is causing untold environmental damage. I was skeptical of this but the more I thought about it the more I thought it *could* be true, but I wanted to find out the facts.

# How does AI use water?
If you're not familiar with these claims, the concern stems from the amount of water consumed by data centres which power AI, specifically for cooling the equipment inside them. With the current hype around AI, tech companies expect to spend $500 billion on new data centres before 2029.[^1] The amount of construction alone is surely a concern, however the bigger concern is perhaps the amount of power and water required to run this new infrastructure.

A report funded by the US Department of Energy estimated that data centres in the US used ~200 terawatt-hours (TWh) of electricity in 2024[^2], of which AI-specific servers may have used 53-76TWh. By 2028, the researchers estimate the figure for AI activities could reach 165-326TWh, enough to power **22% of US households** each year.[^3] 

Data centres typically consume water via water-intensive cooling towers or water evaporation-assisted air cooling used to discharge heat.[^4] We'll explore precise figures later.

> [!info] Water Withdrawal vs Consumption
> - **Water withdrawal:** refers to freshwater taken from the ground or surface water sources
> - **Water consumption:** water withdrawal minus water discharge. It reflects the impact on downstream water availability and is crucial for assessing watershed-level scarcity

# How much does my AI usage consume?
There's clearly challenges with the sustainability of data centres and their environmental impact. However, measuring the impact of an individual's usage can be very difficult, it's not comparable to measuring the fuel economy of a car. There are two parts of AI to consider:
## 1. Training AI models
Creating new AI models is expensive. It's estimated OpenAI spent over $100 million and consumed 50GWh of electricity to train it's GPT-4 model, that's enough to power San Francisco for three days.[^5]

## 2. Inference
It's only once a model has been trained that anyone can use it, referred to as *inference*. Interacting with an AI model is becoming an increasing majority of AI's energy usage (80-90% of it).[^5]

Below are three estimations of how much energy is required for different types of AI usage.[^9] I found it suprising how text generation in some cases can be more energy intensive than generating an image, but even more shocking is just how much more energy intensive generating a video is. But please read the caveat below...

| AI Activity                                          | Energy           | 
| ---------------------------------------------------- | ---------------- | 
| Generate 5-second video (Using CogVideoX)            | 3,400,000 joules | 
| Text generation (Using Llama 3.1 405B)               | 6,706 joules     | 
| Generate image (1024x1024, using Stable Diffusion 3) | 4,402 joules     | 

> [!warning] A big caveat
> The type and size of the AI model, type of output you're generating, the energy source connected to the data centre your request is sent to and what time of day you make your request can make one request **thousands of times** more energy intensive than another similar request.
> 
> We are also forced to guess a lot of these figures, because big tech companies aren't open about the energy efficiency of their models. Sasha Luccioni, an AI and climate researcher at Hugging Face says "We should stop trying to reverse-engineer numbers based on hearsay, and put more pressure on these companies to actually share the real ones."[^9] Luccioni has worked on [AI Energy Score](https://huggingface.co/AIEnergyScore), which ranks the energy efficiency of AI models. But very few tech companies have opted in, it mostly ranks open-source models.

## Water consumption
Water usage by data centres tells a similar story to power consumption on the surface, with a medium-sized data centre consuming up to 110 million gallons of water per year for cooling purposes alone.[^6] This sounds an awful lot, but I wonder if we fall into the trap of making unfair comparisons because we are used to measuring water in much smaller scales such as drinking a bottle of water. To put things in perspective, a typical golf course in the US uses a similar amount of water[^7], and collectively golf courses in the US consume over 2 billion gallons per year.[^8]

When calculating water consumption of data centres, both primary and secondary consumption is factored in. For example, a data centre powered by coal, must factor in the water cooling required in the power plant used to generate the electricity for the data centre. As seen below, the water consumption from fossil fuel based power plants far outstrip the water required for cooling data centres. This means that the biggest impact change tech companies could make is to ensure their data centres are powered by renewable sources.

<figure style="text-align: center">
  <img style="width: 100%" src="/assets/post-content/water-consumption-by-facility.webp" alt="Diagram showing propotional water consumption of data centres and different types of power plants">
  <small>
    <figcaption>
      <b>Sources</b>
      <p style="margin: 0">Coal and natural gas: <a href="https://www.eia.gov/todayinenergy/detail.php?id=56820">https://www.eia.gov/todayinenergy/detail.php?id=56820</a></p>
      <p style="margin: 0">Data centres: <a href="https://watercalculator.org/footprint/data-centers-water-use/">https://watercalculator.org/footprint/data-centers-water-use/</a></p>
      <p style="margin: 0">Wind: <a href="https://www.gem.wiki/Water_consumption_from_coal_plants">https://www.gem.wiki/Water_consumption_from_coal_plants</a></p>
      <p style="margin: 0">Solar PV: <a href="https://www.pbssocal.org/redefine/fact-check-how-much-water-does-solar-power-really-use">https://www.pbssocal.org/redefine/fact-check-how-much-water-does-solar-power-really-use</a></p>
    </figcaption>
  </small>
</figure>

# What about everything else you do on the web?
I think the main sticking point for me regarding the argument which states AI specifically is destroying the environment is this: data centres aren't a new invention required for AI, they power almost **every interaction** you and I have online. Sending an email, watching Netflix, and posting on social media all require a data centre to process and store data; they all have an environmental impact.

If we go along with the argument that AI is destroying the environment, do we apply the same scrutiny to all our activities online? Or are we perhaps treating AI differently because of other threats we feel it presents?

<figure style="text-align: center">
  <img style="width: 100%" src="/assets/post-content/energy-usage-by-activity.webp" alt="Diagram showing propotional energy usage of different online activities, with AI being a small proportion of it">
  <small>
    <figcaption>
      <b>Sources</b>
      <p style="margin: 0">Netflix: <a href="https://www.carbonbrief.org/factcheck-what-is-the-carbon-footprint-of-streaming-video-on-netflix/">https://www.carbonbrief.org/factcheck-what-is-the-carbon-footprint-of-streaming-video-on-netflix/</a></p>
      <p style="margin: 0">Zoom: <a href="https://davidmytton.blog/zoom-video-conferencing-energy-and-emissions/">https://davidmytton.blog/zoom-video-conferencing-energy-and-emissions/</a></p>
      <p style="margin: 0">AI text/image generation: <a href="https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/">https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/</a></p>
      <p style="margin: 0">Google search: <a href="https://store.chipkin.com/articles/did-you-know-it-takes-00003-kwh-per-google-search-and-more">https://store.chipkin.com/articles/did-you-know-it-takes-00003-kwh-per-google-search-and-more</a></p>
    </figcaption>
  </small>
</figure>

# A plea
Please don't misunderstand me. I am far from an AI apologist. I believe AI *does* have benefits in *some* industries, but I am skeptical that it provides *any* value to fields such as the creative industries. Eliza Martin, a legal fellow at the Environmental and Energy Law Program at Harvard says "It’s not clear to us that the benefits of these data centers outweigh these costs".[^9] The shear scale of the capital investment in data centres doesn't justify the value that I believe AI creates.

Data centres and big tech companies need to do a lot more work on sustainability too, I'm not saying they can pass the buck to the power companies. Innovations such as direct-to-chip and immersion cooling can reduce data centres water consumption, but they can also be more expensive.[^10]

Let's be pragmatic about the benefits and challenges that *all* technologies give us, and not fall into the trap of vilifying something that only makes up a small part of the picture.

---
# References

[^1]: “Part four: The future ahead” from the article “We did the math on AI’s energy footprint. Here’s the story you haven’t heard,” *MIT Technology Review* (May 2025). [https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/](https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/).

[^2]: *2024 United States Data Center Energy Usage Report* (December 2024). [https://escholarship.org/uc/item/32d6m0d1](https://escholarship.org/uc/item/32d6m0d1)

[^3]: From the article “We did the math on AI’s energy footprint. Here’s the story you haven’t heard,” *MIT Technology Review* (May 2025). [https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/](https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/).

[^4]: *Making AI Less “Thirsty”: Uncovering and Addressing the Secret Water Footprint of AI Models* (March 2025). [https://arxiv.org/pdf/2304.03271](https://arxiv.org/pdf/2304.03271)

[^5]: “Part one: Making the model” from the article “We did the math on AI’s energy footprint. Here’s the story you haven’t heard,” *MIT Technology Review* (May 2025). [https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/](https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/).

[^6]: *Data centers, backbone of the digital economy, face water scarcity and climate risk* (August 2022). [https://www.npr.org/2022/08/30/1119938708/data-centers-backbone-of-the-digital-economy-face-water-scarcity-and-climate-ris](https://www.npr.org/2022/08/30/1119938708/data-centers-backbone-of-the-digital-economy-face-water-scarcity-and-climate-ris)

[^7]: *The Thirsty Servers: The Truth About Water Footprint of Data Centers* (September 2025). [https://www.akcp.com/index.php/2025/09/02/truth-about-data-water-footprint-of-data-centers/](https://www.akcp.com/index.php/2025/09/02/truth-about-data-water-footprint-of-data-centers/)

[^8]: *TWL Irrigation, How Much Water Does a Golf Course Use?* (July 2020). [https://www.twl-irrigation.com/how-much-water-does-a-golf-course-use/](https://www.twl-irrigation.com/how-much-water-does-a-golf-course-use/)

[^9]: “Part two: A Query” from the article “We did the math on AI’s energy footprint. Here’s the story you haven’t heard,” *MIT Technology Review* (May 2025). [https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/](https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/).

[^10]: *Data Centers and Water Consumption* (June 2025). [https://www.eesi.org/articles/view/data-centers-and-water-consumption](https://www.twl-irrigation.com/how-much-water-does-a-golf-course-use/)


