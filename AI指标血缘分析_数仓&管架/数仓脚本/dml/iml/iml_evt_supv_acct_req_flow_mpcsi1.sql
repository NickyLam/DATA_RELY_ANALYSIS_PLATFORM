/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_supv_acct_req_flow_mpcsi1
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
drop table ${iml_schema}.evt_supv_acct_req_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_supv_acct_req_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_supv_acct_req_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_supv_acct_req_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,sys_id -- 系统编号
    ,tran_flow_num -- 交易流水号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,tran_cnt -- 交易次数
    ,tran_status_cd -- 交易状态代码
    ,supv_acct_id -- 监管账户编号
    ,bus_msg_id -- 业务报文编号
    ,intfc_name -- 接口名称
    ,proc_tm -- 处理时间
    ,rest_cd -- 处理结果代码
    ,que_start_tm -- 查询开始时间
    ,que_end_tm -- 查询结束时间
    ,return_code -- 返回码
    ,return_info_desc -- 返回信息描述
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 处理机构编号
    ,oper_teller_id -- 经办柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,prpery_flow_num -- 外围流水号
    ,sys_in_flow_num -- 系统内流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_supv_acct_req_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a1ftfmplistinfo-1
insert into ${iml_schema}.evt_supv_acct_req_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,sys_id -- 系统编号
    ,tran_flow_num -- 交易流水号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,tran_cnt -- 交易次数
    ,tran_status_cd -- 交易状态代码
    ,supv_acct_id -- 监管账户编号
    ,bus_msg_id -- 业务报文编号
    ,intfc_name -- 接口名称
    ,proc_tm -- 处理时间
    ,rest_cd -- 处理结果代码
    ,que_start_tm -- 查询开始时间
    ,que_end_tm -- 查询结束时间
    ,return_code -- 返回码
    ,return_info_desc -- 返回信息描述
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 处理机构编号
    ,oper_teller_id -- 经办柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,prpery_flow_num -- 外围流水号
    ,sys_in_flow_num -- 系统内流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401026'||P1.MAINSEQ||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.dateformat_max2(P1.TRANSDT||P1.TRANSTM) -- 中台交易日期
    ,P1.SYSCD -- 系统编号
    ,P1.TRANSSEQ -- 交易流水号
    ,nvl(trim(P1.BUSTYPE),'-') -- 业务类型代码
    ,nvl(trim(P1.IOTYPE),'-') -- 交易方向代码
    ,to_number(nvl(trim(P1.TRNUM),0)) -- 交易次数
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.STATUS END -- 交易状态代码
    ,P1.ACCOUNT -- 监管账户编号
    ,P1.MSGID -- 业务报文编号
    ,P1.INTERFACENAME -- 接口名称
    ,${iml_schema}.timeformat_max2(P1.DEALDATE) -- 处理时间
    ,nvl(trim(P1.DEALST),'-') -- 处理结果代码
    ,${iml_schema}.timeformat_min(P1.QUERYSTARTDATE) -- 查询开始时间
    ,${iml_schema}.timeformat_max2(P1.QUERYENDDATE) -- 查询结束时间
    ,P1.RETCODE -- 返回码
    ,P1.RETMSG -- 返回信息描述
    ,P1.OPENBRN -- 开户机构编号
    ,P1.BRCNO -- 处理机构编号
    ,P1.TLRNO -- 经办柜员编号
    ,P1.CKBKUS -- 授权柜员编号
    ,P1.GLOBSEQNUM -- 全局流水号
    ,P1.UNIQUESEQNUM -- 业务流水号
    ,P1.SRVTRXSEQ -- 外围流水号
    ,P1.ZTSTRNSEQNO -- 系统内流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1ftfmplistinfo' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1ftfmplistinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1FTFMPLISTINFO'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_SUPV_ACCT_REQ_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
where  1 = 1 
      and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_supv_acct_req_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_supv_acct_req_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_supv_acct_req_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_supv_acct_req_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_supv_acct_req_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_supv_acct_req_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);