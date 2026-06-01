/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_debt_rgst_flow_ncbsi1
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
drop table ${iml_schema}.evt_debt_rgst_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_debt_rgst_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_debt_rgst_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_debt_rgst_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_name -- 账户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,priv_flg -- 对私标志
    ,open_acct_org_id -- 开户机构编号
    ,amt_type_cd -- 金额类型代码
    ,amt -- 金额
    ,debit_crdt_flg -- 借贷标志
    ,real_cntpty_cust_acct_num -- 真实交易对手客户账号
    ,real_cntpty_name -- 真实交易对手名称
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,tran_revs_flg -- 交易冲正标志
    ,post_flg -- 过账标志
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_debt_rgst_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_asset_offset_debt_reg-1
insert into ${iml_schema}.evt_debt_rgst_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_name -- 账户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,priv_flg -- 对私标志
    ,open_acct_org_id -- 开户机构编号
    ,amt_type_cd -- 金额类型代码
    ,amt -- 金额
    ,debit_crdt_flg -- 借贷标志
    ,real_cntpty_cust_acct_num -- 真实交易对手客户账号
    ,real_cntpty_name -- 真实交易对手名称
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,tran_revs_flg -- 交易冲正标志
    ,post_flg -- 过账标志
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401043'||to_number(nvl(trim(P1.INTERNAL_KEY),'0'))||P1.REFERENCE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.ACCT_DESC -- 账户名称
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,to_number(nvl(trim(P1.INTERNAL_KEY),'0')) -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,decode(P1.INDIVIDUAL_FLAG,'Y','1','N','0',' ','-',P1.INDIVIDUAL_FLAG) -- 对私标志
    ,P1.BRANCH -- 开户机构编号
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,P1.BALANCE -- 金额
    ,nvl(trim(P1.CR_DR_IND),'-') -- 借贷标志
    ,P1.OTH_REAL_BASE_ACCT_NO -- 真实交易对手客户账号
    ,P1.OTH_REAL_TRAN_NAME -- 真实交易对手名称
    ,P1.REFERENCE -- 交易参考号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,decode(P1.REVERSAL_FLAG,'Y','1','N','0',' ','-',P1.REVERSAL_FLAG) -- 交易冲正标志
    ,decode(P1.GL_POSTED_FLAG,'Y','1','N','0',' ','-',P1.GL_POSTED_FLAG) -- 过账标志
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_max(P1.TRAN_TIMESTAMP) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_asset_offset_debt_reg' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_asset_offset_debt_reg p1
where  1 = 1 
    and P1.ETL_DT = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_debt_rgst_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_debt_rgst_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_debt_rgst_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_debt_rgst_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_debt_rgst_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_debt_rgst_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);