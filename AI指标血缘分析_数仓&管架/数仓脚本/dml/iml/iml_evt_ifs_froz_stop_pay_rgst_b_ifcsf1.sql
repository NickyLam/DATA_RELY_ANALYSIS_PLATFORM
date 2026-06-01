/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ifs_froz_stop_pay_rgst_b_ifcsf1
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
drop table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b_ifcsf1_tm purge;
alter table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b add partition p_ifcsf1 values ('ifcsf1')(
        subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b modify partition p_ifcsf1
    add subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b_ifcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,froz_dt -- 冻结日期
    ,froz_tm -- 冻结时间
    ,seq_num -- 顺序号
    ,tran_flow_num -- 交易流水号
    ,rec_cate_cd -- 记录类别代码
    ,bus_way_cd -- 业务方式代码
    ,status_cd -- 状态代码
    ,acct_num -- 账号
    ,sub_acct_num -- 子户号
    ,cust_name -- 客户名称
    ,appl_froz_amt -- 申请冻结金额
    ,surp_froz_amt -- 剩余冻结金额
    ,froz_end_dt -- 冻结截至日期
    ,proof_cate_cd -- 证明类别代码
    ,cert_num -- 证明书号
    ,froz_rs -- 冻结原因
    ,exec_org -- 执行机关
    ,exec_cert_type_cd_1 -- 执行证件类型代码1
    ,exec_num_1 -- 执行号码1
    ,exec_cert_type_cd_2 -- 执行证件类型代码2
    ,exec_num_2 -- 执行号码2
    ,exec_ps_1 -- 执行人1
    ,exec_ps_2 -- 执行人2
    ,operr_id -- 操作员编号
    ,tran_org_id -- 交易机构编号
    ,chn_id -- 渠道编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ifcs_froz_stop_pay_rgst_b-
insert into ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b_ifcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,froz_dt -- 冻结日期
    ,froz_tm -- 冻结时间
    ,seq_num -- 顺序号
    ,tran_flow_num -- 交易流水号
    ,rec_cate_cd -- 记录类别代码
    ,bus_way_cd -- 业务方式代码
    ,status_cd -- 状态代码
    ,acct_num -- 账号
    ,sub_acct_num -- 子户号
    ,cust_name -- 客户名称
    ,appl_froz_amt -- 申请冻结金额
    ,surp_froz_amt -- 剩余冻结金额
    ,froz_end_dt -- 冻结截至日期
    ,proof_cate_cd -- 证明类别代码
    ,cert_num -- 证明书号
    ,froz_rs -- 冻结原因
    ,exec_org -- 执行机关
    ,exec_cert_type_cd_1 -- 执行证件类型代码1
    ,exec_num_1 -- 执行号码1
    ,exec_cert_type_cd_2 -- 执行证件类型代码2
    ,exec_num_2 -- 执行号码2
    ,exec_ps_1 -- 执行人1
    ,exec_ps_2 -- 执行人2
    ,operr_id -- 操作员编号
    ,tran_org_id -- 交易机构编号
    ,chn_id -- 渠道编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102030'||P1.FROZ_DT||P1.FROZ_FLOW_NUM||P1.TRAN_FLOW_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_min(P1.FROZ_DT) -- 冻结日期
    ,SUBSTR(P1.FROZ_TM,10) -- 冻结时间
    ,P1.SEQ_NUM -- 顺序号
    ,P1.TRAN_FLOW_NUM -- 交易流水号
    ,NVL(P1.REC_TYPE,'-') -- 记录类别代码
    ,NVL(P1.BUS_TYPE,'-') -- 业务方式代码
    ,NVL(P1.STATUS_CD,'-') -- 状态代码
    ,P1.ACCT_ID -- 账号
    ,P1.DEP_PROD_SUB_ACCT_ID -- 子户号
    ,P1.ACCT_NAME -- 客户名称
    ,P1.APPL_FROZ_AMT -- 申请冻结金额
    ,P1.SURP_FROZ_AMT -- 剩余冻结金额
    ,${iml_schema}.dateformat_min(P1.FROZ_END_DT) -- 冻结截至日期
    ,P1.PROOF_TYPE -- 证明类别代码
    ,P1.PROOF_ID -- 证明书号
    ,P1.FROZ_RS -- 冻结原因
    ,P1.EXEC_ORG_CD -- 执行机关
    ,decode(trim(P1.EXEC_CERT_TYPE_01),'W1','1999','E1','1090','','0000') -- 执行证件类型代码1
    ,P1.EXEC_CERT_NO_01 -- 执行号码1
    ,decode(trim(P1.EXEC_CERT_TYPE_02),'W1','1999','E1','1090','','0000') -- 执行证件类型代码2
    ,P1.EXEC_CERT_NO_02 -- 执行号码2
    ,P1.EXEC_PS_01 -- 执行人1
    ,P1.EXEC_PS_02 -- 执行人2
    ,P1.OPERR_NO -- 操作员编号
    ,P1.TRAN_ORG -- 交易机构编号
    ,nvl(trim(P1.CHN_CD),'-') -- 渠道编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_froz_stop_pay_rgst_b' -- 源表名称
    ,'ifcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_froz_stop_pay_rgst_b p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b truncate partition p_ifcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b exchange subpartition p_ifcsf1_${batch_date} with table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b_ifcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b_ifcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ifs_froz_stop_pay_rgst_b', partname => 'p_ifcsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);