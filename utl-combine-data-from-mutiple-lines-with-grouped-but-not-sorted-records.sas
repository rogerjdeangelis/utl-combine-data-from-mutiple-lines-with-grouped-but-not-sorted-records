Combine data from mutiple lines for grouped but not sorted records

github
https://tinyurl.com/s5ew6gp
https://github.com/rogerjdeangelis/utl-combine-data-from-mutiple-lines-with-grouped-but-not-sorted-records


SAS Forum
https://tinyurl.com/ts2z2pm
https://communities.sas.com/t5/SAS-Programming/Flagging-Data-from-multiple-lines/m-p/630894

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

data have;
      input Product_Number In_Stock $;
cards4;
2408200 NO
2408200 YES
2529100 NO
9252992 NO
9252992 YES
2295299 YES
2929592 NO
;;;;
run;quit;

WORK.HAVE total obs=7

       PRODUCT_
Obs     NUMBER     IN_STOCK

 1      2408200      NO
 2      2408200      YES
 3      2529100      NO
 4      9252992      NO
 5      9252992      YES
 6      2295299      YES
 7      2929592      NO

*           _
 _ __ _   _| | ___  ___
| '__| | | | |/ _ \/ __|
| |  | |_| | |  __/\__ \
|_|   \__,_|_|\___||___/

;

WORK.HAVE total obs=7

                              +
       PRODUCT_               | IN_STOCK    FLAG
Obs     NUMBER     IN_STOCK   |
                              |
 1      2408200      NO       |
 2      2408200      YES      |  NO/YES     Yes
                              |
 3      2529100      NO       |  NO

 4      9252992      NO       |
 5      9252992      YES      |  NO/YES     Yes

 6      2295299      YES      |  Yes

 7      2929592      NO       |  NO
                              +
*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

WORK.WANT total obs=5

       PRODUCT_
Obs     NUMBER     IN_STOCK    FLAG

 1      2408200     NO/YES     Yes
 2      2529100     NO
 3      9252992     NO/YES     Yes
 4      2295299     YES
 5      2929592     NO

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;


data want;

  set have;

  by product_number notsorted;

  lag_in_stock = lag(in_stock);

  select;

     when  ( first.product_number and last.product_number ) output;
     when  ( last.product_number) do;
            flag="Yes";
            in_stock=catx('/',lag_in_stock,in_stock);
            output;
     end;
     otherwise;

  end;

  drop lag_in_stock;

run;quit;


