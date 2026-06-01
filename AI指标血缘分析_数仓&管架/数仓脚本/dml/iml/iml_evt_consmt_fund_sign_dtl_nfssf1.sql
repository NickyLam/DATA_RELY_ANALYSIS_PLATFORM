/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_consmt_fund_sign_dtl_nfssf1
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
drop table ${iml_schema}.evt_consmt_fund_sign_dtl_nfssf1_tm purge;
alter table ${iml_schema}.evt_consmt_fund_sign_dtl add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_consmt_fund_sign_dtl modify partition p_nfssf1
    add subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_consmt_fund_sign_dtl_nfssf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,intior_flow_num -- 发起方流水号
    ,cfm_flow_num -- 确认流水号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,cfm_dt -- 确认日期
    ,tran_cd -- 交易代码
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_name -- 客户名称
    ,cust_abbr -- 客户简称
    ,fund_acct_id -- 基金账户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,resdnt_addr -- 居住地址
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,memo_comnt -- 摘要说明
    ,sign_chn_cd -- 签约渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,cust_mgr_id -- 客户经理编号
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_consmt_fund_sign_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- nfss_tbhisaccreq-1
insert into ${iml_schema}.evt_consmt_fund_sign_dtl_nfssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,intior_flow_num -- 发起方流水号
    ,cfm_flow_num -- 确认流水号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,cfm_dt -- 确认日期
    ,tran_cd -- 交易代码
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,intnal_cust_id -- 内部客户编号
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_name -- 客户名称
    ,cust_abbr -- 客户简称
    ,fund_acct_id -- 基金账户编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,resdnt_addr -- 居住地址
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,mobile_no -- 手机号码
    ,e_mail -- 电子邮箱
    ,memo_comnt -- 摘要说明
    ,sign_chn_cd -- 签约渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,cust_mgr_id -- 客户经理编号
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104050'||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 申请流水号
    ,P1.EX_SERIAL -- 发起方流水号
    ,P1.CFM_NO -- 确认流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANS_DATE) -- 申请日期
    ,${iml_schema}.timeformat_min((p1.TRANS_DATE||lpad(to_char(P1.TRANS_TIME),6,'0'))) -- 申请时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.OCCUR_INIT_DATE) -- 系统日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.TRANS_CODE -- 交易代码
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易所属机构编号
    ,P1.TA_CODE -- TA代码
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ID_TYPE END -- 证件类型代码
    ,P1.ID_CODE -- 证件号码
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.SHORT_NAME -- 客户简称
    ,P1.ASSET_ACC -- 基金账户编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 交易客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRANS_ACCOUNT_TYPE END -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SEX END -- 性别代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.BIRTHDAY) -- 出生日期
    ,P1.ADDRESS -- 居住地址
    ,P1.POST_CODE -- 邮政编码
    ,P1.MOBILE -- 电话号码
    ,P1.TEL -- 手机号码
    ,P1.EMAIL -- 电子邮箱
    ,P1.SUMMARY -- 摘要说明
    ,decode(channel,'I','10','V','I','C','101','e','102','J','103','M','104','P','105',channel) -- 签约渠道代码
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.AUTH_OPER -- 授权柜员编号
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.ERR_CODE -- 错误码
    ,P1.ERR_MSG -- 错误信息描述
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.DEAL_MODE END -- 受理方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbhisaccreq' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tbhisaccreq p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TBHISACCREQ'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_SIGN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ID_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TBHISACCREQ'
        AND R2.SRC_FIELD_EN_NAME= 'ID_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_SIGN_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRANS_ACCOUNT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TBHISACCREQ'
        AND R3.SRC_FIELD_EN_NAME= 'TRANS_ACCOUNT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_SIGN_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_MED_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.SEX = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TBHISACCREQ'
        AND R4.SRC_FIELD_EN_NAME= 'SEX'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_SIGN_DTL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'GENDER_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.DEAL_MODE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'NFSS'
        AND R6.SRC_TAB_EN_NAME= 'NFSS_TBHISACCREQ'
        AND R6.SRC_FIELD_EN_NAME= 'DEAL_MODE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_SIGN_DTL'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'ACCPT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_consmt_fund_sign_dtl truncate partition p_nfssf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_consmt_fund_sign_dtl exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.evt_consmt_fund_sign_dtl_nfssf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_consmt_fund_sign_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_consmt_fund_sign_dtl_nfssf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_consmt_fund_sign_dtl', partname => 'p_nfssf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);