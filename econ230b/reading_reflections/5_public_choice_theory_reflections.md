
## Reflections on Public Choice Theory readings

Readings referenced in this reflection:

* Bergstrom, T. (1979). When Does Majority Rule Supply Public Goods Efficiently?, 12.
* Bowen, H. R. (1943). The Interpretation of Voting in the Allocation of Economic Resources. The Quarterly Journal of Economics, 58(1), 27. https://doi.org/10.2307/1885754
* Young, H. P. (1988). Condorcet’s Theory of Voting. The American Political Science Review, 82(4), 1231. https://doi.org/10.2307/1961757

I think the initial quote from the Condorcet reading (Young 1988) is a great way to begin this reflection: "A central problem in democratic theory is to justify the principle of majority rule."  Perhaps it's just because we are so used to majority rule voting as a norm for making social decisions that it seems jarring to consider a need to justify it.

Previous readings sometimes referred to a "correct" or "ideal" distribution of private goods or costs with respect to some ideal provision of public good; here the author brings together ideas from Rousseau and Condorcet to provide a little bit more definition to that idea.  Rousseau stated that voters provide their opinion (in vote form) to determine, for a given proposition, "whether it is in conformity with the general will."  Condorcet made the argument that enlightened voters will attempt to make the decision that best serves society, and if they are right more often than they are wrong, then the majority vote will be more often the "correct" decision.  But things get more complicated and less intuitive as more than two options are offered, including cycles of outcomes depending on how different people rank the multiple options.

I found it interesting to see the probabilistic treatment of how Condorcet's voting system works to identify choices that most closely match the general will.  More importantly it seems like this kind of system is forming the foundation for better voting systems that allow for more diverse candidate choices while avoiding the whole third party candidate "spoiler" problem.  Ranked-choice voting in San Francisco's mayoral race and Maine's statewide elections seem to be popular and effective at providing representation that is in general accordance with the populace.  From [this New York Times editorial (June 2018)](https://www.nytimes.com/2018/06/09/opinion/ranked-choice-voting-maine-san-francisco.html): "When voters can express their political preferences more fully, the politicians they elect will be more likely to represent them more fully."

The Bowen (1943) paper was quite easy to follow, starting with a very simplified model and then relaxing particular assumptions (e.g. equal distribution of costs/taxes, equal access to the benefits of the public good, constant or decreasing marginal cost of the public good) one at a time to examine the implications.  A few key points I found interesting:

* Quantities of public goods often cannot be measured in simple physical units (e.g. education) - two methods to deal with this.
    * treat separately each element of a complex public good (e.g. school buildings, teachers, etc)
    * measure quantity in terms of money cost - this involves two aspects: 1) determine priorities among different aspects of public good, 2) determine total allocation for overall increase or decrease
* conditions required for reliability of a sample poll (instead of population voting)
    * informed voters
    * sense of responsibility and agency

Another point Bowen makes is that we should separate redistributive taxes from taxes used to fund public goods.  This echoes (or presages, I guess) ideas in Samuelson (1958) and elsewhere in our readings - while taxes can be valuable both for raising revenue for public goods and for evening out perceived inequities in distribution, it is perhaps more transparent to consider these functions through separate votes.  

One ramification of Bowen's argument seems to be (I need to look into this further to check my logic) that, if the optimal public good provision is based on preferences of a median voter, then for a single up/down vote on a proposal (e.g. a school funding bond), any vote result that deviates significantly from 50% is non-optimal.  So a million-dollar school bond that wins 60/40 should probably have been proposed for some amount more than a million dollars, up to the point where it would win 51/49 (ish).  Though of course, without the vote, it is difficult to predict the margin, and the new proposal could actually end up failing with a 49/51 vote instead.

I think the key to Ted's paper (Bergstrom, 1979) is: 

> A Lindahl equilibrium, though Pareto efficient, requires unobtainable information to be implemented. A Bowen equilibrium, while practically implementable, is in general not Pareto efficient.

So how can we find an efficient equilibrium using a practical method that does not rely on unobservable information?  Ted introduces the idea of pseudo-Lindahl equilibrium, identifying conditions under which a Bowen equilibrium can be Pareto optimal and a Lindahl equilibrium matches a Bowen outcome: 

> If preferences are all log linear and appropriately symmetric, then a Bowen equilibrium with proportional wealth taxation is Pareto optimal.  It is also true that if all individual preferences were identical and representable by the "average" utility function $U(X_i, Y) = \ln X_i + a \ln Y$, then the Lindahl tax would be a proportional wealth tax and the Lindahl quantity of public goods would be the same as the Bowen quantity $Y^*$ found in the previous section. This suggests more generally we could compute Lindahl equilibrium for a hypothetical community in which preferences are "averaged", ignoring individual eccentricities of tastes that are not easily observable. Under certain circumstances, the Lindahl equilibria are Pareto efficient for the actual community and may also be Bowen equilibria.

By bringing together these concepts, we can under certain conditions use observable information (e.g. via voting or sampling to identify the median preferences within each subgroup type) to approximate a Pareto efficient allocation of public goods and the taxes to pay for them.