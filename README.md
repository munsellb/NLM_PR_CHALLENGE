# NLM_PR_CHALLENGE


##Step 1: Setup matlab environment

Add the required files and folders to the matlab path. From the matlab command prompt run
```
setmenv;
```
Note: this script is only executed once and must be done before any other script is executed! Otherwise, the remaining steps will produce file not found errors.

##Step 2: Organize the raw pill image files

From the matlab command prompt run:
```
orgImgs( 'data','proc', 'DR' );
```
For more information about this script, type "help orgImgs" at the matlab command prompt.

##Step 3: Process the raw pill image files

From the matlab command prompt run:
```
procImgs( 'proc', 'DR' );
```
For more information about this script, type "help procImgs" at the matlab command prompt.

##Step 4: Compute classification

From the matlab command prompt run:
```
classifyImgs( ref, consumer );
```
For more information about this script, type "help classifyImgs" at the matlab command prompt.
