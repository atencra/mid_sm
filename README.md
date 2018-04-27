# mid_sm
Squirrel Monkey MID Analysis

A collection of functions to analyze physiological data recorded from the auditory cortex.

Data were recorded from neurons in the auditory cortex while a dynamic, broadband sound was presented. 
This type of sounds allows us to reconstruct system functions, termed receptive fields for each neuorn.

By adding the stimuli together that preceded each spike, we can understand what stimulus features led to a response.
However, this average, termed the spike-triggered average (STA), captures only odd-ordered nonlinear processing, and it represents only one stimulus characteristic
that may influence a neuron to fire.

Therefore, we also applied maximally informative dimensions analysis. The approach applies an iterative optimization scheme,
and finds the the stimulus feature that contains the most information about the stimulus and the response. A significant aspect of this
approach is that we can find additional features after finding the first feature. This allows us to construct models of processing
for each neuron that are multidimensional, and account for more information than the averaging technique.

This repo contains functions to analyze the STA and MIDs for each neuron. We also estimate the information accounted for by each model.

Multiple functions are present that can be used to plot the STA and MIDs for each neurons.
