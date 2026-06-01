/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ifs_jud_remit_rgst_b_ifcsi1
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
drop table ${iml_schema}.evt_ifs_jud_remit_rgst_b_ifcsi1_tm purge;
alter table ${iml_schema}.evt_ifs_jud_remit_rgst_b add partition p_ifcsi1 values ('ifcsi1')(
        subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ifs_jud_remit_rgst_b modify partition p_ifcsi1
    add subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_jud_remit_rgst_b_ifcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,unfrz_dt -- 解冻日期
    ,unfrz_tm -- 解冻时间
    ,tran_flow_num -- 交易流水号
    ,remit_way_cd -- 解除方式代码
    ,remit_proof_cate_cd -- 解除证明类别代码
    ,proof_num -- 证明文号
    ,exec_org -- 执行机关
    ,exec_ps_cert_type_cd_1 -- 执行人证件类型代码1
    ,exec_ps_cert_no_1 -- 执行人证件号码1
    ,exec_ps_cert_type_cd_2 -- 执行人证件类型代码2
    ,exec_ps_cert_no_2 -- 执行人证件号码2
    ,exec_ps_name -- 执行人姓名
    ,remit_rs -- 解除原因
    ,oper_teller_id -- 操作柜员编号
    ,org_id -- 机构编号
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow_num -- 原冻结流水号
    ,remit_amt -- 解除金额
    ,oper_teller_id_2 -- 操作柜员编号2
    ,jud_remit_chn_id -- 解冻解止渠道编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ifs_jud_remit_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifcs_jud_remit_rgst_b-
insert into ${iml_schema}.evt_ifs_jud_remit_rgst_b_ifcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,unfrz_dt -- 解冻日期
    ,unfrz_tm -- 解冻时间
    ,tran_flow_num -- 交易流水号
    ,remit_way_cd -- 解除方式代码
    ,remit_proof_cate_cd -- 解除证明类别代码
    ,proof_num -- 证明文号
    ,exec_org -- 执行机关
    ,exec_ps_cert_type_cd_1 -- 执行人证件类型代码1
    ,exec_ps_cert_no_1 -- 执行人证件号码1
    ,exec_ps_cert_type_cd_2 -- 执行人证件类型代码2
    ,exec_ps_cert_no_2 -- 执行人证件号码2
    ,exec_ps_name -- 执行人姓名
    ,remit_rs -- 解除原因
    ,oper_teller_id -- 操作柜员编号
    ,org_id -- 机构编号
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow_num -- 原冻结流水号
    ,remit_amt -- 解除金额
    ,oper_teller_id_2 -- 操作柜员编号2
    ,jud_remit_chn_id -- 解冻解止渠道编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102032'||p1.REMIT_DT||p1.REMIT_FLOW_NUM||p1.TRAN_FLOW_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_min(P1.REMIT_DT) -- 解冻日期
    ,P1.REMIT_TM -- 解冻时间
    ,P1.TRAN_FLOW_NUM -- 交易流水号
    ,P1.REMIT_WAY -- 解除方式代码
    ,P1.REMIT_PROOF_TYPE -- 解除证明类别代码
    ,P1.PROOF_NUM -- 证明文号
    ,P1.EXEC_ORG_CD -- 执行机关
    ,P1.EXEC_CERT_TYPE_01 -- 执行人证件类型代码1
    ,P1.EXEC_CERT_NO_01 -- 执行人证件号码1
    ,P1.EXEC_CERT_TYPE_02 -- 执行人证件类型代码2
    ,P1.EXEC_CERT_NO_02 -- 执行人证件号码2
    ,P1.EXEC_PS_01 -- 执行人姓名
    ,P1.REMIT_RS -- 解除原因
    ,P1.TELLER_NO -- 操作柜员编号
    ,P1.ORG_NO -- 机构编号
    ,${iml_schema}.dateformat_min(P1.INIT_FROZ_DT) -- 原冻结日期
    ,P1.INIT_FROZ_FLOW -- 原冻结流水号
    ,P1.REMIT_AMT -- 解除金额
    ,P1.EXEC_PS_02 -- 操作柜员编号2
    ,P1.REMIT_CHN -- 解冻解止渠道编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_jud_remit_rgst_b' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_jud_remit_rgst_b p1
where  1 = 1 
    and p1.remit_dt= '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ifs_jud_remit_rgst_b truncate subpartition p_ifcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ifs_jud_remit_rgst_b exchange subpartition p_ifcsi1_${batch_date} with table ${iml_schema}.evt_ifs_jud_remit_rgst_b_ifcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ifs_jud_remit_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ifs_jud_remit_rgst_b_ifcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ifs_jud_remit_rgst_b', partname => 'p_ifcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);