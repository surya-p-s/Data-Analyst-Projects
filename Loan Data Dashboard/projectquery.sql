create database bank_loan;
use bank_loan;
select * from loanapprovedclean;

select count(*) from loanapprovedclean;
alter table loanapprovedclean rename to loanclean;
select * from loanclean;

select count(Loan_ID) from loanclean;
select count(Loan_ID) as Approve_Rejected, Loan_Status from loanclean group by Loan_Status;

select round(avg(LoanAmount),2) from loanclean where Loan_Status = 'Y';
select round(avg(CoapplicantIncome+ApplicantIncome),2) from loanclean;

select approved/count(Loan_ID) from loanclean where approved=(select count(loan_ID) from loanclean where Loan_Status ='Y');


alter table loanclean drop column Myunknowncolumn;
select * from loanclean;