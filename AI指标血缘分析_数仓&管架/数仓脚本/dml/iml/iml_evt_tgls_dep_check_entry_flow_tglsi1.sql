/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tgls_dep_check_entry_flow_tglsi1
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
drop table ${iml_schema}.evt_tgls_dep_check_entry_flow_tglsi1_tm purge;
alter table ${iml_schema}.evt_tgls_dep_check_entry_flow add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tgls_dep_check_entry_flow modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tgls_dep_check_entry_flow_tglsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,batch_no_dt -- 批次号日期
    ,fin_dt -- 财务日期
    ,sorc_sys_cd -- 源系统代码
    ,fin_org_id -- 财务机构编号
    ,amt_type_cd -- 金额类型代码
    ,curr_cd -- 币种代码
    ,sob_id -- 账套编号
    ,acct_id -- 账户编号
    ,sellbl_prod_id -- 可售产品编号
    ,cap_char_cd -- 资金性质代码
    ,bal -- 余额
    ,tran_dir_cd -- 交易方向代码
    ,tran_amt -- 交易金额
    ,base_prod_id -- 基础产品编号
    ,core_module -- 核心模块
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tgls_dep_check_entry_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_glb_dept_book-1
insert into ${iml_schema}.evt_tgls_dep_check_entry_flow_tglsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,batch_no_dt -- 批次号日期
    ,fin_dt -- 财务日期
    ,sorc_sys_cd -- 源系统代码
    ,fin_org_id -- 财务机构编号
    ,amt_type_cd -- 金额类型代码
    ,curr_cd -- 币种代码
    ,sob_id -- 账套编号
    ,acct_id -- 账户编号
    ,sellbl_prod_id -- 可售产品编号
    ,cap_char_cd -- 资金性质代码
    ,bal -- 余额
    ,tran_dir_cd -- 交易方向代码
    ,tran_amt -- 交易金额
    ,base_prod_id -- 基础产品编号
    ,core_module -- 核心模块
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401009'||P1.BATHID||P1.BATHDT||P1.ACCTDT||P1.SYSTID||P1.BRCHCD||P1.TRPRCD||P1.CRCYCD -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATHID -- 批次号
    ,${iml_schema}.dateformat_min(P1.BATHDT) -- 批次号日期
    ,${iml_schema}.dateformat_min(P1.ACCTDT) -- 财务日期
    ,nvl(trim(P1.SYSTID),'-') -- 源系统代码
    ,P1.BRCHCD -- 财务机构编号
    ,nvl(trim(P1.TRPRCD),'-') -- 金额类型代码
    ,nvl(trim(P1.CRCYCD),'-') -- 币种代码
    ,P1.STACID -- 账套编号
    ,P1.ACCTNO -- 账户编号
    ,P1.ASSIS1 -- 可售产品编号
    ,decode(trim(P1.LOANP3),'','-','*','-',P1.LOANP3) -- 资金性质代码
    ,P1.CAPTAL -- 余额
    ,nvl(trim(P1.EVETDN),'-') -- 交易方向代码
    ,P1.TRANAM -- 交易金额
    ,P1.LOANP1 -- 基础产品编号
    ,P1.LOANP2 -- 核心模块
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_glb_dept_book' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_glb_dept_book p1
where  1 = 1 
    and P1.SYSTID='NCBS'
    and P1.acctdt = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_tgls_dep_check_entry_flow truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_tgls_dep_check_entry_flow exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.evt_tgls_dep_check_entry_flow_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tgls_dep_check_entry_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_tgls_dep_check_entry_flow_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tgls_dep_check_entry_flow', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);