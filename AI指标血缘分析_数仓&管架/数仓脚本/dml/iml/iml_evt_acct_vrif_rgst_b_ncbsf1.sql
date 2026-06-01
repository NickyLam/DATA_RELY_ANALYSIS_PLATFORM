/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_acct_vrif_rgst_b_ncbsf1
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
drop table ${iml_schema}.evt_acct_vrif_rgst_b_ncbsf1_tm purge;
alter table ${iml_schema}.evt_acct_vrif_rgst_b add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_acct_vrif_rgst_b modify partition p_ncbsf1
    add subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_acct_vrif_rgst_b_ncbsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,disp_way_cd -- 处置方式代码
    ,vrif_dt -- 核实日期
    ,check_fail_descb -- 验证失败描述
    ,oper_teller_id -- 操作柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_acct_vrif_rgst_b
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ncbs_rb_acct_verify_hist-1
insert into ${iml_schema}.evt_acct_vrif_rgst_b_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,disp_way_cd -- 处置方式代码
    ,vrif_dt -- 核实日期
    ,check_fail_descb -- 验证失败描述
    ,oper_teller_id -- 操作柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '140010'||P1.BASE_ACCT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.ACCT_VERIFY_STATUS),'-') -- 账户核实状态代码
    ,P1.DISPOSAL_METHOD -- 处置方式代码
    ,P1.VERIFICATION_DATE -- 核实日期
    ,P1.ACCT_PROOF_REASON -- 验证失败描述
    ,P1.OPER_USER_ID -- 操作柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_verify_hist' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_verify_hist p1
    left join (select DISTINCT BASE_ACCT_NO,CARD_NO from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where  1 = 1     
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_acct_vrif_rgst_b truncate partition p_ncbsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_acct_vrif_rgst_b exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.evt_acct_vrif_rgst_b_ncbsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_acct_vrif_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_acct_vrif_rgst_b_ncbsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_acct_vrif_rgst_b', partname => 'p_ncbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);