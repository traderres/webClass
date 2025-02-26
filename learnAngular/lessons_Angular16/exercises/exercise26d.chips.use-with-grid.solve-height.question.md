```
Problem:  When I select lots of chips, I have 2 scrollbars
----------------------------------------------------------

     +-------------------------------------------------------------------+
     | Select Contract Reviewers                                    Help |
     +-------------------------------------------------------------------+        
     |   <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  |    Height is 32px
     +-------------------------------------------------------------------+
     | Grid is here                                                      |
     |                                                                   |
     |                                                                   |   Height is set with a calculation
     |                                                                   |   -- and looks good because we assume chips uses height of 32px
     |                                                                   |
     |                                                                   |
     +-------------------------------------------------------------------+




     +-------------------------------------------------------------------+
     | Select Contract Reviewers                                    Help |
     +-------------------------------------------------------------------+        
     |   <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  |  Height is 64px
     |   <chip>  <chip>                                                  |  
     +-------------------------------------------------------------------+
     | Grid is here                                                      |
     |                                                                   |
     |                                                                   |  Height is set with a calculation
     |                                                                   |  -- and looks bad because we assume chips uses height of 32px
     |                                                                   |  -- but actual height of chips div is 64px
     |                                                                   |
     +-------------------------------------------------------------------+





```