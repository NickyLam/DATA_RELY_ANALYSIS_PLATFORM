/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ifs_ct_froz_rgst_b_ifcsf1
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
drop table ${iml_schema}.evt_ifs_ct_froz_rgst_b_ifcsf1_tm purge;
alter table ${iml_schema}.evt_ifs_ct_froz_rgst_b add partition p_ifcsf1 values ('ifcsf1')(
        subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ifs_ct_froz_rgst_b modify partition p_ifcsf1
    add subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_ct_froz_rgst_b_ifcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ct_froz_dt -- 续冻日期
    ,ct_froz_tm -- 续冻时间
    ,ct_froz_amt -- 续冻金额
    ,init_froz_end_dt -- 原冻结截至日期
    ,init_proof_cate_cd -- 原证明类别代码
    ,init_cert_num -- 原证明书号
    ,init_froz_rs -- 原冻结原因
    ,init_exec_org -- 原执行机关
    ,init_exec_cert_1 -- 原执行证件1
    ,init_exec_num_1 -- 原执行号码1
    ,init_exec_cert_2 -- 原执行证件2
    ,init_exec_num_2 -- 原执行号码2
    ,init_exec_ps -- 原执行人
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow -- 原冻结流水
    ,init_froz_seq_num -- 原冻结序号
    ,init_exec_ps_2 -- 原执行人2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ifs_ct_froz_rgst_b
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ifcs_cotin_froz_rgst_b-
insert into ${iml_schema}.evt_ifs_ct_froz_rgst_b_ifcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ct_froz_dt -- 续冻日期
    ,ct_froz_tm -- 续冻时间
    ,ct_froz_amt -- 续冻金额
    ,init_froz_end_dt -- 原冻结截至日期
    ,init_proof_cate_cd -- 原证明类别代码
    ,init_cert_num -- 原证明书号
    ,init_froz_rs -- 原冻结原因
    ,init_exec_org -- 原执行机关
    ,init_exec_cert_1 -- 原执行证件1
    ,init_exec_num_1 -- 原执行号码1
    ,init_exec_cert_2 -- 原执行证件2
    ,init_exec_num_2 -- 原执行号码2
    ,init_exec_ps -- 原执行人
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow -- 原冻结流水
    ,init_froz_seq_num -- 原冻结序号
    ,init_exec_ps_2 -- 原执行人2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102031'||P1.COTIN_FROZ_DT||P1.COTIN_FROZ_FLOW_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_min(P1.COTIN_FROZ_DT) -- 续冻日期
    ,P1.CON_FROZ_TM -- 续冻时间
    ,P1.COTIN_FROZ_AMT -- 续冻金额
    ,P1.INIT_FROZ_END_DT -- 原冻结截至日期
    ,P1.INIT_PROOF_CATE -- 原证明类别代码
    ,P1.INIT_PROOF_NUM -- 原证明书号
    ,P1.INIT_FROZ_RS -- 原冻结原因
    ,P1.INIT_EXEC_ORG -- 原执行机关
    ,P1.INIT_EXEC_CERT_01 -- 原执行证件1
    ,P1.INIT_EXEC_NUM_01 -- 原执行号码1
    ,P1.INIT_EXEC_CERT_02 -- 原执行证件2
    ,P1.INIT_EXEC_NUM_02 -- 原执行号码2
    ,P1.INIT_EXEC_PS_01 -- 原执行人
    ,${iml_schema}.dateformat_min(P1.INIT_FROZ_DT) -- 原冻结日期
    ,P1.INIT_FROZ_FLOW -- 原冻结流水
    ,P1.INIT_FROZ_SEQ_NUM -- 原冻结序号
    ,P1.INIT_EXEC_PS_02 -- 原执行人2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_cotin_froz_rgst_b' -- 源表名称
    ,'ifcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_cotin_froz_rgst_b p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_ifs_ct_froz_rgst_b truncate partition p_ifcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ifs_ct_froz_rgst_b exchange subpartition p_ifcsf1_${batch_date} with table ${iml_schema}.evt_ifs_ct_froz_rgst_b_ifcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ifs_ct_froz_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ifs_ct_froz_rgst_b_ifcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ifs_ct_froz_rgst_b', partname => 'p_ifcsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);