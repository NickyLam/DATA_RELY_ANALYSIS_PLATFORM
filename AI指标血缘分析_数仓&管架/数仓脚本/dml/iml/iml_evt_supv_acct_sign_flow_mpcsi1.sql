/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_supv_acct_sign_flow_mpcsi1
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
drop table ${iml_schema}.evt_supv_acct_sign_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_supv_acct_sign_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_supv_acct_sign_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_supv_acct_sign_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_id -- 系统编号
    ,supv_acct_id -- 监管账户编号
    ,sign_dt -- 签约日期
    ,supv_acct_name -- 监管账户名称
    ,supv_status_cd -- 监管状态代码
    ,sign_status_cd -- 签约状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_org_id -- 开户机构编号
    ,open_bank_name -- 开户行名称
    ,proj_name -- 项目名称
    ,corp_name -- 单位名称
    ,cotas_name -- 联系人名称
    ,cotas_tel -- 联系人电话
    ,rels_dt -- 解约日期
    ,err_info_desc -- 错误信息描述
    ,send_status_cd -- 发送状态代码
    ,oper_rest_cd -- 操作结果代码
    ,return_info_desc -- 返回信息描述
    ,final_modif_tm -- 最后修改时间
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,auth_org_id -- 授权机构编号
    ,auth_teller_id -- 授权柜员编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,prpery_flow_num -- 外围流水号
    ,sys_in_flow_num -- 系统内流水号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_supv_acct_sign_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a1ftjgptsignacct-1
insert into ${iml_schema}.evt_supv_acct_sign_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_id -- 系统编号
    ,supv_acct_id -- 监管账户编号
    ,sign_dt -- 签约日期
    ,supv_acct_name -- 监管账户名称
    ,supv_status_cd -- 监管状态代码
    ,sign_status_cd -- 签约状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_org_id -- 开户机构编号
    ,open_bank_name -- 开户行名称
    ,proj_name -- 项目名称
    ,corp_name -- 单位名称
    ,cotas_name -- 联系人名称
    ,cotas_tel -- 联系人电话
    ,rels_dt -- 解约日期
    ,err_info_desc -- 错误信息描述
    ,send_status_cd -- 发送状态代码
    ,oper_rest_cd -- 操作结果代码
    ,return_info_desc -- 返回信息描述
    ,final_modif_tm -- 最后修改时间
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,auth_org_id -- 授权机构编号
    ,auth_teller_id -- 授权柜员编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,prpery_flow_num -- 外围流水号
    ,sys_in_flow_num -- 系统内流水号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401025'||P1.SYSCD||P1.ACCOUNT||P1.SIGNDATE||P1.SIGNTIME -- 事件编号
    ,'9999' -- 法人编号
    ,nvl(trim(P1.SYSCD),'-') -- 系统编号
    ,P1.ACCOUNT -- 监管账户编号
    ,${iml_schema}.dateformat_min(P1.SIGNDATE||P1.SIGNTIME) -- 签约日期
    ,P1.ACCOUNTNAME -- 监管账户名称
    ,nvl(trim(P1.ACCOUNTSTATUS),'-') -- 监管状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.STATUS END -- 签约状态代码
    ,${iml_schema}.dateformat_min(P1.OPENDATE) -- 开户日期
    ,P1.OPENBRN -- 开户机构编号
    ,P1.OPBANKNAME -- 开户行名称
    ,P1.PROJECTNAME -- 项目名称
    ,P1.COMPANYNAME -- 单位名称
    ,P1.CONTACTNUM -- 联系人名称
    ,P1.TELPHOME -- 联系人电话
    ,${iml_schema}.dateformat_max2(P1.OFFDATE||P1.OFFTIME) -- 解约日期
    ,P1.ERRMSG -- 错误信息描述
    ,nvl(trim(P1.SNDFLAG),'-') -- 发送状态代码
    ,nvl(trim(P1.RETURNCODE),'-') -- 操作结果代码
    ,P1.REASON -- 返回信息描述
    ,${iml_schema}.timeformat_max2(P1.UPDT) -- 最后修改时间
    ,P1.OPRBRN -- 交易机构编号
    ,P1.OPRTLR -- 交易柜员编号
    ,P1.CHKBRN -- 复核机构编号
    ,P1.CHKTLR -- 复核柜员编号
    ,P1.AUTBRN -- 授权机构编号
    ,P1.AUTTLR -- 授权柜员编号
    ,P1.GLOBSEQNUM -- 全局流水号
    ,P1.UNIQUESEQNUM -- 业务流水号
    ,P1.SRVTRXSEQ -- 外围流水号
    ,P1.ZTSTRNSEQNO -- 系统内流水号
    ,P1.REMARKS -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1ftjgptsignacct' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1ftjgptsignacct p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1FTJGPTSIGNACCT'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_SUPV_ACCT_SIGN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SIGN_STATUS_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_supv_acct_sign_flow truncate partition p_mpcsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_supv_acct_sign_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_supv_acct_sign_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_supv_acct_sign_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_supv_acct_sign_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_supv_acct_sign_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);