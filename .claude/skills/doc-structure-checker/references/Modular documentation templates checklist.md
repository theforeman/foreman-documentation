**Modular documentation templates checklist**

**All modules and assemblies:**

* Has :\_mod-docs-content-type: \<TYPE\>, where  \<TYPE\> is ASSEMBLY, CONCEPT, REFERENCE, or PROCEDURE.  
* Has a topic ID in the following format:  
  \[id="\<file-name\>\_{context}"\]  
  	For OCP: \[\_{context}"\] does not belong in Assemblies.  
    
* Has one and only one level 0 (=) title (H1) title  
* Has a short introduction  
* Has a blank line between the level 0 (=)  title and the short introduction  
* For any images, has alternative text descriptions enclosed in quotation marks ("")  
* Admonitions do not include titles.

**Nested assembly files:**

* Contains the following conditional statement at the top of the document:  
  ifdef::context\[:parent-context: {context}\]  
* Contains the following conditional statement at the bottom of the document:  
  ifdef::parent-context\[:context: {parent-context}\]  
  ifndef::parent-context\[:\!context:\]  
* Has the context variable declared and defined (:context: some-assembly).

**All assembly files:**

* Has a blank line between each include statement.  
* Does not contain a level 2 (===) section title (H3) or lower.   
* Does not include block titles.

**Concept or reference module:**

* Does not contain an instruction (imperative statement).  
* Does not contain a level 2 (===) section title (H3) or lower..  
* Does not contain block titles, except .Additional references or .Next steps. Note that .Next steps will not be mapped to \<related-links\>, .Additional resources will.

**Procedure module:**

* Includes the .Procedure block title followed by one ordered or unordered list.  
* Includes only one .Procedure block title and list.  
* Does not contain embellishments of .Procedure, for example .Procedure for installing X.  
* Does not contain content following the last step of the procedure except the optional sections in the order listed:  
  \* Prerequisites or Prerequisite  
  \* Procedure  
  \* Verification, Results, or Result  
  \* Troubleshooting, Troubleshooting steps, or Troubleshooting step  
  \* Next steps or Next step  
  \* Additional resources  
    
* Does not contain any other block titles. 

