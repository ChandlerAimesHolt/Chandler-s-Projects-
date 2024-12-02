--Creating Table to view data more efficiently
CREATE TABLE credit_data (
    id VARCHAR(255),
    loan_amnt VARCHAR(255),
    funded_amnt VARCHAR(255),
    funded_amnt_inv VARCHAR(255),
    term VARCHAR(255),
    int_rate VARCHAR(255),
    installment VARCHAR(255),
    grade VARCHAR(255),
    sub_grade VARCHAR(255),
    emp_title VARCHAR(255),
    emp_length VARCHAR(255),
    home_ownership VARCHAR(255),
    annual_inc VARCHAR(255),
    verification_status VARCHAR(255),
    issue_d VARCHAR(255),
    loan_status VARCHAR(255),
    pymnt_plan VARCHAR(255),
    purpose VARCHAR(255),
    title VARCHAR(255),
    zip_code VARCHAR(255),
    addr_state VARCHAR(255),
    dti VARCHAR(255),
    delinq_2yrs VARCHAR(255),
    earliest_cr_line VARCHAR(255),
    fico_range_low VARCHAR(255),
    fico_range_high VARCHAR(255),
    inq_last_6mths VARCHAR(255),
    mths_since_last_delinq VARCHAR(255),
    mths_since_last_record VARCHAR(255),
    open_acc VARCHAR(255),
    pub_rec VARCHAR(255),
    revol_bal VARCHAR(255),
    revol_util VARCHAR(255),
    total_acc VARCHAR(255),
    initial_list_status VARCHAR(255),
    out_prncp VARCHAR(255),
    out_prncp_inv VARCHAR(255),
    total_pymnt VARCHAR(255),
    total_pymnt_inv VARCHAR(255),
    total_rec_prncp VARCHAR(255),
    total_rec_int VARCHAR(255),
    total_rec_late_fee VARCHAR(255),
    recoveries VARCHAR(255),
    collection_recovery_fee VARCHAR(255),
    last_pymnt_d VARCHAR(255),
    last_pymnt_amnt VARCHAR(255),
    next_pymnt_d VARCHAR(255),
    last_credit_pull_d VARCHAR(255),
    last_fico_range_high VARCHAR(255),
    last_fico_range_low VARCHAR(255),
    collections_12_mths_ex_med VARCHAR(255),
    mths_since_last_major_derog VARCHAR(255),
    policy_code VARCHAR(255),
    application_type VARCHAR(255),
    annual_inc_joint VARCHAR(255),
    dti_joint VARCHAR(255),
    verification_status_joint VARCHAR(255),
    acc_now_delinq VARCHAR(255),
    tot_coll_amt VARCHAR(255),
    tot_cur_bal VARCHAR(255),
    open_acc_6m VARCHAR(255),
    open_act_il VARCHAR(255),
    open_il_12m VARCHAR(255),
    open_il_24m VARCHAR(255),
    mths_since_rcnt_il VARCHAR(255),
    total_bal_il VARCHAR(255),
    il_util VARCHAR(255),
    open_rv_12m VARCHAR(255),
    open_rv_24m VARCHAR(255),
    max_bal_bc VARCHAR(255),
    all_util VARCHAR(255),
    total_rev_hi_lim VARCHAR(255),
    inq_fi VARCHAR(255),
    total_cu_tl VARCHAR(255),
    inq_last_12m VARCHAR(255),
    acc_open_past_24mths VARCHAR(255),
    avg_cur_bal VARCHAR(255),
    bc_open_to_buy VARCHAR(255),
    bc_util VARCHAR(255),
    chargeoff_within_12_mths VARCHAR(255),
    delinq_amnt VARCHAR(255),
    mo_sin_old_il_acct VARCHAR(255),
    mo_sin_old_rev_tl_op VARCHAR(255),
    mo_sin_rcnt_rev_tl_op VARCHAR(255),
    mo_sin_rcnt_tl VARCHAR(255),
    mort_acc VARCHAR(255),
    mths_since_recent_bc VARCHAR(255),
    mths_since_recent_bc_dlq VARCHAR(255),
    mths_since_recent_inq VARCHAR(255),
    mths_since_recent_revol_delinq VARCHAR(255),
    num_accts_ever_120_pd VARCHAR(255),
    num_actv_bc_tl VARCHAR(255),
    num_actv_rev_tl VARCHAR(255),
    num_bc_sats VARCHAR(255),
    num_bc_tl VARCHAR(255),
    num_il_tl VARCHAR(255),
    num_op_rev_tl VARCHAR(255),
    num_rev_accts VARCHAR(255),
    num_rev_tl_bal_gt_0 VARCHAR(255),
    num_sats VARCHAR(255),
    num_tl_120dpd_2m VARCHAR(255),
    num_tl_30dpd VARCHAR(255),
    num_tl_90g_dpd_24m VARCHAR(255),
    num_tl_op_past_12m VARCHAR(255),
    pct_tl_nvr_dlq VARCHAR(255),
    percent_bc_gt_75 VARCHAR(255),
    pub_rec_bankruptcies VARCHAR(255),
    tax_liens VARCHAR(255),
    tot_hi_cred_lim VARCHAR(255),
    total_bal_ex_mort VARCHAR(255),
    total_bc_limit VARCHAR(255),
    total_il_high_credit_limit VARCHAR(255),
    hardship_flag VARCHAR(255),
    disbursement_method VARCHAR(255),
    debt_settlement_flag VARCHAR(255)
);
--Copying data to new table

COPY credit_data
FROM 'C:\Users\chand\Documents\public\Credit Data2.csv'
CSV HEADER;
--General query to show data
SELECT * FROM credit_data

--Going through each variable to see if it can be cleaned or simplified
SELECT DISTINCT loan_amnt FROM credit_data

--Checking to see if loan amount is ever different from funded_amnt
SELECT distinct cast((loan_amnt) as int) - cast((funded_amnt)as int) from credit_data

--It is never different therefore one of the columns is not needed
ALTER TABLE credit_data
DROP COLUMN funded_amnt

--Next one
SELECT DISTINCT cast((funded_amnt_inv)as decimal)- cast((loan_amnt) as Decimal) as purple,
COUNT(funded_amnt_inv) as total FROM credit_data
GROUP BY purple
-- These are the same, so I am dropping the column 
ALTER TABLE credit_data
DROP COLUMN funded_amnt_inv

--Term is next
SELECT term, count(term) FROM credit_data
GROUP 
--EVERY term IS either 36 or 60 months, so I'm changing this to binary 
UPDATE credit_data
SET term = 0
WHERE term = ' 36 months'

UPDATE credit_data
SET term = 1
WHERE term = ' 60 months'

--int_rate is next
SELECT DISTINCT int_rate FROM credit_data
--This is fine as is

--installment is next
SELECT DISTINCT installment FROM credit_data
--This is fine
--grade is next
SELECT DISTINCT grade FROM credit_data

--Did some research and saw that grade can be translated from fico score, so I will be dropping
--These columns to remove redundancy
ALTER TABLE credit_data
DROP COLUMN grade 
ALTER TABLE credit_data
DROP COLUMN sub_grade

--Next one emp_title 
SELECT DISTINCT emp_title FROM credit_data
--Over 100,000 different emp_title, it could be relevant, but it will most likely have 
-- A lot of multicolinerearity with annual income anyways, so I will be dropping this column
ALTER TABLE credit_data
DROP COLUMN emp_title

--Next one is emp_length
SELECT DISTINCT emp_length 
FROM credit_data
-- Linear data, so I need to remove any non numbers from the column so it can be used as an integer
UPDATE credit_data
SET emp_length = 0 
WHERE emp_length = '< 1 year'

UPDATE credit_data
SET emp_length = 1 
WHERE emp_length = '1 year'

UPDATE credit_data
SET emp_length = 2 
WHERE emp_length = '2 years'

UPDATE credit_data
SET emp_length = 3 
WHERE emp_length = '3 years'

UPDATE credit_data
SET emp_length = 4 
WHERE emp_length = '4 years'

UPDATE credit_data
SET emp_length = 5
WHERE emp_length = '5 years'

UPDATE credit_data
SET emp_length = 6
WHERE emp_length = '6 years'

UPDATE credit_data
SET emp_length = 7 
WHERE emp_length = '7 years'

UPDATE credit_data
SET emp_length = 8 
WHERE emp_length = '8 years'

UPDATE credit_data
SET emp_length = 9 
WHERE emp_length = '9 years'

UPDATE credit_data
SET emp_length = 10 
WHERE emp_length = '10+ years'

--home ownership is next
select distinct home_ownership, count(home_ownership) FROM credit_data
GROUP BY home_ownership
-- Three different variables, so I am going to hot key this later in python
-- but i need to get rid of the 'any' variable since it only has 3 observations
UPDATE credit_data
SET home_ownership = 'MORTGAGE'
WHERE home_ownership = 'ANY'
--Next is annual income
SELECT DISTINCT annual_inc FROM credit_data
--Nothting wrong here
--Next is Verification status
SELECT DISTINCT verification_status, count(verification_status) FROM credit_data
GROUP BY verification_status
--There are three variables 'not verified', 'source verified' and 'verified'
--I did some research and found that source verified and verified are virtually the same things
--so i will change all verified observations to 1 and not verified to 0
UPDATE credit_data
SET verification_status = 0
WHERE verification_status = 'Not Verified'

UPDATE credit_data
SET verification_status = 1
WHERE verification_status = 'Source Verified' OR verification_status = 'Verified'
--Next one is issue ID
SELECT DISTINCT issue_d, count(issue_d) FROM credit_data
GROUP BY issue_d
--I suspect there will be multicolinearity with another column, but I am gonna leave it for now
--Next is loan status
SELECT DISTINCT loan_status, count(loan_status) FROM credit_data
GROUP BY loan_status
-- The variables fall into two categories, either fully paid/ current or late/ defaulted
--Therefore I can change this to binary to represent this
-- This will also be my outcome variable that I am predicting later in my analysis
UPDATE credit_data
SET loan_status = 1
WHERE loan_status = 'Paid Off' OR loan_status = 'Current' 

UPDATE credit_data
SET loan_status = 0
WHERE loan_status = 'Default' OR loan_status = 'In Grace Period' or 
loan_status = 'Charged Off' OR loan_status = 'Late (16-30 days)' or 
loan_status = 'Late (31-120 days)'

--Next one is pymnt_plan
SELECT DISTINCT pymnt_plan, count(pymnt_plan) FROM credit_data
GROUP BY pymnt_plan
--exclusively yes or no variables, but only 75 yes observations out of 460,000, so it may not be useful
--but I will keep it since it would be a strong indicator of defaulting
UPDATE credit_data
SET pymnt_plan = 0
WHERE pymnt_plan = 'n'

UPDATE credit_data
SET pymnt_plan = 1
WHERE pymnt_plan = 'y'

--Next one is purpose
SELECT DISTINCT purpose, count(purpose) FROM credit_data
GROUP BY purpose
-- Going to have to one-Hot code this in Python later
--Next one is title
SELECT DISTINCT title, count(title) FROM credit_data
GROUP BY title
--This is just a slightly more specific version of the purpose column, so I'm gonna drop this
ALTER TABLE credit_data
DROP COLUMN title
--Next is zip code 
SELECT DISTINCT zip_code, count(zip_code) FROM credit_data
GROUP BY zip_code
--Unsure what I am gonna do with this, since there are close to 1000 unique variables and 
-- it might have a high degree of multicolinearity with another column
--Next one is address state
SELECT DISTINCT addr_state, count(addr_state) FROM credit_data
GROUP BY addr_state
--Gonna do a rudimentary check if there is a correlation between state and likelyhood of defaulting
SELECT 
    addr_state,
    COUNT(CASE WHEN loan_status = '0' THEN 1 END) * 1.0 / COUNT(*) AS proportion
FROM 
    credit_data
GROUP BY 
    addr_state
ORDER BY proportion
--Looks like there is a correlation so I am going to leave it for now
--Checking for zip_code too
SELECT 
    zip_code,
    COUNT(CASE WHEN loan_status = '0' THEN 1 END) * 1.0 / COUNT(*) AS proportion
FROM 
    credit_data
GROUP BY 
   zip_code
ORDER BY proportion
--There is a correlation here as well
--Next is dti
SELECT DISTINCT dti FROM credit_data
--This is fine
--Next is deling_2 years
SELECT DISTINCT delinq_2yrs, count(delinq_2yrs) FROM credit_data
GROUP BY delinq_2yrs
--This variable means number of delinquet payments in the last 2 years.
--I'm just gonna change it to binary so that if there is no delinquet payments then it is 0 and if 
--there are then 1
UPDATE credit_data
SET delinq_2yrs = 1
WHERE delinq_2yrs != '0'

--Next is earliest credit line
SELECT DISTINCT earliest_cr_line, count(earliest_cr_line) FROM credit_data
GROUP BY earliest_cr_line
--Probably need to transform this into credit age at the time of the issued loan
UPDATE credit_data
SET earliest_cr_line = regexp_replace(earliest_cr_line, '[^0-9]', '', 'g');

ALTER TABLE credit_data
    ALTER COLUMN earliest_cr_line TYPE INT USING earliest_cr_line::INT;

UPDATE credit_data
SET earliest_cr_line = earliest_cr_line + 2000
WHERE earliest_cr_line < 20

UPDATE credit_data
SET earliest_cr_line = earliest_cr_line + 1900
WHERE earliest_cr_line > 20 AND earliest_cr_line < 1000
-- Now the same for issue_d
UPDATE credit_data
SET issue_d = regexp_replace(issue_d, '[^0-9]', '', 'g');

ALTER TABLE credit_data
    ALTER COLUMN issue_d TYPE INT USING issue_d::INT;

UPDATE credit_data
SET issue_d = issue_d + 2000
WHERE issue_d < 20

ALTER TABLE credit_data
ADD credit_age INT

UPDATE credit_data
SET credit_age = (issue_d-earliest_cr_line)

SELECT DISTINCT credit_age FROM credit_data

--Don't see a reason to keep the previous date columns now 
ALTER TABLE credit_data
DROP COLUMN earliest_cr_line

ALTER TABLE credit_data
DROP COLUMN issue_d

--The next one is low fico credit range
SELECT DISTINCT fico_range_low FROM credit_data

ALTER TABLE credit_data
    ALTER COLUMN fico_range_low TYPE INT USING fico_range_low::INT;
--Checking to see if the range is universal
SELECT DISTINCT fico_range_high FROM credit_data

ALTER TABLE credit_data
    ALTER COLUMN fico_range_high TYPE INT USING fico_range_high::INT;

select DISTINCT (fico_range_high-fico_range_low) as diff, fico_range_high
FROM credit_data
GROUP BY fico_range_high, diff
--They almost all have a difference of 4 points, so it is redundant to keep both of them
ALTER TABLE credit_data
DROP COLUMN fico_range_high

--The next one is inq_last_6mnths
SELECT DISTINCT inq_last_6mths FROM credit_data
--Credit score already takes into account  this variable so i am dropping it
ALTER TABLE credit_data
DROP COLUMN inq_last_6mths 
--Next is months since last delinquent payment
SELECT DISTINCT mths_since_last_delinq FROM credit_data
--Since there are data points big enough to where it would not affect the 
--fico score I will keep this column

--Next one is months since last record
SELECT DISTINCT mths_since_last_record, mths_since_last_delinq FROM credit_data
--Next one is open_acc
SELECT DISTINCT open_acc, count(open_acc) FROM credit_data
GROUP BY open_acc
--This is fine
SELECT DISTINCT pub_rec, count(pub_rec) FROM credit_data
GROUP BY pub_rec
--Gonna change this to binary 
ALTER TABLE credit_data
    ALTER COLUMN pub_rec TYPE INT USING pub_rec::INT
UPDATE credit_data
SET pub_rec = 1
WHERE pub_rec > 0

--Next is revol_bal and Utililization 
SELECT DISTINCT revol_bal FROM credit_data
--dropping these columns since it is also factored into credit score
ALTER TABLE credit_data
DROP COLUMN revol_bal

ALTER TABLE credit_data
DROP COLUMN revol_util

--Next one is total accounts
SELECT DISTINCT total_acc FROM credit_data
-- This is fine

--Next one is initial list status
SELECT DISTINCT initial_list_status FROM credit_data
-- Two variables, changing this to binary
UPDATE credit_data
SET initial_list_status = 0
WHERE initial_list_status = 'f'

UPDATE credit_data
SET initial_list_status = 1
WHERE initial_list_status = 'w'

--Next is out_prncp 
SELECT DISTINCT out_prncp_inv FROM credit_data
--This is fine
SELECT DISTINCT out_prncp,  out_prncp_inv FROM credit_data
WHERE out_prncp !=out_prncp_inv
--There is going to be a lot of multicolinearity so I am dropping this column
ALTER TABLE credit_data
DROP COLUMN out_prncp_inv

--Next one is total payment 
SELECT DISTINCT total_pymnt FROM credit_data
--Fine for now
--Next is total payment inv
SELECT DISTINCT total_pymnt_inv, total_pymnt FROM credit_data
WHERE total_pymnt !=total_pymnt_inv
--Again dropping the inventory column because of multicolinearity
ALTER TABLE credit_data
DROP COLUMN total_pymnt_inv

--Next is total_rec_prncp
SELECT DISTINCT total_rec_prncp FROM credit_data
--Fine for now
--Next is total rec int
SELECT DISTINCT total_rec_int FROM credit_data

SELECT DISTINCT total_rec_int, total_rec_prncp FROM credit_data
WHERE total_rec_prncp !=total_rec_int
--This is fine for now
--Next is total rec late fee
SELECT DISTINCT total_rec_late_fee FROM credit_data
--Some weird exponents that should just be zero in the column 
UPDATE credit_data
SET total_rec_late_fee = 0
WHERE total_rec_late_fee LIKE '%E%'
--Next is recoveries 
SELECT DISTINCT recoveries FROM credit_data
--Fine for now
--Next is collection_recovery_fee
SELECT DISTINCT collection_recovery_fee FROM credit_data
--This is fine
-- Next is last payment data
SELECT DISTINCT last_pymnt_d FROM credit_data
-- Not interested in this column
ALTER TABLE credit_data
DROP COLUMN last_pymnt_d

--Next is last_pymnt_amnt
SELECT DISTINCT last_pymnt_amnt,  FROM credit_data
--This is fine
--Dropping next payment date
ALTER TABLE credit_data
DROP COLUMN next_pymnt_d
--Dropping last credit pulled date
ALTER TABLE credit_data
DROP COLUMN last_credit_pull_d

--DROPPING last_fico_range_high
ALTER TABLE credit_data
DROP COLUMN last_fico_range_high
--Checking to see difference in last and first low fico range
SELECT DISTINCT last_fico_range_low, fico_range_low FROM credit_data
--Keeping this since there is pretty large differences

--Next is collections in the last 12 months
SELECT DISTINCT collections_12_mths_ex_med, COUNT(collections_12_mths_ex_med) 
FROM credit_data
GROUP BY collections_12_mths_ex_med
--Changing this to binary if there was a collection 
UPDATE credit_data
SET collections_12_mths_ex_med = 1
WHERE collections_12_mths_ex_med != '0'

--Next is months since last major derog
SELECT DISTINCT mths_since_last_major_derog, COUNT(mths_since_last_major_derog)
FROM credit_data
GROUP BY mths_since_last_major_derog
--This column is just the sum of a number of other columns so I am going to drop it
ALTER TABLE credit_data
DROP COLUMN mths_since_last_major_derog
--Next is policy code
SELECT DISTINCT policy_code, COUNT(policy_code)
FROM credit_data
GROUP BY policy_code
-- every value is 1 so I am dropping it
ALTER TABLE credit_data
DROP COLUMN policy_code

-- NEXT is application type
SELECT DISTINCT application_type FROM credit_data
-- two types joint and individual, so I'm changint it to binary
UPDATE credit_data
SET application_type = 0
WHERE application_type = 'Individual'

UPDATE credit_data
SET application_type = 1
WHERE application_type = 'Joint App'

--Next is dti joint
SELECT DISTINCT dti_joint FROM credit_data
WHERE dti_joint != dti

-- I am going to combine this data with the original dti data
UPDATE credit_data
SET dti = dti_joint
WHERE dti IS NULL

--Next is verification status joint
SELECT DISTINCT verification_status_joint FROM credit_data

--Changing to binary again

UPDATE credit_data
SET verification_status_joint = 0
WHERE verification_status_joint = 'Not Verified'

UPDATE credit_data
SET verification_status_joint = 1
WHERE verification_status_joint = 'Source Verified' OR verification_status_joint = 'Verified'

--Next is acc_now_delinq
SELECT DISTINCT acc_now_delinq, COUNT(acc_now_delinq)
FROM credit_data
GROUP BY acc_now_delinq
--Changing to binary
UPDATE credit_data
SET acc_now_delinq = 1
WHERE acc_now_delinq != '0'

--NEXT is tot_coll_amt
SELECT DISTINCT tot_coll_amt FROM credit_data
--This is fine
--Next is tot_cur_bal
SELECT DISTINCT tot_cur_bal FROM credit_data
--This is fine
--Next is open-acc_6m
SELECT DISTINCT open_acc_6m, COUNT(open_acc_6m) 
FROM credit_data
GROUP BY open_acc_6m
-- changing to binary and if null then changing to 0
UPDATE credit_data
SET open_acc_6m = 1
WHERE open_acc_6m != '0'

UPDATE credit_data
SET open_acc_6m = 0
WHERE open_acc_6m IS NULL

--Next is open_il_12m
SELECT DISTINCT open_il_12m, COUNT(open_il_12m) 
FROM credit_data
GROUP BY open_il_12m
-- Doing the same thing for the next 3 columns
--open_il_12m
UPDATE credit_data
SET open_il_12m = 1
WHERE open_il_12m != '0'

UPDATE credit_data
SET open_il_12m = 0
WHERE open_il_12m IS NULL

--open_il_24m
UPDATE credit_data
SET open_il_24m = 1
WHERE open_il_24m != '0'

UPDATE credit_data
SET open_il_24m = 0
WHERE open_il_24m IS NULL

--mths_since_rcnt_il
SELECT DISTINCT mths_since_rcnt_il, COUNT(mths_since_rcnt_il) 
FROM credit_data
GROUP BY mths_since_rcnt_il
--This is fine
--total_bal_il
SELECT DISTINCT total_bal_il, COUNT(total_bal_il) 
FROM credit_data
GROUP BY total_bal_il
--This is fine
--il_util
SELECT DISTINCT il_util, COUNT(il_util) 
FROM credit_data
GROUP BY il_util
--This is fine
--open_rv_12m
SELECT DISTINCT open_rv_12m, COUNT(open_rv_12m) 
FROM credit_data
GROUP BY open_rv_12m
--Same thing
UPDATE credit_data
SET open_rv_12m = 1
WHERE open_rv_12m != '0'

UPDATE credit_data
SET open_rv_12m = 0
WHERE open_rv_12m IS NULL

UPDATE credit_data
SET open_rv_24m = 1
WHERE open_rv_24m != '0'

UPDATE credit_data
SET open_rv_24m = 0
WHERE open_rv_24m IS NULL

--max_bal_bc
SELECT DISTINCT max_bal_bc, COUNT(max_bal_bc) 
FROM credit_data
GROUP BY max_bal_bc
--THIS IS FINE
--all_util
SELECT DISTINCT all_util, COUNT(all_util) 
FROM credit_data
GROUP BY all_util
--There is not enough oberservations for this so I am dropping it
ALTER TABLE credit_data
DROP COLUMN all_util

--toal_rev_hi_lim
SELECT DISTINCT total_rev_hi_lim, COUNT(total_rev_hi_lim) 
FROM credit_data
GROUP BY total_rev_hi_lim
--This is fine
--inq_fi
SELECT DISTINCT inq_fi, COUNT(inq_fi) 
FROM credit_data
GROUP BY inq_fi
--we've done this before
UPDATE credit_data
SET inq_fi = 1
WHERE inq_fi != '0'

UPDATE credit_data
SET inq_fi = 0
WHERE inq_fi IS NULL

--total_cu_tl
SELECT DISTINCT total_cu_tl, COUNT(total_cu_tl) 
FROM credit_data
GROUP BY total_cu_tl

UPDATE credit_data
SET total_cu_tl = 1
WHERE total_cu_tl != '0'

UPDATE credit_data
SET total_cu_tl = 0
WHERE total_cu_tl IS NULL

--inq_last_12m is getting dropped since fico score is affected by this
ALTER TABLE credit_data
DROP COLUMN inq_last_12m

--acc_open_past_24mths
SELECT DISTINCT acc_open_past_24mths, COUNT(acc_open_past_24mths) 
FROM credit_data
GROUP BY acc_open_past_24mths
--This is fine
--avg_cur_bal
SELECT DISTINCT avg_cur_bal, COUNT(avg_cur_bal) 
FROM credit_data
GROUP BY avg_cur_bal
--This is fine
--bc_open_to_buy
SELECT DISTINCT bc_open_to_buy, COUNT(bc_open_to_buy) 
FROM credit_data
GROUP BY bc_open_to_buy
--This is fine
--bc_util
SELECT DISTINCT bc_util, COUNT(bc_util) 
FROM credit_data
GROUP BY bc_util
--This is fine
--chargeoff_within_12mths
SELECT DISTINCT chargeoff_within_12_mths, COUNT(chargeoff_within_12_mths) 
FROM credit_data
GROUP BY chargeoff_within_12_mths

UPDATE credit_data
SET chargeoff_within_12_mths = 1
WHERE chargeoff_within_12_mths != '0'

UPDATE credit_data
SET chargeoff_within_12_mths = 0
WHERE chargeoff_within_12_mths IS NULL

--delinq_amnt
SELECT DISTINCT delinq_amnt, COUNT(delinq_amnt) 
FROM credit_data
GROUP BY delinq_amnt
--This is fine for now
--mo_sin_old_il_acct
SELECT DISTINCT mo_sin_old_il_acct, COUNT(mo_sin_old_il_acct) 
FROM credit_data
GROUP BY mo_sin_old_il_acct
--This is fine
--mo_sin_old_rev_tl_op
SELECT DISTINCT mo_sin_old_rev_tl_op, COUNT(mo_sin_old_rev_tl_op) 
FROM credit_data
GROUP BY mo_sin_old_rev_tl_op
--unessary columns
ALTER TABLE credit_data
DROP COLUMN mo_sin_old_rev_tl_op

ALTER TABLE credit_data
DROP COLUMN mo_sin_rcnt_rev_tl_op

ALTER TABLE credit_data
DROP COLUMN mo_sin_rcnt_tl

--mort_acc
SELECT DISTINCT mort_acc, COUNT(mort_acc) 
FROM credit_data
GROUP BY mort_acc
--Leave this be
--mths_since_recent_bc
SELECT DISTINCT mths_since_recent_bc, COUNT(mths_since_recent_bc) 
FROM credit_data
GROUP BY mths_since_recent_bc
--Fine
--DROPPING unecessary columns 
ALTER TABLE credit_data
DROP COLUMN mths_since_recent_bc_dlq

ALTER TABLE credit_data
DROP COLUMN mths_since_recent_inq

ALTER TABLE credit_data
DROP COLUMN mths_since_recent_revol_delinq

--num_accts_ever_120_pd
SELECT DISTINCT num_accts_ever_120_pd, COUNT(num_accts_ever_120_pd) 
FROM credit_data
GROUP BY num_accts_ever_120_pd
--This is fine
--num_actv_bc_tl
SELECT DISTINCT num_actv_bc_tl, COUNT(num_actv_bc_tl) 
FROM credit_data
GROUP BY num_actv_bc_tl
--This is fine
--num_actv_rev_tl
SELECT DISTINCT num_actv_rev_tl, COUNT(num_actv_rev_tl) 
FROM credit_data
GROUP BY num_actv_rev_tl
--fine
--num_bc_sats
SELECT DISTINCT num_bc_sats, COUNT(num_bc_sats) 
FROM credit_data
GROUP BY num_bc_sats
--fine
--num_bc_tl
SELECT DISTINCT num_bc_tl, COUNT(num_bc_tl) 
FROM credit_data
GROUP BY num_bc_tl
--fine
-- num_il_tl
SELECT DISTINCT num_il_tl, COUNT(num_il_tl) 
FROM credit_data
GROUP BY num_il_tl;
--fine
-- num_op_rev_tl
SELECT DISTINCT num_op_rev_tl, COUNT(num_op_rev_tl) 
FROM credit_data
GROUP BY num_op_rev_tl;
--fine
-- num_rev_accts
SELECT DISTINCT num_rev_accts, COUNT(num_rev_accts) 
FROM credit_data
GROUP BY num_rev_accts;
--fine
-- num_rev_tl_bal_gt_0
SELECT DISTINCT num_rev_tl_bal_gt_0, COUNT(num_rev_tl_bal_gt_0) 
FROM credit_data
GROUP BY num_rev_tl_bal_gt_0;
--fine
-- num_sats
SELECT DISTINCT num_sats, COUNT(num_sats) 
FROM credit_data
GROUP BY num_sats;
--fine
-- num_tl_120dpd_2m
SELECT DISTINCT num_tl_120dpd_2m, COUNT(num_tl_120dpd_2m) 
FROM credit_data
GROUP BY num_tl_120dpd_2m;
--This column is worthless
ALTER TABLE credit_data
DROP COLUMN num_tl_120dpd_2m

-- num_tl_30dpd
SELECT DISTINCT num_tl_30dpd, COUNT(num_tl_30dpd) 
FROM credit_data
GROUP BY num_tl_30dpd;
--Worthless
ALTER TABLE credit_data
DROP COLUMN num_tl_30dpd

-- num_tl_90g_dpd_24m
SELECT DISTINCT num_tl_90g_dpd_24m, COUNT(num_tl_90g_dpd_24m) 
FROM credit_data
GROUP BY num_tl_90g_dpd_24m;

UPDATE credit_data
SET num_tl_90g_dpd_24m = 1
WHERE num_tl_90g_dpd_24m != '0'

-- num_tl_op_past_12m
SELECT DISTINCT num_tl_op_past_12m, COUNT(num_tl_op_past_12m) 
FROM credit_data
GROUP BY num_tl_op_past_12m;
-- Fine

-- pct_tl_nvr_dlq
SELECT DISTINCT pct_tl_nvr_dlq, COUNT(pct_tl_nvr_dlq) 
FROM credit_data
GROUP BY pct_tl_nvr_dlq;
--Fine

-- percent_bc_gt_75
SELECT DISTINCT percent_bc_gt_75, COUNT(percent_bc_gt_75) 
FROM credit_data
GROUP BY percent_bc_gt_75;
--Fine

-- pub_rec_bankruptcies
SELECT DISTINCT pub_rec_bankruptcies, COUNT(pub_rec_bankruptcies) 
FROM credit_data
GROUP BY pub_rec_bankruptcies;

-- tax_liens
SELECT DISTINCT tax_liens, COUNT(tax_liens) 
FROM credit_data
GROUP BY tax_liens;

UPDATE credit_data
SET tax_liens = 1
WHERE tax_liens != '0'


-- tot_hi_cred_lim
SELECT DISTINCT tot_hi_cred_lim, COUNT(tot_hi_cred_lim) 
FROM credit_data
GROUP BY tot_hi_cred_lim;
--Fine

-- total_bal_ex_mort
SELECT DISTINCT total_bal_ex_mort, COUNT(total_bal_ex_mort) 
FROM credit_data
GROUP BY total_bal_ex_mort;
--Fine

-- total_bc_limit
SELECT DISTINCT total_bc_limit, COUNT(total_bc_limit) 
FROM credit_data
GROUP BY total_bc_limit;
--Fine

-- total_il_high_credit_limit
SELECT DISTINCT total_il_high_credit_limit, COUNT(total_il_high_credit_limit) 
FROM credit_data
GROUP BY total_il_high_credit_limit;
--Fine

-- hardship_flag
SELECT DISTINCT hardship_flag, COUNT(hardship_flag) 
FROM credit_data
GROUP BY hardship_flag;
--Data too small to matter
ALTER TABLE credit_data
DROP COLUMN hardship_flag

-- disbursement_method
SELECT DISTINCT disbursement_method, COUNT(disbursement_method) 
FROM credit_data
GROUP BY disbursement_method;

UPDATE credit_data
SET disbursement_method = 0
WHERE disbursement_method = 'Cash'

UPDATE credit_data
SET disbursement_method = 1
WHERE disbursement_method = 'DirectPay'

-- debt_settlement_flag
SELECT DISTINCT debt_settlement_flag, COUNT(debt_settlement_flag) 
FROM credit_data
GROUP BY debt_settlement_flag;

UPDATE credit_data
SET debt_settlement_flag = 0
WHERE debt_settlement_flag = 'N'

UPDATE credit_data
SET debt_settlement_flag = 1
WHERE debt_settlement_flag = 'Y'


--Done, gonna go into python now

SELECT * FROM credit_data