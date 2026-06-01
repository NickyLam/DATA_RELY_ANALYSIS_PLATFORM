/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cap_supv_coprator_info_h_fdpsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_cap_supv_coprator_info_h add partition p_fdpsf1 values ('fdpsf1')(
        subpartition p_fdpsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_fdpsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cap_supv_coprator_info_h partition for ('fdpsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_tm purge;
drop table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_op purge;
drop table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_tm nologging
compress ${option_switch} for query high
as select
    coprator_seq_num -- 合作商序号
    ,lp_id -- 法人编号
    ,coprator_id -- 合作商编号
    ,coprator_name -- 合作商名称
    ,coprator_abbr -- 合作商简称
    ,cust_type_cd -- 客户类型代码
    ,trdpty_flow_num -- 第三方流水号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_exp_dt -- 证件到期日期
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,lp_cert_start_dt -- 法人证件开始日期
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,lp_phone_num -- 法人联系电话号码
    ,operr_name -- 经办人名称
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_start_dt -- 经办人证件开始日期
    ,operr_cert_exp_dt -- 经办人证件到期日期
    ,operr_mobile_no -- 经办人手机号
    ,dtl_addr -- 详细地址
    ,zip_cd -- 邮政编码
    ,phone_num -- 联系电话号码
    ,monit_acct_id -- 监控账户编号
    ,monit_acct_name -- 监控账户名称
    ,monit_acct_org_id -- 监控账户机构编号
    ,monit_acct_org_name -- 监控账户机构名称
    ,mdl_enter_id -- 中间入账账户编号
    ,mdl_enter_name -- 中间入账账户名称
    ,mdl_enter_org_id -- 中间入账账户机构编号
    ,mdl_enter_org_name -- 中间入账账户机构名称
    ,trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,corp_stl_acct_id -- 企业结算账户编号
    ,corp_stl_acct_name -- 企业结算账户名称
    ,corp_stl_acct_org_id -- 企业结算账户机构编号
    ,corp_stl_acct_org_name -- 企业结算账户机构名称
    ,cust_id -- 客户编号
    ,coprator_status_cd -- 合作商状态代码
    ,clear_mode_cd -- 清算模式代码
    ,dmic_st_msg_send_flg -- 动账短信发送标志
    ,vtual_acct_id -- 虚拟账户编号
    ,open_chn_cd -- 开通渠道代码
    ,bd_card_qtty_uplmi -- 绑定卡数量上限
    ,operr_id -- 操作员编号
    ,check_operr_id -- 复核操作员编号
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cap_supv_coprator_info_h partition for ('fdpsf1')
where 0=1
;

create table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cap_supv_coprator_info_h partition for ('fdpsf1') where 0=1;

create table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cap_supv_coprator_info_h partition for ('fdpsf1') where 0=1;

-- 3.1 get new data into table
-- fdps_fdp_cooperator-1
insert into ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_tm(
    coprator_seq_num -- 合作商序号
    ,lp_id -- 法人编号
    ,coprator_id -- 合作商编号
    ,coprator_name -- 合作商名称
    ,coprator_abbr -- 合作商简称
    ,cust_type_cd -- 客户类型代码
    ,trdpty_flow_num -- 第三方流水号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_exp_dt -- 证件到期日期
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,lp_cert_start_dt -- 法人证件开始日期
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,lp_phone_num -- 法人联系电话号码
    ,operr_name -- 经办人名称
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_start_dt -- 经办人证件开始日期
    ,operr_cert_exp_dt -- 经办人证件到期日期
    ,operr_mobile_no -- 经办人手机号
    ,dtl_addr -- 详细地址
    ,zip_cd -- 邮政编码
    ,phone_num -- 联系电话号码
    ,monit_acct_id -- 监控账户编号
    ,monit_acct_name -- 监控账户名称
    ,monit_acct_org_id -- 监控账户机构编号
    ,monit_acct_org_name -- 监控账户机构名称
    ,mdl_enter_id -- 中间入账账户编号
    ,mdl_enter_name -- 中间入账账户名称
    ,mdl_enter_org_id -- 中间入账账户机构编号
    ,mdl_enter_org_name -- 中间入账账户机构名称
    ,trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,corp_stl_acct_id -- 企业结算账户编号
    ,corp_stl_acct_name -- 企业结算账户名称
    ,corp_stl_acct_org_id -- 企业结算账户机构编号
    ,corp_stl_acct_org_name -- 企业结算账户机构名称
    ,cust_id -- 客户编号
    ,coprator_status_cd -- 合作商状态代码
    ,clear_mode_cd -- 清算模式代码
    ,dmic_st_msg_send_flg -- 动账短信发送标志
    ,vtual_acct_id -- 虚拟账户编号
    ,open_chn_cd -- 开通渠道代码
    ,bd_card_qtty_uplmi -- 绑定卡数量上限
    ,operr_id -- 操作员编号
    ,check_operr_id -- 复核操作员编号
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.FDP_COOPERATOR_ID -- 合作商序号
    ,'9999' -- 法人编号
    ,P1.PARENT_MERCHANT_ID -- 合作商编号
    ,P1.PARENT_MERCHANT_NAME -- 合作商名称
    ,P1.PARENT_MERCHANT_SNAME -- 合作商简称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE substr('@'||P1.CUSTOMER_TYPE,1,30) END -- 客户类型代码
    ,P1.OLD_REQ_SEQ_NO -- 第三方流水号
    ,substr(P1.CUST_ID_TYPE,1,30) -- 证件类型代码
    ,substr(P1.CUST_ID_NO,1,100) -- 证件号码
    ,${iml_schema}.dateformat_max(TRIM(P1.CUST_ID_DUE_DATE)) -- 证件到期日期
    ,P1.LEGAL_PERSON_NAME -- 法定代表人名称
    ,substr(P1.LEGAL_PERSON_IDTYPE,1,30) -- 法定代表人证件类型代码
    ,substr(P1.LEGAL_PERSON_IDNO,1,100) -- 法定代表人证件号码
    ,${iml_schema}.dateformat_min(TRIM(P1.LPID_FROM_DATE)) -- 法人证件开始日期
    ,${iml_schema}.dateformat_max(TRIM(P1.LPID_TO_DATE)) -- 法人证件到期日期
    ,substr(P1.LEGAL_PERSON_TELNO,1,60) -- 法人联系电话号码
    ,P1.ACTOR_NAME -- 经办人名称
    ,substr(P1.ACTOR_ID_TYPE,1,30) -- 经办人证件类型代码
    ,substr(P1.ACTOR_ID_NO,1,100) -- 经办人证件号码
    ,${iml_schema}.dateformat_min(TRIM(P1.ACTORID_FROM_DATE)) -- 经办人证件开始日期
    ,${iml_schema}.dateformat_max(TRIM(P1.ACTORID_TO_DATE)) -- 经办人证件到期日期
    ,substr(P1.ACTOR_MOBILE,1,60) -- 经办人手机号
    ,P1.DETAIL_ADDRESS -- 详细地址
    ,substr(P1.POSTAL_CODE,1,60) -- 邮政编码
    ,substr(P1.CONTACT_TEL,1,60) -- 联系电话号码
    ,P1.CLEAR_ACCOUNT -- 监控账户编号
    ,P1.CLEAR_ACCOUNT_NAME -- 监控账户名称
    ,P1.CLEAR_ORG -- 监控账户机构编号
    ,P1.CLEAR_ORG_NAME -- 监控账户机构名称
    ,P1.MID_CLEAR_ACCOUNT -- 中间入账账户编号
    ,P1.MID_ACCOUNT_NAME -- 中间入账账户名称
    ,P1.MID_CLEAR_ORG -- 中间入账账户机构编号
    ,P1.MID_CLEAR_ORG_NAME -- 中间入账账户机构名称
    ,P1.DEP_CLEAR_ACCOUNT -- 第三方清算入账账户编号
    ,P1.DEP_ACCOUNT_NAME -- 第三方清算入账账户名称
    ,P1.DEP_CLEAR_ORG -- 第三方清算入账账号机构编号
    ,P1.DEP_CLEAR_ORG_NAME -- 第三方清算入账账户机构名称
    ,substr(P1.DEP_OTHER_BANK_FLAG,1,30) -- 第三方清算入账账户他行标志
    ,P1.EP_CLEAR_AC -- 企业结算账户编号
    ,P1.EP_CLEAR_AC_NAME -- 企业结算账户名称
    ,P1.EP_CLEAR_ORG -- 企业结算账户机构编号
    ,P1.EP_CLEAR_ORG_NAME -- 企业结算账户机构名称
    ,P1.EP_CLIENT_NO -- 客户编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE substr('@'||P1.CUST_STATUS,1,30) END -- 合作商状态代码
    ,NVL(TRIM(P1.SETTLE_MODEL),'-') -- 清算模式代码
    ,P1.ACTIVE_MSM_MODEL -- 动账短信发送标志
    ,P1.ACCOUNT_NO -- 虚拟账户编号
    ,NVL(TRIM(P1.PLATFORM_CODE),'-') -- 开通渠道代码
    ,P1.MAX_BIND_CARDS -- 绑定卡数量上限
    ,P1.OPERATOR_ID -- 操作员编号
    ,P1.CHECKER_ID -- 复核操作员编号
    ,P1.LAST_UPDATED_STAMP -- 更新时间
    ,P1.CREATED_STAMP -- 创建时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fdps_fdp_cooperator' -- 源表名称
    ,'fdpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fdps_fdp_cooperator p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUSTOMER_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FDPS'
        AND R1.SRC_TAB_EN_NAME= 'FDPS_FDP_COOPERATOR'
        AND R1.SRC_FIELD_EN_NAME= 'CUSTOMER_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_CAP_SUPV_COPRATOR_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CUST_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FDPS'
        AND R2.SRC_TAB_EN_NAME= 'FDPS_FDP_COOPERATOR'
        AND R2.SRC_FIELD_EN_NAME= 'CUST_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_CAP_SUPV_COPRATOR_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'COPRATOR_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_cl(
            coprator_seq_num -- 合作商序号
    ,lp_id -- 法人编号
    ,coprator_id -- 合作商编号
    ,coprator_name -- 合作商名称
    ,coprator_abbr -- 合作商简称
    ,cust_type_cd -- 客户类型代码
    ,trdpty_flow_num -- 第三方流水号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_exp_dt -- 证件到期日期
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,lp_cert_start_dt -- 法人证件开始日期
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,lp_phone_num -- 法人联系电话号码
    ,operr_name -- 经办人名称
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_start_dt -- 经办人证件开始日期
    ,operr_cert_exp_dt -- 经办人证件到期日期
    ,operr_mobile_no -- 经办人手机号
    ,dtl_addr -- 详细地址
    ,zip_cd -- 邮政编码
    ,phone_num -- 联系电话号码
    ,monit_acct_id -- 监控账户编号
    ,monit_acct_name -- 监控账户名称
    ,monit_acct_org_id -- 监控账户机构编号
    ,monit_acct_org_name -- 监控账户机构名称
    ,mdl_enter_id -- 中间入账账户编号
    ,mdl_enter_name -- 中间入账账户名称
    ,mdl_enter_org_id -- 中间入账账户机构编号
    ,mdl_enter_org_name -- 中间入账账户机构名称
    ,trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,corp_stl_acct_id -- 企业结算账户编号
    ,corp_stl_acct_name -- 企业结算账户名称
    ,corp_stl_acct_org_id -- 企业结算账户机构编号
    ,corp_stl_acct_org_name -- 企业结算账户机构名称
    ,cust_id -- 客户编号
    ,coprator_status_cd -- 合作商状态代码
    ,clear_mode_cd -- 清算模式代码
    ,dmic_st_msg_send_flg -- 动账短信发送标志
    ,vtual_acct_id -- 虚拟账户编号
    ,open_chn_cd -- 开通渠道代码
    ,bd_card_qtty_uplmi -- 绑定卡数量上限
    ,operr_id -- 操作员编号
    ,check_operr_id -- 复核操作员编号
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_op(
            coprator_seq_num -- 合作商序号
    ,lp_id -- 法人编号
    ,coprator_id -- 合作商编号
    ,coprator_name -- 合作商名称
    ,coprator_abbr -- 合作商简称
    ,cust_type_cd -- 客户类型代码
    ,trdpty_flow_num -- 第三方流水号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_exp_dt -- 证件到期日期
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,lp_cert_start_dt -- 法人证件开始日期
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,lp_phone_num -- 法人联系电话号码
    ,operr_name -- 经办人名称
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_start_dt -- 经办人证件开始日期
    ,operr_cert_exp_dt -- 经办人证件到期日期
    ,operr_mobile_no -- 经办人手机号
    ,dtl_addr -- 详细地址
    ,zip_cd -- 邮政编码
    ,phone_num -- 联系电话号码
    ,monit_acct_id -- 监控账户编号
    ,monit_acct_name -- 监控账户名称
    ,monit_acct_org_id -- 监控账户机构编号
    ,monit_acct_org_name -- 监控账户机构名称
    ,mdl_enter_id -- 中间入账账户编号
    ,mdl_enter_name -- 中间入账账户名称
    ,mdl_enter_org_id -- 中间入账账户机构编号
    ,mdl_enter_org_name -- 中间入账账户机构名称
    ,trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,corp_stl_acct_id -- 企业结算账户编号
    ,corp_stl_acct_name -- 企业结算账户名称
    ,corp_stl_acct_org_id -- 企业结算账户机构编号
    ,corp_stl_acct_org_name -- 企业结算账户机构名称
    ,cust_id -- 客户编号
    ,coprator_status_cd -- 合作商状态代码
    ,clear_mode_cd -- 清算模式代码
    ,dmic_st_msg_send_flg -- 动账短信发送标志
    ,vtual_acct_id -- 虚拟账户编号
    ,open_chn_cd -- 开通渠道代码
    ,bd_card_qtty_uplmi -- 绑定卡数量上限
    ,operr_id -- 操作员编号
    ,check_operr_id -- 复核操作员编号
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.coprator_seq_num, o.coprator_seq_num) as coprator_seq_num -- 合作商序号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.coprator_id, o.coprator_id) as coprator_id -- 合作商编号
    ,nvl(n.coprator_name, o.coprator_name) as coprator_name -- 合作商名称
    ,nvl(n.coprator_abbr, o.coprator_abbr) as coprator_abbr -- 合作商简称
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.trdpty_flow_num, o.trdpty_flow_num) as trdpty_flow_num -- 第三方流水号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_exp_dt, o.cert_exp_dt) as cert_exp_dt -- 证件到期日期
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法定代表人名称
    ,nvl(n.legal_rep_cert_type_cd, o.legal_rep_cert_type_cd) as legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,nvl(n.legal_rep_cert_no, o.legal_rep_cert_no) as legal_rep_cert_no -- 法定代表人证件号码
    ,nvl(n.lp_cert_start_dt, o.lp_cert_start_dt) as lp_cert_start_dt -- 法人证件开始日期
    ,nvl(n.lp_cert_exp_dt, o.lp_cert_exp_dt) as lp_cert_exp_dt -- 法人证件到期日期
    ,nvl(n.lp_phone_num, o.lp_phone_num) as lp_phone_num -- 法人联系电话号码
    ,nvl(n.operr_name, o.operr_name) as operr_name -- 经办人名称
    ,nvl(n.operr_cert_type_cd, o.operr_cert_type_cd) as operr_cert_type_cd -- 经办人证件类型代码
    ,nvl(n.operr_cert_no, o.operr_cert_no) as operr_cert_no -- 经办人证件号码
    ,nvl(n.operr_cert_start_dt, o.operr_cert_start_dt) as operr_cert_start_dt -- 经办人证件开始日期
    ,nvl(n.operr_cert_exp_dt, o.operr_cert_exp_dt) as operr_cert_exp_dt -- 经办人证件到期日期
    ,nvl(n.operr_mobile_no, o.operr_mobile_no) as operr_mobile_no -- 经办人手机号
    ,nvl(n.dtl_addr, o.dtl_addr) as dtl_addr -- 详细地址
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.phone_num, o.phone_num) as phone_num -- 联系电话号码
    ,nvl(n.monit_acct_id, o.monit_acct_id) as monit_acct_id -- 监控账户编号
    ,nvl(n.monit_acct_name, o.monit_acct_name) as monit_acct_name -- 监控账户名称
    ,nvl(n.monit_acct_org_id, o.monit_acct_org_id) as monit_acct_org_id -- 监控账户机构编号
    ,nvl(n.monit_acct_org_name, o.monit_acct_org_name) as monit_acct_org_name -- 监控账户机构名称
    ,nvl(n.mdl_enter_id, o.mdl_enter_id) as mdl_enter_id -- 中间入账账户编号
    ,nvl(n.mdl_enter_name, o.mdl_enter_name) as mdl_enter_name -- 中间入账账户名称
    ,nvl(n.mdl_enter_org_id, o.mdl_enter_org_id) as mdl_enter_org_id -- 中间入账账户机构编号
    ,nvl(n.mdl_enter_org_name, o.mdl_enter_org_name) as mdl_enter_org_name -- 中间入账账户机构名称
    ,nvl(n.trdpty_clear_enter_id, o.trdpty_clear_enter_id) as trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,nvl(n.trdpty_clear_enter_name, o.trdpty_clear_enter_name) as trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,nvl(n.trdpty_clear_enter_org_id, o.trdpty_clear_enter_org_id) as trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,nvl(n.trdpty_clear_enter_org_name, o.trdpty_clear_enter_org_name) as trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,nvl(n.trdpty_clear_enter_obank_flg, o.trdpty_clear_enter_obank_flg) as trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,nvl(n.corp_stl_acct_id, o.corp_stl_acct_id) as corp_stl_acct_id -- 企业结算账户编号
    ,nvl(n.corp_stl_acct_name, o.corp_stl_acct_name) as corp_stl_acct_name -- 企业结算账户名称
    ,nvl(n.corp_stl_acct_org_id, o.corp_stl_acct_org_id) as corp_stl_acct_org_id -- 企业结算账户机构编号
    ,nvl(n.corp_stl_acct_org_name, o.corp_stl_acct_org_name) as corp_stl_acct_org_name -- 企业结算账户机构名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.coprator_status_cd, o.coprator_status_cd) as coprator_status_cd -- 合作商状态代码
    ,nvl(n.clear_mode_cd, o.clear_mode_cd) as clear_mode_cd -- 清算模式代码
    ,nvl(n.dmic_st_msg_send_flg, o.dmic_st_msg_send_flg) as dmic_st_msg_send_flg -- 动账短信发送标志
    ,nvl(n.vtual_acct_id, o.vtual_acct_id) as vtual_acct_id -- 虚拟账户编号
    ,nvl(n.open_chn_cd, o.open_chn_cd) as open_chn_cd -- 开通渠道代码
    ,nvl(n.bd_card_qtty_uplmi, o.bd_card_qtty_uplmi) as bd_card_qtty_uplmi -- 绑定卡数量上限
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 操作员编号
    ,nvl(n.check_operr_id, o.check_operr_id) as check_operr_id -- 复核操作员编号
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,case when
            n.coprator_seq_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.coprator_seq_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.coprator_seq_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_tm n
    full join (select * from ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.coprator_seq_num = n.coprator_seq_num
            and o.lp_id = n.lp_id
where (
        o.coprator_seq_num is null
        and o.lp_id is null
    )
    or (
        n.coprator_seq_num is null
        and n.lp_id is null
    )
    or (
        o.coprator_id <> n.coprator_id
        or o.coprator_name <> n.coprator_name
        or o.coprator_abbr <> n.coprator_abbr
        or o.cust_type_cd <> n.cust_type_cd
        or o.trdpty_flow_num <> n.trdpty_flow_num
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.cert_exp_dt <> n.cert_exp_dt
        or o.legal_rep_name <> n.legal_rep_name
        or o.legal_rep_cert_type_cd <> n.legal_rep_cert_type_cd
        or o.legal_rep_cert_no <> n.legal_rep_cert_no
        or o.lp_cert_start_dt <> n.lp_cert_start_dt
        or o.lp_cert_exp_dt <> n.lp_cert_exp_dt
        or o.lp_phone_num <> n.lp_phone_num
        or o.operr_name <> n.operr_name
        or o.operr_cert_type_cd <> n.operr_cert_type_cd
        or o.operr_cert_no <> n.operr_cert_no
        or o.operr_cert_start_dt <> n.operr_cert_start_dt
        or o.operr_cert_exp_dt <> n.operr_cert_exp_dt
        or o.operr_mobile_no <> n.operr_mobile_no
        or o.dtl_addr <> n.dtl_addr
        or o.zip_cd <> n.zip_cd
        or o.phone_num <> n.phone_num
        or o.monit_acct_id <> n.monit_acct_id
        or o.monit_acct_name <> n.monit_acct_name
        or o.monit_acct_org_id <> n.monit_acct_org_id
        or o.monit_acct_org_name <> n.monit_acct_org_name
        or o.mdl_enter_id <> n.mdl_enter_id
        or o.mdl_enter_name <> n.mdl_enter_name
        or o.mdl_enter_org_id <> n.mdl_enter_org_id
        or o.mdl_enter_org_name <> n.mdl_enter_org_name
        or o.trdpty_clear_enter_id <> n.trdpty_clear_enter_id
        or o.trdpty_clear_enter_name <> n.trdpty_clear_enter_name
        or o.trdpty_clear_enter_org_id <> n.trdpty_clear_enter_org_id
        or o.trdpty_clear_enter_org_name <> n.trdpty_clear_enter_org_name
        or o.trdpty_clear_enter_obank_flg <> n.trdpty_clear_enter_obank_flg
        or o.corp_stl_acct_id <> n.corp_stl_acct_id
        or o.corp_stl_acct_name <> n.corp_stl_acct_name
        or o.corp_stl_acct_org_id <> n.corp_stl_acct_org_id
        or o.corp_stl_acct_org_name <> n.corp_stl_acct_org_name
        or o.cust_id <> n.cust_id
        or o.coprator_status_cd <> n.coprator_status_cd
        or o.clear_mode_cd <> n.clear_mode_cd
        or o.dmic_st_msg_send_flg <> n.dmic_st_msg_send_flg
        or o.vtual_acct_id <> n.vtual_acct_id
        or o.open_chn_cd <> n.open_chn_cd
        or o.bd_card_qtty_uplmi <> n.bd_card_qtty_uplmi
        or o.operr_id <> n.operr_id
        or o.check_operr_id <> n.check_operr_id
        or o.update_tm <> n.update_tm
        or o.create_tm <> n.create_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_cl(
            coprator_seq_num -- 合作商序号
    ,lp_id -- 法人编号
    ,coprator_id -- 合作商编号
    ,coprator_name -- 合作商名称
    ,coprator_abbr -- 合作商简称
    ,cust_type_cd -- 客户类型代码
    ,trdpty_flow_num -- 第三方流水号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_exp_dt -- 证件到期日期
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,lp_cert_start_dt -- 法人证件开始日期
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,lp_phone_num -- 法人联系电话号码
    ,operr_name -- 经办人名称
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_start_dt -- 经办人证件开始日期
    ,operr_cert_exp_dt -- 经办人证件到期日期
    ,operr_mobile_no -- 经办人手机号
    ,dtl_addr -- 详细地址
    ,zip_cd -- 邮政编码
    ,phone_num -- 联系电话号码
    ,monit_acct_id -- 监控账户编号
    ,monit_acct_name -- 监控账户名称
    ,monit_acct_org_id -- 监控账户机构编号
    ,monit_acct_org_name -- 监控账户机构名称
    ,mdl_enter_id -- 中间入账账户编号
    ,mdl_enter_name -- 中间入账账户名称
    ,mdl_enter_org_id -- 中间入账账户机构编号
    ,mdl_enter_org_name -- 中间入账账户机构名称
    ,trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,corp_stl_acct_id -- 企业结算账户编号
    ,corp_stl_acct_name -- 企业结算账户名称
    ,corp_stl_acct_org_id -- 企业结算账户机构编号
    ,corp_stl_acct_org_name -- 企业结算账户机构名称
    ,cust_id -- 客户编号
    ,coprator_status_cd -- 合作商状态代码
    ,clear_mode_cd -- 清算模式代码
    ,dmic_st_msg_send_flg -- 动账短信发送标志
    ,vtual_acct_id -- 虚拟账户编号
    ,open_chn_cd -- 开通渠道代码
    ,bd_card_qtty_uplmi -- 绑定卡数量上限
    ,operr_id -- 操作员编号
    ,check_operr_id -- 复核操作员编号
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_op(
            coprator_seq_num -- 合作商序号
    ,lp_id -- 法人编号
    ,coprator_id -- 合作商编号
    ,coprator_name -- 合作商名称
    ,coprator_abbr -- 合作商简称
    ,cust_type_cd -- 客户类型代码
    ,trdpty_flow_num -- 第三方流水号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_exp_dt -- 证件到期日期
    ,legal_rep_name -- 法定代表人名称
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,lp_cert_start_dt -- 法人证件开始日期
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,lp_phone_num -- 法人联系电话号码
    ,operr_name -- 经办人名称
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_start_dt -- 经办人证件开始日期
    ,operr_cert_exp_dt -- 经办人证件到期日期
    ,operr_mobile_no -- 经办人手机号
    ,dtl_addr -- 详细地址
    ,zip_cd -- 邮政编码
    ,phone_num -- 联系电话号码
    ,monit_acct_id -- 监控账户编号
    ,monit_acct_name -- 监控账户名称
    ,monit_acct_org_id -- 监控账户机构编号
    ,monit_acct_org_name -- 监控账户机构名称
    ,mdl_enter_id -- 中间入账账户编号
    ,mdl_enter_name -- 中间入账账户名称
    ,mdl_enter_org_id -- 中间入账账户机构编号
    ,mdl_enter_org_name -- 中间入账账户机构名称
    ,trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,corp_stl_acct_id -- 企业结算账户编号
    ,corp_stl_acct_name -- 企业结算账户名称
    ,corp_stl_acct_org_id -- 企业结算账户机构编号
    ,corp_stl_acct_org_name -- 企业结算账户机构名称
    ,cust_id -- 客户编号
    ,coprator_status_cd -- 合作商状态代码
    ,clear_mode_cd -- 清算模式代码
    ,dmic_st_msg_send_flg -- 动账短信发送标志
    ,vtual_acct_id -- 虚拟账户编号
    ,open_chn_cd -- 开通渠道代码
    ,bd_card_qtty_uplmi -- 绑定卡数量上限
    ,operr_id -- 操作员编号
    ,check_operr_id -- 复核操作员编号
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.coprator_seq_num -- 合作商序号
    ,o.lp_id -- 法人编号
    ,o.coprator_id -- 合作商编号
    ,o.coprator_name -- 合作商名称
    ,o.coprator_abbr -- 合作商简称
    ,o.cust_type_cd -- 客户类型代码
    ,o.trdpty_flow_num -- 第三方流水号
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.cert_exp_dt -- 证件到期日期
    ,o.legal_rep_name -- 法定代表人名称
    ,o.legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,o.legal_rep_cert_no -- 法定代表人证件号码
    ,o.lp_cert_start_dt -- 法人证件开始日期
    ,o.lp_cert_exp_dt -- 法人证件到期日期
    ,o.lp_phone_num -- 法人联系电话号码
    ,o.operr_name -- 经办人名称
    ,o.operr_cert_type_cd -- 经办人证件类型代码
    ,o.operr_cert_no -- 经办人证件号码
    ,o.operr_cert_start_dt -- 经办人证件开始日期
    ,o.operr_cert_exp_dt -- 经办人证件到期日期
    ,o.operr_mobile_no -- 经办人手机号
    ,o.dtl_addr -- 详细地址
    ,o.zip_cd -- 邮政编码
    ,o.phone_num -- 联系电话号码
    ,o.monit_acct_id -- 监控账户编号
    ,o.monit_acct_name -- 监控账户名称
    ,o.monit_acct_org_id -- 监控账户机构编号
    ,o.monit_acct_org_name -- 监控账户机构名称
    ,o.mdl_enter_id -- 中间入账账户编号
    ,o.mdl_enter_name -- 中间入账账户名称
    ,o.mdl_enter_org_id -- 中间入账账户机构编号
    ,o.mdl_enter_org_name -- 中间入账账户机构名称
    ,o.trdpty_clear_enter_id -- 第三方清算入账账户编号
    ,o.trdpty_clear_enter_name -- 第三方清算入账账户名称
    ,o.trdpty_clear_enter_org_id -- 第三方清算入账账号机构编号
    ,o.trdpty_clear_enter_org_name -- 第三方清算入账账户机构名称
    ,o.trdpty_clear_enter_obank_flg -- 第三方清算入账账户他行标志
    ,o.corp_stl_acct_id -- 企业结算账户编号
    ,o.corp_stl_acct_name -- 企业结算账户名称
    ,o.corp_stl_acct_org_id -- 企业结算账户机构编号
    ,o.corp_stl_acct_org_name -- 企业结算账户机构名称
    ,o.cust_id -- 客户编号
    ,o.coprator_status_cd -- 合作商状态代码
    ,o.clear_mode_cd -- 清算模式代码
    ,o.dmic_st_msg_send_flg -- 动账短信发送标志
    ,o.vtual_acct_id -- 虚拟账户编号
    ,o.open_chn_cd -- 开通渠道代码
    ,o.bd_card_qtty_uplmi -- 绑定卡数量上限
    ,o.operr_id -- 操作员编号
    ,o.check_operr_id -- 复核操作员编号
    ,o.update_tm -- 更新时间
    ,o.create_tm -- 创建时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_bk o
    left join ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_op n
        on
            o.coprator_seq_num = n.coprator_seq_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_cl d
        on
            o.coprator_seq_num = d.coprator_seq_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_cap_supv_coprator_info_h;
alter table ${iml_schema}.pty_cap_supv_coprator_info_h truncate partition for ('fdpsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_cap_supv_coprator_info_h exchange subpartition p_fdpsf1_19000101 with table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_cl;
alter table ${iml_schema}.pty_cap_supv_coprator_info_h exchange subpartition p_fdpsf1_20991231 with table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cap_supv_coprator_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_tm purge;
drop table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_op purge;
drop table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_cap_supv_coprator_info_h_fdpsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cap_supv_coprator_info_h', partname => 'p_fdpsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
