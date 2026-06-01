/*
Purpose:    应用集市层-跑数脚本。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py ${batch_date} idl_m_sys_lspz
CreateDate: 20200618
FileType:   DML
Logs:
    dongyl 2020-06-18 新建表本
*/

truncate table ${idl_schema}.m_sys_lspz;
insert into ${idl_schema}.m_sys_lspz values('2','DS03','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('2','DS36','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('4','DS39','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('01','CNY','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('12','GBP','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('13','HKD','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('14','USD','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('15','CHF','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('18','SGD','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('27','JPY','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('28','CAD','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('29','AUD','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('38','EUR','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('43','KRW','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('90','RUB','CCY_CD','币种代码');
insert into ${idl_schema}.m_sys_lspz values('0','1','CASH_REMIT_IND_CD','钞汇标识代码');
insert into ${idl_schema}.m_sys_lspz values('1','2','CASH_REMIT_IND_CD','钞汇标识代码');
insert into ${idl_schema}.m_sys_lspz values('x','x','CASH_REMIT_IND_CD','钞汇标识代码');
insert into ${idl_schema}.m_sys_lspz values('0','IT01','DACCT_INTR_MTH_CD','计息方式代码');
insert into ${idl_schema}.m_sys_lspz values('1','IT02','DACCT_INTR_MTH_CD','计息方式代码');
insert into ${idl_schema}.m_sys_lspz values('0','DS38','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('1','DS01','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('2','DS02','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('3','DS41','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('8','DS13','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('9','DS35','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('4','DS99','ACCT_STATS_CD','账户状态代码');
insert into ${idl_schema}.m_sys_lspz values('0','A02','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('1','A01','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('4','A03','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('5','A21','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('6','A04','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('7','A05','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('9','A24','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('B','A27','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('C','A28','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('F','A25','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('G','A26','DACCT_TYP_CD','存款分户类型代码');
insert into ${idl_schema}.m_sys_lspz values('223304','2011010203','PRD_ID','产品编号');
insert into ${idl_schema}.m_sys_lspz values('A','02','DRAW_MODE_CD','支取方式代码');
insert into ${idl_schema}.m_sys_lspz values('D','04','DRAW_MODE_CD','支取方式代码');
insert into ${idl_schema}.m_sys_lspz values('E','03','DRAW_MODE_CD','支取方式代码');
insert into ${idl_schema}.m_sys_lspz values('N','99','DRAW_MODE_CD','支取方式代码');
insert into ${idl_schema}.m_sys_lspz values('ATM','1003','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('BEP','1028','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('BPB','1013','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('CCU','2102','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('CLM','1019','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('CNT','1001','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('CUP','2101','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('CUS','2100','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('EAP','2304','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('EBK','1006','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('EES','1010','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('EFM','1014','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('FBS','1027','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('FUY','1030','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('LNT','1002','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('MBL','1007','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('NMB','1022','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('NPB','1033','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('NTE','1032','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('PAD','1009','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('POS','1005','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('POT','1021','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('SCK','9001','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('SEB','1202','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('TBM','1024','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('TBP','1018','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('TMS','1023','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('WWD','1020','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('WXY','1008','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('ZTS','9001','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values(' ','XXXX','REG_CHN_CD','开户渠道代码');
insert into ${idl_schema}.m_sys_lspz values('0','DS14','ACCT_STATS_CD','账户状态代码');
commit;