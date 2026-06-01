/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_open_acct_acct_que_rgst_b_mpcsi1
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
drop table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b_mpcsi1_tm purge;
alter table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,msg_ind_no -- 报文标识号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,que_acct_qtty -- 查询账户数量
    ,seq_num -- 序号
    ,acct_que_rest_cd -- 账户查询结果代码
    ,acct_kind_cd -- 账户种类代码
    ,open_bank_no -- 开户行行号
    ,msg_id -- 报文编号
    ,midgrod_tran_dt -- 中台交易日期
    ,midgrod_tran_tm -- 中台交易时间
    ,msg_send_tm -- 报文发送时间
    ,proc_status_cd -- 处理状态代码
    ,pbc_rest_cd -- 人行处理结果代码
    ,pbc_proc_dt -- 人行处理日期
    ,nostro_cd -- 往来账代码
    ,bus_refuse_code -- 业务拒绝码
    ,bus_refuse_info_desc -- 业务拒绝信息描述
    ,bus_process_cd -- 业务处理码
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_prtcpt_org_id -- 发起参与机构编号
    ,recv_dir_prtcpt_org_id -- 接收直接参与机构编号
    ,recv_prtcpt_org_id -- 接收参与机构编号
    ,sys_id -- 系统编号
    ,remark -- 备注
    ,comm_msg_ind_no -- 通讯机报文标识号
    ,id_no -- 身份证号码
    ,rsrv_mobile_no -- 预留手机号码
    ,tel_num -- 电话号码
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 交易码
    ,sorc_sys_id -- 源系统编号
    ,open_acct_org_id -- 开户机构编号
    ,check_dept_id -- 检查部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a08plkhzhcx-1
insert into ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,msg_ind_no -- 报文标识号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,que_acct_qtty -- 查询账户数量
    ,seq_num -- 序号
    ,acct_que_rest_cd -- 账户查询结果代码
    ,acct_kind_cd -- 账户种类代码
    ,open_bank_no -- 开户行行号
    ,msg_id -- 报文编号
    ,midgrod_tran_dt -- 中台交易日期
    ,midgrod_tran_tm -- 中台交易时间
    ,msg_send_tm -- 报文发送时间
    ,proc_status_cd -- 处理状态代码
    ,pbc_rest_cd -- 人行处理结果代码
    ,pbc_proc_dt -- 人行处理日期
    ,nostro_cd -- 往来账代码
    ,bus_refuse_code -- 业务拒绝码
    ,bus_refuse_info_desc -- 业务拒绝信息描述
    ,bus_process_cd -- 业务处理码
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_prtcpt_org_id -- 发起参与机构编号
    ,recv_dir_prtcpt_org_id -- 接收直接参与机构编号
    ,recv_prtcpt_org_id -- 接收参与机构编号
    ,sys_id -- 系统编号
    ,remark -- 备注
    ,comm_msg_ind_no -- 通讯机报文标识号
    ,id_no -- 身份证号码
    ,rsrv_mobile_no -- 预留手机号码
    ,tel_num -- 电话号码
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 交易码
    ,sorc_sys_id -- 源系统编号
    ,open_acct_org_id -- 开户机构编号
    ,check_dept_id -- 检查部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201016'||P1.TRANSSEQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRANSSEQ -- 报文标识号
    ,P1.ACCTNO -- 账户编号
    ,P1.ACCTNAME -- 账户名称
    ,NVL(TRIM(P1.QRYACCTCNT),0) -- 查询账户数量
    ,P1.NO -- 序号
    ,P1.ACCOUNTSTATUS -- 账户查询结果代码
    ,P1.ACCOUNTLEVEL -- 账户种类代码
    ,P1.ACCTOPENBRN -- 开户行行号
    ,P1.PTKYPE -- 报文编号
    ,${iml_schema}.dateformat_max(P1.transdt) -- 中台交易日期
    ,${iml_schema}.timeformat_min(P1.transdt||' '||p1.transtm) -- 中台交易时间
    ,${iml_schema}.timeformat_min(REPLACE(p1.transmitdt,'T',' ')) -- 报文发送时间
    ,P1.TRANST -- 处理状态代码
    ,P1.PROCESSCODE -- 人行处理结果代码
    ,${iml_schema}.dateformat_max(P1.obaldt) -- 人行处理日期
    ,P1.IOTYPE -- 往来账代码
    ,P1.ADVEST -- 业务拒绝码
    ,P1.RJCTINF -- 业务拒绝信息描述
    ,P1.PRCCD -- 业务处理码
    ,P1.SNDUPBRN -- 发起直接参与机构编号
    ,P1.SNDBRN -- 发起参与机构编号
    ,P1.RCVUPBRN -- 接收直接参与机构编号
    ,P1.RCVBRN -- 接收参与机构编号
    ,P1.SYSCD -- 系统编号
    ,P1.NOTE -- 备注
    ,P1.REFMSGNO -- 通讯机报文标识号
    ,P1.ID -- 身份证号码
    ,P1.MOBILEPHONE -- 预留手机号码
    ,P1.TEL -- 电话号码
    ,P1.CONTACTCERTIFICATETYPEID -- 证件类型代码
    ,P1.INFOSTRING -- 证件编号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.CHANNLID -- 交易码
    ,P1.SRCSYSID -- 源系统编号
    ,P1.OPENBRN -- 开户机构编号
    ,P1.CHECKDEPT -- 检查部门编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08plkhzhcx' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08plkhzhcx p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b truncate partition p_mpcsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_batch_open_acct_acct_que_rgst_b_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_open_acct_acct_que_rgst_b', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);