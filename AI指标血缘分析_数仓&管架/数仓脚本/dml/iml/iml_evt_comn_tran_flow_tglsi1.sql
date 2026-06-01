/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_comn_tran_flow_tglsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_comn_tran_flow_tglsi1_tm purge;
alter table ${iml_schema}.evt_comn_tran_flow add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_comn_tran_flow modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_comn_tran_flow_tglsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,bus_acct_id -- 业务账户编号
    ,bus_type_id -- 业务类型编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_code -- 交易码
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_dir_cd -- 交易方向代码
    ,tard_way_cd -- 交易方式代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_org_id -- 交易机构编号
    ,acct_instit_id -- 账务机构编号
    ,revs_flg -- 冲正标志
    ,brevs_bus_tran_dt -- 被冲正业务交易日期
    ,brevs_bus_tran_flow_num -- 被冲正业务交易流水号
    ,sorc_sys_cd -- 源系统代码
    ,bal_type_cd -- 余额类型代码
    ,charge_doc_id -- 收费单据编号
    ,evt_type_id -- 事件类型编号
    ,amt_8 -- 金额8
    ,amt_6 -- 金额6
    ,amt_5 -- 金额5
    ,process_cd -- 处理码
    ,remark -- 备注
    ,cap_char_cd -- 资金性质代码
    ,taxable_flg -- 应税标志
    ,int_accr_way_cd -- 计息方式代码
    ,core_tran_dt -- 核心交易日期
    ,batch_no -- 批次号
    ,emply_id -- 员工编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_comn_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_loan_busi_h-1
insert into ${iml_schema}.evt_comn_tran_flow_tglsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,bus_acct_id -- 业务账户编号
    ,bus_type_id -- 业务类型编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_code -- 交易码
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_dir_cd -- 交易方向代码
    ,tard_way_cd -- 交易方式代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_org_id -- 交易机构编号
    ,acct_instit_id -- 账务机构编号
    ,revs_flg -- 冲正标志
    ,brevs_bus_tran_dt -- 被冲正业务交易日期
    ,brevs_bus_tran_flow_num -- 被冲正业务交易流水号
    ,sorc_sys_cd -- 源系统代码
    ,bal_type_cd -- 余额类型代码
    ,charge_doc_id -- 收费单据编号
    ,evt_type_id -- 事件类型编号
    ,amt_8 -- 金额8
    ,amt_6 -- 金额6
    ,amt_5 -- 金额5
    ,process_cd -- 处理码
    ,remark -- 备注
    ,cap_char_cd -- 资金性质代码
    ,taxable_flg -- 应税标志
    ,int_accr_way_cd -- 计息方式代码
    ,core_tran_dt -- 核心交易日期
    ,batch_no -- 批次号
    ,emply_id -- 员工编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401020'||to_char(P1.STACID)||P1.TRANSQ||P1.TRANDT||P1.BSNSSQ||to_char(P1.SERINO) -- 事件编号
    ,'9999' -- 法人编号
    ,to_char(P1.STACID) -- 账套编号
    ,P1.BSNSSQ -- 全局流水号
    ,P1.CUSTCD -- 客户编号
    ,P1.ACCTNO -- 业务账户编号
    ,P1.PRODCD -- 业务类型编号
    ,P1.ASSIS1 -- 产品编号
    ,nvl(trim(P1.CRCYCD),'-') -- 币种代码
    ,P1.ASSIS4 -- 交易码
    ,P1.TRANSQ -- 交易流水号
    ,${iml_schema}.dateformat_min(P1.TRANDT) -- 交易日期
    ,nvl(trim(P1.EVETDN),'-') -- 交易方向代码
    ,nvl(trim(P1.TRANTP),'-') -- 交易方式代码
    ,P1.TRANAM -- 交易金额
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,nvl(trim(P1.ASSIS0),'0000') -- 交易渠道代码
    ,P1.TRANBR -- 交易机构编号
    ,P1.ACCTBR -- 账务机构编号
    ,nvl(trim(P1.STRKST),'-') -- 冲正标志
    ,${iml_schema}.dateformat_min(P1.STRKDT) -- 被冲正业务交易日期
    ,P1.STRKSQ -- 被冲正业务交易流水号
    ,nvl(trim(P1.SYSTID),'-') -- 源系统代码
    ,nvl(trim(P1.TRPRCD),'-') -- 余额类型代码
    ,to_char(P1.SERINO) -- 收费单据编号
    ,P1.ASSIS5 -- 事件类型编号
    ,P1.NUMEX7 -- 金额8
    ,P1.NUMEX5 -- 金额6
    ,P1.NUMEX4 -- 金额5
    ,P1.PRCSCD -- 处理码
    ,P1.CHREXJ -- 备注
    ,decode(trim(P1.LOANP2),'','-','*','-',P1.LOANP2) -- 资金性质代码
    ,decode(P1.CHREX2,'Y','1','N','0','*','-',' ','-',P1.CHREX2) -- 应税标志
    ,nvl(trim(P1.LOANP3),'-') -- 计息方式代码
    ,${iml_schema}.dateformat_max2(P1.DATEX0) -- 核心交易日期
    ,P1.BATHID -- 批次号
    ,P1.PRSNCD -- 员工编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_loan_busi_h' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_loan_busi_h p1
where  1 = 1 
    and to_char(p1.stacid)='1'
     and P1.trandt = '${batch_date}'
     and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;

-- tgls_loan_busi-1
insert into ${iml_schema}.evt_comn_tran_flow_tglsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sob_id -- 账套编号
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,bus_acct_id -- 业务账户编号
    ,bus_type_id -- 业务类型编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_code -- 交易码
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_dir_cd -- 交易方向代码
    ,tard_way_cd -- 交易方式代码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_org_id -- 交易机构编号
    ,acct_instit_id -- 账务机构编号
    ,revs_flg -- 冲正标志
    ,brevs_bus_tran_dt -- 被冲正业务交易日期
    ,brevs_bus_tran_flow_num -- 被冲正业务交易流水号
    ,sorc_sys_cd -- 源系统代码
    ,bal_type_cd -- 余额类型代码
    ,charge_doc_id -- 收费单据编号
    ,evt_type_id -- 事件类型编号
    ,amt_8 -- 金额8
    ,amt_6 -- 金额6
    ,amt_5 -- 金额5
    ,process_cd -- 处理码
    ,remark -- 备注
    ,cap_char_cd -- 资金性质代码
    ,taxable_flg -- 应税标志
    ,int_accr_way_cd -- 计息方式代码
    ,core_tran_dt -- 核心交易日期
    ,batch_no -- 批次号
    ,emply_id -- 员工编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401020'||to_char(P1.STACID)||P1.TRANSQ||P1.TRANDT||P1.BSNSSQ||to_char(P1.SERINO) -- 事件编号
    ,'9999' -- 法人编号
    ,to_char(P1.STACID) -- 账套编号
    ,P1.BSNSSQ -- 全局流水号
    ,P1.CUSTCD -- 客户编号
    ,P1.ACCTNO -- 业务账户编号
    ,P1.PRODCD -- 业务类型编号
    ,P1.ASSIS1 -- 产品编号
    ,nvl(trim(P1.CRCYCD),'-') -- 币种代码
    ,P1.ASSIS4 -- 交易码
    ,P1.TRANSQ -- 交易流水号
    ,${iml_schema}.dateformat_min(P1.TRANDT) -- 交易日期
    ,nvl(trim(P1.EVETDN),'-') -- 交易方向代码
    ,nvl(trim(P1.TRANTP),'-') -- 交易方式代码
    ,P1.TRANAM -- 交易金额
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,nvl(trim(P1.ASSIS0),'0000') -- 交易渠道代码
    ,P1.TRANBR -- 交易机构编号
    ,P1.ACCTBR -- 账务机构编号
    ,nvl(trim(P1.STRKST),'-') -- 冲正标志
    ,${iml_schema}.dateformat_min(P1.STRKDT) -- 被冲正业务交易日期
    ,P1.STRKSQ -- 被冲正业务交易流水号
    ,nvl(trim(P1.SYSTID),'-') -- 源系统代码
    ,nvl(trim(P1.TRPRCD),'-') -- 余额类型代码
    ,to_char(P1.SERINO) -- 收费单据编号
    ,P1.ASSIS5 -- 事件类型编号
    ,P1.NUMEX7 -- 金额8
    ,P1.NUMEX5 -- 金额6
    ,P1.NUMEX4 -- 金额5
    ,P1.PRCSCD -- 处理码
    ,P1.CHREXJ -- 备注
    ,decode(trim(P1.LOANP2),'','-','*','-',P1.LOANP2) -- 资金性质代码
    ,decode(P1.CHREX2,'Y','1','N','0','*','-',' ','-',P1.CHREX2) -- 应税标志
    ,nvl(trim(P1.LOANP3),'-') -- 计息方式代码
    ,${iml_schema}.dateformat_max2(P1.DATEX0) -- 核心交易日期
    ,P1.BATHID -- 批次号
    ,P1.PRSNCD -- 员工编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_loan_busi' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_loan_busi p1
where  1 = 1 
    and to_char(p1.stacid)='2'
and p1.trandt = '${batch_date}'
and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h p2 
                   where p2.transq=p1.transq 
                     and p2.trandt=p1.trandt 
                     and p2.bsnssq=p1.bsnssq 
                     and p2.serino=p1.serino
                     and to_char(p2.stacid)='1'
                     and p2.trandt = '${batch_date}'
                     and p2.etl_dt = to_date('${batch_date}','yyyymmdd'))
;
commit;


-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_comn_tran_flow truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_comn_tran_flow exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.evt_comn_tran_flow_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_comn_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_comn_tran_flow_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_comn_tran_flow', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);